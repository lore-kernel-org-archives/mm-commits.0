From: akpm@linux-foundation.org
Subject: - add-argv_split.patch removed from -mm tree
Date: Mon, 21 May 2007 16:17:48 -0700
Message-ID: <200705212317.l4LNHl0R022507@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758273AbXEUXWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 19:22:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, chrisw@sous-sol.org, jeremy@xensource.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     add argv_split()
has been removed from the -mm tree.  Its filename was
     add-argv_split.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add argv_split()
From: Jeremy Fitzhardinge <jeremy@goop.org>

argv_split() is a helper function which takes a string, splits it at
whitespace, and returns a NULL-terminated argv vector.  This is deliberately
simple - it does no quote processing of any kind.

[ Seems to me that this is something which is already being done in
  the kernel, but I couldn't find any other implementations, either to
  steal or replace.  Keep an eye out. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    3 
 lib/Makefile           |    2 
 lib/argv_split.c       |  159 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 163 insertions(+), 1 deletion(-)

diff -puN include/linux/string.h~add-argv_split include/linux/string.h
--- a/include/linux/string.h~add-argv_split
+++ a/include/linux/string.h
@@ -108,6 +108,9 @@ extern char *kstrdup(const char *s, gfp_
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
 
+extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
+extern void argv_free(char **argv);
+
 #ifdef __cplusplus
 }
 #endif
diff -puN lib/Makefile~add-argv_split lib/Makefile
--- a/lib/Makefile~add-argv_split
+++ a/lib/Makefile
@@ -5,7 +5,7 @@
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
-	 sha1.o irq_regs.o reciprocal_div.o
+	 sha1.o irq_regs.o reciprocal_div.o argv_split.o
 
 lib-$(CONFIG_MMU) += ioremap.o pagewalk.o
 lib-$(CONFIG_SMP) += cpumask.o
diff -puN /dev/null lib/argv_split.c
--- /dev/null
+++ a/lib/argv_split.c
@@ -0,0 +1,159 @@
+/*
+ * Helper function for splitting a string into an argv-like array.
+ */
+
+#ifndef TEST
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/bug.h>
+#endif
+
+static const char *skip_sep(const char *cp)
+{
+	while (*cp && isspace(*cp))
+		cp++;
+
+	return cp;
+}
+
+static const char *skip_arg(const char *cp)
+{
+	while (*cp && !isspace(*cp))
+		cp++;
+
+	return cp;
+}
+
+static int count_argc(const char *str)
+{
+	int count = 0;
+
+	while (*str) {
+		str = skip_sep(str);
+		if (*str) {
+			count++;
+			str = skip_arg(str);
+		}
+	}
+
+	return count;
+}
+
+/**
+ * argv_free - free an argv
+ *
+ * @argv - the argument vector to be freed
+ *
+ * Frees an argv and the strings it points to.
+ */
+void argv_free(char **argv)
+{
+	char **p;
+	for (p = argv; *p; p++)
+		kfree(*p);
+
+	kfree(argv);
+}
+EXPORT_SYMBOL(argv_free);
+
+/**
+ * argv_split - split a string at whitespace, returning an argv
+ * @gfp: the GFP mask used to allocate memory
+ * @str: the string to be split
+ * @argcp: returned argument count
+ *
+ * Returns an array of pointers to strings which are split out from
+ * @str.  This is performed by strictly splitting on white-space; no
+ * quote processing is performed.  Multiple whitespace characters are
+ * considered to be a single argument separator.  The returned array
+ * is always NULL-terminated.  Returns NULL on memory allocation
+ * failure.
+ */
+char **argv_split(gfp_t gfp, const char *str, int *argcp)
+{
+	int argc = count_argc(str);
+	char **argv = kzalloc(sizeof(*argv) * (argc+1), gfp);
+	char **argvp;
+
+	if (argv == NULL)
+		goto out;
+
+	*argcp = argc;
+	argvp = argv;
+
+	while (*str) {
+		str = skip_sep(str);
+
+		if (*str) {
+			const char *p = str;
+			char *t;
+
+			str = skip_arg(str);
+
+			t = kstrndup(p, str-p, gfp);
+			if (t == NULL)
+				goto fail;
+			*argvp++ = t;
+		}
+	}
+	*argvp = NULL;
+
+  out:
+	return argv;
+
+  fail:
+	argv_free(argv);
+	return NULL;
+}
+EXPORT_SYMBOL(argv_split);
+
+#ifdef TEST
+#define _GNU_SOURCE
+#include <ctype.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+
+typedef enum {
+	GFP_KERNEL,
+} gfp_t;
+#define kzalloc(size, x)	malloc(size)
+#define kfree(x)		free(x)
+#define kstrndup(s, n, gfp)	strndup(s, n)
+#define BUG()	abort()
+
+int main() {
+	const char *testvec[] = {
+		"",
+		"x",
+		"\"",
+		"\\\0",
+		"\"",
+		"test one two three",
+		"arg\"foo\"bar biff",
+		"one two\\ three four",
+		"one \"two three\" four",
+		NULL,
+	};
+	const char **t;
+
+	for (t = testvec; *t; t++) {
+		char **argv;
+		int argc;
+		char **a;
+
+		printf("%d: test [%s]\n", t-testvec, *t);
+
+		argv = argv_split(GFP_KERNEL, *t, &argc);
+
+		printf("argc=%d vec=", argc);
+		for (a = argv; *a; a++)
+			printf("[%s] ", *a);
+		printf("\n");
+
+		argv_free(argv);
+	}
+
+	return 0;
+}
+#endif
_

Patches currently in -mm which might be from jeremy@goop.org are

add-kstrndup-fix.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
lguest-the-guest-code.patch
