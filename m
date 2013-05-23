From: akpm@linux-foundation.org
Subject: +
 drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
 added to -mm tree
Date: Thu, 23 May 2013 16:27:27 -0700
Message-ID: <519ea5df.T22Z34KVYMUnuHSA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759888Ab3EWX12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 19:27:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, libo.chen@huawei.com, james.hogan@imgtec.com, dwmw2@infradead.org, davidb@codeaurora.org, clbchenlibo.chen@huawei.com, akpm@linux-foundation.org

Subject: + drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch added to -mm tree
To: akpm@linux-foundation.org,clbchenlibo.chen@huawei.com,davidb@codeaurora.org,dwmw2@infradead.org,james.hogan@imgtec.com,libo.chen@huawei.com
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 16:27:27 -0700


The patch titled
     Subject: drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix
has been added to the -mm tree.  Its filename is
     drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix

remove now-unneeded initialization of ctx_drvdata, remove unneeded braces

Cc: David Brown <davidb@codeaurora.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: Libo Chen <libo.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/msm_iommu_dev.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/iommu/msm_iommu_dev.c~drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix drivers/iommu/msm_iommu_dev.c
--- a/drivers/iommu/msm_iommu_dev.c~drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix
+++ a/drivers/iommu/msm_iommu_dev.c
@@ -289,22 +289,19 @@ static int msm_iommu_ctx_probe(struct pl
 {
 	struct msm_iommu_ctx_dev *c = pdev->dev.platform_data;
 	struct msm_iommu_drvdata *drvdata;
-	struct msm_iommu_ctx_drvdata *ctx_drvdata = NULL;
+	struct msm_iommu_ctx_drvdata *ctx_drvdata;
 	int i, ret;
-	if (!c || !pdev->dev.parent) {
+
+	if (!c || !pdev->dev.parent)
 		return -EINVAL;
-	}
 
 	drvdata = dev_get_drvdata(pdev->dev.parent);
-
-	if (!drvdata) {
+	if (!drvdata)
 		return -ENODEV;
-	}
 
 	ctx_drvdata = kzalloc(sizeof(*ctx_drvdata), GFP_KERNEL);
-	if (!ctx_drvdata) {
+	if (!ctx_drvdata)
 		return -ENOMEM;
-	}
 
 	ctx_drvdata->num = c->num;
 	ctx_drvdata->pdev = pdev;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
revert-selftest-add-simple-test-for-soft-dirty-bit.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

