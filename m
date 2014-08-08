From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-support-for-kexec-on-panic-using-new-system-call-fix.patch removed
 from -mm tree
Date: Fri, 08 Aug 2014 14:03:38 -0700
Message-ID: <53e53b2a.Dl9gFagZ6Ye515z9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:61070 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaHHVDj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 17:03:39 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so252884igd.4
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 14:03:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-bzimage64: fix the ordering of registers
has been removed from the -mm tree.  Its filename was
     kexec-support-for-kexec-on-panic-using-new-system-call-fix.patch

This patch was dropped because it was folded into kexec-support-for-kexec-on-panic-using-new-system-call.patch

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec-bzimage64: fix the ordering of registers

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
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-kexec-kdump-on-efi-systems.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
kexec-verify-the-signature-of-signed-pe-bzimage.patch

