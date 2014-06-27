From: akpm@linux-foundation.org
Subject: +
 kexec-support-for-kexec-on-panic-using-new-system-call-fix.patch added to
 -mm tree
Date: Fri, 27 Jun 2014 11:44:47 -0700
Message-ID: <53adbb9f.D93g6pXHqXr7Mc4f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:33782 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaF0Sos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jun 2014 14:44:48 -0400
Received: by mail-ve0-f202.google.com with SMTP id oy12so496628veb.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2014 11:44:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-bzimage64: Fix the ordering of registers
has been added to the -mm tree.  Its filename is
     kexec-support-for-kexec-on-panic-using-new-system-call-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-support-for-kexec-on-panic-using-new-system-call-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-support-for-kexec-on-panic-using-new-system-call-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec-bzimage64: Fix the ordering of registers

hpa suggested to fix the ordering of register declaration.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kexec.h |   11 ++++++++---
 arch/x86/purgatory/entry64.S |    6 +++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN arch/x86/include/asm/kexec.h~kexec-support-for-kexec-on-panic-using-new-system-call-fix arch/x86/include/asm/kexec.h
--- a/arch/x86/include/asm/kexec.h~kexec-support-for-kexec-on-panic-using-new-system-call-fix
+++ a/arch/x86/include/asm/kexec.h
@@ -182,15 +182,20 @@ struct kimage_arch {
 #endif /* CONFIG_X86_32 */
 
 #ifdef CONFIG_X86_64
+/*
+ * Number of elements and order of elements in this structure should match
+ * with the ones in arch/x86/purgatory/entry64.S. If you make a change here
+ * make an appropriate change in purgatory too.
+ */
 struct kexec_entry64_regs {
 	uint64_t rax;
-	uint64_t rbx;
 	uint64_t rcx;
 	uint64_t rdx;
-	uint64_t rsi;
-	uint64_t rdi;
+	uint64_t rbx;
 	uint64_t rsp;
 	uint64_t rbp;
+	uint64_t rsi;
+	uint64_t rdi;
 	uint64_t r8;
 	uint64_t r9;
 	uint64_t r10;
diff -puN arch/x86/purgatory/entry64.S~kexec-support-for-kexec-on-panic-using-new-system-call-fix arch/x86/purgatory/entry64.S
--- a/arch/x86/purgatory/entry64.S~kexec-support-for-kexec-on-panic-using-new-system-call-fix
+++ a/arch/x86/purgatory/entry64.S
@@ -61,13 +61,13 @@ new_cs_exit:
 	.balign 4
 entry64_regs:
 rax:	.quad 0x0
-rbx:	.quad 0x0
 rcx:	.quad 0x0
 rdx:	.quad 0x0
-rsi:	.quad 0x0
-rdi:	.quad 0x0
+rbx:	.quad 0x0
 rsp:	.quad 0x0
 rbp:	.quad 0x0
+rsi:	.quad 0x0
+rdi:	.quad 0x0
 r8:	.quad 0x0
 r9:	.quad 0x0
 r10:	.quad 0x0
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-for-kexec-on-panic-using-new-system-call-fix.patch
kexec-support-kexec-kdump-on-efi-systems.patch

