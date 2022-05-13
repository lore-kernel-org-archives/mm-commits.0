Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549E3C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383832AbiEMTYA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383845AbiEMTWh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275283C73E
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8540B83174
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7BFC34113;
        Fri, 13 May 2022 19:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469717;
        bh=JV1x/TtCiljSO/iER3AoS/408ReI8lpQ1HDBZOwwlZQ=;
        h=Date:To:From:Subject:From;
        b=SprTUOifK3PUl95McrHIHaunwcxaCAtPB0bW74hexMicL8HRz+TZKyeXCXbwosMjW
         oTxzM8okUeFYL+SrEngjWJFizsD6Yqg1odKVocNLOZKJ8ehH7HDpzVLXPh1ibCx6OF
         +1hGJsZL2tyRoMDNrZgtXmQtmuIzM6w5BSbHO0DE=
Date:   Fri, 13 May 2022 12:21:56 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-add-folio_throttle_swaprate.patch removed from -mm tree
Message-Id: <20220513192157.8A7BFC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: add folio_throttle_swaprate
has been removed from the -mm tree.  Its filename was
     mm-swap-add-folio_throttle_swaprate.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: add folio_throttle_swaprate

The only use of the page argument to cgroup_throttle_swaprate() is to get
the node ID, and this will be the same for all pages in the folio, so just
pass in the first page of the folio.

Link: https://lkml.kernel.org/r/20220504182857.4013401-18-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/swap.h~mm-swap-add-folio_throttle_swaprate
+++ a/include/linux/swap.h
@@ -640,6 +640,10 @@ static inline void cgroup_throttle_swapr
 {
 }
 #endif
+static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
+{
+	cgroup_throttle_swaprate(&folio->page, gfp);
+}
 
 #ifdef CONFIG_MEMCG_SWAP
 void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

