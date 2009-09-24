From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-do-not-call-user_shm_lock-for-map_hugetlb-fix.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:33:26 -0700
Message-ID: <200909241933.n8OJXQPD028803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbZIXTeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, agl@us.ibm.com, david@gibson.dropbear.id.au, ebmunson@us.ibm.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, rientjes@google.com, mm-


The patch titled
     hugetlbfs: do not call user_shm_lock() for MAP_HUGETLB fix
has been removed from the -mm tree.  Its filename was
     hugetlbfs-do-not-call-user_shm_lock-for-map_hugetlb-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlbfs: do not call user_shm_lock() for MAP_HUGETLB fix
From: From: Mel Gorman <mel@csn.ul.ie>

hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
alters can_do_hugetlb_shm() to check if a file is being created for shared
memory or mmap().  If this returns false, we then unconditionally call
user_shm_lock() triggering a warning.  This block should never be entered
for MAP_HUGETLB.  This patch partially reverts the problem and fixes the
check.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-do-not-call-user_shm_lock-for-map_hugetlb-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-do-not-call-user_shm_lock-for-map_hugetlb-fix
+++ a/fs/hugetlbfs/inode.c
@@ -936,15 +936,9 @@ static struct file_system_type hugetlbfs
 
 static struct vfsmount *hugetlbfs_vfsmount;
 
-static int can_do_hugetlb_shm(int creat_flags)
+static int can_do_hugetlb_shm(void)
 {
-	if (creat_flags != HUGETLB_SHMFS_INODE)
-		return 0;
-	if (capable(CAP_IPC_LOCK))
-		return 1;
-	if (in_group_p(sysctl_hugetlb_shm_group))
-		return 1;
-	return 0;
+	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
 }
 
 struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag,
@@ -960,7 +954,7 @@ struct file *hugetlb_file_setup(const ch
 	if (!hugetlbfs_vfsmount)
 		return ERR_PTR(-ENOENT);
 
-	if (!can_do_hugetlb_shm(creat_flags)) {
+	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
 		*user = current_user();
 		if (user_shm_lock(size, *user)) {
 			WARN_ONCE(1,
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
hugetlb_file_setup-use-c-not-cpp.patch
linux-next.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
add-debugging-aid-for-memory-initialisation-problems.patch

