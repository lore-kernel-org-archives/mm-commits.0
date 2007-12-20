From: akpm@linux-foundation.org
Subject: + kernel-sysc-get-rid-of-expensive-divides-in-groups_sort.patch added to -mm tree
Date: Wed, 19 Dec 2007 16:25:37 -0800
Message-ID: <200712200025.lBK0PbpS026914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753844AbXLTA0j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Dec 2007 19:26:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com


The patch titled
     kernel/sys.c: get rid of expensive divides in groups_sort()
has been added to the -mm tree.  Its filename is
     kernel-sysc-get-rid-of-expensive-divides-in-groups_sort.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -803,7 +803,7 @@ static inline int above_background_load(
 
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
parport-dev-timeslice-is-an-unsigned-long-not-an-int.patch
git-net.patch
git-sched.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
lib-extablec-removes-an-expensive-integer-divide-in-search_extable.patch
kernel-sysc-get-rid-of-expensive-divides-in-groups_sort.patch
