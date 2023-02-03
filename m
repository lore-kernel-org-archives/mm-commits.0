Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B89CC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjBCGhd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjBCGg1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922388D632
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F490B82982
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45C7C433D2;
        Fri,  3 Feb 2023 06:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406176;
        bh=FKS0WHznW9CvA0D3eXqAEoOJGfVYZpzEZUDEyk7ME2Y=;
        h=Date:To:From:Subject:From;
        b=V2S+I/K5EzfTcKr2m/mslWlEmrCxAhgKwPWvZw/4v41mWqHsxfzfFbwzGDqurI9dm
         VQq4L+gNg8rgnvN/otb2JBgK+6XrZqldx9OLCCs4aJxXjGaLJyF5eq4dWFeHYhqNky
         24BG270nCIizIbvlWKm4j1/Sr3X9FQf+G3Nf34jw=
Date:   Thu, 02 Feb 2023 22:36:15 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch removed from -mm tree
Message-Id: <20230203063615.E45C7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: madvise: use vm_normal_folio() in madvise_free_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: madvise: use vm_normal_folio() in madvise_free_pte_range()
Date: Thu, 12 Jan 2023 20:40:28 +0800

There is already a vm_normal_folio(), use it to make
madvise_free_pte_range() only use a folio.

Link: https://lkml.kernel.org/r/20230112124028.16964-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/madvise.c~mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range
+++ a/mm/madvise.c
@@ -617,7 +617,6 @@ static int madvise_free_pte_range(pmd_t
 	spinlock_t *ptl;
 	pte_t *orig_pte, *pte, ptent;
 	struct folio *folio;
-	struct page *page;
 	int nr_swap = 0;
 	unsigned long next;
 
@@ -658,10 +657,9 @@ static int madvise_free_pte_range(pmd_t
 			continue;
 		}
 
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page || is_zone_device_page(page))
+		folio = vm_normal_folio(vma, addr, ptent);
+		if (!folio || folio_is_zone_device(folio))
 			continue;
-		folio = page_folio(page);
 
 		/*
 		 * If pmd isn't transhuge but the folio is large and
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4.patch

