From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbfs-move-hugetlbfs_i-outside-ifdef-config_hugetlbfs.patch added to -mm tree
Date: Thu, 08 Feb 2018 16:04:46 -0800
Message-ID: <5a7ce59e.ifw5j4UZV3IUgNIQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34062 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeBIAEs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 19:04:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aarcange@redhat.com, akpm@linux-foundation.org, dh.herrmann@gmail.com, hughd@google.com, khalid.aziz@oracle.com, marcandre.lureau@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlbfs: move HUGETLBFS_I outside #ifdef CONFIG_HUGETLBFS
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-move-hugetlbfs_i-outside-ifdef-config_hugetlbfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-move-hugetlbfs_i-outside-ifdef-config_hugetlbfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-move-hugetlbfs_i-outside-ifdef-config_hugetlbfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm: hugetlbfs: move HUGETLBFS_I outside #ifdef CONFIG_HUGETLBFS

Patch series "restructure memfd code", v2.

With the addition of memfd hugetlbfs support, we now have the situation
where memfd depends on TMPFS -or- HUGETLBFS.  Previously, memfd was only
supported on tmpfs, so it made sense that the code resides in shmem.c.

This patch series moves the memfd code to separate files (memfd.c and
memfd.h).  It creates a new config option MEMFD_CREATE that is defined if
either TMPFS or HUGETLBFS is defined.

In the current code, memfd is only functional if TMPFS is defined.  If
HUGETLFS is defined and TMPFS is not defined, then memfd functionality
will not be available for hugetlbfs.  This does not cause BUGs, just a
potential lack of desired functionality.

When this was sent as a RFC, one comment suggested combining patches 2 and
3 so that we would not have 'new unused' files between patches.  If this
is desired, I can make the change.  For me, it is easier to read as
separate patches.


This patch (of 3):

HUGETLBFS_I will be referenced (but not used) in code outside #ifdef
CONFIG_HUGETLBFS.  Move the definition to prevent compiler errors.

Link: http://lkml.kernel.org/r/20180131022911.23947-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Marc-André Lureau <marcandre.lureau@gmail.com>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlbfs-move-hugetlbfs_i-outside-ifdef-config_hugetlbfs include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlbfs-move-hugetlbfs_i-outside-ifdef-config_hugetlbfs
+++ a/include/linux/hugetlb.h
@@ -9,6 +9,7 @@
 #include <linux/cgroup.h>
 #include <linux/list.h>
 #include <linux/kref.h>
+#include <linux/mempolicy.h>
 #include <asm/pgtable.h>
 
 struct ctl_table;
@@ -256,6 +257,21 @@ enum {
 	HUGETLB_ANONHUGE_INODE  = 2,
 };
 
+/*
+ * HUGETLBFS_I (and hugetlbfs_inode_info) referenced but not used by code
+ * outside #ifdef CONFIG_HUGETLBFS.  Define here to prevent compiler errors.
+ */
+struct hugetlbfs_inode_info {
+	struct shared_policy policy;
+	struct inode vfs_inode;
+	unsigned int seals;
+};
+
+static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
+{
+	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
+}
+
 #ifdef CONFIG_HUGETLBFS
 struct hugetlbfs_sb_info {
 	long	max_inodes;   /* inodes allowed */
@@ -273,17 +289,6 @@ static inline struct hugetlbfs_sb_info *
 	return sb->s_fs_info;
 }
 
-struct hugetlbfs_inode_info {
-	struct shared_policy policy;
-	struct inode vfs_inode;
-	unsigned int seals;
-};
-
-static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
-{
-	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
-}
