From: akpm@linux-foundation.org
Subject: [patch 082/124] mm: vmpressure: fix sending wrong events on
 underflow
Date: Fri, 24 Feb 2017 14:59:39 -0800
Message-ID: <58b0badb.BszoVWEtriYhC7kx%akpm__44804.3557502844$1487977183$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbdBXW7l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vinmenon@codeaurora.org, anton.vorontsov@linaro.org, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, shashim@codeaurora.org, stable@vger.kernel.org, vbabka@suse.cz, vdavydov.dev@gmail.com

From: Vinayak Menon <vinmenon@codeaurora.org>
Subject: mm: vmpressure: fix sending wrong events on underflow

At the end of a window period, if the reclaimed pages is greater than
scanned, an unsigned underflow can result in a huge pressure value and
thus a critical event.  Reclaimed pages is found to go higher than scanned
because of the addition of reclaimed slab pages to reclaimed in
shrink_node without a corresponding increment to scanned pages.  Minchan
Kim mentioned that this can also happen in the case of a THP page where
the scanned is 1 and reclaimed could be 512.

Link: http://lkml.kernel.org/r/1486641577-11685-1-git-send-email-vinmenon@codeaurora.org
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Shiraz Hashim <shashim@codeaurora.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/vmpressure.c~mm-vmpressure-fix-sending-wrong-events-on-underflow mm/vmpressure.c
--- a/mm/vmpressure.c~mm-vmpressure-fix-sending-wrong-events-on-underflow
+++ a/mm/vmpressure.c
@@ -112,9 +112,16 @@ static enum vmpressure_levels vmpressure
 						    unsigned long reclaimed)
 {
 	unsigned long scale = scanned + reclaimed;
-	unsigned long pressure;
+	unsigned long pressure = 0;
 
 	/*
+	 * reclaimed can be greater than scanned in cases
+	 * like THP, where the scanned is 1 and reclaimed
+	 * could be 512
+	 */
+	if (reclaimed >= scanned)
+		goto out;
+	/*
 	 * We calculate the ratio (in percents) of how many pages were
 	 * scanned vs. reclaimed in a given time frame (window). Note that
 	 * time is in VM reclaimer's "ticks", i.e. number of pages
@@ -124,6 +131,7 @@ static enum vmpressure_levels vmpressure
 	pressure = scale - (reclaimed * scale / scanned);
 	pressure = pressure * 100 / scale;
 
+out:
 	pr_debug("%s: %3lu  (s: %lu  r: %lu)\n", __func__, pressure,
 		 scanned, reclaimed);
 
_
