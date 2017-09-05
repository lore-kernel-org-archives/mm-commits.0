From: akpm@linux-foundation.org
Subject: +
 mm-kvfree-the-swap-cluster-info-if-the-swap-file-is-unsatisfactory.patch
 added to -mm tree
Date: Tue, 05 Sep 2017 16:55:17 -0700
Message-ID: <59af3965.LXXfwFPKjB0rYXku%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47650 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754188AbdIEXzT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 19:55:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, hughd@google.com, rientjes@google.com, stable@vger.kernel.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kvfree the swap cluster info if the swap file is unsatisfactory
has been added to the -mm tree.  Its filename is
     mm-kvfree-the-swap-cluster-info-if-the-swap-file-is-unsatisfactory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kvfree-the-swap-cluster-info-if-the-swap-file-is-unsatisfactory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kvfree-the-swap-cluster-info-if-the-swap-file-is-unsatisfactory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: mm: kvfree the swap cluster info if the swap file is unsatisfactory

If initializing a small swap file fails because the swap file has a
problem (holes, etc.) then we need to free the cluster info as part of
cleanup.  Unfortunately a previous patch changed the code to use kvzalloc
but did not change all the vfree calls to use kvfree.

Found by running generic/357 from xfstests.

Link: http://lkml.kernel.org/r/20170831233515.GR3775@magnolia
Fixes: 54f180d3c181 ("mm, swap: use kvzalloc to allocate some swap data structures")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[4.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-kvfree-the-swap-cluster-info-if-the-swap-file-is-unsatisfactory mm/swapfile.c
--- a/mm/swapfile.c~mm-kvfree-the-swap-cluster-info-if-the-swap-file-is-unsatisfactory
+++ a/mm/swapfile.c
@@ -3290,7 +3290,7 @@ bad_swap:
 	p->flags = 0;
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
-	vfree(cluster_info);
+	kvfree(cluster_info);
 	if (swap_file) {
 		if (inode && S_ISREG(inode->i_mode)) {
 			inode_unlock(inode);
_

Patches currently in -mm which might be from darrick.wong@oracle.com are

mm-kvfree-the-swap-cluster-info-if-the-swap-file-is-unsatisfactory.patch

