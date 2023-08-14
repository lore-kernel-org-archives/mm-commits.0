Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8BEEB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 20:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbjHNUX0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 16:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbjHNUWy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 16:22:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6927DBC
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 13:22:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06C3063219
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 20:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A73DC433C8;
        Mon, 14 Aug 2023 20:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692044572;
        bh=TRPixX8vwIkMouXb8NvW07WEKBjcx79Lkku0L7QwePY=;
        h=Date:To:From:Subject:From;
        b=2lvO+bbpbpcNZRXUd7vIJdhN5G6D/yUGdzA6Vop/pnv8Hpr66i/SxJK6VpkK0vGAF
         NoLq5QS7mGTPXRZPISnIfKDYPcs+xOvzUGNpJ7eAgKJRYdMiZZWOfxpRR/P5HI+4qc
         2bQcj88GotmvlEJZJJDKBq0QVUl/Yl1xA1OfBWBg=
Date:   Mon, 14 Aug 2023 13:22:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-use-a-folio-in-secretmem_fault.patch added to mm-unstable branch
Message-Id: <20230814202252.5A73DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/secretmem: use a folio in secretmem_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-secretmem-use-a-folio-in-secretmem_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-secretmem-use-a-folio-in-secretmem_fault.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/secretmem: use a folio in secretmem_fault()
Date: Sat, 12 Aug 2023 14:26:12 +0800

Saves four implicit call to compound_head().

Link: https://lkml.kernel.org/r/20230812062612.3184990-1-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/secretmem.c~mm-secretmem-use-a-folio-in-secretmem_fault
+++ a/mm/secretmem.c
@@ -55,6 +55,7 @@ static vm_fault_t secretmem_fault(struct
 	gfp_t gfp = vmf->gfp_mask;
 	unsigned long addr;
 	struct page *page;
+	struct folio *folio;
 	vm_fault_t ret;
 	int err;
 
@@ -66,23 +67,24 @@ static vm_fault_t secretmem_fault(struct
 retry:
 	page = find_lock_page(mapping, offset);
 	if (!page) {
-		page = alloc_page(gfp | __GFP_ZERO);
-		if (!page) {
+		folio = folio_alloc(gfp | __GFP_ZERO, 0);
+		if (!folio) {
 			ret = VM_FAULT_OOM;
 			goto out;
 		}
 
+		page = &folio->page;
 		err = set_direct_map_invalid_noflush(page);
 		if (err) {
-			put_page(page);
+			folio_put(folio);
 			ret = vmf_error(err);
 			goto out;
 		}
 
-		__SetPageUptodate(page);
-		err = add_to_page_cache_lru(page, mapping, offset, gfp);
+		__folio_mark_uptodate(folio);
+		err = filemap_add_folio(mapping, folio, offset, gfp);
 		if (unlikely(err)) {
-			put_page(page);
+			folio_put(folio);
 			/*
 			 * If a split of large page was required, it
 			 * already happened when we marked the page invalid
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-kmsan-use-helper-function-page_size.patch
mm-kmsan-use-helper-macro-offset_in_page.patch
mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch
mm-remove-redundant-k-macro-definition.patch
mm-swapfilec-use-helper-macro-k.patch
mm-swap_statec-use-helper-macro-k.patch
mm-shmemc-use-helper-macro-k.patch
mm-nommuc-use-helper-macro-k.patch
mm-mmapc-use-helper-macro-k.patch
mm-hugetlbc-use-helper-macro-k.patch
mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch
mm-oom-remove-unnecessary-goto-in-oom_evaluate_task.patch
mm-oom-terminate-the-oom_evaluate_task-loop-early.patch
mm-secretmem-use-a-folio-in-secretmem_fault.patch

