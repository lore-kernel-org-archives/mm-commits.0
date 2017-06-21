From: akpm@linux-foundation.org
Subject: [merged]
 mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages.patch
 removed from -mm tree
Date: Wed, 21 Jun 2017 15:05:35 -0700
Message-ID: <20170621220535.X6jNL1k2u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36628 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdFUWFg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2017 18:05:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org, zhongjiang@huawei.com


The patch titled
     Subject: mm: correct the comment when reclaimed pages exceed the scanned pages
has been removed from the -mm tree.  Its filename was
     mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhongjiang <zhongjiang@huawei.com>
Subject: mm: correct the comment when reclaimed pages exceed the scanned pages

e1587a494540 ("mm: vmpressure: fix sending wrong events on underflow")
declare that reclaimed pages exceed the scanned pages due to the thp
reclaim.  it is incorrect because THP will be spilt to normal page and
loop again.  which will result in the scanned pages increment.

[akpm@linux-foundation.org: tweak comment text]
Link: http://lkml.kernel.org/r/1496824266-25235-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhongjiang <zhongjiang@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmpressure.c~mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages mm/vmpressure.c
--- a/mm/vmpressure.c~mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages
+++ a/mm/vmpressure.c
@@ -115,9 +115,9 @@ static enum vmpressure_levels vmpressure
 	unsigned long pressure = 0;
 
 	/*
-	 * reclaimed can be greater than scanned in cases
-	 * like THP, where the scanned is 1 and reclaimed
-	 * could be 512
+	 * reclaimed can be greater than scanned for things such as reclaimed
+	 * slab pages. shrink_node() just adds reclaimed pages without a
+	 * related increment to scanned pages.
 	 */
 	if (reclaimed >= scanned)
 		goto out;
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch
signal-avoid-undefined-behaviour-in-kill_something_info.patch
exit-avoid-undefined-behaviour-when-call-wait4.patch

