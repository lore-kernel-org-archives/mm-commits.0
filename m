From: akpm@linux-foundation.org
Subject: + mmzone-simplify-zone_intersects.patch added to -mm tree
Date: Fri, 16 Jun 2017 10:34:00 -0700
Message-ID: <59441688.u24B14j9MTMSZrgt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53652 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbdFPReB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 13:34:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: simplify zone_intersects()
has been added to the -mm tree.  Its filename is
     mmzone-simplify-zone_intersects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmzone-simplify-zone_intersects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmzone-simplify-zone_intersects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: include/linux/mmzone.h: simplify zone_intersects()

To make sure a range intersects a zone, only two comparisons are
necessary.  Simplify the function a little.

Link: http://lkml.kernel.org/r/20170616092335.5177-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN include/linux/mmzone.h~mmzone-simplify-zone_intersects include/linux/mmzone.h
--- a/include/linux/mmzone.h~mmzone-simplify-zone_intersects
+++ a/include/linux/mmzone.h
@@ -541,15 +541,11 @@ static inline bool zone_intersects(struc
 {
 	if (zone_is_empty(zone))
 		return false;
-	if (start_pfn >= zone_end_pfn(zone))
+	if (start_pfn >= zone_end_pfn(zone) ||
+	    start_pfn + nr_pages <= zone->zone_start_pfn)
 		return false;
 
-	if (zone->zone_start_pfn <= start_pfn)
-		return true;
-	if (start_pfn + nr_pages > zone->zone_start_pfn)
-		return true;
