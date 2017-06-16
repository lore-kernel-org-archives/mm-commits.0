From: akpm@linux-foundation.org
Subject: [patch 5/5] mm: correct the comment when reclaimed pages exceed
 the scanned pages
Date: Fri, 16 Jun 2017 14:02:40 -0700
Message-ID: <59444770.45QIuPKSqdSuHfbI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdFPVCl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 17:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zhongjiang@huawei.com, minchan@kernel.org

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
