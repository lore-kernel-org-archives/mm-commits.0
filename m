From: akpm@linux-foundation.org
Subject: [merged] mm-fix-shm_hugetlb-to-work-with-users-in-hugetlb_shm_group.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:41 -0700
Message-ID: <200904011834.n31IYfaF007251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765439AbZDASl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:41:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kiran@scalex86.org, agl@us.ibm.com, mel@csn.ul.ie, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix SHM_HUGETLB to work with users in hugetlb_shm_group
has been removed from the -mm tree.  Its filename was
     mm-fix-shm_hugetlb-to-work-with-users-in-hugetlb_shm_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix SHM_HUGETLB to work with users in hugetlb_shm_group
From: Ravikiran G Thirumalai <kiran@scalex86.org>

Fix hugetlb subsystem so that non root users belonging to
hugetlb_shm_group can actually allocate hugetlb backed shm.

Currently non root users cannot even map one large page using SHM_HUGETLB
when they belong to the gid in /proc/sys/vm/hugetlb_shm_group.  This is
because allocation size is verified against RLIMIT_MEMLOCK resource limit
even if the user belongs to hugetlb_shm_group.

This patch
1. Fixes hugetlb subsystem so that users with CAP_IPC_LOCK and users
   belonging to hugetlb_shm_group don't need to be restricted with
   RLIMIT_MEMLOCK resource limits
2. This patch also disables mlock based rlimit checking (which will
   be reinstated and marked deprecated in a subsequent patch).

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Adam Litke <agl@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-fix-shm_hugetlb-to-work-with-users-in-hugetlb_shm_group fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-fix-shm_hugetlb-to-work-with-users-in-hugetlb_shm_group
+++ a/fs/hugetlbfs/inode.c
@@ -943,9 +943,7 @@ static struct vfsmount *hugetlbfs_vfsmou
 
 static int can_do_hugetlb_shm(void)
 {
-	return likely(capable(CAP_IPC_LOCK) ||
-			in_group_p(sysctl_hugetlb_shm_group) ||
-			can_do_mlock());
+	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
 }
 
 struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag)
@@ -963,9 +961,6 @@ struct file *hugetlb_file_setup(const ch
 	if (!can_do_hugetlb_shm())
 		return ERR_PTR(-EPERM);
 
-	if (!user_shm_lock(size, user))
-		return ERR_PTR(-ENOMEM);
