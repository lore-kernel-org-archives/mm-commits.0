From: akpm@linux-foundation.org
Subject: [merged]
 mm-swapfile-fix-swapon-frontswap_map-memory-leak-on-error.patch removed
 from -mm tree
Date: Mon, 11 Sep 2017 12:40:31 -0700
Message-ID: <20170911194031.D-ezg_ugz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49418 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdIKTkc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, hughd@google.com, mm-commits@vger.kernel.org, rientjes@google.com, stable@vger.kernel.org, ying.huang@intel.com


The patch titled
     Subject: mm/swapfile.c: fix swapon frontswap_map memory leak on error
has been removed from the -mm tree.  Its filename was
     mm-swapfile-fix-swapon-frontswap_map-memory-leak-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch
mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch
mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch

