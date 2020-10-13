Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 840D6C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5189A2222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633392;
	bh=11/29tM1oaaO48l+Yp/hDIg297Qg7ReeFp75By2AWCg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=DRjs71LHXvQVkY79qhoPSQU2HSsuzBBoNMSU2Tww8Yp0VcjmCQ20EyJk0uDEiF7qw
	 sX4bLuyzPc7sn3RL/02O/mYTVUzBlhZVVEnwWDP//8Uh2kX4FTpQ4vKRz4ih1s6x7L
	 jZqAd1yIJEPk+VFUlU78zuobYfLzOX5XtSVD3teU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgJMX4c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgJMX4b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96B3F22244;
        Tue, 13 Oct 2020 23:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633390;
        bh=11/29tM1oaaO48l+Yp/hDIg297Qg7ReeFp75By2AWCg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NiA6fcHWhvhOMHFc8tGEJ1QvOpct1DBtcWLQQabytbtKolQpLHtCFqHwHtRmUEuiV
         Ds9RdKCiEQA1k5zZVl7Rn8/JZQbhV+NAtSgwhfDA0kFAjB/TDko/Vn4nweRFD2UKrS
         L68DKft1DZUw31zB/aLBX6cYTVpABp3rRSQBWLzs=
Date:   Tue, 13 Oct 2020 16:56:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 147/181] mm/hugetlb: count file_region to be added
 when regions_needed != NULL
Message-ID: <20201013235630.HInH_Pa56%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/hugetlb: count file_region to be added when regions_needed != NULL

There are only two cases of function add_reservation_in_range()

    * count file_region and return the number in regions_needed
    * do the real list operation without counting

This means it is not necessary to have two parameters to classify these
two cases.

Just use regions_needed to separate them.

Link: https://lkml.kernel.org/r/20200831022351.20916-5-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-count-file_region-to-be-added-when-regions_needed-=-null
+++ a/mm/hugetlb.c
@@ -321,16 +321,17 @@ static void coalesce_file_region(struct
 	}
 }
 
-/* Must be called with resv->lock held. Calling this with count_only == true
- * will count the number of pages to be added but will not modify the linked
- * list. If regions_needed != NULL and count_only == true, then regions_needed
- * will indicate the number of file_regions needed in the cache to carry out to
- * add the regions for this range.
+/*
+ * Must be called with resv->lock held.
+ *
+ * Calling this with regions_needed != NULL will count the number of pages
+ * to be added but will not modify the linked list. And regions_needed will
+ * indicate the number of file_regions needed in the cache to carry out to add
+ * the regions for this range.
  */
 static long add_reservation_in_range(struct resv_map *resv, long f, long t,
 				     struct hugetlb_cgroup *h_cg,
-				     struct hstate *h, long *regions_needed,
-				     bool count_only)
+				     struct hstate *h, long *regions_needed)
 {
 	long add = 0;
 	struct list_head *head = &resv->regions;
@@ -366,14 +367,14 @@ static long add_reservation_in_range(str
 		 */
 		if (rg->from > last_accounted_offset) {
 			add += rg->from - last_accounted_offset;
-			if (!count_only) {
+			if (!regions_needed) {
 				nrg = get_file_region_entry_from_cache(
 					resv, last_accounted_offset, rg->from);
 				record_hugetlb_cgroup_uncharge_info(h_cg, h,
 								    resv, nrg);
 				list_add(&nrg->link, rg->link.prev);
 				coalesce_file_region(resv, nrg);
-			} else if (regions_needed)
+			} else
 				*regions_needed += 1;
 		}
 
@@ -385,13 +386,13 @@ static long add_reservation_in_range(str
 	 */
 	if (last_accounted_offset < t) {
 		add += t - last_accounted_offset;
-		if (!count_only) {
+		if (!regions_needed) {
 			nrg = get_file_region_entry_from_cache(
 				resv, last_accounted_offset, t);
 			record_hugetlb_cgroup_uncharge_info(h_cg, h, resv, nrg);
 			list_add(&nrg->link, rg->link.prev);
 			coalesce_file_region(resv, nrg);
-		} else if (regions_needed)
+		} else
 			*regions_needed += 1;
 	}
 
@@ -484,8 +485,8 @@ static long region_add(struct resv_map *
 retry:
 
 	/* Count how many regions are actually needed to execute this add. */
-	add_reservation_in_range(resv, f, t, NULL, NULL, &actual_regions_needed,
-				 true);
+	add_reservation_in_range(resv, f, t, NULL, NULL,
+				 &actual_regions_needed);
 
 	/*
 	 * Check for sufficient descriptors in the cache to accommodate
@@ -513,7 +514,7 @@ retry:
 		goto retry;
 	}
 
-	add = add_reservation_in_range(resv, f, t, h_cg, h, NULL, false);
+	add = add_reservation_in_range(resv, f, t, h_cg, h, NULL);
 
 	resv->adds_in_progress -= in_regions_needed;
 
@@ -549,9 +550,9 @@ static long region_chg(struct resv_map *
 
 	spin_lock(&resv->lock);
 
-	/* Count how many hugepages in this range are NOT respresented. */
+	/* Count how many hugepages in this range are NOT represented. */
 	chg = add_reservation_in_range(resv, f, t, NULL, NULL,
-				       out_regions_needed, true);
+				       out_regions_needed);
 
 	if (*out_regions_needed == 0)
 		*out_regions_needed = 1;
_
