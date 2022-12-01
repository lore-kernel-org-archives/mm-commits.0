Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35070C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiLAAGo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiLAAEi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:04:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813A990774
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19EE06176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40846C4314B;
        Thu,  1 Dec 2022 00:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852929;
        bh=dfaLJUGPPwYMqQy11MBUG2TkgUo6pl5j4Sv/r/6zQ1s=;
        h=Date:To:From:Subject:From;
        b=jnqWb47b0oxjpbglPmmXA3B7UNbqD7FXF2QXFshhYPKw4CXezY2oatb9UcddJyn6g
         AvVd6/eBgl49OVsoiE34/3+H/tt20/FhTAgN5ienL2MU/5WYz5yL+n3bi7jUldGIc3
         i1sx2/9jFeZXwWarQz5e5y+cS7z0q18XlHV3QVyo=
Date:   Wed, 30 Nov 2022 16:02:08 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings.patch removed from -mm tree
Message-Id: <20221201000209.40846C4314B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rework handling in do_wp_page() based on private vs. shared mappings
has been removed from the -mm tree.  Its filename was
     mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: rework handling in do_wp_page() based on private vs. shared mappings
Date: Wed, 16 Nov 2022 11:26:45 +0100

We want to extent FAULT_FLAG_UNSHARE support to anything mapped into a
COW mapping (pagecache page, zeropage, PFN, ...), not just anonymous pages.
Let's prepare for that by handling shared mappings first such that we can
handle private mappings last.

While at it, use folio-based functions instead of page-based functions
where we touch the code either way.

Link: https://lkml.kernel.org/r/20221116102659.70287-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

--- a/mm/memory.c~mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings
+++ a/mm/memory.c
@@ -3341,7 +3341,7 @@ static vm_fault_t do_wp_page(struct vm_f
 {
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	struct vm_area_struct *vma = vmf->vma;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	if (likely(!unshare)) {
 		if (userfaultfd_pte_wp(vma, *vmf->pte)) {
@@ -3359,13 +3359,12 @@ static vm_fault_t do_wp_page(struct vm_f
 	}
 
 	vmf->page = vm_normal_page(vma, vmf->address, vmf->orig_pte);
-	if (!vmf->page) {
-		if (unlikely(unshare)) {
-			/* No anonymous page -> nothing to do. */
-			pte_unmap_unlock(vmf->pte, vmf->ptl);
-			return 0;
-		}
 
+	/*
+	 * Shared mapping: we are guaranteed to have VM_WRITE and
+	 * FAULT_FLAG_WRITE set at this point.
+	 */
+	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
 		/*
 		 * VM_MIXEDMAP !pfn_valid() case, or VM_SOFTDIRTY clear on a
 		 * VM_PFNMAP VMA.
@@ -3373,20 +3372,19 @@ static vm_fault_t do_wp_page(struct vm_f
 		 * We should not cow pages in a shared writeable mapping.
 		 * Just mark the pages writable and/or call ops->pfn_mkwrite.
 		 */
-		if ((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
-				     (VM_WRITE|VM_SHARED))
+		if (!vmf->page)
 			return wp_pfn_shared(vmf);
-
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		return wp_page_copy(vmf);
+		return wp_page_shared(vmf);
 	}
 
+	if (vmf->page)
+		folio = page_folio(vmf->page);
+
 	/*
-	 * Take out anonymous pages first, anonymous shared vmas are
-	 * not dirty accountable.
+	 * Private mapping: create an exclusive anonymous page copy if reuse
+	 * is impossible. We might miss VM_WRITE for FOLL_FORCE handling.
 	 */
-	folio = page_folio(vmf->page);
-	if (folio_test_anon(folio)) {
+	if (folio && folio_test_anon(folio)) {
 		/*
 		 * If the page is exclusive to this process we must reuse the
 		 * page without further checks.
@@ -3437,19 +3435,17 @@ reuse:
 		/* No anonymous page -> nothing to do. */
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		return 0;
-	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
-					(VM_WRITE|VM_SHARED))) {
-		return wp_page_shared(vmf);
 	}
 copy:
 	/*
 	 * Ok, we need to copy. Oh, well..
 	 */
-	get_page(vmf->page);
+	if (folio)
+		folio_get(folio);
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 #ifdef CONFIG_KSM
-	if (PageKsm(vmf->page))
+	if (folio && folio_test_ksm(folio))
 		count_vm_event(COW_KSM);
 #endif
 	return wp_page_copy(vmf);
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

