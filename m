Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED5EC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F4C82223F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633398;
	bh=d/eJdCWI1Jz88MmTVrl/nI+SjFAvgkribLa9JdIILeg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xp5XjSHJdfRpireat3eVZj7TOp9w+NOoSpNWhYwyTiGX2FG3OEn236DE33yHb+Fb+
	 H6EspFoOYW167bh4D3rsrWYlbfcHWh6X+BTutId+XoMzp4gx9452FbdUn6rFtLFPVG
	 IlHVnpsHK0P2Y5YVCnlphhmxuJzRyz8aCMUfBKps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgJMX4h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgJMX4h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D94CD2222E;
        Tue, 13 Oct 2020 23:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633397;
        bh=d/eJdCWI1Jz88MmTVrl/nI+SjFAvgkribLa9JdIILeg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s/+tuJ0gaVJp2GoGFRMTKvJMKGBtVt2cMEW+lKcVH5nzawHts22ULo4Q3GmEmjAUV
         /zJeYB8bRX+sDs/jLom9sksTFDwbbg49eq/CpyF2yS/DiFaGtOL4c5QOWPEqGf2tl3
         4lTRTxGySi/wO48gNXVVgu2BMGE6374zEt6WU7Ik=
Date:   Tue, 13 Oct 2020 16:56:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 149/181] mm/hugetlb: narrow the hugetlb_lock
 protection area during preparing huge page
Message-ID: <20201013235636.jWvYFcEVc%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
