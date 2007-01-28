From: akpm@osdl.org
Subject: + x86-fix-vdso-mapping-for-aout-executables-x86_64-fixpatch.patch added to -mm tree
Date: Sun, 28 Jan 2007 14:55:32 -0800
Message-ID: <200701282255.l0SMtWoS005333@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40634 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947AbXA1Wzi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 17:55:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: parag.warudkar@gmail.com, ak@suse.de


The patch titled
     x86-fix-vdso-mapping-for-aout-executables x86_64 fix
has been added to the -mm tree.  Its filename is
     x86-fix-vdso-mapping-for-aout-executables-x86_64-fixpatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-fix-vdso-mapping-for-aout-executables x86_64 fix
From: "Parag Warudkar" <parag.warudkar@gmail.com>

I think the easy and correct fix for this situation is defining
CONFIG_ARCH_HAS_SETUP_ADDITIONAL_PAGES on x86_64 only if IA32_EMULATION is
defined.  (Because x86_64 proper doesn't seem to require
arch_setup_additional_pages() only IA32 emulation requires it.)

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/Kconfig~x86-fix-vdso-mapping-for-aout-executables-x86_64-fixpatch arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86-fix-vdso-mapping-for-aout-executables-x86_64-fixpatch
+++ a/arch/x86_64/Kconfig
@@ -401,7 +401,7 @@ config HAVE_ARCH_EARLY_PFN_TO_NID
 config ARCH_HAS_SETUP_ADDITIONAL_PAGES
 	bool
 	default y
-	depends on X86_64
+	depends on X86_64 && IA32_EMULATION
 
 config OUT_OF_LINE_PFN_TO_PAGE
 	def_bool y
_

Patches currently in -mm which might be from parag.warudkar@gmail.com are

x86-fix-vdso-mapping-for-aout-executables.patch
x86-fix-vdso-mapping-for-aout-executables-fixes.patch
x86-fix-vdso-mapping-for-aout-executables-fixes-2.patch
x86-fix-vdso-mapping-for-aout-executables-cleanups.patch
x86-fix-vdso-mapping-for-aout-executables-doh.patch
x86-fix-vdso-mapping-for-aout-executables-sh-fix.patch
x86-fix-vdso-mapping-for-aout-executables-x86_64-fixpatch.patch
