From: akpm@linux-foundation.org
Subject: - reduce-module-image-and-resident-size.patch removed from -mm tree
Date: Mon, 17 Mar 2008 21:17:07 -0700
Message-ID: <200803180417.m2I4H73G013723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355AbYCRERq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:17:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     modules: reduce module image and resident size
has been removed from the -mm tree.  Its filename was
     reduce-module-image-and-resident-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: modules: reduce module image and resident size
From: "Jan Beulich" <jbeulich@novell.com>

Resulting reduction (x86-64, gcc 4.1.2) with my (special purpose, i.e.
much reduced) configurations:
- 16k kernel resident size
- 180k module resident size
- 10k module image size

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    2 +-
 kernel/module.c        |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/module.h~reduce-module-image-and-resident-size include/linux/module.h
--- a/include/linux/module.h~reduce-module-image-and-resident-size
+++ a/include/linux/module.h
@@ -190,7 +190,7 @@ void *__symbol_get_gpl(const char *symbo
 	extern typeof(sym) sym;					\
 	__CRC_SYMBOL(sym, sec)					\
 	static const char __kstrtab_##sym[]			\
-	__attribute__((section("__ksymtab_strings")))		\
+	__attribute__((section("__ksymtab_strings"), aligned(1))) \
 	= MODULE_SYMBOL_PREFIX #sym;                    	\
 	static const struct kernel_symbol __ksymtab_##sym	\
 	__used							\
diff -puN kernel/module.c~reduce-module-image-and-resident-size kernel/module.c
--- a/kernel/module.c~reduce-module-image-and-resident-size
+++ a/kernel/module.c
@@ -1814,8 +1814,9 @@ static struct module *load_module(void _
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
 
-	/* Don't keep modinfo section */
+	/* Don't keep modinfo and version sections. */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	sechdrs[versindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 #ifdef CONFIG_KALLSYMS
 	/* Keep symbol and string tables for decoding later. */
 	sechdrs[symindex].sh_flags |= SHF_ALLOC;
_

Patches currently in -mm which might be from jbeulich@novell.com are

lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
lib-swiotlbc-cleanups.patch
reduce-module-image-and-resident-size.patch
make-module_sect_attrs-private-to-kernel-modulec.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
fix-verify_export_symbols.patch

