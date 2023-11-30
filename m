Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D14DC10DCE
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 22:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377150AbjK3W0T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 17:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377158AbjK3W0Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 17:26:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEEF10D9
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 14:26:22 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7A9C433CA;
        Thu, 30 Nov 2023 22:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701383182;
        bh=WCMI9y0eDJZL5fpu4IcbHxYmBubPo6ZZDQkSGglOZsE=;
        h=Date:To:From:Subject:From;
        b=oDuxRPsla09rZYcyrLDP1PLwoQQ9v2FKQgbaw7er16TVvYb2n/wGEBHttUkIkPf7Y
         w86qDUyDl202Wop2nw7vDoXhnxRrHl0eV/f46fq08lI2ZFehnSeyyAqykN/yEeL5op
         LyRoTJg9xz4bZZKCZRGqU62DjewMhFqrAZANNMkY=
Date:   Thu, 30 Nov 2023 14:26:22 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sidhartha.kumar@oracle.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-use-folio_prealloc-in-wp_page_copy.patch added to mm-unstable branch
Message-Id: <20231130222622.8C7A9C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: use folio_prealloc() in wp_page_copy()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-use-folio_prealloc-in-wp_page_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-use-folio_prealloc-in-wp_page_copy.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm: memory: use folio_prealloc() in wp_page_copy()
Date: Sat, 18 Nov 2023 10:32:32 +0800

Use folio_prealloc() helper to simplify code a bit.

Link: https://lkml.kernel.org/r/20231118023232.1409103-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/mm/memory.c~mm-memory-use-folio_prealloc-in-wp_page_copy
+++ a/mm/memory.c
@@ -3117,6 +3117,7 @@ static vm_fault_t wp_page_copy(struct vm
 	int page_copied = 0;
 	struct mmu_notifier_range range;
 	vm_fault_t ret;
+	bool pfn_is_zero;
 
 	delayacct_wpcopy_start();
 
@@ -3126,16 +3127,13 @@ static vm_fault_t wp_page_copy(struct vm
 	if (unlikely(ret))
 		goto out;
 
-	if (is_zero_pfn(pte_pfn(vmf->orig_pte))) {
-		new_folio = vma_alloc_zeroed_movable_folio(vma, vmf->address);
-		if (!new_folio)
-			goto oom;
-	} else {
+	pfn_is_zero = is_zero_pfn(pte_pfn(vmf->orig_pte));
+	new_folio = folio_prealloc(mm, vma, vmf->address, pfn_is_zero);
+	if (!new_folio)
+		goto oom;
+
+	if (!pfn_is_zero) {
 		int err;
-		new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
-				vmf->address, false);
-		if (!new_folio)
-			goto oom;
 
 		err = __wp_page_copy_user(&new_folio->page, vmf->page, vmf);
 		if (err) {
@@ -3156,10 +3154,6 @@ static vm_fault_t wp_page_copy(struct vm
 		kmsan_copy_page_meta(&new_folio->page, vmf->page);
 	}
 
-	if (mem_cgroup_charge(new_folio, mm, GFP_KERNEL))
-		goto oom_free_new;
-	folio_throttle_swaprate(new_folio, GFP_KERNEL);
-
 	__folio_mark_uptodate(new_folio);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
@@ -3258,8 +3252,6 @@ static vm_fault_t wp_page_copy(struct vm
 
 	delayacct_wpcopy_end();
 	return 0;
-oom_free_new:
-	folio_put(new_folio);
 oom:
 	ret = VM_FAULT_OOM;
 out:
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy.patch
mm-memory-use-a-folio-in-validate_page_before_insert.patch
mm-memory-rename-page_copy_prealloc-to-folio_prealloc.patch
mm-memory-use-a-folio-in-do_cow_fault.patch
mm-memory-use-folio_prealloc-in-wp_page_copy.patch

