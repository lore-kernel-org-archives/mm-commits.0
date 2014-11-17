From: akpm@linux-foundation.org
Subject: [merged]
 mm-alloc_contig_range-demote-pages-busy-message-from-warn-to-info.patch
 removed from -mm tree
Date: Mon, 17 Nov 2014 12:50:50 -0800
Message-ID: <546a5faa.U2xXFdRaslyyRQex%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaKQUuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 15:50:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mina86@mina86.com, laurent.pinchart@ideasonboard.com, minchan@kernel.org, peter@hurleysoftware.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: alloc_contig_range: demote pages busy message from warn to info
has been removed from the -mm tree.  Its filename was
     mm-alloc_contig_range-demote-pages-busy-message-from-warn-to-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: mm: alloc_contig_range: demote pages busy message from warn to info

Having test_pages_isolated failure message as a warning confuses users
into thinking that it is more serious than it really is.  In reality, if
called via CMA, allocation will be retried so a single test_pages_isolated
failure does not prevent allocation from succeeding.

Demote the warning message to an info message and reformat it such that
the text "failed" does not appear and instead a less worrying "PFNS busy"
is used.

This message is trivially reproducible on a 10GB x86 machine on 3.16.y
kernels configured with CONFIG_DMA_CMA.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-alloc_contig_range-demote-pages-busy-message-from-warn-to-info mm/page_alloc.c
--- a/mm/page_alloc.c~mm-alloc_contig_range-demote-pages-busy-message-from-warn-to-info
+++ a/mm/page_alloc.c
@@ -6397,13 +6397,12 @@ int alloc_contig_range(unsigned long sta
 
 	/* Make sure the range is really isolated. */
 	if (test_pages_isolated(outer_start, end, false)) {
-		pr_warn("alloc_contig_range test_pages_isolated(%lx, %lx) failed\n",
-		       outer_start, end);
+		pr_info("%s: [%lx, %lx) PFNs busy\n",
+			__func__, outer_start, end);
 		ret = -EBUSY;
 		goto done;
 	}
 
