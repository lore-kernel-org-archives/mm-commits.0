From: akpm@linux-foundation.org
Subject: + mm-fix-shm_hugetlb-to-work-with-users-in-hugetlb_shm_group.patch added to -mm tree
Date: Tue, 24 Feb 2009 11:57:34 -0800
Message-ID: <200902241957.n1OJvZml006372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbZBXUAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 15:00:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kiran@scalex86.org, agl@us.ibm.com, mel@csn.ul.ie, wli@holomorphy.com


The patch titled
     mm: fix SHM_HUGETLB to work with users in hugetlb_shm_group
has been added to the -mm tree.  Its filename is
     mm-fix-shm_hugetlb-to-work-with-users-in-hugetlb_shm_group.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
