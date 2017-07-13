From: akpm@linux-foundation.org
Subject: [merged] efi-avoid-fortify-checks-in-efi-stub.patch
 removed from -mm tree
Date: Thu, 13 Jul 2017 13:42:12 -0700
Message-ID: <20170713204212.vrY7eOikR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59468 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753286AbdGMUmN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:42:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, danielmicay@gmail.com, keescook@chromium.org, mark.rutland@arm.com, matt@codeblueprint.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: efi: avoid fortify checks in EFI stub
has been removed from the -mm tree.  Its filename was
     efi-avoid-fortify-checks-in-efi-stub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: efi: avoid fortify checks in EFI stub

This avoids CONFIG_FORTIFY_SOURCE from being enabled during the EFI stub
build, as adding a panic() implementation may not work well.  This can be
adjusted in the future.

Link: http://lkml.kernel.org/r/1497903987-21002-2-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Daniel Micay <danielmicay@gmail.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/efi/libstub/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/firmware/efi/libstub/Makefile~efi-avoid-fortify-checks-in-efi-stub drivers/firmware/efi/libstub/Makefile
--- a/drivers/firmware/efi/libstub/Makefile~efi-avoid-fortify-checks-in-efi-stub
+++ a/drivers/firmware/efi/libstub/Makefile
@@ -17,6 +17,7 @@ cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(
 cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
 
 KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
+				   -D__NO_FORTIFY \
 				   $(call cc-option,-ffreestanding) \
 				   $(call cc-option,-fno-stack-protector)
 
_

Patches currently in -mm which might be from keescook@chromium.org are


