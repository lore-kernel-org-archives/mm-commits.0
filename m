Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D623C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358798AbiEMTUy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381251AbiEMTUw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:20:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEFA2DC4
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54E0062252
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C60C34100;
        Fri, 13 May 2022 19:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469650;
        bh=rQ042qvej3KUiGxpXAD7sjMNEbyfkC2oRltwti7NmZg=;
        h=Date:To:From:Subject:From;
        b=VI8SIkwjBmdT3f9wzNH6qh7qt1OlSFO4qZBou/e8zyEMfm6MBsiDgZn/78yA90+5/
         HvFVUI5hpwgZJpeAKkYBjO8LM2hBvLkqmnt56IZYDLYwMEVCz9zlE6PGGNYIVRPB9J
         P2V42iHBKmKU02wj9HSOzU5GZ6DUIEcGpRWbDHnE=
Date:   Fri, 13 May 2022 12:20:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        m.szyprowski@samsung.com, mike.kravetz@oracle.com,
        kirill@shutemov.name, jglisse@redhat.com, hughd@google.com,
        david@redhat.com, axelrasmussen@google.com, apopple@nvidia.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-check-against-orig_pte-for-finish_fault.patch removed from -mm tree
Message-Id: <20220513192050.A4C60C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: check against orig_pte for finish_fault()
has been removed from the -mm tree.  Its filename was
     mm-check-against-orig_pte-for-finish_fault.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: check against orig_pte for finish_fault()

This patch allows do_fault() to trigger on !pte_none() cases too.  This
prepares for the pte markers to be handled by do_fault() just like none
pte.

To achieve this, instead of unconditionally check against pte_none() in
finish_fault(), we may hit the case that the orig_pte was some pte marker
so what we want to do is to replace the pte marker with some valid pte
entry.  Then if orig_pte was set we'd want to check the current *pte
(under pgtable lock) against orig_pte rather than none pte.

Right now there's no solid way to safely reference orig_pte because when
pmd is not allocated handle_pte_fault() will not initialize orig_pte, so
it's not safe to reference it.

There's another solution proposed before this patch to do pte_clear() for
vmf->orig_pte for pmd==NULL case, however it turns out it'll break arm32
because arm32 could have assumption that pte_t* pointer will always reside
on a real ram32 pgtable, not any kernel stack variable.

To solve this, we add a new flag FAULT_FLAG_ORIG_PTE_VALID, and it'll be
set along with orig_pte when there is valid orig_pte, or it'll be cleared
when orig_pte was not initialized.

It'll be updated every time we call handle_pte_fault(), so e.g.  if a page
fault retry happened it'll be properly updated along with orig_pte.

[1] https://lore.kernel.org/lkml/710c48c9-406d-e4c5-a394-10501b951316@samsung.com/

[akpm@linux-foundation.org: coding-style cleanups]
[peterx@redhat.com: fix crash reported by Marek]
  Link: https://lkml.kernel.org/r/Ylb9rXJyPm8/ao8f@xz-m1.local
Link: https://lkml.kernel.org/r/20220405014836.14077-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    3 +++
 mm/memory.c              |   12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-check-against-orig_pte-for-finish_fault
+++ a/include/linux/mm_types.h
@@ -822,6 +822,8 @@ typedef struct {
  * @FAULT_FLAG_UNSHARE: The fault is an unsharing request to unshare (and mark
  *                      exclusive) a possibly shared anonymous page that is
  *                      mapped R/O.
+ * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
+ *                        We should only access orig_pte if this flag set.
  *
  * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
  * whether we would allow page faults to retry by specifying these two
@@ -858,6 +860,7 @@ enum fault_flag {
 	FAULT_FLAG_INSTRUCTION =	1 << 8,
 	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
 	FAULT_FLAG_UNSHARE =		1 << 10,
+	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
 };
 
 #endif /* _LINUX_MM_TYPES_H */
--- a/mm/memory.c~mm-check-against-orig_pte-for-finish_fault
+++ a/mm/memory.c
@@ -4183,6 +4183,14 @@ void do_set_pte(struct vm_fault *vmf, st
 	set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
 }
 
+static bool vmf_pte_changed(struct vm_fault *vmf)
+{
+	if (vmf->flags & FAULT_FLAG_ORIG_PTE_VALID)
+		return !pte_same(*vmf->pte, vmf->orig_pte);
+
+	return !pte_none(*vmf->pte);
+}
+
 /**
  * finish_fault - finish page fault once we have prepared the page to fault
  *
@@ -4241,7 +4249,7 @@ vm_fault_t finish_fault(struct vm_fault
 				      vmf->address, &vmf->ptl);
 	ret = 0;
 	/* Re-check under ptl */
-	if (likely(pte_none(*vmf->pte)))
+	if (likely(!vmf_pte_changed(vmf)))
 		do_set_pte(vmf, page, vmf->address);
 	else
 		ret = VM_FAULT_NOPAGE;
@@ -4709,6 +4717,7 @@ static vm_fault_t handle_pte_fault(struc
 		 * concurrent faults and from rmap lookups.
 		 */
 		vmf->pte = NULL;
+		vmf->flags &= ~FAULT_FLAG_ORIG_PTE_VALID;
 	} else {
 		/*
 		 * If a huge pmd materialized under us just retry later.  Use
@@ -4732,6 +4741,7 @@ static vm_fault_t handle_pte_fault(struc
 		 */
 		vmf->pte = pte_offset_map(vmf->pmd, vmf->address);
 		vmf->orig_pte = *vmf->pte;
+		vmf->flags |= FAULT_FLAG_ORIG_PTE_VALID;
 
 		/*
 		 * some architectures can have larger ptes than wordsize,
_

Patches currently in -mm which might be from peterx@redhat.com are


