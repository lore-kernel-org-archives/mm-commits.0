Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C90A2C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383884AbiEMTXQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383828AbiEMTWU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EF83BBD2
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 113526225F
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B87DC34113;
        Fri, 13 May 2022 19:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469711;
        bh=RprJQycOQ2dxCt74aPxCWwUzT+ep+52/X9yoe4aGmDQ=;
        h=Date:To:From:Subject:From;
        b=GGMWBUTjln5V6W1P58YIKZlo9lxBEGOSj8rIJ4RtLXGz5vnauixv0s1A415o08gHk
         DEaV3LdFQ6tYsWZQEeeo9yotIObkuQseHW7ltPeQhNAK0SnXdyW7zNQHZtA4FTI8/7
         mpBVhG6hJ7n9wZ3w2rk6D9ebTry+LbHKNtb6MNaM=
Date:   Fri, 13 May 2022 12:21:50 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmscan-convert-lazy-freeing-to-folios.patch removed from -mm tree
Message-Id: <20220513192151.6B87DC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmscan: convert lazy freeing to folios
has been removed from the -mm tree.  Its filename was
     vmscan-convert-lazy-freeing-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmscan: convert lazy freeing to folios

Remove a hidden call to compound_head(), and account nr_pages instead of a
single page.  This matches the code in lru_lazyfree_fn() that accounts
nr_pages to PGLAZYFREE.

Link: https://lkml.kernel.org/r/20220504182857.4013401-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 ++++++++++++++
 mm/vmscan.c                |   18 +++++++++---------
 2 files changed, 23 insertions(+), 9 deletions(-)

--- a/include/linux/memcontrol.h~vmscan-convert-lazy-freeing-to-folios
+++ a/include/linux/memcontrol.h
@@ -1057,6 +1057,15 @@ static inline void count_memcg_page_even
 		count_memcg_events(memcg, idx, 1);
 }
 
+static inline void count_memcg_folio_events(struct folio *folio,
+		enum vm_event_item idx, unsigned long nr)
+{
+	struct mem_cgroup *memcg = folio_memcg(folio);
+
+	if (memcg)
+		count_memcg_events(memcg, idx, nr);
+}
+
 static inline void count_memcg_event_mm(struct mm_struct *mm,
 					enum vm_event_item idx)
 {
@@ -1494,6 +1503,11 @@ static inline void count_memcg_page_even
 {
 }
 
+static inline void count_memcg_folio_events(struct folio *folio,
+		enum vm_event_item idx, unsigned long nr)
+{
+}
+
 static inline
 void count_memcg_event_mm(struct mm_struct *mm, enum vm_event_item idx)
 {
--- a/mm/vmscan.c~vmscan-convert-lazy-freeing-to-folios
+++ a/mm/vmscan.c
@@ -1902,20 +1902,20 @@ retry:
 			}
 		}
 
-		if (PageAnon(page) && !PageSwapBacked(page)) {
+		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
 			/* follow __remove_mapping for reference */
-			if (!page_ref_freeze(page, 1))
+			if (!folio_ref_freeze(folio, 1))
 				goto keep_locked;
 			/*
-			 * The page has only one reference left, which is
+			 * The folio has only one reference left, which is
 			 * from the isolation. After the caller puts the
-			 * page back on lru and drops the reference, the
-			 * page will be freed anyway. It doesn't matter
-			 * which lru it goes. So we don't bother checking
-			 * PageDirty here.
+			 * folio back on the lru and drops the reference, the
+			 * folio will be freed anyway. It doesn't matter
+			 * which lru it goes on. So we don't bother checking
+			 * the dirty flag here.
 			 */
-			count_vm_event(PGLAZYFREED);
-			count_memcg_page_event(page, PGLAZYFREED);
+			count_vm_events(PGLAZYFREED, nr_pages);
+			count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
 		} else if (!mapping || !__remove_mapping(mapping, folio, true,
 							 sc->target_mem_cgroup))
 			goto keep_locked;
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

