Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29731C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 19:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF77B206F0
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 19:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598903383;
	bh=8VK/HLd9ljhVwd0n/txI7xr+Mrb2ur86rS9hwsJIDdU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aW50fFDihuiFJMMtE1r1mjMkxkULWVo/f3UkeISFPT4MiJAs4o0nGzwhRfoFz/CfU
	 f1xE35IASM1Js34CVf1P9d+qIiKZeJxl0zyWaP0cBfLxoW8WHPNPYuf5iMzLmugD8v
	 wRbcf788k4BXTr+88LEn4razeNt6JcsW0jV+nxAw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgHaTtm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbgHaTtm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 15:49:42 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A43F2087D;
        Mon, 31 Aug 2020 19:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598903381;
        bh=8VK/HLd9ljhVwd0n/txI7xr+Mrb2ur86rS9hwsJIDdU=;
        h=Date:From:To:Subject:From;
        b=bXOkwom9P6zeq/j8qBTQDgjtldAmoTBzk1l3cH8x8unsdZoKrlvrK81s7NU7FzT8G
         yKcgsG93trbCjLhKvWhupljp9QMkfJLV1+mnCAm37Y0jCIah2ZXyzfWVFDF+5UdbZe
         CaTFniqofBjCA9WcLGKwNl65VhU3wm8SPkUCRBjU=
Date:   Mon, 31 Aug 2020 12:49:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        bhe@redhat.com, richard.weiyang@linux.alibaba.com
Subject:  +
 mm-hugetlb-count-file_region-to-be-added-when-regions_needed-=-null.patch
 added to -mm tree
Message-ID: <20200831194940.QOTgx%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: count file_region to be added when regions_needed != NULL
has been added to the -mm tree.  Its filename is
     mm-hugetlb-count-file_region-to-be-added-when-regions_needed-=-null.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-count-file_region-to-be-added-when-regions_needed-%3D-null.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-count-file_region-to-be-added-when-regions_needed-%3D-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch
mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number.patch
mm-hugetlb-not-necessary-to-coalesce-regions-recursively.patch
mm-hugetlb-remove-vm_bug_onnrg-in-get_file_region_entry_from_cache.patch
mm-hugetlb-use-list_splice-to-merge-two-list-at-once.patch
mm-hugetlb-count-file_region-to-be-added-when-regions_needed-=-null.patch
mm-hugetlb-a-page-from-buddy-is-not-on-any-list.patch
mm-hugetlb-narrow-the-hugetlb_lock-protection-area-during-preparing-huge-page.patch
mm-hugetlb-take-the-free-hpage-during-the-iteration-directly.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

