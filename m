Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F866C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 22:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiLOWaB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 17:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLOWaA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 17:30:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704D25289D
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 14:29:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09F5D61F73
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 22:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B922C433EF;
        Thu, 15 Dec 2022 22:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671143398;
        bh=7FI+HD/hMjL6g6IQZOmvEPzPeMJq3a66jDPXgYkQjAM=;
        h=Date:To:From:Subject:From;
        b=yuL/1ZENM3E4/5E4SdpwPUrUlTjxSbA80UWfO/E0EMpfEXzUZXaM4QNAPZ2VhLaxe
         aheOoASXOicZ2MEk2pMl+w4e5KEjZglhimnk/KsCoHad3FDiJBzvTx2hSeWd4GFyXc
         s+VwhfwkkYNNxb+b+4LG1F38r03TXZcRDxlN77io=
Date:   Thu, 15 Dec 2022 14:29:57 -0800
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20221215222958.5B922C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwposion: support recovery from ksm_might_need_to_copy()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 mm/swapfile.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/mm/swapfile.c~mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3
+++ a/mm/swapfile.c
@@ -1763,12 +1763,15 @@ static int unuse_pte(struct vm_area_stru
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
@@ -1776,15 +1779,19 @@ static int unuse_pte(struct vm_area_stru
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
@@ -1816,6 +1823,7 @@ static int unuse_pte(struct vm_area_stru
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
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch

