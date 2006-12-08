From: akpm@osdl.org
Subject: - move-kallsyms-data-to-rodata.patch removed from -mm tree
Date: Fri, 08 Dec 2006 11:59:35 -0800
Message-ID: <200612081959.kB8JxZms001635@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56391 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426179AbWLHT7l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 14:59:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     move kallsyms data to .rodata
has been removed from the -mm tree.  Its filename was
     move-kallsyms-data-to-rodata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: move kallsyms data to .rodata
From: "Jan Beulich" <jbeulich@novell.com>

Kallsyms data is never written to, so it can as well benefit from
CONFIG_DEBUG_RODATA.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/kallsyms.c  |   16 ++++++++--------
 scripts/kallsyms.c |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/kallsyms.c~move-kallsyms-data-to-rodata kernel/kallsyms.c
--- a/kernel/kallsyms.c~move-kallsyms-data-to-rodata
+++ a/kernel/kallsyms.c
@@ -31,14 +31,14 @@
 #endif
 
 /* These will be re-linked against their real values during the second link stage */
-extern unsigned long kallsyms_addresses[] __attribute__((weak));
-extern unsigned long kallsyms_num_syms __attribute__((weak,section("data")));
-extern u8 kallsyms_names[] __attribute__((weak));
+extern const unsigned long kallsyms_addresses[] __attribute__((weak));
+extern const unsigned long kallsyms_num_syms __attribute__((weak));
+extern const u8 kallsyms_names[] __attribute__((weak));
 
-extern u8 kallsyms_token_table[] __attribute__((weak));
-extern u16 kallsyms_token_index[] __attribute__((weak));
+extern const u8 kallsyms_token_table[] __attribute__((weak));
+extern const u16 kallsyms_token_index[] __attribute__((weak));
 
-extern unsigned long kallsyms_markers[] __attribute__((weak));
+extern const unsigned long kallsyms_markers[] __attribute__((weak));
 
 static inline int is_kernel_inittext(unsigned long addr)
 {
@@ -84,7 +84,7 @@ static int is_ksym_addr(unsigned long ad
 static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
 {
 	int len, skipped_first = 0;
-	u8 *tptr, *data;
+	const u8 *tptr, *data;
 
 	/* get the compressed symbol length from the first symbol byte */
 	data = &kallsyms_names[off];
@@ -132,7 +132,7 @@ static char kallsyms_get_symbol_type(uns
  * kallsyms array */
 static unsigned int get_symbol_offset(unsigned long pos)
 {
-	u8 *name;
+	const u8 *name;
 	int i;
 
 	/* use the closest marker we have. We have markers every 256 positions,
diff -puN scripts/kallsyms.c~move-kallsyms-data-to-rodata scripts/kallsyms.c
--- a/scripts/kallsyms.c~move-kallsyms-data-to-rodata
+++ a/scripts/kallsyms.c
@@ -265,7 +265,7 @@ static void write_src(void)
 	printf("#define ALGN .align 4\n");
 	printf("#endif\n");
 
-	printf(".data\n");
+	printf("\t.section .rodata, \"a\"\n");
 
 	/* Provide proper symbols relocatability by their '_text'
 	 * relativeness.  The symbol names cannot be used to construct
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
move-kallsyms-data-to-rodata.patch
some-kbuild-fix.patch

