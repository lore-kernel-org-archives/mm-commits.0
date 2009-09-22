From: akpm@linux-foundation.org
Subject: [merged] ksm-sysfs-and-defaults.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:40:13 -0700
Message-ID: <200909222040.n8MKeDS7005114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbZIVUmR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: sysfs and defaults
has been removed from the -mm tree.  Its filename was
     ksm-sysfs-and-defaults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: sysfs and defaults
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

At present KSM is just a waste of space if you don't have CONFIG_SYSFS=y
to provide the /sys/kernel/mm/ksm files to tune and activate it.

Make KSM depend on SYSFS?  Could do, but it might be better to provide
some defaults so that KSM works out-of-the-box, ready for testers to
madvise MADV_MERGEABLE, even without SYSFS.

Though anyone serious is likely to want to retune the numbers to their
taste once they have experience; and whether these settings ever reach
2.6.32 can be discussed along the way.

Save 1kB from tiny kernels by #ifdef'ing the SYSFS side of it.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff -puN mm/ksm.c~ksm-sysfs-and-defaults mm/ksm.c
--- a/mm/ksm.c~ksm-sysfs-and-defaults
+++ a/mm/ksm.c
@@ -163,18 +163,18 @@ static unsigned long ksm_pages_unshared;
 static unsigned long ksm_rmap_items;
 
 /* Limit on the number of unswappable pages used */
-static unsigned long ksm_max_kernel_pages;
+static unsigned long ksm_max_kernel_pages = 2000;
 
 /* Number of pages ksmd should scan in one batch */
-static unsigned int ksm_thread_pages_to_scan;
+static unsigned int ksm_thread_pages_to_scan = 200;
 
 /* Milliseconds ksmd should sleep between batches */
-static unsigned int ksm_thread_sleep_millisecs;
+static unsigned int ksm_thread_sleep_millisecs = 20;
 
 #define KSM_RUN_STOP	0
 #define KSM_RUN_MERGE	1
 #define KSM_RUN_UNMERGE	2
-static unsigned int ksm_run;
+static unsigned int ksm_run = KSM_RUN_MERGE;
 
 static DECLARE_WAIT_QUEUE_HEAD(ksm_thread_wait);
 static DEFINE_MUTEX(ksm_thread_mutex);
@@ -506,6 +506,10 @@ static int unmerge_ksm_pages(struct vm_a
 	return err;
 }
 
+#ifdef CONFIG_SYSFS
+/*
+ * Only called through the sysfs control interface:
+ */
 static int unmerge_and_remove_all_rmap_items(void)
 {
 	struct mm_slot *mm_slot;
@@ -563,6 +567,7 @@ error:
 	spin_unlock(&ksm_mmlist_lock);
 	return err;
 }
+#endif /* CONFIG_SYSFS */
 
 static u32 calc_checksum(struct page *page)
 {
@@ -1454,6 +1459,11 @@ void __ksm_exit(struct mm_struct *mm)
 	}
 }
 
+#ifdef CONFIG_SYSFS
+/*
+ * This all compiles without CONFIG_SYSFS, but is a waste of space.
+ */
+
 #define KSM_ATTR_RO(_name) \
 	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 #define KSM_ATTR(_name) \
@@ -1636,6 +1646,7 @@ static struct attribute_group ksm_attr_g
 	.attrs = ksm_attrs,
 	.name = "ksm",
 };
+#endif /* CONFIG_SYSFS */
 
 static int __init ksm_init(void)
 {
@@ -1657,16 +1668,17 @@ static int __init ksm_init(void)
 		goto out_free2;
 	}
 
+#ifdef CONFIG_SYSFS
 	err = sysfs_create_group(mm_kobj, &ksm_attr_group);
 	if (err) {
 		printk(KERN_ERR "ksm: register sysfs failed\n");
-		goto out_free3;
+		kthread_stop(ksm_thread);
+		goto out_free2;
 	}
+#endif /* CONFIG_SYSFS */
 
 	return 0;
 
-out_free3:
-	kthread_stop(ksm_thread);
 out_free2:
 	mm_slots_hash_free();
 out_free1:
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

