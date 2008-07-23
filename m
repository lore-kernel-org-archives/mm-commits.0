From: akpm@linux-foundation.org
Subject: - security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:44:38 -0700
Message-ID: <200807232357.m6NNvGcf019002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209AbYGWX5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:57:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, morgan@kernel.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     security-protect-legacy-apps-from-insufficient-privilege-cleanup
has been removed from the -mm tree.  Its filename was
     security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch

This patch was dropped because it was folded into security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security-protect-legacy-apps-from-insufficient-privilege-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andrew G. Morgan <morgan@kernel.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN security/commoncap.c~security-protect-legacy-apps-from-insufficient-privilege-cleanup security/commoncap.c
--- a/security/commoncap.c~security-protect-legacy-apps-from-insufficient-privilege-cleanup
+++ a/security/commoncap.c
@@ -228,30 +228,28 @@ static inline int cap_from_disk(struct v
 	ret = 0;
 
 	CAP_FOR_EACH_U32(i) {
+		__u32 value_cpu;
+
 		if (i >= tocopy) {
 			/*
 			 * Legacy capability sets have no upper bits
 			 */
 			bprm->cap_post_exec_permitted.cap[i] = 0;
-		} else {
-			__u32 value_cpu;
+			continue;
+		}
+		/*
+		 * pP' = (X & fP) | (pI & fI)
+		 */
+		value_cpu = le32_to_cpu(caps->data[i].permitted);
+		bprm->cap_post_exec_permitted.cap[i] =
+			(current->cap_bset.cap[i] & value_cpu) |
+			(current->cap_inheritable.cap[i] &
+				le32_to_cpu(caps->data[i].inheritable));
+		if (value_cpu & ~bprm->cap_post_exec_permitted.cap[i]) {
 			/*
-			 * pP' = (X & fP) | (pI & fI)
+			 * insufficient to execute correctly
 			 */
-			value_cpu = le32_to_cpu(caps->data[i].permitted);
-			bprm->cap_post_exec_permitted.cap[i] = (
-					current->cap_bset.cap[i] & value_cpu
-				) | (
-					current->cap_inheritable.cap[i] &
-					le32_to_cpu(caps->data[i].inheritable)
-				);
-			if (value_cpu &
-			    ~bprm->cap_post_exec_permitted.cap[i]) {
-				/*
-				 * insufficient to execute correctly
-				 */
-				ret = -EPERM;
-			}
+			ret = -EPERM;
 		}
 	}
 
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
flag-parameters-signalfd.patch
flag-parameters-eventfd.patch
flag-parameters-inotify_init.patch
flag-parameters-check-magic-constants.patch
spi-au1550_spi-improve-pio-transfer-mode.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts.patch
rtc-cmos-improve-hpet-irq-glue.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed.patch
atmel_lcdfb-avoid-division-by-zero.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant.patch
lcd-add-platform_lcd-driver.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons.patch

