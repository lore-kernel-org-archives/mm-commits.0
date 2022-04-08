Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9CCC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Apr 2022 17:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiDHRqB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 13:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbiDHRqA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 13:46:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AB426F7
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 10:43:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D123621C4
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 17:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B266C385A3;
        Fri,  8 Apr 2022 17:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649439835;
        bh=1K8CK/0RN0ofUdZnXL0p8FQ7F9+gd9Py8CDxRC5RQ/8=;
        h=Date:To:From:Subject:From;
        b=kLR7SvisAeaQNbgOG3robhBwJyZwodzr2JmynkF3nLLr8AUys4GYNmKPBfdeDPr0J
         kBRhzaz6bgqt6BfrspP/aauxviRVaPkyAv35Vn+e3hoQZRwbvLkZjWkc6duBPn6uWh
         YtVQjP9wnwnmYIR532EpRhq8XqqbIeJsobuw04Mg=
Date:   Fri, 08 Apr 2022 10:43:54 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-next-rejects.patch added to -mm tree
Message-Id: <20220408174355.5B266C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/Makefile |    3 --
 mm/mempolicy.c       |   23 ++++++-----------
 mm/migrate.c         |   54 +++++++++++++++--------------------------
 3 files changed, 31 insertions(+), 49 deletions(-)

--- a/arch/x86/mm/Makefile~linux-next-rejects
+++ a/arch/x86/mm/Makefile
@@ -20,13 +20,12 @@ CFLAGS_REMOVE_mem_encrypt_identity.o	= -
 endif
 
 obj-y				:=  init.o init_$(BITS).o fault.o ioremap.o extable.o mmap.o \
-				    pgtable.o physaddr.o setup_nx.o tlb.o cpu_entry_area.o maccess.o pgprot.o
+				    pgtable.o physaddr.o tlb.o cpu_entry_area.o maccess.o pgprot.o
 
 obj-y				+= pat/
 
 # Make sure __phys_addr has no stackprotector
 CFLAGS_physaddr.o		:= -fno-stack-protector
-CFLAGS_setup_nx.o		:= -fno-stack-protector
 CFLAGS_mem_encrypt_identity.o	:= -fno-stack-protector
 
 CFLAGS_fault.o := -I $(srctree)/$(src)/../include/asm/trace
--- a/mm/mempolicy.c~linux-next-rejects
+++ a/mm/mempolicy.c
@@ -1211,24 +1211,19 @@ static struct page *new_page(struct page
 		vma = vma->vm_next;
 	}
 
-	if (PageHuge(page)) {
-		return alloc_huge_page_vma(page_hstate(compound_head(page)),
+	if (folio_test_hugetlb(src))
+		return alloc_huge_page_vma(page_hstate(&src->page),
 				vma, address);
-	} else if (PageTransHuge(page)) {
-		struct page *thp;
 
-		thp = alloc_hugepage_vma(GFP_TRANSHUGE, vma, address,
-					 thp_order(page));
-		if (!thp)
-			return NULL;
-		prep_transhuge_page(thp);
-		return thp;
-	}
+	if (folio_test_large(src))
+		gfp = GFP_TRANSHUGE;
+
 	/*
-	 * if !vma, alloc_page_vma() will use task or system default policy
+	 * if !vma, vma_alloc_folio() will use task or system default policy
 	 */
-	return alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_RETRY_MAYFAIL,
-			vma, address);
+	dst = vma_alloc_folio(gfp, folio_order(src), vma, address,
+			folio_test_large(src));
+	return &dst->page;
 }
 #else
 
--- a/mm/migrate.c~linux-next-rejects
+++ a/mm/migrate.c
@@ -1538,34 +1538,31 @@ struct page *alloc_migration_target(stru
 	gfp_mask = mtc->gfp_mask;
 	nid = mtc->nid;
 	if (nid == NUMA_NO_NODE)
-		nid = page_to_nid(page);
+		nid = folio_nid(folio);
 
-	if (PageHuge(page)) {
-		struct hstate *h = page_hstate(compound_head(page));
+	if (folio_test_hugetlb(folio)) {
+		struct hstate *h = page_hstate(&folio->page);
 
 		gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
 		return alloc_huge_page_nodemask(h, nid, mtc->nmask, gfp_mask);
 	}
 
-	if (PageTransHuge(page)) {
+	if (folio_test_large(folio)) {
 		/*
 		 * clear __GFP_RECLAIM to make the migration callback
 		 * consistent with regular THP allocations.
 		 */
 		gfp_mask &= ~__GFP_RECLAIM;
 		gfp_mask |= GFP_TRANSHUGE;
-		order = thp_order(page);
+		order = folio_order(folio);
 	}
-	zidx = zone_idx(page_zone(page));
+	zidx = zone_idx(folio_zone(folio));
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
-	new_page = __alloc_pages(gfp_mask, order, nid, mtc->nmask);
-
-	if (new_page && PageTransHuge(page))
-		prep_transhuge_page(new_page);
+	new_folio = __folio_alloc(gfp_mask, order, nid, mtc->nmask);
 
-	return new_page;
+	return &new_folio->page;
 }
 
 #ifdef CONFIG_NUMA
@@ -2007,29 +2004,20 @@ static struct page *alloc_misplaced_dst_
 					   unsigned long data)
 {
 	int nid = (int) data;
-	struct page *newpage;
-
-	newpage = __alloc_pages_node(nid,
-					 (GFP_HIGHUSER_MOVABLE |
-					  __GFP_THISNODE | __GFP_NOMEMALLOC |
-					  __GFP_NORETRY | __GFP_NOWARN) &
-					 ~__GFP_RECLAIM, 0);
-
-	return newpage;
-}
-
-static struct page *alloc_misplaced_dst_page_thp(struct page *page,
-						 unsigned long data)
-{
-	int nid = (int) data;
-	struct page *newpage;
-
-	newpage = alloc_pages_node(nid, (GFP_TRANSHUGE_LIGHT | __GFP_THISNODE),
-				   HPAGE_PMD_ORDER);
-	if (newpage)
-		prep_transhuge_page(newpage);
+	int order = compound_order(page);
+	gfp_t gfp = __GFP_THISNODE;
+	struct folio *new;
+
+	if (order > 0)
+		gfp |= GFP_TRANSHUGE_LIGHT;
+	else {
+		gfp |= GFP_HIGHUSER_MOVABLE | __GFP_NOMEMALLOC | __GFP_NORETRY |
+			__GFP_NOWARN;
+		gfp &= ~__GFP_RECLAIM;
+	}
+	new = __folio_alloc_node(gfp, order, nid);
 
-	return newpage;
+	return &new->page;
 }
 
 static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

