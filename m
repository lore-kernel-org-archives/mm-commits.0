Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8171C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Dec 2022 00:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiLJAwJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Dec 2022 19:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLJAwG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2022 19:52:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC07760EBF
        for <mm-commits@vger.kernel.org>; Fri,  9 Dec 2022 16:52:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 928A7B82A07
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 00:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A23FC433F0;
        Sat, 10 Dec 2022 00:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670633523;
        bh=du6mE+t9CFr2uKmdm/E2nbMvJyU8d3Faidagnv5FQ90=;
        h=Date:To:From:Subject:From;
        b=bLEoa1EUhmbcbb/bogg6gIDAYxx9NKYojMyvaNpgjQXp6MVvDBoOnQDlpg1+B686/
         IZzvu3bo+GHMHg1f4ugNaf7xRMaKxKW/VLNH8hxUloYwa3zPvfGzRGNzP4CHwxAMp9
         w8qbJ3LKMbjsC/Btlz/xulVzBdZTw2jI2W0wYuHI=
Date:   Fri, 09 Dec 2022 16:52:02 -0800
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch added to mm-hotfixes-unstable branch
Message-Id: <20221210005203.4A23FC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: support recovery from ksm_might_need_to_copy()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch

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
Subject: mm: hwpoison: support recovery from ksm_might_need_to_copy()
Date: Fri, 9 Dec 2022 15:28:01 +0800

When the kernel copies a page in ksm_might_need_to_copy(), but runs into
an uncorrectable error, it will crash since the poisoned page is consumed
by kernel.  This is similar to Copy-on-write poison recovery.

When an error is detected during the page copy, return VM_FAULT_HWPOISON,
which helps us to avoid the system crash.  Note, memory failure on a KSM
page will be skipped, but still call memory_failure_queue() to be
consistent with general memory failure processes.

Link: https://lkml.kernel.org/r/20221209072801.193221-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c      |    8 ++++++--
 mm/memory.c   |    3 +++
 mm/swapfile.c |    2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/mm/ksm.c~mm-hwposion-support-recovery-from-ksm_might_need_to_copy
+++ a/mm/ksm.c
@@ -2602,8 +2602,12 @@ struct page *ksm_might_need_to_copy(stru
 		new_page = NULL;
 	}
 	if (new_page) {
-		copy_user_highpage(new_page, page, address, vma);
-
+		if (copy_mc_user_highpage(new_page, page, address, vma)) {
+			put_page(new_page);
+			new_page = ERR_PTR(-EHWPOISON);
+			memory_failure_queue(page_to_pfn(page), 0);
+			return new_page;
+		}
 		SetPageDirty(new_page);
 		__SetPageUptodate(new_page);
 		__SetPageLocked(new_page);
--- a/mm/memory.c~mm-hwposion-support-recovery-from-ksm_might_need_to_copy
+++ a/mm/memory.c
@@ -3878,6 +3878,9 @@ vm_fault_t do_swap_page(struct vm_fault
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
@@ -1768,7 +1768,7 @@ static int unuse_pte(struct vm_area_stru
 
 	swapcache = page;
 	page = ksm_might_need_to_copy(page, vma, addr);
-	if (unlikely(!page))
+	if (IS_ERR_OR_NULL(page))
 		return -ENOMEM;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-add-cond_resched-in-swapin_walk_pmd_entry.patch

