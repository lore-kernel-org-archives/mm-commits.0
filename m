Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88693C433E6
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 19:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53A2420936
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 19:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598903380;
	bh=sd6kkj2Nr6t+FkUDZF7GYAvtQRTNiKxzppVKVJUJMrE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=NxO+LIG3pNp9CHyg44jitGNPSfFUWXZmsgc0Z6+wDsoxBI8KDAVSzUkaw0F04G6FO
	 y/nRl/ckcse5GIOC7XyO1kHHki2Ln40FHhuQb6YM81Rjkfa6lcAMMi0/6hJdhe29Sw
	 VFnIGYIdlAeiZf2dUMS2Bwzxf6ym5PH+6Upa65L4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgHaTtj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:49:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbgHaTti (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 15:49:38 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C862083E;
        Mon, 31 Aug 2020 19:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598903378;
        bh=sd6kkj2Nr6t+FkUDZF7GYAvtQRTNiKxzppVKVJUJMrE=;
        h=Date:From:To:Subject:From;
        b=aGwd+k4oOK1l7HlWoHwstbdrxWqFF5mi9KVnEepj8Xt1Vlj78/be/AQQ1YHCbws2V
         vu64l+/oWH86LVDGRke5Aw7yGnmYhCNhlzLUuehJqwhlWceU3YZY+D/3GmylJa7we+
         8if7tpPb91oC9AP9+PfyJLWclg2qqkLyWBL57xvA=
Date:   Mon, 31 Aug 2020 12:49:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        bhe@redhat.com, richard.weiyang@linux.alibaba.com
Subject:  +
 mm-hugetlb-use-list_splice-to-merge-two-list-at-once.patch added to -mm tree
Message-ID: <20200831194937.mX2gD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use list_splice to merge two list at once
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-list_splice-to-merge-two-list-at-once.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-list_splice-to-merge-two-list-at-once.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-list_splice-to-merge-two-list-at-once.patch

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
Subject: mm/hugetlb: use list_splice to merge two list at once

Instead of add allocated file_region one by one to region_cache, we could
use list_splice to merge two list at once.

Also we know the number of entries in the list, increase the number
directly.

Link: https://lkml.kernel.org/r/20200831022351.20916-4-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-list_splice-to-merge-two-list-at-once
+++ a/mm/hugetlb.c
@@ -443,11 +443,8 @@ static int allocate_file_region_entries(
 
 		spin_lock(&resv->lock);
 
-		list_for_each_entry_safe(rg, trg, &allocated_regions, link) {
-			list_del(&rg->link);
-			list_add(&rg->link, &resv->region_cache);
-			resv->region_cache_count++;
-		}
+		list_splice(&allocated_regions, &resv->region_cache);
+		resv->region_cache_count += to_allocate;
 	}
 
 	return 0;
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

