From: akpm@linux-foundation.org
Subject: - flag-parameters-anon_inode_getfd-extension-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:28:45 -0700
Message-ID: <200807232341.m6NNfMhY018288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956AbYGWXl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davidel@xmailserver.org, drepper@redhat.com, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     flag-parameters-anon_inode_getfd-extension kvm fix
has been removed from the -mm tree.  Its filename was
     flag-parameters-anon_inode_getfd-extension-fix.patch

This patch was dropped because it was folded into flag-parameters-anon_inode_getfd-extension.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag-parameters-anon_inode_getfd-extension kvm fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/kvm_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN virt/kvm/kvm_main.c~flag-parameters-anon_inode_getfd-extension-fix virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~flag-parameters-anon_inode_getfd-extension-fix
+++ a/virt/kvm/kvm_main.c
@@ -902,7 +902,7 @@ static const struct file_operations kvm_
  */
 static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 {
-	int fd = anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu);
+	int fd = anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, 0);
 	if (fd < 0)
 		kvm_put_kvm(vcpu->kvm);
 	return fd;
@@ -1261,7 +1261,7 @@ static int kvm_dev_ioctl_create_vm(void)
 	kvm = kvm_create_vm();
 	if (IS_ERR(kvm))
 		return PTR_ERR(kvm);
-	fd = anon_inode_getfd("kvm-vm", &kvm_vm_fops, kvm);
+	fd = anon_inode_getfd("kvm-vm", &kvm_vm_fops, kvm, 0);
 	if (fd < 0)
 		kvm_put_kvm(kvm);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
kill-generic_file_direct_io.patch
use-generic_access_phys-for-dev-mem-mappings.patch
spufs-use-the-new-vm_ops-access.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
page-flags-record-page-flag-overlays-explicitly.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups.patch
vma-page-offset-has-no-callees-drop-it.patch
sync_file_range_write-may-and-will-block-document-that.patch
vmallocinfo-add-numa-information.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
bootmem-add-debugging-framework.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
flag-parameters-paccept.patch
flag-parameters-anon_inode_getfd-extension.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts-fix.patch
rtc-cmos-improve-hpet-irq-glue-build-fix.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size-fix.patch
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch

