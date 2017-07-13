From: akpm@linux-foundation.org
Subject: [merged] x86-efi-move-asmlinkage-before-return-type.patch
 removed from -mm tree
Date: Thu, 13 Jul 2017 13:43:30 -0700
Message-ID: <20170713204330.N6zVWWvkq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59904 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdGMUnb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, hpa@zytor.com, joe@perches.com, matt@codeblueprint.co.uk, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: x86/efi: move asmlinkage before return type
has been removed from the -mm tree.  Its filename was
     x86-efi-move-asmlinkage-before-return-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: x86/efi: move asmlinkage before return type

Make the code like the rest of the kernel.

Link: http://lkml.kernel.org/r/1cd3d401626e51ea0e2333a860e76e80bc560a4c.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/efi.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/include/asm/efi.h~x86-efi-move-asmlinkage-before-return-type arch/x86/include/asm/efi.h
--- a/arch/x86/include/asm/efi.h~x86-efi-move-asmlinkage-before-return-type
+++ a/arch/x86/include/asm/efi.h
@@ -33,7 +33,7 @@
 
 #ifdef CONFIG_X86_32
 
-extern unsigned long asmlinkage efi_call_phys(void *, ...);
+extern asmlinkage unsigned long efi_call_phys(void *, ...);
 
 #define arch_efi_call_virt_setup()	kernel_fpu_begin()
 #define arch_efi_call_virt_teardown()	kernel_fpu_end()
@@ -52,7 +52,7 @@ extern unsigned long asmlinkage efi_call
 
 #define EFI_LOADER_SIGNATURE	"EL64"
 
-extern u64 asmlinkage efi_call(void *fp, ...);
+extern asmlinkage u64 efi_call(void *fp, ...);
 
 #define efi_call_phys(f, args...)		efi_call((f), args)
 
_

Patches currently in -mm which might be from joe@perches.com are


