Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71BBEC43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30C482222E
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633382;
	bh=LVx0omR5GUxVi7RRdIQXehWaocRuInZ7VCeOkY9DwPg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=VQYdzSZScRixRT0lmvEEYsESXxmVi+9So4+bEAF+wDD6ZEgcUEvLb+U/m2Bvl7sf+
	 W0FmAdzS2tXMlQag6LxxFf085vpH6iGn3/7aBPvytNxtwMHBlwjdjD+CqGzKpUrsWW
	 07LYl11yPd1EyrpkFE/uNOFJ7gNF4H1BMA/j0f+o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388676AbgJMX4V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMX4V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED3502222F;
        Tue, 13 Oct 2020 23:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633381;
        bh=LVx0omR5GUxVi7RRdIQXehWaocRuInZ7VCeOkY9DwPg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rtt3uOQGJkRSlSScUnLrKCoogm878AM5STLvd+v41mAAdQsDxhcNIF8XxZehm+TIB
         iVzGFH3oJ1KZ9XZYt7dUq53u7xymsauyXXIiHQ5YNshimSHBrboJF1DLzlkkmbWumU
         FIqkl/yuke+8fBHyju1KXsbyA/cjNXuc/XwM3D5A=
Date:   Tue, 13 Oct 2020 16:56:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 144/181] mm/hugetlb: not necessary to coalesce
 regions recursively
Message-ID: <20201013235620.C3PzUMXl3%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
