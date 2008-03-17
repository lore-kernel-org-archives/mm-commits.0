From: akpm@linux-foundation.org
Subject: + reduce-module-image-and-resident-size.patch added to -mm tree
Date: Mon, 17 Mar 2008 14:51:56 -0700
Message-ID: <200803172151.m2HLpurg032711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727AbYCQVwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:52:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, rusty@rustcorp.com.au


The patch titled
     modules: reduce module image and resident size
has been added to the -mm tree.  Its filename is
     reduce-module-image-and-resident-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-verify_export_symbols.patch

