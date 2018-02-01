From: akpm@linux-foundation.org
Subject: [merged] hugetlb-implement-memfd-sealing.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:33:31 -0800
Message-ID: <20180201193331.8W0j25rM7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754623AbeBATdj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:33:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dh.herrmann@gmail.com, hughd@google.com, marcandre.lureau@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: implement memfd sealing
has been removed from the -mm tree.  Its filename was
     hugetlb-implement-memfd-sealing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marc-André Lureau <marcandre.lureau@redhat.com>
Subject: hugetlb: implement memfd sealing

Implements memfd sealing, similar to shmem:
- WRITE: deny fallocate(PUNCH_HOLE). mmap() write is denied in
  memfd_add_seals(). write() doesn't exist for hugetlbfs.
- SHRINK: added similar check as shmem_setattr()
- GROW: added similar check as shmem_setattr() & shmem_fallocate()

Except write() operation that doesn't exist with hugetlbfs, that
should make sealing as close as it can be to shmem support.

Link: http://lkml.kernel.org/r/20171107122800.25517-5-marcandre.lureau@redhat.com
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   29 +++++++++++++++++++++++++++--
 include/linux/hugetlb.h |    1 +
 2 files changed, 28 insertions(+), 2 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-implement-memfd-sealing fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-implement-memfd-sealing
+++ a/fs/hugetlbfs/inode.c
@@ -510,8 +510,16 @@ static long hugetlbfs_punch_hole(struct
 
 	if (hole_end > hole_start) {
 		struct address_space *mapping = inode->i_mapping;
+		struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
 
 		inode_lock(inode);
+
+		/* protected by i_mutex */
+		if (info->seals & F_SEAL_WRITE) {
+			inode_unlock(inode);
+			return -EPERM;
+		}
+
 		i_mmap_lock_write(mapping);
 		if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
 			hugetlb_vmdelete_list(&mapping->i_mmap,
@@ -529,6 +537,7 @@ static long hugetlbfs_fallocate(struct f
 				loff_t len)
 {
 	struct inode *inode = file_inode(file);
+	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
 	struct address_space *mapping = inode->i_mapping;
 	struct hstate *h = hstate_inode(inode);
 	struct vm_area_struct pseudo_vma;
@@ -560,6 +569,11 @@ static long hugetlbfs_fallocate(struct f
 	if (error)
 		goto out;
 
+	if ((info->seals & F_SEAL_GROW) && offset + len > inode->i_size) {
+		error = -EPERM;
+		goto out;
+	}
+
 	/*
 	 * Initialize a pseudo vma as this is required by the huge page
 	 * allocation routines.  If NUMA is configured, use page index
@@ -650,6 +664,7 @@ static int hugetlbfs_setattr(struct dent
 	struct hstate *h = hstate_inode(inode);
 	int error;
 	unsigned int ia_valid = attr->ia_valid;
+	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
 
 	BUG_ON(!inode);
 
@@ -658,9 +673,16 @@ static int hugetlbfs_setattr(struct dent
 		return error;
 
 	if (ia_valid & ATTR_SIZE) {
-		if (attr->ia_size & ~huge_page_mask(h))
+		loff_t oldsize = inode->i_size;
+		loff_t newsize = attr->ia_size;
+
+		if (newsize & ~huge_page_mask(h))
 			return -EINVAL;
-		error = hugetlb_vmtruncate(inode, attr->ia_size);
+		/* protected by i_mutex */
+		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
+		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
+			return -EPERM;
+		error = hugetlb_vmtruncate(inode, newsize);
 		if (error)
 			return error;
 	}
@@ -712,6 +734,8 @@ static struct inode *hugetlbfs_get_inode
 
 	inode = new_inode(sb);
 	if (inode) {
+		struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
+
 		inode->i_ino = get_next_ino();
 		inode_init_owner(inode, dir, mode);
 		lockdep_set_class(&inode->i_mapping->i_mmap_rwsem,
@@ -719,6 +743,7 @@ static struct inode *hugetlbfs_get_inode
 		inode->i_mapping->a_ops = &hugetlbfs_aops;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = current_time(inode);
 		inode->i_mapping->private_data = resv_map;
+		info->seals = F_SEAL_SEAL;
 		switch (mode & S_IFMT) {
 		default:
 			init_special_inode(inode, mode, dev);
diff -puN include/linux/hugetlb.h~hugetlb-implement-memfd-sealing include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-implement-memfd-sealing
+++ a/include/linux/hugetlb.h
@@ -273,6 +273,7 @@ static inline struct hugetlbfs_sb_info *
 struct hugetlbfs_inode_info {
 	struct shared_policy policy;
 	struct inode vfs_inode;
+	unsigned int seals;
 };
 
 static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
_

Patches currently in -mm which might be from marcandre.lureau@redhat.com are

mm-page_owner-align-with-pageblock_nr_pages.patch

