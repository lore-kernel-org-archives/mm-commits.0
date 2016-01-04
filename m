From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 04 Jan 2016 11:04:05 -0800
Message-ID: <568ac225.QMsGg1GTo6nylyYm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbcADTEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2016 14:04:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_display.c |    5 -
 drivers/nvme/host/pci.c              |   95 -------------------------
 2 files changed, 100 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_display.c
--- a/drivers/gpu/drm/i915/intel_display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -14141,12 +14141,7 @@ intel_commit_cursor_plane(struct drm_pla
 
 	intel_crtc->cursor_addr = addr;
 
-<<<<<<< HEAD
-	if (crtc->state->active)
-		intel_crtc_update_cursor(crtc, state->visible);
-=======
 	intel_crtc_update_cursor(crtc, state->visible);
->>>>>>> linux-next/akpm-base
 }
 
 static struct drm_plane *intel_cursor_plane_create(struct drm_device *dev,
diff -puN drivers/nvme/host/pci.c~linux-next-git-rejects drivers/nvme/host/pci.c
--- a/drivers/nvme/host/pci.c~linux-next-git-rejects
+++ a/drivers/nvme/host/pci.c
@@ -1569,81 +1569,6 @@ static int nvme_setup_io_queues(struct n
 	return result;
 }
 
-<<<<<<< HEAD
-static int ns_cmp(void *priv, struct list_head *a, struct list_head *b)
-{
-	struct nvme_ns *nsa = container_of(a, struct nvme_ns, list);
-	struct nvme_ns *nsb = container_of(b, struct nvme_ns, list);
-
-	return nsa->ns_id - nsb->ns_id;
-}
-
-static struct nvme_ns *nvme_find_ns(struct nvme_dev *dev, unsigned nsid)
-{
-	struct nvme_ns *ns;
-
-	list_for_each_entry(ns, &dev->namespaces, list) {
-		if (ns->ns_id == nsid)
-			return ns;
-		if (ns->ns_id > nsid)
-			break;
-	}
-	return NULL;
-}
-
-static inline bool nvme_io_incapable(struct nvme_dev *dev)
-{
-	return (!dev->bar || readl(&dev->bar->csts) & NVME_CSTS_CFS ||
-							dev->online_queues < 2);
-}
-
-static void nvme_ns_remove(struct nvme_ns *ns)
-{
-	bool kill = nvme_io_incapable(ns->dev) && !blk_queue_dying(ns->queue);
-
-	if (kill) {
-		blk_set_queue_dying(ns->queue);
-
-		/*
-		 * The controller was shutdown first if we got here through
-		 * device removal. The shutdown may requeue outstanding
-		 * requests. These need to be aborted immediately so
-		 * del_gendisk doesn't block indefinitely for their completion.
-		 */
-		blk_mq_abort_requeue_list(ns->queue);
-	}
-	if (ns->disk->flags & GENHD_FL_UP)
-		del_gendisk(ns->disk);
-	if (kill || !blk_queue_dying(ns->queue)) {
-		blk_mq_abort_requeue_list(ns->queue);
-		blk_cleanup_queue(ns->queue);
-	}
-	list_del_init(&ns->list);
-	kref_put(&ns->kref, nvme_free_ns);
-}
-
-static void nvme_scan_namespaces(struct nvme_dev *dev, unsigned nn)
-{
-	struct nvme_ns *ns, *next;
-	unsigned i;
-
-	for (i = 1; i <= nn; i++) {
-		ns = nvme_find_ns(dev, i);
-		if (ns) {
-			if (revalidate_disk(ns->disk))
-				nvme_ns_remove(ns);
-		} else
-			nvme_alloc_ns(dev, i);
-	}
-	list_for_each_entry_safe(ns, next, &dev->namespaces, list) {
-		if (ns->ns_id > nn)
-			nvme_ns_remove(ns);
-	}
-	list_sort(NULL, &dev->namespaces, ns_cmp);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static void nvme_set_irq_hints(struct nvme_dev *dev)
 {
 	struct nvme_queue *nvmeq;
@@ -2044,27 +1969,7 @@ static void nvme_dev_shutdown(struct nvm
 
 	for (i = dev->queue_count - 1; i >= 0; i--)
 		nvme_clear_queue(dev->queues[i]);
-<<<<<<< HEAD
-}
-
-static void nvme_dev_remove(struct nvme_dev *dev)
-{
-	struct nvme_ns *ns, *next;
-
-	if (nvme_io_incapable(dev)) {
-		/*
-		 * If the device is not capable of IO (surprise hot-removal,
-		 * for example), we need to quiesce prior to deleting the
-		 * namespaces. This will end outstanding requests and prevent
-		 * attempts to sync dirty data.
-		 */
-		nvme_dev_shutdown(dev);
-	}
-	list_for_each_entry_safe(ns, next, &dev->namespaces, list)
-		nvme_ns_remove(ns);
-=======
 	mutex_unlock(&dev->shutdown_lock);
->>>>>>> linux-next/akpm-base
 }
 
 static int nvme_setup_prp_pools(struct nvme_dev *dev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-introduce-kernelcore=mirror-option-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-printk-introduce-new-format-string-for-flags-fix-2.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-oom-introduce-oom-reaper-fix-fix.patch
mm-oom-introduce-oom-reaper-fix-fix-2.patch
mm-oom-introduce-oom-reaper-checkpatch-fixes.patch
mm-oom-introduce-oom-reaper-fix-3.patch
mm-oom-introduce-oom-reaper-fix-4-fix.patch
mm-oom-introduce-oom-reaper-fix-5-fix.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
include-linux-propertyh-fix-build-issues-with-gcc-444.patch
fs-overlayfs-superc-needs-pagemaph.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

