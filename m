Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539A4C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02353221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709404;
	bh=heDQZvZNElSolfkaUH+8T5l4Yw6L45veKq0DI34/lh8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Gqi1KK8RUaaOVfBcjSmhd3RtyOc6A3w7HIVE3Z2m+iFHlOtQQT53ua6DTXxoPrb8Z
	 03JY9e/eOvvyeSM4X3Lx0VrQaQVlRsfd3Vex5DX0wDoVRJ6mFD9JxFwnhsdGPOnhOZ
	 hoDmgf0V7QgGfIYJoDwphis8KdCFq5tmxjMw6ZpM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgJNVDX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVDX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:23 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8818A206B2;
        Wed, 14 Oct 2020 21:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709402;
        bh=heDQZvZNElSolfkaUH+8T5l4Yw6L45veKq0DI34/lh8=;
        h=Date:From:To:Subject:From;
        b=cbA6cixqLZYcfoDPuXs05y9n+ILRY6mnPeSsnvB+CObcg3cvfXDewgENDAft0mdQ2
         AROlkH0bsezx0nzeiu6iNy0ZG55CgEuOtmQj+9MUhbXGTr60RDuGyM8BoeTncunm08
         3DJX2isTIkF6cuQicG43rx36NJoK44EOgq02eWGU=
Date:   Wed, 14 Oct 2020 14:03:22 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-hugetlb-use-list_splice-to-merge-two-list-at-once.patch removed from -mm
 tree
Message-ID: <20201014210322.Bvbeb94Kf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use list_splice to merge two list at once
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-list_splice-to-merge-two-list-at-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

