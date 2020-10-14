Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C0EC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D7D4221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709413;
	bh=m7Tvrqr/GSfJrSPezsku6WP5g74rr+wO17L0LTKX+IA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=veGnbsP7XP7ERSFCkZ49G9RdhEhS5EQ/JmP1gBj9BobSGxRXq9FRm1KQZ/AN7ZQ1V
	 2JkOkIBZQqUMzC8cnRbHt5xg9udZncEz8D4UPqFUCJciaxhSRd7kau9Izlwr4ckOLO
	 cVhdrb8lIETCHHpCDVzWvPdzjOSQVEAUhhILLow4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbgJNVDc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVDc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D49B206B2;
        Wed, 14 Oct 2020 21:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709411;
        bh=m7Tvrqr/GSfJrSPezsku6WP5g74rr+wO17L0LTKX+IA=;
        h=Date:From:To:Subject:From;
        b=2vzKpDIcrERSO5sHD3/qp3lYr9SF7s8VZgAhd1MtOBU96eEk3Fx9UgTjazBNAe0nZ
         WROXYxx5gIWQPshAACktFyPNwc0XbpQfsZPNLBoKLQQXUclE+q/BzQ9EBmjwgJWlHd
         T6ntzL0gNAq0B4cF3d7WzRkPR6ZkFUh5UMdDcqnc=
Date:   Wed, 14 Oct 2020 14:03:31 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-hugetlb-narrow-the-hugetlb=5Flock-protection-area-duri?=
 =?US-ASCII?Q?ng-preparing-huge-page.patch?= removed from -mm tree
Message-ID: <20201014210331.pLChu9BFq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: narrow the hugetlb_lock protection area during preparing huge page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-narrow-the-hugetlb_lock-protection-area-during-preparing-huge-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/hugetlb: narrow the hugetlb_lock protection area during preparing huge page

set_hugetlb_cgroup_[rsvd] just manipulate page local data, which is not
necessary to be protected by hugetlb_lock.

Let's take this out.

Link: https://lkml.kernel.org/r/20200831022351.20916-7-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-narrow-the-hugetlb_lock-protection-area-during-preparing-huge-page
+++ a/mm/hugetlb.c
@@ -1504,9 +1504,9 @@ static void prep_new_huge_page(struct hs
 {
 	INIT_LIST_HEAD(&page->lru);
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
-	spin_lock(&hugetlb_lock);
 	set_hugetlb_cgroup(page, NULL);
 	set_hugetlb_cgroup_rsvd(page, NULL);
+	spin_lock(&hugetlb_lock);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
 	spin_unlock(&hugetlb_lock);
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

