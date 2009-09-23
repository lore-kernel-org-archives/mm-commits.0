From: akpm@linux-foundation.org
Subject: + hugetlbfs-do-not-call-user_shm_lock-for-map_hugetlb-fix.patch added to -mm tree
Date: Wed, 23 Sep 2009 13:42:05 -0700
Message-ID: <200909232042.n8NKg5LD031211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbZIWUnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:43:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, agl@us.ibm.com, david@gibson.dropbear.id.au, ebmunson@us.ibm.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, rientjes@google.com


The patch titled
     hugetlbfs: do not call user_shm_lock() for MAP_HUGETLB fix
has been added to the -mm tree.  Its filename is
     hugetlbfs-do-not-call-user_shm_lock-for-map_hugetlb-fix.patch

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
hugetlbfs-do-not-call-user_shm_lock-for-map_hugetlb-fix.patch
linux-next.patch
hugetlb_file_setup-use-c-not-cpp.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
add-debugging-aid-for-memory-initialisation-problems.patch

