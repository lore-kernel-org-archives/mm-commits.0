From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb-expose-hugetlbfs_inode_info-in-header.patch removed from -mm tree
Date: Thu, 01 Feb 2018 11:33:26 -0800
Message-ID: <20180201193326.Itf2AgBIm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59656 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754623AbeBATdg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:33:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dh.herrmann@gmail.com, hughd@google.com, marcandre.lureau@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: expose hugetlbfs_inode_info in header
has been removed from the -mm tree.  Its filename was
     hugetlb-expose-hugetlbfs_inode_info-in-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marc-André Lureau <marcandre.lureau@redhat.com>
Subject: hugetlb: expose hugetlbfs_inode_info in header

hugetlbfs inode information will need to be accessed by code in mm/shmem.c
for file sealing operations.  Move inode information definition from .c
file to header for needed access.

Link: http://lkml.kernel.org/r/20171107122800.25517-4-marcandre.lureau@redhat.com
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   10 ----------
 include/linux/hugetlb.h |   10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-expose-hugetlbfs_inode_info-in-header fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-expose-hugetlbfs_inode_info-in-header
+++ a/fs/hugetlbfs/inode.c
@@ -55,16 +55,6 @@ struct hugetlbfs_config {
 	umode_t			mode;
 };
 
-struct hugetlbfs_inode_info {
-	struct shared_policy policy;
-	struct inode vfs_inode;
-};
-
-static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
-{
-	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
-}
-
 int sysctl_hugetlb_shm_group;
 
 enum {
diff -puN include/linux/hugetlb.h~hugetlb-expose-hugetlbfs_inode_info-in-header include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-expose-hugetlbfs_inode_info-in-header
+++ a/include/linux/hugetlb.h
@@ -270,6 +270,16 @@ static inline struct hugetlbfs_sb_info *
 	return sb->s_fs_info;
 }
 
+struct hugetlbfs_inode_info {
+	struct shared_policy policy;
+	struct inode vfs_inode;
+};
+
+static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
+{
+	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
+}
+
 extern const struct file_operations hugetlbfs_file_operations;
 extern const struct vm_operations_struct hugetlb_vm_ops;
 struct file *hugetlb_file_setup(const char *name, size_t size, vm_flags_t acct,
_

Patches currently in -mm which might be from marcandre.lureau@redhat.com are

mm-page_owner-align-with-pageblock_nr_pages.patch

