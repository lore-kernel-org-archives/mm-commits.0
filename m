Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5DEC727B9
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244073AbjHXXWc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244101AbjHXXV7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CB2A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1356863676
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D079C433C9;
        Thu, 24 Aug 2023 23:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919316;
        bh=Unpw14s0iT3xIofq0cu0oTwAH0ig4TxthAv4JCRVqEo=;
        h=Date:To:From:Subject:From;
        b=pnF6/RZTNJikUe+dMf47KUYl8iEetVX9mfCeAoY/eyd60K8bKG/AbteS/gw+Q0s+v
         gt9j81EYQGWOoKJJcb7pfTb6/iKcuWsxZVHiwkMLeRgtbJx7HPtPlh+dygtuv86ycf
         TNH0OZOK0qSPJ+U1qNUUP8WI9llTQCSQzqv/sWks=
Date:   Thu, 24 Aug 2023 16:21:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch removed from -mm tree
Message-Id: <20230824232156.6D079C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: call update_mmu_cache_range() in more page fault handling paths
has been removed from the -mm tree.  Its filename was
     mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: call update_mmu_cache_range() in more page fault handling paths
Date: Wed, 2 Aug 2023 16:14:06 +0100

Pass the vm_fault to the architecture to help it make smarter decisions
about which PTEs to insert into the TLB.

Link: https://lkml.kernel.org/r/20230802151406.3735276-39-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths
+++ a/mm/memory.c
@@ -2862,7 +2862,7 @@ static inline int __wp_page_copy_user(st
 
 		entry = pte_mkyoung(vmf->orig_pte);
 		if (ptep_set_access_flags(vma, addr, vmf->pte, entry, 0))
-			update_mmu_cache(vma, addr, vmf->pte);
+			update_mmu_cache_range(vmf, vma, addr, vmf->pte, 1);
 	}
 
 	/*
@@ -3039,7 +3039,7 @@ static inline void wp_page_reuse(struct
 	entry = pte_mkyoung(vmf->orig_pte);
 	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 	if (ptep_set_access_flags(vma, vmf->address, vmf->pte, entry, 1))
-		update_mmu_cache(vma, vmf->address, vmf->pte);
+		update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	count_vm_event(PGREUSE);
 }
@@ -3163,7 +3163,7 @@ static vm_fault_t wp_page_copy(struct vm
 		 */
 		BUG_ON(unshare && pte_write(entry));
 		set_pte_at_notify(mm, vmf->address, vmf->pte, entry);
-		update_mmu_cache(vma, vmf->address, vmf->pte);
+		update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
 		if (old_folio) {
 			/*
 			 * Only after switching the pte to the new page may
@@ -4046,7 +4046,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	}
 
 	/* No need to invalidate - it was non-present before */
-	update_mmu_cache(vma, vmf->address, vmf->pte);
+	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
@@ -4170,7 +4170,7 @@ setpte:
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
 
 	/* No need to invalidate - it was non-present before */
-	update_mmu_cache(vma, vmf->address, vmf->pte);
+	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
@@ -4859,7 +4859,7 @@ out_map:
 	if (writable)
 		pte = pte_mkwrite(pte);
 	ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
-	update_mmu_cache(vma, vmf->address, vmf->pte);
+	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	goto out;
 }
@@ -5030,7 +5030,8 @@ static vm_fault_t handle_pte_fault(struc
 	entry = pte_mkyoung(entry);
 	if (ptep_set_access_flags(vmf->vma, vmf->address, vmf->pte, entry,
 				vmf->flags & FAULT_FLAG_WRITE)) {
-		update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
+		update_mmu_cache_range(vmf, vmf->vma, vmf->address,
+				vmf->pte, 1);
 	} else {
 		/* Skip spurious TLB flush for retried page fault */
 		if (vmf->flags & FAULT_FLAG_TRIED)
_

Patches currently in -mm which might be from willy@infradead.org are


