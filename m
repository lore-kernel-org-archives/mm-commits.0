From: akpm@linux-foundation.org
Subject: - kallsyms-should-prefer-non-weak-symbols.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:06 -0800
Message-ID: <200802070023.m170NlJ1006559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933089AbYBGAqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmarques@grupopie.com, mathieu.desnoyers@polymtl.ca, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kallsyms should prefer non weak symbols
has been removed from the -mm tree.  Its filename was
     kallsyms-should-prefer-non-weak-symbols.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kallsyms should prefer non weak symbols
From: Paulo Marques <pmarques@grupopie.com>

When resolving symbol names from addresses with aliased symbol names,
kallsyms_lookup always returns the first symbol, even if it is a weak
symbol.

This patch changes this by sorting the symbols with the weak symbols last
before feeding them to the kernel.  This way the kernel runtime isn't
changed at all, only the kallsyms build system is changed.

Another side effect is that the symbols get sorted by address, too.  So,
even if future binutils version have some bug in "nm" that makes it fail to
correctly sort symbols by address, the kernel won't be affected by this.

Mathieu says:

  I created a module in LTTng that uses kallsyms to get the symbol
  corresponding to a specific system call address.  Unfortunately, all the
  unimplemented syscalls were all referring to the (same) weak symbol
  identifying an unrelated system call rather that sys_ni (or whatever
  non-weak symbol would be expected).  Kallsyms was dumbly returning the first
  symbol that matched.

  This patch makes sure kallsyms returns the non-weak symbol when there is
  one, which seems to be the expected result.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Looks-great-to: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |   37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff -puN scripts/kallsyms.c~kallsyms-should-prefer-non-weak-symbols scripts/kallsyms.c
--- a/scripts/kallsyms.c~kallsyms-should-prefer-non-weak-symbols
+++ a/scripts/kallsyms.c
@@ -31,14 +31,13 @@
 
 #define KSYM_NAME_LEN		128
 
-
 struct sym_entry {
 	unsigned long long addr;
 	unsigned int len;
+	unsigned int start_pos;
 	unsigned char *sym;
 };
 
-
 static struct sym_entry *table;
 static unsigned int table_size, table_cnt;
 static unsigned long long _text, _stext, _etext, _sinittext, _einittext;
@@ -198,8 +197,10 @@ static void read_map(FILE *in)
 				exit (1);
 			}
 		}
-		if (read_symbol(in, &table[table_cnt]) == 0)
+		if (read_symbol(in, &table[table_cnt]) == 0) {
+			table[table_cnt].start_pos = table_cnt;
 			table_cnt++;
+		}
 	}
 }
 
@@ -502,6 +503,35 @@ static void optimize_token_table(void)
 	optimize_result();
 }
 
+static int compare_symbols(const void *a, const void *b)
+{
+	const struct sym_entry *sa;
+	const struct sym_entry *sb;
+	int wa, wb;
+
+	sa = a;
+	sb = b;
+
+	/* sort by address first */
+	if (sa->addr > sb->addr)
+		return 1;
+	if (sa->addr < sb->addr)
+		return -1;
+
+	/* sort by "weakness" type */
+	wa = (sa->sym[0] == 'w') || (sa->sym[0] == 'W');
+	wb = (sb->sym[0] == 'w') || (sb->sym[0] == 'W');
+	if (wa != wb)
+		return wa - wb;
+
+	/* sort by initial order, so that other symbols are left undisturbed */
+	return sa->start_pos - sb->start_pos;
+}
+
+static void sort_symbols(void)
+{
+	qsort(table, table_cnt, sizeof(struct sym_entry), compare_symbols);
+}
 
 int main(int argc, char **argv)
 {
@@ -523,6 +553,7 @@ int main(int argc, char **argv)
 		usage();
 
 	read_map(stdin);
+	sort_symbols();
 	optimize_token_table();
 	write_src();
 
_

Patches currently in -mm which might be from pmarques@grupopie.com are

origin.patch
