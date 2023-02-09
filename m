Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFF4C05027
	for <mm-commits@archiver.kernel.org>; Thu,  9 Feb 2023 23:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjBIX5Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 18:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjBIX5W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 18:57:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E126F56EFA
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 15:57:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52B0CB8224B
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 23:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DEFC433D2;
        Thu,  9 Feb 2023 23:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675987037;
        bh=H0LSs6Px/EpaSAEY2yPD+OpNZe1sbh4bUeXahKNast4=;
        h=Date:To:From:Subject:From;
        b=Rv5L6jZXEXk3aIRuo4HaIgd2EhyiRJWeEA78mGcq2X7/BTQfGJjlu66B7lexL/ISZ
         KLFJkm7evjRfcK5kSWC+fMDTU250vpYsoEY87u4gNha9o1QyPkGoYUO6/00mRWqxs6
         uO6euYKMVyXOuPcRRIZkdSMC2YSpiyKyRTwfbQx8=
Date:   Thu, 09 Feb 2023 15:57:17 -0800
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch removed from -mm tree
Message-Id: <20230209235717.C6DEFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hwpoison: support recovery from ksm_might_need_to_copy()
has been removed from the -mm tree.  Its filename was
     mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hwpoison: support recovery from ksm_might_need_to_copy()
Date: Fri, 9 Dec 2022 15:28:01 +0800

When the kernel copies a page from ksm_might_need_to_copy(), but runs into
an uncorrectable error, it will crash since poisoned page is consumed by
kernel, this is similar to the issue recently fixed by Copy-on-write
poison recovery.

When an error is detected during the page copy, return VM_FAULT_HWPOISON
in do_swap_page(), and install a hwpoison entry in unuse_pte() when
swapoff, which help us to avoid system crash.  Note, memory failure on a
KSM page will be skipped, but still call memory_failure_queue() to be
consistent with general memory failure process, and we could support KSM
page recovery in the feature.

[wangkefeng.wang@huawei.com: enhance unuse_pte(), fix issue found by lkp]
  Link: https://lkml.kernel.org/r/20221213120523.141588-1-wangkefeng.wang@huawei.com
[wangkefeng.wang@huawei.com: update changelog, alter ksm_might_need_to_copy(), restore unlikely() in unuse_pte()]
  Link: https://lkml.kernel.org/r/20230201074433.96641-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20221209072801.193221-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c      |    7 +++++--
 mm/memory.c   |    3 +++
 mm/swapfile.c |   20 ++++++++++++++------
 3 files changed, 22 insertions(+), 8 deletions(-)

--- a/mm/ksm.c~mm-hwposion-support-recovery-from-ksm_might_need_to_copy
+++ a/mm/ksm.c
@@ -2629,8 +2629,11 @@ struct page *ksm_might_need_to_copy(stru
 		new_page = NULL;
 	}
 	if (new_page) {
-		copy_user_highpage(new_page, page, address, vma);
-
+		if (copy_mc_user_highpage(new_page, page, address, vma)) {
+			put_page(new_page);
+			memory_failure_queue(page_to_pfn(page), 0);
+			return ERR_PTR(-EHWPOISON);
+		}
 		SetPageDirty(new_page);
 		__SetPageUptodate(new_page);
 		__SetPageLocked(new_page);
--- a/mm/memory.c~mm-hwposion-support-recovery-from-ksm_might_need_to_copy
+++ a/mm/memory.c
@@ -3840,6 +3840,9 @@ vm_fault_t do_swap_page(struct vm_fault
 		if (unlikely(!page)) {
 			ret = VM_FAULT_OOM;
 			goto out_page;
+		} else if (unlikely(PTR_ERR(page) == -EHWPOISON)) {
+			ret = VM_FAULT_HWPOISON;
+			goto out_page;
 		}
 		folio = page_folio(page);
 
--- a/mm/swapfile.c~mm-hwposion-support-recovery-from-ksm_might_need_to_copy
+++ a/mm/swapfile.c
@@ -1764,12 +1764,15 @@ static int unuse_pte(struct vm_area_stru
 	struct page *swapcache;
 	spinlock_t *ptl;
 	pte_t *pte, new_pte;
+	bool hwposioned = false;
 	int ret = 1;
 
 	swapcache = page;
 	page = ksm_might_need_to_copy(page, vma, addr);
 	if (unlikely(!page))
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
+	if (unlikely(hwposioned || !PageUptodate(page))) {
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


