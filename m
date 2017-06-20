From: akpm@linux-foundation.org
Subject: + efi-avoid-fortify-checks-in-efi-stub.patch added to -mm tree
Date: Tue, 20 Jun 2017 15:20:58 -0700
Message-ID: <59499fca.IfSOPX6efnzkxlUL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47918 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752401AbdFTWU7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jun 2017 18:20:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ard.biesheuvel@linaro.org, danielmicay@gmail.com, mark.rutland@arm.com, matt@codeblueprint.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: efi: avoid fortify checks in EFI stub
has been added to the -mm tree.  Its filename is
     efi-avoid-fortify-checks-in-efi-stub.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efi-avoid-fortify-checks-in-efi-stub.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efi-avoid-fortify-checks-in-efi-stub.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ipc-drop-non-rcu-allocation.patch
ipc-sem-do-not-use-ipc_rcu_free.patch
ipc-shm-do-not-use-ipc_rcu_free.patch
ipc-msg-do-not-use-ipc_rcu_free.patch
ipc-util-drop-ipc_rcu_free.patch
ipc-sem-avoid-ipc_rcu_alloc.patch
ipc-shm-avoid-ipc_rcu_alloc.patch
ipc-msg-avoid-ipc_rcu_alloc.patch
ipc-util-drop-ipc_rcu_alloc.patch
ipc-move-atomic_set-to-where-it-is-needed.patch
ipc-shm-remove-special-shm_alloc-free.patch
ipc-msg-remove-special-msg_alloc-free.patch
ipc-sem-drop-__sem_free.patch
efi-avoid-fortify-checks-in-efi-stub.patch
x86-power-64-use-char-arrays-for-asm-function-names.patch
kexec_file-adjust-declaration-of-kexec_purgatory.patch
ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch

