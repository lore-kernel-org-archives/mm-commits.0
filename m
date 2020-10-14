Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5AFC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 699CC214D8
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709407;
	bh=tGkIw+uz/Q/550K+FF+ZAVe9NpfaCZj5W0o4u5G9SK8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RrxEh+VwV2l9hOFcx63spvNEwKLz3HTYx5uSXRHdTWS2kk1X+H01jnirq9GxVfSh2
	 UPxyRMEI6kHBqU5SZ1SZEmg359JCyrzoNCHqmBCZwG/te6HswZZZDSp4HeH7JzcmbW
	 17aaFeKprurXz/FM8FisldL5dj9vREpTr7iXhOXg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbgJNVD1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVD1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:27 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD676221FF;
        Wed, 14 Oct 2020 21:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709406;
        bh=tGkIw+uz/Q/550K+FF+ZAVe9NpfaCZj5W0o4u5G9SK8=;
        h=Date:From:To:Subject:From;
        b=Jfwhis++EchoKMaNf3dCS1rReKPlD+aditdq4BvBNuxbP5NQ5FGVAL5Q6/e73V/rP
         b9nefyCgkkWjbeSlbHbk8mHUYEX9byZOqG0QsrfmoeGKGw8qqx0YZIcKqjhYhXv7rQ
         LOFrZ6EXTD19zUbPFddX6TwtD7d2mFqc0HfQ7fFo=
Date:   Wed, 14 Oct 2020 14:03:25 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-hugetlb-count-file_region-to-be-added-when-regions_needed-=-null.patch
 removed from -mm tree
Message-ID: <20201014210325.xuFyQEoL0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: count file_region to be added when regions_needed != NULL
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-count-file_region-to-be-added-when-regions_needed-=-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

