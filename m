From: akpm@linux-foundation.org
Subject: + mm-zswap-avoid-unnecessary-page-scanning.patch added to -mm
 tree
Date: Thu, 10 Oct 2013 12:52:45 -0700
Message-ID: <5257058d.IHb2Bhc1wlxCdIrQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab3JJTwq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 15:52:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, minchan@kernel.org, bob.liu@oracle.com, weijie.yang@samsung.com

Subject: + mm-zswap-avoid-unnecessary-page-scanning.patch added to -mm tree
To: weijie.yang@samsung.com,bob.liu@oracle.com,minchan@kernel.org,sjenning@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 12:52:45 -0700


The patch titled
     Subject: mm/zswap: avoid unnecessary page scanning
has been added to the -mm tree.  Its filename is
     mm-zswap-avoid-unnecessary-page-scanning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-avoid-unnecessary-page-scanning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-avoid-unnecessary-page-scanning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -577,6 +577,9 @@ static int zswap_writeback_entry(struct
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

mm-zswap-bugfix-memory-leak-when-re-swapon.patch
mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently.patch
mm-zswap-avoid-unnecessary-page-scanning.patch

