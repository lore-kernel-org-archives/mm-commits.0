From: akpm@linux-foundation.org
Subject: [merged] do_mbind-fix-memory-leak.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:50:44 -0700
Message-ID: <200910302050.n9UKoiJ8011315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757523AbZJ3Uvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:51:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     do_mbind(): fix memory leak
has been removed from the -mm tree.  Its filename was
     do_mbind-fix-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_mbind(): fix memory leak
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If migrate_prep is failed, new variable is leaked.  This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/mempolicy.c~do_mbind-fix-memory-leak mm/mempolicy.c
--- a/mm/mempolicy.c~do_mbind-fix-memory-leak
+++ a/mm/mempolicy.c
@@ -1024,7 +1024,7 @@ static long do_mbind(unsigned long start
 
 		err = migrate_prep();
 		if (err)
-			return err;
+			goto mpol_out;
 	}
 	{
 		NODEMASK_SCRATCH(scratch);
@@ -1039,10 +1039,9 @@ static long do_mbind(unsigned long start
 			err = -ENOMEM;
 		NODEMASK_SCRATCH_FREE(scratch);
 	}
-	if (err) {
-		mpol_put(new);
-		return err;
-	}
+	if (err)
+		goto mpol_out;
+
 	vma = check_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
@@ -1062,6 +1061,7 @@ static long do_mbind(unsigned long start
 		putback_lru_pages(&pagelist);
 
 	up_write(&mm->mmap_sem);
+ mpol_out:
 	mpol_put(new);
 	return err;
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch
page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch
linux-next.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

