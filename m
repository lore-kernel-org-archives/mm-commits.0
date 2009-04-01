From: akpm@linux-foundation.org
Subject: [merged] mm-reintroduce-and-deprecate-rlimit-based-access-for-shm_hugetlb.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:36:29 -0700
Message-ID: <200904011836.n31IaTC0007735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933545AbZDASnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kiran@scalex86.org, agl@us.ibm.com, mel@csn.ul.ie, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     mm: reintroduce and deprecate rlimit based access for SHM_HUGETLB
has been removed from the -mm tree.  Its filename was
     mm-reintroduce-and-deprecate-rlimit-based-access-for-shm_hugetlb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: reintroduce and deprecate rlimit based access for SHM_HUGETLB
From: Ravikiran G Thirumalai <kiran@scalex86.org>

Allow non root users with sufficient mlock rlimits to be able to allocate
hugetlb backed shm for now.  Deprecate this though.  This is being
deprecated because the mlock based rlimit checks for SHM_HUGETLB is not
consistent with mmap based huge page allocations.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Adam Litke <agl@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   12 ++++++++++++
 fs/hugetlbfs/inode.c                       |   13 +++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~mm-reintroduce-and-deprecate-rlimit-based-access-for-shm_hugetlb Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~mm-reintroduce-and-deprecate-rlimit-based-access-for-shm_hugetlb
+++ a/Documentation/feature-removal-schedule.txt
@@ -311,6 +311,18 @@ Who:	Vlad Yasevich <vladislav.yasevich@h
 
 ---------------------------
 
+What:	Ability for non root users to shm_get hugetlb pages based on mlock
+	resource limits
+When:	2.6.31
+Why:	Non root users need to be part of /proc/sys/vm/hugetlb_shm_group or
+	have CAP_IPC_LOCK to be able to allocate shm segments backed by
+	huge pages.  The mlock based rlimit check to allow shm hugetlb is
+	inconsistent with mmap based allocations.  Hence it is being
+	deprecated.
+Who:	Ravikiran Thirumalai <kiran@scalex86.org>
+
+---------------------------
+
 What:	CONFIG_THERMAL_HWMON
 When:	January 2009
 Why:	This option was introduced just to allow older lm-sensors userspace
diff -puN fs/hugetlbfs/inode.c~mm-reintroduce-and-deprecate-rlimit-based-access-for-shm_hugetlb fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-reintroduce-and-deprecate-rlimit-based-access-for-shm_hugetlb
+++ a/fs/hugetlbfs/inode.c
@@ -949,6 +949,7 @@ static int can_do_hugetlb_shm(void)
 struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag)
 {
 	int error = -ENOMEM;
+	int unlock_shm = 0;
 	struct file *file;
 	struct inode *inode;
 	struct dentry *dentry, *root;
@@ -958,8 +959,14 @@ struct file *hugetlb_file_setup(const ch
 	if (!hugetlbfs_vfsmount)
 		return ERR_PTR(-ENOENT);
 
-	if (!can_do_hugetlb_shm())
-		return ERR_PTR(-EPERM);
+	if (!can_do_hugetlb_shm()) {
+		if (user_shm_lock(size, user)) {
+			unlock_shm = 1;
+			WARN_ONCE(1,
+			  "Using mlock ulimits for SHM_HUGETLB deprecated\n");
+		} else
+			return ERR_PTR(-EPERM);
+	}
 
 	root = hugetlbfs_vfsmount->mnt_root;
 	quick_string.name = name;
@@ -999,6 +1006,8 @@ out_inode:
 out_dentry:
 	dput(dentry);
 out_shm_unlock:
+	if (unlock_shm)
+		user_shm_unlock(size, user);
 	return ERR_PTR(error);
 }
 
_

Patches currently in -mm which might be from kiran@scalex86.org are

origin.patch
slab-leaks3-default-y.patch

