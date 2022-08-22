Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9A7C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237888AbiHVTWb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238110AbiHVTV1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:21:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D9C3DF3B
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:21:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A242CB818A9
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE89C433D7;
        Mon, 22 Aug 2022 19:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196082;
        bh=dBZmVSaZ3zRODAZZ98MenYTLtyxKdmo7u0jd7+jAeHA=;
        h=Date:To:From:Subject:From;
        b=bVqal8/GvOJFsAneyOv6BHWDNPO6gN+aP5QBEdRSPXQ93EAsFCn5WMhxPliKXy0G7
         K4es2JCneKHux0GSodXKCj6flEJFEsprOBr0be5EDV78zJEPdEiirQTrdwqkzfJx41
         fCgBJ0aUIFw8htdcAeDEwGMRiTnwhhCKXT/ND2+w=
Date:   Mon, 22 Aug 2022 12:21:21 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@oracle.com, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-stop-using-vma-linked-list.patch added to mm-unstable branch
Message-Id: <20220822192122.4BE89C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: stop using vma linked list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-stop-using-vma-linked-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-stop-using-vma-linked-list.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/khugepaged: stop using vma linked list
Date: Mon, 22 Aug 2022 15:06:28 +0000

Use vma iterator & find_vma() instead of vma linked list.

Link: https://lkml.kernel.org/r/20220822150128.1562046-53-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 mm/khugepaged.c  |   11 ++++++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-khugepaged-stop-using-vma-linked-list
+++ a/mm/huge_memory.c
@@ -2339,11 +2339,11 @@ void vma_adjust_trans_huge(struct vm_are
 	split_huge_pmd_if_needed(vma, end);
 
 	/*
-	 * If we're also updating the vma->vm_next->vm_start,
+	 * If we're also updating the next vma vm_start,
 	 * check if we need to split it.
 	 */
 	if (adjust_next > 0) {
-		struct vm_area_struct *next = vma->vm_next;
+		struct vm_area_struct *next = find_vma(vma->vm_mm, vma->vm_end);
 		unsigned long nstart = next->vm_start;
 		nstart += adjust_next;
 		split_huge_pmd_if_needed(next, nstart);
--- a/mm/khugepaged.c~mm-khugepaged-stop-using-vma-linked-list
+++ a/mm/khugepaged.c
@@ -2053,10 +2053,12 @@ static unsigned int khugepaged_scan_mm_s
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
 {
+	struct vma_iterator vmi;
 	struct mm_slot *mm_slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	int progress = 0;
+	unsigned long address;
 
 	VM_BUG_ON(!pages);
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -2081,11 +2083,14 @@ static unsigned int khugepaged_scan_mm_s
 	vma = NULL;
 	if (unlikely(!mmap_read_trylock(mm)))
 		goto breakouterloop_mmap_lock;
-	if (likely(!hpage_collapse_test_exit(mm)))
-		vma = find_vma(mm, khugepaged_scan.address);
 
 	progress++;
-	for (; vma; vma = vma->vm_next) {
+	if (unlikely(hpage_collapse_test_exit(mm)))
+		goto breakouterloop;
+
+	address = khugepaged_scan.address;
+	vma_iter_init(&vmi, mm, address);
+	for_each_vma(vmi, vma) {
 		unsigned long hstart, hend;
 
 		cond_resched();
_

Patches currently in -mm which might be from willy@infradead.org are

support-highmem-pages-in-vmap_pages_range_noflush.patch
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

