From: akpm@linux-foundation.org
Subject: [patch 047/126] mm/swapfile.c: fix swapon frontswap_map
 memory leak on error
Date: Fri, 08 Sep 2017 16:13:29 -0700
Message-ID: <20170908231329.HgqDQ5LYS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52136 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757173AbdIHXNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:13:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, darrick.wong@oracle.com, hughd@google.com, mm-commits@vger.kernel.org, rientjes@google.com, stable@vger.kernel.org, torvalds@linux-foundation.org, ying.huang@intel.com

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
