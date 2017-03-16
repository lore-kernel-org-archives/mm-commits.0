From: akpm@linux-foundation.org
Subject: +
 mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch added to -mm tree
Date: Thu, 16 Mar 2017 13:51:58 -0700
Message-ID: <58cafaee.vHuBIizfWOE3g50f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52822 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752871AbdCPVDt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:03:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, ebaskakov@nvidia.com, jhubbard@nvidia.com, mhairgrove@nvidia.com, sgutti@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm/mirror: mirror process address space on device with HMM helpers
has been added to the -mm tree.  Its filename is
     mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/hmm/mirror: mirror process address space on device with HMM helpers

This is heterogeneous memory management (HMM) process address space
mirroring.  In a nutshell this provide an API to mirror process address
space on a device.  This boils down to keeping CPU and device page table
synchronize (we assume that both device and CPU are cache coherent like
PCIe device can be).

This patch provide a simple API for device driver to achieve address space
mirroring thus avoiding each device driver to grow its own CPU page table
walker and its own CPU page table synchronization mechanism.

This is useful for NVidia GPU >= Pascal, Mellanox IB >= mlx5 and more
hardware in the future.

Link: http://lkml.kernel.org/r/1489680335-6594-11-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Evgeny Baskakov <ebaskakov@nvidia.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Mark Hairgrove <mhairgrove@nvidia.com>
Signed-off-by: Sherry Cheung <SCheung@nvidia.com>
Signed-off-by: Subhash Gutti <sgutti@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h |  101 ++++++++++++++++++++++
 mm/Kconfig          |   15 +++
 mm/hmm.c            |  186 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 302 insertions(+)

diff -puN include/linux/hmm.h~mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers
+++ a/include/linux/hmm.h
@@ -79,6 +79,7 @@
 
 #if IS_ENABLED(CONFIG_HMM)
 
+struct hmm;
 
 /*
  * hmm_pfn_t - HMM use its own pfn type to keep several flags per page
@@ -141,6 +142,106 @@ static inline hmm_pfn_t hmm_pfn_from_pfn
 }
 
 
+#if IS_ENABLED(CONFIG_HMM_MIRROR)
+/*
+ * Mirroring: how to use synchronize device page table with CPU page table ?
+ *
+ * Device driver must always synchronize with CPU page table update, for this
+ * they can either directly use mmu_notifier API or they can use the hmm_mirror
+ * API. Device driver can decide to register one mirror per device per process
+ * or just one mirror per process for a group of device. Pattern is:
+ *
+ *      int device_bind_address_space(..., struct mm_struct *mm, ...)
+ *      {
+ *          struct device_address_space *das;
+ *          int ret;
+ *          // Device driver specific initialization, and allocation of das
+ *          // which contain an hmm_mirror struct as one of its field.
+ *          ret = hmm_mirror_register(&das->mirror, mm, &device_mirror_ops);
+ *          if (ret) {
+ *              // Cleanup on error
+ *              return ret;
+ *          }
+ *          // Other device driver specific initialization
+ *      }
+ *
+ * Device driver must not free the struct containing hmm_mirror struct before
+ * calling hmm_mirror_unregister() expected usage is to do that when device
+ * driver is unbinding from an address space.
+ *
+ *      void device_unbind_address_space(struct device_address_space *das)
+ *      {
+ *          // Device driver specific cleanup
+ *          hmm_mirror_unregister(&das->mirror);
+ *          // Other device driver specific cleanup and now das can be free
+ *      }
+ *
+ * Once an hmm_mirror is registered for an address space, device driver will get
+ * callbacks through the update() operation (see hmm_mirror_ops struct).
+ */
+
+struct hmm_mirror;
+
+/*
+ * enum hmm_update - type of update
+ * @HMM_UPDATE_INVALIDATE: invalidate range (no indication as to why)
+ */
+enum hmm_update {
+	HMM_UPDATE_INVALIDATE,
+};
+
+/*
+ * struct hmm_mirror_ops - HMM mirror device operations callback
+ *
+ * @update: callback to update range on a device
+ */
+struct hmm_mirror_ops {
+	/* update() - update virtual address range of memory
+	 *
+	 * @mirror: pointer to struct hmm_mirror
+	 * @update: update's type (turn read only, unmap, ...)
+	 * @start: virtual start address of the range to update
+	 * @end: virtual end address of the range to update
+	 *
+	 * This callback is call when the CPU page table is updated, the device
+	 * driver must update device page table accordingly to update's action.
+	 *
+	 * Device driver callback must wait until the device has fully updated
+	 * its view for the range. Note we plan to make this asynchronous in
+	 * later patches, so that multiple devices can schedule update to their
+	 * page tables, and once all device have schedule the update then we
+	 * wait for them to propagate.
+	 */
+	void (*update)(struct hmm_mirror *mirror,
+		       enum hmm_update action,
+		       unsigned long start,
+		       unsigned long end);
+};
+
+/*
+ * struct hmm_mirror - mirror struct for a device driver
+ *
+ * @hmm: pointer to struct hmm (which is unique per mm_struct)
+ * @ops: device driver callback for HMM mirror operations
+ * @list: for list of mirrors of a given mm
+ *
+ * Each address space (mm_struct) being mirrored by a device must register one
+ * of hmm_mirror struct with HMM. HMM will track list of all mirrors for each
+ * mm_struct (or each process).
+ */
+struct hmm_mirror {
+	struct hmm			*hmm;
+	const struct hmm_mirror_ops	*ops;
+	struct list_head		list;
+};
+
+int hmm_mirror_register(struct hmm_mirror *mirror, struct mm_struct *mm);
+int hmm_mirror_register_locked(struct hmm_mirror *mirror,
+			       struct mm_struct *mm);
+void hmm_mirror_unregister(struct hmm_mirror *mirror);
+#endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
+
+
 /* Below are for HMM internal use only! Not to be used by device driver! */
 void hmm_mm_destroy(struct mm_struct *mm);
 
diff -puN mm/Kconfig~mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers mm/Kconfig
--- a/mm/Kconfig~mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers
+++ a/mm/Kconfig
@@ -293,6 +293,21 @@ config HMM
 	bool
 	depends on MMU
 
+config HMM_MIRROR
+	bool "HMM mirror CPU page table into a device page table"
+	select HMM
+	select MMU_NOTIFIER
+	help
+	  HMM mirror is a set of helpers to mirror CPU page table into a device
+	  page table. There is two side, first keep both page table synchronize
+	  so that no virtual address can point to different page (but one page
+	  table might lag ie onee might still point to page while the other is
+	  is pointing to nothing).
+
+	  Second side of the equation is replicating CPU page table content for
+	  range of virtual address. This require careful synchronization with
+	  CPU page table update.
+
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
 
diff -puN mm/hmm.c~mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers mm/hmm.c
--- a/mm/hmm.c~mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers
+++ a/mm/hmm.c
@@ -21,14 +21,27 @@
 #include <linux/hmm.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/mmu_notifier.h>
 
 /*
  * struct hmm - HMM per mm struct
  *
  * @mm: mm struct this HMM struct is bound to
+ * @lock: lock protecting mirrors list
+ * @mirrors: list of mirrors for this mm
+ * @wait_queue: wait queue
+ * @sequence: we track updates to the CPU page table with a sequence number
+ * @mmu_notifier: mmu notifier to track updates to CPU page table
+ * @notifier_count: number of currently active notifiers
  */
 struct hmm {
 	struct mm_struct	*mm;
+	spinlock_t		lock;
+	struct list_head	mirrors;
+	atomic_t		sequence;
+	wait_queue_head_t	wait_queue;
+	struct mmu_notifier	mmu_notifier;
+	atomic_t		notifier_count;
 };
 
 /*
@@ -47,6 +60,12 @@ static struct hmm *hmm_register(struct m
 		hmm = kmalloc(sizeof(*hmm), GFP_KERNEL);
 		if (!hmm)
 			return NULL;
+		init_waitqueue_head(&hmm->wait_queue);
+		atomic_set(&hmm->notifier_count, 0);
+		INIT_LIST_HEAD(&hmm->mirrors);
+		atomic_set(&hmm->sequence, 0);
+		hmm->mmu_notifier.ops = NULL;
+		spin_lock_init(&hmm->lock);
 		hmm->mm = mm;
 
 		spin_lock(&mm->page_table_lock);
@@ -79,3 +98,170 @@ void hmm_mm_destroy(struct mm_struct *mm
 	spin_unlock(&mm->page_table_lock);
 	kfree(hmm);
 }
+
+
+#if IS_ENABLED(CONFIG_HMM_MIRROR)
+static void hmm_invalidate_range(struct hmm *hmm,
+				 enum hmm_update action,
+				 unsigned long start,
+				 unsigned long end)
+{
+	struct hmm_mirror *mirror;
+
+	/*
+	 * Mirror being added or removed is a rare event so list traversal isn't
+	 * protected by a lock, we rely on simple rules. All list modification
+	 * are done using list_add_rcu() and list_del_rcu() under a spinlock to
+	 * protect from concurrent addition or removal but not traversal.
+	 *
+	 * Because hmm_mirror_unregister() waits for all running invalidation to
+	 * complete (and thus all list traversals to finish), none of the mirror
+	 * structs can be freed from under us while traversing the list and thus
+	 * it is safe to dereference their list pointer even if they were just
+	 * removed.
+	 */
+	list_for_each_entry (mirror, &hmm->mirrors, list)
+		mirror->ops->update(mirror, action, start, end);
+}
+
+static void hmm_invalidate_page(struct mmu_notifier *mn,
+				struct mm_struct *mm,
+				unsigned long addr)
+{
+	unsigned long start = addr & PAGE_MASK;
+	unsigned long end = start + PAGE_SIZE;
+	struct hmm *hmm = mm->hmm;
+
+	VM_BUG_ON(!hmm);
+
+	atomic_inc(&hmm->notifier_count);
+	atomic_inc(&hmm->sequence);
+	hmm_invalidate_range(mm->hmm, HMM_UPDATE_INVALIDATE, start, end);
+	atomic_dec(&hmm->notifier_count);
+	wake_up(&hmm->wait_queue);
+}
+
+static void hmm_invalidate_range_start(struct mmu_notifier *mn,
+				       struct mm_struct *mm,
+				       unsigned long start,
+				       unsigned long end)
+{
+	struct hmm *hmm = mm->hmm;
+
+	VM_BUG_ON(!hmm);
+
+	atomic_inc(&hmm->notifier_count);
+	atomic_inc(&hmm->sequence);
+}
+
+static void hmm_invalidate_range_end(struct mmu_notifier *mn,
+				     struct mm_struct *mm,
+				     unsigned long start,
+				     unsigned long end)
+{
+	struct hmm *hmm = mm->hmm;
+
+	VM_BUG_ON(!hmm);
+
+	hmm_invalidate_range(mm->hmm, HMM_UPDATE_INVALIDATE, start, end);
+
+	/* Reverse order here because we are getting out of invalidation */
+	atomic_dec(&hmm->notifier_count);
+	wake_up(&hmm->wait_queue);
+}
+
+static const struct mmu_notifier_ops hmm_mmu_notifier_ops = {
+	.invalidate_page	= hmm_invalidate_page,
+	.invalidate_range_start	= hmm_invalidate_range_start,
+	.invalidate_range_end	= hmm_invalidate_range_end,
+};
+
+static int hmm_mirror_do_register(struct hmm_mirror *mirror,
+				  struct mm_struct *mm,
+				  const bool locked)
+{
+	/* Sanity check */
+	if (!mm || !mirror || !mirror->ops)
+		return -EINVAL;
+
+	mirror->hmm = hmm_register(mm);
+	if (!mirror->hmm)
+		return -ENOMEM;
+
+	/* Register mmu_notifier if not already, use mmap_sem for locking */
+	if (!mirror->hmm->mmu_notifier.ops) {
+		struct hmm *hmm = mirror->hmm;
+
+		if (!locked)
+			down_write(&mm->mmap_sem);
+		if (!hmm->mmu_notifier.ops) {
+			hmm->mmu_notifier.ops = &hmm_mmu_notifier_ops;
+			if (__mmu_notifier_register(&hmm->mmu_notifier, mm)) {
+				hmm->mmu_notifier.ops = NULL;
+				up_write(&mm->mmap_sem);
+				return -ENOMEM;
+			}
+		}
+		if (!locked)
+			up_write(&mm->mmap_sem);
+	}
+
+	spin_lock(&mirror->hmm->lock);
+	list_add_rcu(&mirror->list, &mirror->hmm->mirrors);
+	spin_unlock(&mirror->hmm->lock);
+
+	return 0;
+}
+
+/*
+ * hmm_mirror_register() - register a mirror against an mm
+ *
+ * @mirror: new mirror struct to register
+ * @mm: mm to register against
+ *
+ * To start mirroring a process address space, the device driver must register
+ * an HMM mirror struct.
+ */
+int hmm_mirror_register(struct hmm_mirror *mirror, struct mm_struct *mm)
+{
+	return hmm_mirror_do_register(mirror, mm, false);
+}
+EXPORT_SYMBOL(hmm_mirror_register);
+
+/*
+ * hmm_mirror_register_locked() - register a mirror against an mm
+ *
+ * @mirror: new mirror struct to register
+ * @mm: mm to register against
+ *
+ * Same as hmm_mirror_register() except that mmap_sem must be held for writing.
+ */
+int hmm_mirror_register_locked(struct hmm_mirror *mirror, struct mm_struct *mm)
+{
+	return hmm_mirror_do_register(mirror, mm, true);
+}
+EXPORT_SYMBOL(hmm_mirror_register_locked);
+
+/*
+ * hmm_mirror_unregister() - unregister a mirror
+ *
+ * @mirror: new mirror struct to register
+ *
+ * Stop mirroring a process address space, and cleanup.
+ */
+void hmm_mirror_unregister(struct hmm_mirror *mirror)
+{
+	struct hmm *hmm = mirror->hmm;
+
+	spin_lock(&hmm->lock);
+	list_del_rcu(&mirror->list);
+	spin_unlock(&hmm->lock);
+
+	/*
+	 * Wait for all active notifiers so that it is safe to traverse the
+	 * mirror list without holding any locks.
+	 */
+	wait_event(hmm->wait_queue, !atomic_read(&hmm->notifier_count));
+}
+EXPORT_SYMBOL(hmm_mirror_unregister);
+#endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3.patch
mm-put_page-move-ref-decrement-to-put_zone_device_page.patch
mm-zone_device-free-page-callback-when-page-is-freed-v3.patch
mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3.patch
mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch
mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch

