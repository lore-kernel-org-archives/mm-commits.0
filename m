Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CCCC352A1
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiK3Xoo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiK3Xon (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:44:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E6B4D5E4
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:44:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F86DB81D75
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF99CC433D7;
        Wed, 30 Nov 2022 23:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669851879;
        bh=J9aIEFHllA/1gq7innj/DOjXubk7ADC/YLxqFAQ8AnQ=;
        h=Date:To:From:Subject:From;
        b=pTbGWPwwPLjaC2Tq2Vhj3bPxrm8z3W90/uQ1YRFd7GCPHl+V5v/VSwm+UCSIPULfX
         oCgxExQev3PlkUxgnOsqUlBOfpIiy4VNRa5gYeEQyPId3Xt0tNlLv+ShOAqC2wIA+S
         q6xw51DGaeKPJZ3BTF8dCoZAufcxAGeoPfi84tLE=
Date:   Wed, 30 Nov 2022 15:44:38 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        joao.m.martins@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4.patch removed from -mm tree
Message-Id: <20221130234438.DF99CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4.patch

This patch was dropped because it was folded into mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page.patch

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4
Date: Thu, 10 Nov 2022 12:12:14 +0000

add smp_wmb() to ensure page contents are visible prior to PTE write

Link: https://lkml.kernel.org/r/20221110121214.6297-1-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4
+++ a/mm/hugetlb_vmemmap.c
@@ -246,6 +246,13 @@ static void vmemmap_remap_pte(pte_t *pte
 	if (unlikely(addr == walk->reuse_addr)) {
 		pgprot = PAGE_KERNEL;
 		list_del(&walk->reuse_page->lru);
+
+		/*
+		 * Makes sure that preceding stores to the page contents from
+		 * vmemmap_remap_free() become visible before the set_pte_at()
+		 * write.
+		 */
+		smp_wmb();
 	}
 
 	entry = mk_pte(walk->reuse_page, pgprot);
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page.patch

