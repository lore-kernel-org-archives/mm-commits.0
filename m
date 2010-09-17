From: akpm@linux-foundation.org
Subject: + drivers-pci-intel-iommuc-fix-build-with-older-gccs.patch added to -mm tree
Date: Fri, 17 Sep 2010 15:52:21 -0700
Message-ID: <201009172252.o8HMqLoe014588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136Ab0IQWwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 18:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dwmw2@infradead.org, jbarnes@virtuousgeek.org, mmokrejs@ribosome.natur.cuni.cz, stable@kernel.org


The patch titled
     drivers/pci/intel-iommu.c: fix build with older gcc's
has been added to the -mm tree.  Its filename is
     drivers-pci-intel-iommuc-fix-build-with-older-gccs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/pci/intel-iommu.c: fix build with older gcc's
From: Andrew Morton <akpm@linux-foundation.org>

drivers/pci/intel-iommu.c: In function `__iommu_calculate_agaw':
drivers/pci/intel-iommu.c:437: sorry, unimplemented: inlining failed in call to 'width_to_agaw': function body not available
drivers/pci/intel-iommu.c:445: sorry, unimplemented: called from here

Move the offending function (and its siblings) to top-of-file, remove the
forward declaration.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=17441

Reported-by: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |   90 +++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 47 deletions(-)

diff -puN drivers/pci/intel-iommu.c~drivers-pci-intel-iommuc-fix-build-with-older-gccs drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~drivers-pci-intel-iommuc-fix-build-with-older-gccs
+++ a/drivers/pci/intel-iommu.c
@@ -71,6 +71,49 @@
 #define DMA_32BIT_PFN		IOVA_PFN(DMA_BIT_MASK(32))
 #define DMA_64BIT_PFN		IOVA_PFN(DMA_BIT_MASK(64))
 
+/* page table handling */
+#define LEVEL_STRIDE		(9)
+#define LEVEL_MASK		(((u64)1 << LEVEL_STRIDE) - 1)
+
+static inline int agaw_to_level(int agaw)
+{
+	return agaw + 2;
+}
+
+static inline int agaw_to_width(int agaw)
+{
+	return 30 + agaw * LEVEL_STRIDE;
+}
+
+static inline int width_to_agaw(int width)
+{
+	return (width - 30) / LEVEL_STRIDE;
+}
+
+static inline unsigned int level_to_offset_bits(int level)
+{
+	return (level - 1) * LEVEL_STRIDE;
+}
+
+static inline int pfn_level_offset(unsigned long pfn, int level)
+{
+	return (pfn >> level_to_offset_bits(level)) & LEVEL_MASK;
+}
+
+static inline unsigned long level_mask(int level)
+{
+	return -1UL << level_to_offset_bits(level);
+}
+
+static inline unsigned long level_size(int level)
+{
+	return 1UL << level_to_offset_bits(level);
+}
+
+static inline unsigned long align_to_level(unsigned long pfn, int level)
+{
+	return (pfn + level_size(level) - 1) & level_mask(level);
+}
 
 /* VT-d pages must always be _smaller_ than MM pages. Otherwise things
    are never going to work. */
@@ -434,8 +477,6 @@ void free_iova_mem(struct iova *iova)
 }
 
 
-static inline int width_to_agaw(int width);
-
 static int __iommu_calculate_agaw(struct intel_iommu *iommu, int max_gaw)
 {
 	unsigned long sagaw;
@@ -646,51 +687,6 @@ out:
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-/* page table handling */
-#define LEVEL_STRIDE		(9)
-#define LEVEL_MASK		(((u64)1 << LEVEL_STRIDE) - 1)
-
-static inline int agaw_to_level(int agaw)
-{
-	return agaw + 2;
-}
-
-static inline int agaw_to_width(int agaw)
-{
-	return 30 + agaw * LEVEL_STRIDE;
-
-}
-
-static inline int width_to_agaw(int width)
-{
-	return (width - 30) / LEVEL_STRIDE;
-}
-
-static inline unsigned int level_to_offset_bits(int level)
-{
-	return (level - 1) * LEVEL_STRIDE;
-}
-
-static inline int pfn_level_offset(unsigned long pfn, int level)
-{
-	return (pfn >> level_to_offset_bits(level)) & LEVEL_MASK;
-}
-
-static inline unsigned long level_mask(int level)
-{
-	return -1UL << level_to_offset_bits(level);
-}
-
-static inline unsigned long level_size(int level)
-{
-	return 1UL << level_to_offset_bits(level);
-}
-
-static inline unsigned long align_to_level(unsigned long pfn, int level)
-{
-	return (pfn + level_size(level) - 1) & level_mask(level);
-}
-
 static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 				      unsigned long pfn)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes.patch
mm-vmap-area-cache.patch
drivers-pci-intel-iommuc-fix-build-with-older-gccs.patch
acpi-apei-fix-erst-move_data-instruction-implementation.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
drivers-media-video-cx23885-cx23885-corec-fix-cx23885_dev_checkrevision.patch
fs-notify-fanotify-fanotify_userc-fix-warnings.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
sctp-prevent-reading-out-of-bounds-memory-cleanup.patch
drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl-checkpatch-fixes.patch
serial-add-sc16is7x2-driver-update-fix.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-message-fusion-mptsasc-fix-warning.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
mmc_test-move-files-from-sysfs-to-debugfs-checkpatch-fixes.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

