From: akpm@linux-foundation.org
Subject: +
 kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch added
 to -mm tree
Date: Mon, 25 Jan 2016 13:45:43 -0800
Message-ID: <56a69787.KM0SRbDB4yGEymDD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbcAYVpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 16:45:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, hpa@zytor.com, keescook@chromium.org, linux@roeck-us.net, mingo@kernel.org, mmarek@suse.cz, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kallsyms: don't overload absolute symbol type for percpu symbols
has been added to the -mm tree.  Its filename is
     kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: kallsyms: don't overload absolute symbol type for percpu symbols

Commit c6bda7c988a5 ("kallsyms: fix percpu vars on x86-64 with
relocation") overloaded the 'A' (absolute) symbol type to signify that a
symbol is not subject to dynamic relocation.  However, the original A type
does not imply that at all, and depending on the version of the toolchain,
many A type symbols are emitted that are in fact relative to the kernel
text, i.e., if the kernel is relocated at runtime, these symbols should be
updated as well.

For instance, on sparc32, the following symbols are emitted as absolute
(kindly provided by Guenter Roeck):

  f035a420 A _etext
  f03d9000 A _sdata
  f03de8c4 A jiffies
  f03f8860 A _edata
  f03fc000 A __init_begin
  f041bdc8 A __init_text_end
  f0423000 A __bss_start
  f0423000 A __init_end
  f044457d A __bss_stop
  f044457d A _end

On x86_64, similar behavior can be observed:

  ffffffff81a00000 A __end_rodata_hpage_align
  ffffffff81b19000 A __vvar_page
  ffffffff81d3d000 A _end

Even if only a couple of them pass the symbol range check that results in
them to be taken into account for the final kallsyms symbol table, it is
obvious that 'A' does not mean the symbol does not need to be updated at
relocation time, and overloading its meaning to signify that is perhaps
not a good idea.

So instead, add a new percpu_absolute member to struct sym_entry, and when
--absolute-percpu is in effect, use it to record symbols whose addresses
should be emitted as final values rather than values that still require
relocation at runtime.  That way, we can drop the check against the 'A'
type.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au> # powerpc
Cc: Kees Cook <keescook@chromium.org> # x86_64
Cc: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN scripts/kallsyms.c~kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols scripts/kallsyms.c
--- a/scripts/kallsyms.c~kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols
+++ a/scripts/kallsyms.c
@@ -34,6 +34,7 @@ struct sym_entry {
 	unsigned int len;
 	unsigned int start_pos;
 	unsigned char *sym;
+	unsigned int percpu_absolute;
 };
 
 struct addr_range {
@@ -171,6 +172,8 @@ static int read_symbol(FILE *in, struct
 	strcpy((char *)s->sym + 1, str);
 	s->sym[0] = stype;
 
+	s->percpu_absolute = 0;
+
 	/* Record if we've found __per_cpu_start/end. */
 	check_symbol_range(sym, s->addr, &percpu_range, 1);
 
@@ -325,7 +328,7 @@ static int expand_symbol(unsigned char *
 
 static int symbol_absolute(struct sym_entry *s)
 {
-	return toupper(s->sym[0]) == 'A';
+	return s->percpu_absolute;
 }
 
 static void write_src(void)
@@ -681,8 +684,15 @@ static void make_percpus_absolute(void)
 	unsigned int i;
 
 	for (i = 0; i < table_cnt; i++)
-		if (symbol_in_range(&table[i], &percpu_range, 1))
+		if (symbol_in_range(&table[i], &percpu_range, 1)) {
+			/*
+			 * Keep the 'A' override for percpu symbols to
+			 * ensure consistent behavior compared to older
+			 * versions of this tool.
+			 */
 			table[i].sym[0] = 'A';
+			table[i].percpu_absolute = 1;
+		}
 }
 
 int main(int argc, char **argv)
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch
kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch

