Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064F9C43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A673322248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709400;
	bh=sCuuCQjrhupWeYf2nh625B17AwuNupdF3i8H+pLtfU8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vw+StoMCHthXbAD8b+CRg2+uGMeoTm6xwNzn3VHE2VcmsUPmPYXugIG9+PuARGSxv
	 bmRntk/h1OatBtCudiq+Gm1SMEsddIPDB9xDI/rV1rFyyeoPYvuG1SYMOu/VcT7buO
	 uI3YMLt4fDC0dFErcbnckD2JRwmj/0O5GzHUPVms=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388427AbgJNVDU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbgJNVDU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C3F4214D8;
        Wed, 14 Oct 2020 21:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709399;
        bh=sCuuCQjrhupWeYf2nh625B17AwuNupdF3i8H+pLtfU8=;
        h=Date:From:To:Subject:From;
        b=NxXLaIgLfuU4hksAHS8N7cZJkWJMbb6T6SWNjsMXWAKtmSL+ak5+feEBlkh73/bw4
         IMHlZVmiqbXKypxRGkqU3HUs6YOmgenZsA9C8zypcqlsszNRFeZCMI3zabPs1B6H+L
         pbXtW12MxX8k2d9PongAfUhkRPrMvU0XGap/djQY=
Date:   Wed, 14 Oct 2020 14:03:19 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-hugetlb-remove-vm_bug_onnrg-in-get_file_region_entry_from_cache.patch
 removed from -mm tree
Message-ID: <20201014210319.d0l3sKPPV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove VM_BUG_ON(!nrg) in get_file_region_entry_from_cache()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-vm_bug_onnrg-in-get_file_region_entry_from_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/hugetlb: remove VM_BUG_ON(!nrg) in get_file_region_entry_from_cache()

We are sure to get a valid file_region, otherwise the
VM_BUG_ON(resv->region_cache_count <= 0) at the very beginning would be
triggered.

Let's remove the redundant one.

Link: https://lkml.kernel.org/r/20200831022351.20916-3-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-vm_bug_onnrg-in-get_file_region_entry_from_cache
+++ a/mm/hugetlb.c
@@ -240,7 +240,6 @@ get_file_region_entry_from_cache(struct
 
 	resv->region_cache_count--;
 	nrg = list_first_entry(&resv->region_cache, struct file_region, link);
-	VM_BUG_ON(!nrg);
 	list_del(&nrg->link);
 
 	nrg->from = from;
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

