From: akpm@linux-foundation.org
Subject: + shmem-reduce-one-time-of-locking-in-pagefault.patch added to -mm tree
Date: Fri, 09 Jul 2010 15:17:27 -0700
Message-ID: <201007092217.o69MHS9V028664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425Ab0GIWTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 18:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, hughd@google.com, tim.c.chen@linux.intel.com, yanmin.zhang@intel.com


The patch titled
     shmem: reduce pagefault lock contention
has been added to the -mm tree.  Its filename is
     shmem-reduce-one-time-of-locking-in-pagefault.patch

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
Subject: shmem: reduce pagefault lock contention
From: Shaohua Li <shaohua.li@intel.com>

I'm running a shmem pagefault test case (see attached file) under a 64 CPU
system.  Profile shows shmem_inode_info->lock is heavily contented and
100% CPUs time are trying to get the lock.  In the pagefault (no swap)
case, shmem_getpage gets the lock twice, the last one is avoidable if we
prealloc a page so we could reduce one time of locking.  This is what
below patch does.

The result of the test case:
2.6.35-rc3: ~20s
2.6.35-rc3 + patch: ~12s
so this is 40% improvement.

One might argue if we could have better locking for shmem.  But even shmem
is lockless, the pagefault will soon have pagecache lock heavily contented
because shmem must add new page to pagecache.  So before we have better
locking for pagecache, improving shmem locking doesn't have too much
improvement.  I did a similar pagefault test against a ramfs file, the
test result is ~10.5s.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   69 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 20 deletions(-)

diff -puN mm/shmem.c~shmem-reduce-one-time-of-locking-in-pagefault mm/shmem.c
--- a/mm/shmem.c~shmem-reduce-one-time-of-locking-in-pagefault
+++ a/mm/shmem.c
@@ -1223,6 +1223,7 @@ static int shmem_getpage(struct inode *i
 	struct shmem_sb_info *sbinfo;
 	struct page *filepage = *pagep;
 	struct page *swappage;
+	struct page *prealloc_page = NULL;
 	swp_entry_t *entry;
 	swp_entry_t swap;
 	gfp_t gfp;
@@ -1247,7 +1248,6 @@ repeat:
 		filepage = find_lock_page(mapping, idx);
 	if (filepage && PageUptodate(filepage))
 		goto done;
-	error = 0;
 	gfp = mapping_gfp_mask(mapping);
 	if (!filepage) {
 		/*
@@ -1258,7 +1258,19 @@ repeat:
 		if (error)
 			goto failed;
 		radix_tree_preload_end();
+		if (sgp != SGP_READ && !prealloc_page) {
+			/* don't care if this successes */
+			prealloc_page = shmem_alloc_page(gfp, info, idx);
+			if (prealloc_page) {
+				if (mem_cgroup_cache_charge(prealloc_page,
+				    current->mm, GFP_KERNEL)) {
+					page_cache_release(prealloc_page);
+					prealloc_page = NULL;
+				}
+			}
+		}
 	}
+	error = 0;
 
 	spin_lock(&info->lock);
 	shmem_recalc_inode(inode);
@@ -1406,28 +1418,37 @@ repeat:
 		if (!filepage) {
 			int ret;
 
-			spin_unlock(&info->lock);
-			filepage = shmem_alloc_page(gfp, info, idx);
-			if (!filepage) {
-				shmem_unacct_blocks(info->flags, 1);
-				shmem_free_blocks(inode, 1);
-				error = -ENOMEM;
-				goto failed;
-			}
-			SetPageSwapBacked(filepage);
+			if (!prealloc_page) {
+				spin_unlock(&info->lock);
+				filepage = shmem_alloc_page(gfp, info, idx);
+				if (!filepage) {
+					shmem_unacct_blocks(info->flags, 1);
+					shmem_free_blocks(inode, 1);
+					error = -ENOMEM;
+					goto failed;
+				}
+				SetPageSwapBacked(filepage);
 
-			/* Precharge page while we can wait, compensate after */
-			error = mem_cgroup_cache_charge(filepage, current->mm,
-					GFP_KERNEL);
-			if (error) {
-				page_cache_release(filepage);
-				shmem_unacct_blocks(info->flags, 1);
-				shmem_free_blocks(inode, 1);
-				filepage = NULL;
-				goto failed;
+				/* Precharge page while we can wait, compensate
+				 * after
+				 */
+				error = mem_cgroup_cache_charge(filepage,
+					current->mm, GFP_KERNEL);
+				if (error) {
+					page_cache_release(filepage);
+					shmem_unacct_blocks(info->flags, 1);
+					shmem_free_blocks(inode, 1);
+					filepage = NULL;
+					goto failed;
+				}
+
+				spin_lock(&info->lock);
+			} else {
+				filepage = prealloc_page;
+				prealloc_page = NULL;
+				SetPageSwapBacked(filepage);
 			}
 
-			spin_lock(&info->lock);
 			entry = shmem_swp_alloc(info, idx, sgp);
 			if (IS_ERR(entry))
 				error = PTR_ERR(entry);
@@ -1468,6 +1489,10 @@ repeat:
 	}
 done:
 	*pagep = filepage;
+	if (prealloc_page) {
+		mem_cgroup_uncharge_cache_page(prealloc_page);
+		page_cache_release(prealloc_page);
+	}
 	return 0;
 
 failed:
@@ -1475,6 +1500,10 @@ failed:
 		unlock_page(filepage);
 		page_cache_release(filepage);
 	}
+	if (prealloc_page) {
+		mem_cgroup_uncharge_cache_page(prealloc_page);
+		page_cache_release(prealloc_page);
+	}
 	return error;
 }
 
_

Patches currently in -mm which might be from shaohua.li@intel.com are

shmem-reduce-one-time-of-locking-in-pagefault.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch

