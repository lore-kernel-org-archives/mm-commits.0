Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA048C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383622AbiEMTVf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383801AbiEMTVG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85674266D
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18F4762256
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C63C34100;
        Fri, 13 May 2022 19:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469664;
        bh=ugDpLIji6Mx8h4sdKEHbT/fBUE9ydivfvE0/1PzPHm8=;
        h=Date:To:From:Subject:From;
        b=D6r/8/AjxD59t87EzQ2Gff8Pfej/mhzTFYHeAqwOI45oAa81lrtpKe/TYDJRYgtYR
         QlN+6bk/Vre8Z7p5K6GprK1PHoasmw2lwL+GuJi05rSi66s6JOMVvbcZHIuWKJ1Hzh
         u+bi1NE+o9h35KjaFBjgtHQ6wNFhmxzEopvh1HNA=
Date:   Fri, 13 May 2022 12:21:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-handle-pte-markers-in-page-faults.patch removed from -mm tree
Message-Id: <20220513192104.70C63C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: handle pte markers in page faults
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-handle-pte-markers-in-page-faults.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: handle pte markers in page faults

Allow hugetlb code to handle pte markers just like none ptes.  It's mostly
there, we just need to make sure we don't assume hugetlb_no_page() only
handles none pte, so when detecting pte change we should use pte_same()
rather than pte_none().  We need to pass in the old_pte to do the
comparison.

Check the original pte to see whether it's a pte marker, if it is, we
should recover uffd-wp bit on the new pte to be installed, so that the
next write will be trapped by uffd.

Link: https://lkml.kernel.org/r/20220405014909.14761-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
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

 mm/hugetlb.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-handle-pte-markers-in-page-faults
+++ a/mm/hugetlb.c
@@ -5438,7 +5438,8 @@ static inline vm_fault_t hugetlb_handle_
 static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 			struct vm_area_struct *vma,
 			struct address_space *mapping, pgoff_t idx,
-			unsigned long address, pte_t *ptep, unsigned int flags)
+			unsigned long address, pte_t *ptep,
+			pte_t old_pte, unsigned int flags)
 {
 	struct hstate *h = hstate_vma(vma);
 	vm_fault_t ret = VM_FAULT_SIGBUS;
@@ -5565,7 +5566,8 @@ retry:
 
 	ptl = huge_pte_lock(h, mm, ptep);
 	ret = 0;
-	if (!huge_pte_none(huge_ptep_get(ptep)))
+	/* If pte changed from under us, retry */
+	if (!pte_same(huge_ptep_get(ptep), old_pte))
 		goto backout;
 
 	if (anon_rmap) {
@@ -5575,6 +5577,12 @@ retry:
 		page_dup_file_rmap(page, true);
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
+	/*
+	 * If this pte was previously wr-protected, keep it wr-protected even
+	 * if populated.
+	 */
+	if (unlikely(pte_marker_uffd_wp(old_pte)))
+		new_pte = huge_pte_wrprotect(huge_pte_mkuffd_wp(new_pte));
 	set_huge_pte_at(mm, haddr, ptep, new_pte);
 
 	hugetlb_count_add(pages_per_huge_page(h), mm);
@@ -5692,8 +5700,10 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	entry = huge_ptep_get(ptep);
-	if (huge_pte_none(entry)) {
-		ret = hugetlb_no_page(mm, vma, mapping, idx, address, ptep, flags);
+	/* PTE markers should be handled the same way as none pte */
+	if (huge_pte_none_mostly(entry)) {
+		ret = hugetlb_no_page(mm, vma, mapping, idx, address, ptep,
+				      entry, flags);
 		goto out_mutex;
 	}
 
_

Patches currently in -mm which might be from peterx@redhat.com are


