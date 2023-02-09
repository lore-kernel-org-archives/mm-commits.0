Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D512C636D3
	for <mm-commits@archiver.kernel.org>; Thu,  9 Feb 2023 23:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBIXtc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 18:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBIXt2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 18:49:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC3A48591
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 15:49:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52A49B8237D
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 23:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7FCC433EF;
        Thu,  9 Feb 2023 23:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675986564;
        bh=SJzZNo7n0ZkdR19LrSA1XlaTBskRhfvgOTXwAJw2U0s=;
        h=Date:To:From:Subject:From;
        b=e4MzWN2fIy+RqJf6kz3r5e0xNl+SZaZAaY64ZSldiGlQtX7lNA2lwPlD1b3s4RXrO
         kGzUGKp3Q+2FUclh9/DIe2q6WIDwgxro1DjidMtJBpA6ARQkNOUrgCIu6UHfyprQuQ
         29LUNyqmmcHSNgKobd8EL6mzY+X4yYpralzuWl/w=
Date:   Thu, 09 Feb 2023 15:49:24 -0800
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch removed from -mm tree
Message-Id: <20230209234924.DD7FCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hwposion: support recovery from ksm_might_need_to_copy()
has been removed from the -mm tree.  Its filename was
     mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch

This patch was dropped because it was folded into mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hwposion: support recovery from ksm_might_need_to_copy()
Date: Tue, 13 Dec 2022 20:05:23 +0800

- enhance unuse_pte() if ksm_might_need_to_copy() return -EHWPOISON
- fix issue found by lkp 

Link: https://lkml.kernel.org/r/20221213120523.141588-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/swapfile.c~mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3
+++ a/mm/swapfile.c
@@ -1764,12 +1764,15 @@ static int unuse_pte(struct vm_area_stru
 	struct page *swapcache;
 	spinlock_t *ptl;
 	pte_t *pte, new_pte;
+	bool hwposioned = false;
 	int ret = 1;
 
 	swapcache = page;
 	page = ksm_might_need_to_copy(page, vma, addr);
-	if (IS_ERR_OR_NULL(page))
+	if (unlikely(!page))
 		return -ENOMEM;
+	else if (unlikely(PTR_ERR(page) == -EHWPOISON))
+		hwposioned = true;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (unlikely(!pte_same_as_swp(*pte, swp_entry_to_pte(entry)))) {
@@ -1777,15 +1780,19 @@ static int unuse_pte(struct vm_area_stru
 		goto out;
 	}
 
-	if (unlikely(!PageUptodate(page))) {
-		pte_t pteval;
+	if (hwposioned || !PageUptodate(page)) {
+		swp_entry_t swp_entry;
 
 		dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
-		pteval = swp_entry_to_pte(make_swapin_error_entry());
-		set_pte_at(vma->vm_mm, addr, pte, pteval);
-		swap_free(entry);
+		if (hwposioned) {
+			swp_entry = make_hwpoison_entry(swapcache);
+			page = swapcache;
+		} else {
+			swp_entry = make_swapin_error_entry();
+		}
+		new_pte = swp_entry_to_pte(swp_entry);
 		ret = 0;
-		goto out;
+		goto setpte;
 	}
 
 	/* See do_swap_page() */
@@ -1817,6 +1824,7 @@ static int unuse_pte(struct vm_area_stru
 		new_pte = pte_mksoft_dirty(new_pte);
 	if (pte_swp_uffd_wp(*pte))
 		new_pte = pte_mkuffd_wp(new_pte);
+setpte:
 	set_pte_at(vma->vm_mm, addr, pte, new_pte);
 	swap_free(entry);
 out:
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v4.patch

