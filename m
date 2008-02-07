From: akpm@linux-foundation.org
Subject: - kernel-sysc-get-rid-of-expensive-divides-in-groups_sort.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:05 -0800
Message-ID: <200802070024.m170OkT8006644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765588AbYBGAor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mm-commits@vger.kernel.org


The patch titled
     kernel/sys.c: get rid of expensive divides in groups_sort()
has been removed from the -mm tree.  Its filename was
     kernel-sysc-get-rid-of-expensive-divides-in-groups_sort.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/sys.c: get rid of expensive divides in groups_sort()
From: Eric Dumazet <dada1@cosmosbay.com>

groups_sort() can be quite long if user loads a large gid table.

This is because GROUP_AT(group_info, some_integer) uses an integer divide. 
So having to do XXX thousand divides during one syscall can lead to very
high latencies.  (NGROUPS_MAX=65536)

In the past (25 Mar 2006), an analog problem was found in groups_search()
(commit d74beb9f33a5f16d2965f11b275e401f225c949d ) and at that time I
changed some variables to unsigned int.

I believe that a more generic fix is to make sure NGROUPS_PER_BLOCK is
unsigned.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 kernel/sys.c          |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/sched.h~kernel-sysc-get-rid-of-expensive-divides-in-groups_sort include/linux/sched.h
--- a/include/linux/sched.h~kernel-sysc-get-rid-of-expensive-divides-in-groups_sort
+++ a/include/linux/sched.h
@@ -810,7 +810,7 @@ static inline int above_background_load(
 
 struct io_context;			/* See blkdev.h */
 #define NGROUPS_SMALL		32
-#define NGROUPS_PER_BLOCK	((int)(PAGE_SIZE / sizeof(gid_t)))
+#define NGROUPS_PER_BLOCK	((unsigned int)(PAGE_SIZE / sizeof(gid_t)))
 struct group_info {
 	int ngroups;
 	atomic_t usage;
diff -puN kernel/sys.c~kernel-sysc-get-rid-of-expensive-divides-in-groups_sort kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-get-rid-of-expensive-divides-in-groups_sort
+++ a/kernel/sys.c
@@ -1145,16 +1145,16 @@ static int groups_to_user(gid_t __user *
     struct group_info *group_info)
 {
 	int i;
-	int count = group_info->ngroups;
+	unsigned int count = group_info->ngroups;
 
 	for (i = 0; i < group_info->nblocks; i++) {
-		int cp_count = min(NGROUPS_PER_BLOCK, count);
-		int off = i * NGROUPS_PER_BLOCK;
-		int len = cp_count * sizeof(*grouplist);
+		unsigned int cp_count = min(NGROUPS_PER_BLOCK, count);
+		unsigned int len = cp_count * sizeof(*grouplist);
 
-		if (copy_to_user(grouplist+off, group_info->blocks[i], len))
+		if (copy_to_user(grouplist, group_info->blocks[i], len))
 			return -EFAULT;
 
+		grouplist += NGROUPS_PER_BLOCK;
 		count -= cp_count;
 	}
 	return 0;
@@ -1165,16 +1165,16 @@ static int groups_from_user(struct group
     gid_t __user *grouplist)
 {
 	int i;
-	int count = group_info->ngroups;
+	unsigned int count = group_info->ngroups;
 
 	for (i = 0; i < group_info->nblocks; i++) {
-		int cp_count = min(NGROUPS_PER_BLOCK, count);
-		int off = i * NGROUPS_PER_BLOCK;
-		int len = cp_count * sizeof(*grouplist);
+		unsigned int cp_count = min(NGROUPS_PER_BLOCK, count);
+		unsigned int len = cp_count * sizeof(*grouplist);
 
-		if (copy_from_user(group_info->blocks[i], grouplist+off, len))
+		if (copy_from_user(group_info->blocks[i], grouplist, len))
 			return -EFAULT;
 
+		grouplist += NGROUPS_PER_BLOCK;
 		count -= cp_count;
 	}
 	return 0;
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
