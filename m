Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2A8C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 718E9207BB
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595563671;
	bh=BuLEU2j+F1G7l2dIom/c4LLiCN9gT1S7CphEasd6gBk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=u4mDMZ6RgCFU/L4GN8+jcqD7lUT5Qex5+TWWGmePTpqsE3MeWWsIlb9y9MlGfWKp9
	 jXZXXNwrV5TY025AUhwsRFrJ2cIepHVQwhZg5W9G+jiNvfAWUKdw5iPlYILxyIucqJ
	 eAw28OOd3juGvU2Vs2Wvw3JxVk3qUiiumMtwSHlc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbgGXEHv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgGXEHv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:07:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A144220792;
        Fri, 24 Jul 2020 04:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595563670;
        bh=BuLEU2j+F1G7l2dIom/c4LLiCN9gT1S7CphEasd6gBk=;
        h=Date:From:To:Subject:From;
        b=FBzQG1k622SAawBQXQCliTg8ogyearvB8ouD0GvJRt1/NmFjhVApsOC/y7KuaiGjL
         Iz6TnNa5dHMI0KGjg2Az90saE0rJEQDvk0nZkMYRhC7a+BJlsuqksI9r9tSSM7DVKC
         pKgLWSjHf+R5AoZRLbbJunTl2lskH2Ct3x59ooOQ=
Date:   Thu, 23 Jul 2020 21:07:50 -0700
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix-fix.patch
 removed from -mm tree
Message-ID: <20200724040750.QKU1u9m44%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: better checks before using hugetlb_cma
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix-fix.patch

This patch was dropped because it was folded into mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm/hugetlb: better checks before using hugetlb_cma

Link: http://lkml.kernel.org/r/20200721205716.6dbaa56b@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix-fix
+++ a/mm/hugetlb.c
@@ -1238,9 +1238,10 @@ static void free_gigantic_page(struct pa
 	 * If the page isn't allocated using the cma allocator,
 	 * cma_release() returns false.
 	 */
-	if (IS_ENABLED(CONFIG_CMA) &&
-	    cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order))
+#ifdef CONFIG_CMA
+	if (cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order))
 		return;
+#endif
 
 	free_contig_range(page_to_pfn(page), 1 << order);
 }
@@ -1251,7 +1252,8 @@ static struct page *alloc_gigantic_page(
 {
 	unsigned long nr_pages = 1UL << huge_page_order(h);
 
-	if (IS_ENABLED(CONFIG_CMA)) {
+#ifdef CONFIG_CMA
+	{
 		struct page *page;
 		int node;
 
@@ -1265,6 +1267,7 @@ static struct page *alloc_gigantic_page(
 				return page;
 		}
 	}
+#endif
 
 	return alloc_contig_pages(nr_pages, gfp_mask, nid, nodemask);
 }
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled.patch

