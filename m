From: akpm@linux-foundation.org
Subject: [merged] mm-zswap-avoid-unnecessary-page-scanning.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:38:52 -0800
Message-ID: <5283e35c.RBDoxukz00tkBzyZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3KMUiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, minchan@kernel.org, bob.liu@oracle.com, weijie.yang@samsung.com

Subject: [merged] mm-zswap-avoid-unnecessary-page-scanning.patch removed from -mm tree
To: weijie.yang@samsung.com,bob.liu@oracle.com,minchan@kernel.org,sjenning@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:52 -0800


The patch titled
     Subject: mm/zswap: avoid unnecessary page scanning
has been removed from the -mm tree.  Its filename was
     mm-zswap-avoid-unnecessary-page-scanning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm/zswap: avoid unnecessary page scanning

Add SetPageReclaim() before __swap_writepage() so that page can be moved
to the tail of the inactive list, which can avoid unnecessary page
scanning as this page was reclaimed by swap subsystem before.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/zswap.c~mm-zswap-avoid-unnecessary-page-scanning mm/zswap.c
--- a/mm/zswap.c~mm-zswap-avoid-unnecessary-page-scanning
+++ a/mm/zswap.c
@@ -556,6 +556,9 @@ static int zswap_writeback_entry(struct
 		SetPageUptodate(page);
 	}
 
+	/* move it to the tail of the inactive list after end_writeback */
+	SetPageReclaim(page);
+
 	/* start writeback */
 	__swap_writepage(page, &wbc, end_swap_bio_write);
 	page_cache_release(page);
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

origin.patch

