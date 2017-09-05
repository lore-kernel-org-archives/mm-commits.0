From: akpm@linux-foundation.org
Subject: + mm-swapfile-fix-swapon-frontswap_map-memory-leak-on-error.patch added to -mm tree
Date: Tue, 05 Sep 2017 16:55:19 -0700
Message-ID: <59af3967.1hZnzYpqsJyFLHlh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47694 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754321AbdIEXzU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 19:55:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, darrick.wong@oracle.com, hughd@google.com, stable@vger.kernel.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: fix swapon frontswap_map memory leak on error
has been added to the -mm tree.  Its filename is
     mm-swapfile-fix-swapon-frontswap_map-memory-leak-on-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-fix-swapon-frontswap_map-memory-leak-on-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-fix-swapon-frontswap_map-memory-leak-on-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm/swapfile.c: fix swapon frontswap_map memory leak on error

Free frontswap_map if an error is encountered before enable_swap_info().

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[4.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/swapfile.c~mm-swapfile-fix-swapon-frontswap_map-memory-leak-on-error mm/swapfile.c
--- a/mm/swapfile.c~mm-swapfile-fix-swapon-frontswap_map-memory-leak-on-error
+++ a/mm/swapfile.c
@@ -3291,6 +3291,7 @@ bad_swap:
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
 	kvfree(cluster_info);
+	kvfree(frontswap_map);
 	if (swap_file) {
 		if (inode && S_ISREG(inode->i_mode)) {
 			inode_unlock(inode);
_

Patches currently in -mm which might be from rientjes@google.com are

mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2.patch
mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch
mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch
mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch
mm-swapfile-fix-swapon-frontswap_map-memory-leak-on-error.patch
fs-proc-unconditional-cond_resched-when-reading-smaps.patch

