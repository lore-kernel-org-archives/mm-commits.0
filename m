From: akpm@linux-foundation.org
Subject: + do_mbind-fix-memory-leak.patch added to -mm tree
Date: Tue, 13 Oct 2009 11:57:20 -0700
Message-ID: <200910131857.n9DIvKoc023129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761012AbZJMS61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 14:58:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org


The patch titled
     do_mbind(): fix memory leak
has been added to the -mm tree.  Its filename is
     do_mbind-fix-memory-leak.patch

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
Subject: do_mbind(): fix memory leak
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If migrate_prep is failed, new variable is leaked.  This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
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

linux-next.patch
congestion_wait-dont-use-write.patch
cgroup-fix-strstrip-misuse.patch
strstrip-mark-as-as-must_check.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mbind-fix-leak-of-never-putback-pages.patch
do_mbind-fix-memory-leak.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

