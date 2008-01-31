From: akpm@linux-foundation.org
Subject: + mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch added to -mm tree
Date: Wed, 30 Jan 2008 16:39:58 -0800
Message-ID: <200801310039.m0V0dwLa000406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760583AbYAaAkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 19:40:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mszeredi@suse.cz


The patch titled
     mm: bdi: allow setting a minimum for the bdi dirty limit
has been added to the -mm tree.  Its filename is
     mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: allow setting a minimum for the bdi dirty limit
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Add "min_ratio" to /sys/class/bdi.  This indicates the minimum percentage of
the global dirty threshold allocated to this bdi.

[mszeredi@suse.cz]

 - fix parsing in min_ratio_store()
 - document new sysfs attribute

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |    6 ++++
 include/linux/backing-dev.h               |    4 ++
 mm/backing-dev.c                          |   21 +++++++++++++++
 mm/page-writeback.c                       |   27 +++++++++++++++++++-
 4 files changed, 57 insertions(+), 1 deletion(-)

diff -puN Documentation/ABI/testing/sysfs-class-bdi~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit Documentation/ABI/testing/sysfs-class-bdi
--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -48,3 +48,9 @@ bdi_dirty_kb (read-only)
 	Current threshold on this BDI for reclaimable + writeback
 	memory
 
+min_ratio (read-write)
+
+	Minimal percentage of global dirty threshold allocated to this
+	bdi.  If the value written to this file would make the the sum
+	of all min_ratio values exceed 100, then EINVAL is returned.
+	The default is zero
diff -puN include/linux/backing-dev.h~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit
+++ a/include/linux/backing-dev.h
@@ -51,6 +51,8 @@ struct backing_dev_info {
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
 
+	unsigned int min_ratio;
+
 	struct device *dev;
 };
 
@@ -136,6 +138,8 @@ static inline unsigned long bdi_stat_err
 #endif
 }
 
+int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
+
 /*
  * Flags in backing_dev_info::capability
  * - The first two flags control whether dirty pages will contribute to the
diff -puN mm/backing-dev.c~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit mm/backing-dev.c
--- a/mm/backing-dev.c~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit
+++ a/mm/backing-dev.c
@@ -50,6 +50,24 @@ static inline unsigned long get_dirty(st
 BDI_SHOW(dirty_kb, K(get_dirty(bdi, 1)))
 BDI_SHOW(bdi_dirty_kb, K(get_dirty(bdi, 2)))
 
+static ssize_t min_ratio_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	char *end;
+	unsigned int ratio;
+	ssize_t ret = -EINVAL;
+
+	ratio = simple_strtoul(buf, &end, 10);
+	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
+		ret = bdi_set_min_ratio(bdi, ratio);
+		if (!ret)
+			ret = count;
+	}
+	return ret;
+}
+BDI_SHOW(min_ratio, bdi->min_ratio)
+
 #define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
 
 static struct device_attribute bdi_dev_attrs[] = {
@@ -58,6 +76,7 @@ static struct device_attribute bdi_dev_a
 	__ATTR_RO(writeback_kb),
 	__ATTR_RO(dirty_kb),
 	__ATTR_RO(bdi_dirty_kb),
+	__ATTR_RW(min_ratio),
 	__ATTR_NULL,
 };
 
@@ -116,6 +135,8 @@ int bdi_init(struct backing_dev_info *bd
 
 	bdi->dev = NULL;
 
+	bdi->min_ratio = 0;
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
 		if (err)
diff -puN mm/page-writeback.c~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit mm/page-writeback.c
--- a/mm/page-writeback.c~mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit
+++ a/mm/page-writeback.c
@@ -243,6 +243,29 @@ static void task_dirty_limit(struct task
 }
 
 /*
+ *
+ */
+static DEFINE_SPINLOCK(bdi_lock);
+static unsigned int bdi_min_ratio;
+
+int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bdi_lock, flags);
+	min_ratio -= bdi->min_ratio;
+	if (bdi_min_ratio + min_ratio < 100) {
+		bdi_min_ratio += min_ratio;
+		bdi->min_ratio += min_ratio;
+	} else
+		ret = -EINVAL;
+	spin_unlock_irqrestore(&bdi_lock, flags);
+
+	return ret;
+}
+
+/*
  * Work out the current dirty-memory clamping and background writeout
  * thresholds.
  *
@@ -330,7 +353,7 @@ get_dirty_limits(long *pbackground, long
 	*pdirty = dirty;
 
 	if (bdi) {
-		u64 bdi_dirty = dirty;
+		u64 bdi_dirty;
 		long numerator, denominator;
 
 		/*
@@ -338,8 +361,10 @@ get_dirty_limits(long *pbackground, long
 		 */
 		bdi_writeout_fraction(bdi, &numerator, &denominator);
 
+		bdi_dirty = (dirty * (100 - bdi_min_ratio)) / 100;
 		bdi_dirty *= numerator;
 		do_div(bdi_dirty, denominator);
+		bdi_dirty += (dirty * bdi->min_ratio) / 100;
 
 		*pbdi_dirty = bdi_dirty;
 		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
lockdep-annotate-epoll.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
mm-page-writeback-highmem_is_dirtyable-option.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
fix-dirty-page-accounting-leak-with-ext3-data=journal.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
