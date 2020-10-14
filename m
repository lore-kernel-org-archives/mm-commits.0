Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7D7C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 069F5221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709399;
	bh=RczkgPe/c7gFxKk424+y5iQTRLudLeSk53BjiE4ebXk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SkLg/pBvZ/RjzB/dme+IJ3rjQmuRZslIS40+rzaSgb/wGu91B2tHNZ5iVg7AGLuVr
	 VpvwVIr79rDgTq+v2fNi54TC5yU/gTFNu7kcJLvPRLRPXzJSIA417cGHYdXkNfddkC
	 97OeC0EnhwROuCcJ+U4ei4henwiHG8QBgDWzuRyc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbgJNVDS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbgJNVDR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 854CE206B2;
        Wed, 14 Oct 2020 21:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709396;
        bh=RczkgPe/c7gFxKk424+y5iQTRLudLeSk53BjiE4ebXk=;
        h=Date:From:To:Subject:From;
        b=Dd+0T2GC4HABgnXhgXaXVTVV1BSnT6c1ymysm9j/Bdhld8s04XRbupodNWFbgkeu+
         /UtxMr9iujl7NGzoCLZmn3kNm+zJ5fvDoq6A0EYXj2v+jpvo22FHkX+3GDVeyP6at7
         JYW8l+XC1A0OlmVyMq92a7vDMX1yFBYEUmP+O1Ys=
Date:   Wed, 14 Oct 2020 14:03:16 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-hugetlb-not-necessary-to-coalesce-regions-recursively.patch removed from
 -mm tree
Message-ID: <20201014210316.epWe6t2qO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: not necessary to coalesce regions recursively
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-not-necessary-to-coalesce-regions-recursively.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/hugetlb: not necessary to coalesce regions recursively

Patch series "mm/hugetlb: code refine and simplification", v4.

Following are some cleanups for hugetlb.  Simple testing with
tools/testing/selftests/vm/map_hugetlb passes.


This patch (of 7):

Per my understanding, we keep the regions ordered and would always
coalesce regions properly.  So the task to keep this property is just to
coalesce its neighbour.

Let's simplify this.

Link: https://lkml.kernel.org/r/20200901014636.29737-1-richard.weiyang@linux.alibaba.com
Link: https://lkml.kernel.org/r/20200831022351.20916-1-richard.weiyang@linux.alibaba.com
Link: https://lkml.kernel.org/r/20200831022351.20916-2-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-not-necessary-to-coalesce-regions-recursively
+++ a/mm/hugetlb.c
@@ -309,8 +309,7 @@ static void coalesce_file_region(struct
 		list_del(&rg->link);
 		kfree(rg);
 
-		coalesce_file_region(resv, prg);
-		return;
+		rg = prg;
 	}
 
 	nrg = list_next_entry(rg, link);
@@ -320,9 +319,6 @@ static void coalesce_file_region(struct
 
 		list_del(&rg->link);
 		kfree(rg);
-
-		coalesce_file_region(resv, nrg);
-		return;
 	}
 }
 
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

