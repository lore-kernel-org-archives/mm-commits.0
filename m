From: akpm@osdl.org
Subject: - x86-fix-vdso-mapping-for-aout-executables-x86_64-fixpatch.patch removed from -mm tree
Date: Mon, 29 Jan 2007 00:56:42 -0800
Message-ID: <200701290856.l0T8ug5D016150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54461 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933280AbXA2I4u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 03:56:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: parag.warudkar@gmail.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-fix-vdso-mapping-for-aout-executables x86_64 fix
has been removed from the -mm tree.  Its filename was
     x86-fix-vdso-mapping-for-aout-executables-x86_64-fixpatch.patch

This patch was dropped because it was folded into x86-fix-vdso-mapping-for-aout-executables.patch

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
x86-fix-vdso-mapping-for-aout-executables-x86_64-fixpatch.patch
