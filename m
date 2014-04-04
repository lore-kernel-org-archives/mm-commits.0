From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-unify-region-structure-handling.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:31:00 -0700
Message-ID: <533f0874.u0MXpRXyHVJ4BAKF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaDDTbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-unify-region-structure-handling.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:00 -0700


The patch titled
     Subject: mm, hugetlb: unify region structure handling
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-unify-region-structure-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: unify region structure handling

Currently, to track reserved and allocated regions, we use two different
ways, depending on the mapping.  For MAP_SHARED, we use address_mapping's
private_list and, while for MAP_PRIVATE, we use a resv_map.

Now, we are preparing to change a coarse grained lock which protect a
region structure to fine grained lock, and this difference hinder it.  So,
before changing it, unify region structure handling, consistently using a
resv_map regardless of the kind of mapping.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   17 +++++++++++++++--
 include/linux/hugetlb.h |    9 +++++++++
 mm/hugetlb.c            |   37 +++++++++++++++++++++----------------
 3 files changed, 45 insertions(+), 18 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlb-unify-region-structure-handling fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlb-unify-region-structure-handling
+++ a/fs/hugetlbfs/inode.c
@@ -366,7 +366,13 @@ static void truncate_hugepages(struct in
 
 static void hugetlbfs_evict_inode(struct inode *inode)
 {
+	struct resv_map *resv_map;
+
 	truncate_hugepages(inode, 0);
+	resv_map = (struct resv_map *)inode->i_mapping->private_data;
+	/* root inode doesn't have the resv_map, so we should check it */
+	if (resv_map)
+		resv_map_release(&resv_map->refs);
 	clear_inode(inode);
 }
 
@@ -476,6 +482,11 @@ static struct inode *hugetlbfs_get_inode
 					umode_t mode, dev_t dev)
 {
 	struct inode *inode;
+	struct resv_map *resv_map;
+
+	resv_map = resv_map_alloc();
+	if (!resv_map)
+		return NULL;
 
 	inode = new_inode(sb);
 	if (inode) {
@@ -487,7 +498,7 @@ static struct inode *hugetlbfs_get_inode
 		inode->i_mapping->a_ops = &hugetlbfs_aops;
 		inode->i_mapping->backing_dev_info =&hugetlbfs_backing_dev_info;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		INIT_LIST_HEAD(&inode->i_mapping->private_list);
+		inode->i_mapping->private_data = resv_map;
 		info = HUGETLBFS_I(inode);
 		/*
 		 * The policy is initialized here even if we are creating a
@@ -517,7 +528,9 @@ static struct inode *hugetlbfs_get_inode
 			break;
 		}
 		lockdep_annotate_inode_mutex_key(inode);
-	}
+	} else
+		kref_put(&resv_map->refs, resv_map_release);
+
 	return inode;
 }
 
diff -puN include/linux/hugetlb.h~mm-hugetlb-unify-region-structure-handling include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-unify-region-structure-handling
+++ a/include/linux/hugetlb.h
@@ -6,6 +6,8 @@
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
+#include <linux/list.h>
+#include <linux/kref.h>
 
 struct ctl_table;
 struct user_struct;
@@ -23,6 +25,13 @@ struct hugepage_subpool {
 	long max_hpages, used_hpages;
 };
 
+struct resv_map {
+	struct kref refs;
+	struct list_head regions;
+};
+extern struct resv_map *resv_map_alloc(void);
+void resv_map_release(struct kref *ref);
+
 extern spinlock_t hugetlb_lock;
 extern int hugetlb_max_hstate __read_mostly;
 #define for_each_hstate(h) \
diff -puN mm/hugetlb.c~mm-hugetlb-unify-region-structure-handling mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-unify-region-structure-handling
+++ a/mm/hugetlb.c
@@ -376,12 +376,7 @@ static void set_vma_private_data(struct
 	vma->vm_private_data = (void *)value;
 }
 
-struct resv_map {
-	struct kref refs;
-	struct list_head regions;
-};
-
-static struct resv_map *resv_map_alloc(void)
+struct resv_map *resv_map_alloc(void)
 {
 	struct resv_map *resv_map = kmalloc(sizeof(*resv_map), GFP_KERNEL);
 	if (!resv_map)
@@ -393,7 +388,7 @@ static struct resv_map *resv_map_alloc(v
 	return resv_map;
 }
 
-static void resv_map_release(struct kref *ref)
+void resv_map_release(struct kref *ref)
 {
 	struct resv_map *resv_map = container_of(ref, struct resv_map, refs);
 
@@ -1155,8 +1150,9 @@ static long vma_needs_reservation(struct
 
 	if (vma->vm_flags & VM_MAYSHARE) {
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
-		return region_chg(&inode->i_mapping->private_list,
-							idx, idx + 1);
+		struct resv_map *resv = inode->i_mapping->private_data;
+
+		return region_chg(&resv->regions, idx, idx + 1);
 
 	} else if (!is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		return 1;
@@ -1180,7 +1176,9 @@ static void vma_commit_reservation(struc
 
 	if (vma->vm_flags & VM_MAYSHARE) {
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
-		region_add(&inode->i_mapping->private_list, idx, idx + 1);
+		struct resv_map *resv = inode->i_mapping->private_data;
+
+		region_add(&resv->regions, idx, idx + 1);
 
 	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
@@ -3161,6 +3159,7 @@ int hugetlb_reserve_pages(struct inode *
 	long ret, chg;
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
+	struct resv_map *resv_map;
 
 	/*
 	 * Only apply hugepage reservation if asked. At fault time, an
@@ -3176,10 +3175,13 @@ int hugetlb_reserve_pages(struct inode *
 	 * to reserve the full area even if read-only as mprotect() may be
 	 * called to make the mapping read-write. Assume !vma is a shm mapping
 	 */
-	if (!vma || vma->vm_flags & VM_MAYSHARE)
-		chg = region_chg(&inode->i_mapping->private_list, from, to);
-	else {
-		struct resv_map *resv_map = resv_map_alloc();
+	if (!vma || vma->vm_flags & VM_MAYSHARE) {
+		resv_map = inode->i_mapping->private_data;
+
+		chg = region_chg(&resv_map->regions, from, to);
+
+	} else {
+		resv_map = resv_map_alloc();
 		if (!resv_map)
 			return -ENOMEM;
 
@@ -3222,7 +3224,7 @@ int hugetlb_reserve_pages(struct inode *
 	 * else has to be done for private mappings here
 	 */
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
-		region_add(&inode->i_mapping->private_list, from, to);
+		region_add(&resv_map->regions, from, to);
 	return 0;
 out_err:
 	if (vma)
@@ -3233,9 +3235,12 @@ out_err:
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 {
 	struct hstate *h = hstate_inode(inode);
-	long chg = region_truncate(&inode->i_mapping->private_list, offset);
+	struct resv_map *resv_map = inode->i_mapping->private_data;
+	long chg = 0;
 	struct hugepage_subpool *spool = subpool_inode(inode);
 
+	if (resv_map)
+		chg = region_truncate(&resv_map->regions, offset);
 	spin_lock(&inode->i_lock);
 	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compaction-disallow-high-order-page-for-migration-target.patch
mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch
mm-compaction-check-pageblock-suitability-once-per-pageblock.patch
mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-compaction-determine-isolation-mode-only-once.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch
mm-hugetlb-fix-softlockup-when-a-large-number-of-hugepages-are-freed.patch
zram-support-req_discard.patch
zram-support-req_discard-v4.patch
zram-support-req_discard-v4-fix.patch
linux-next.patch
page-owners-correct-page-order-when-to-free-page.patch

