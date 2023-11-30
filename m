Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAB5C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 22:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377153AbjK3W0P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 17:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377150AbjK3W0O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 17:26:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A863D10D9
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 14:26:20 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AAFC433C7;
        Thu, 30 Nov 2023 22:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701383180;
        bh=LHiwPp9kYM+ZXVRUueKb40E3y7kcBYjq8TNRqV0TB6Y=;
        h=Date:To:From:Subject:From;
        b=otdCayHt5gNs255z41fT03mnfDCLQZzCkx3zib8rQD0tfe+FQVi847BaaqpMCFtUq
         KHX375i6wKbyDXLkZhr24EZ0+FQy0HDiSPHCKLZ4t34UMicrLDTUz80q0/UrDWP52F
         +Cpz4kw/uQjJPHZVJYIvM4p2w1sONIN/om13IiUo=
Date:   Thu, 30 Nov 2023 14:26:19 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sidhartha.kumar@oracle.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-rename-page_copy_prealloc-to-folio_prealloc.patch added to mm-unstable branch
Message-Id: <20231130222620.44AAFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: rename page_copy_prealloc() to folio_prealloc()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-rename-page_copy_prealloc-to-folio_prealloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-rename-page_copy_prealloc-to-folio_prealloc.patch

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
Subject: mm: memory: rename page_copy_prealloc() to folio_prealloc()
Date: Sat, 18 Nov 2023 10:32:30 +0800

Let's rename page_copy_prealloc() to folio_prealloc(), which could be
reused in more functons, as it maybe zero the new page, pass a new
need_zero to it, and call the vma_alloc_zeroed_movable_folio() if
need_zero is true.

Link: https://lkml.kernel.org/r/20231118023232.1409103-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-rename-page_copy_prealloc-to-folio_prealloc
+++ a/mm/memory.c
@@ -992,12 +992,17 @@ copy_present_pte(struct vm_area_struct *
 	return 0;
 }
 
-static inline struct folio *page_copy_prealloc(struct mm_struct *src_mm,
-		struct vm_area_struct *vma, unsigned long addr)
+static inline struct folio *folio_prealloc(struct mm_struct *src_mm,
+		struct vm_area_struct *vma, unsigned long addr, bool need_zero)
 {
 	struct folio *new_folio;
 
-	new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr, false);
+	if (need_zero)
+		new_folio = vma_alloc_zeroed_movable_folio(vma, addr);
+	else
+		new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
+					    addr, false);
+
 	if (!new_folio)
 		return NULL;
 
@@ -1129,7 +1134,7 @@ again:
 	} else if (ret == -EBUSY) {
 		goto out;
 	} else if (ret ==  -EAGAIN) {
-		prealloc = page_copy_prealloc(src_mm, src_vma, addr);
+		prealloc = folio_prealloc(src_mm, src_vma, addr, false);
 		if (!prealloc)
 			return -ENOMEM;
 	} else if (ret) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy.patch
mm-memory-use-a-folio-in-validate_page_before_insert.patch
mm-memory-rename-page_copy_prealloc-to-folio_prealloc.patch
mm-memory-use-a-folio-in-do_cow_fault.patch
mm-memory-use-folio_prealloc-in-wp_page_copy.patch

