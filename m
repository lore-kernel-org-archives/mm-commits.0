Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952DDC28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbiHVTYJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238607AbiHVTWH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:22:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06714E621
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A99461240
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19CBC43140;
        Mon, 22 Aug 2022 19:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196092;
        bh=9Rwb1dnn72D0finZa0WtKXmnw1Or2EZLMXWGMQEWTPM=;
        h=Date:To:From:Subject:From;
        b=zKyPNmJfkd8VcW7seesObdjaQ0jyxsDaM40TvKfgv7YyyWdUY+WloD1CYGtBCNb5n
         9XiFZ/alHZHTp94unz3m2MlDDomgWCi/baBtsNviiEnPHvvEQuDfxW7/k7HdFHRY7l
         qtxmz2s0wvOsxuwPA/tSYZVUD2yeSd7mloyjKyfI=
Date:   Mon, 22 Aug 2022 12:21:32 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch added to mm-unstable branch
Message-Id: <20220822192132.D19CBC43140@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: use vma iterator and maple state instead of vma linked list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch

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
Subject: mm/mlock: use vma iterator and maple state instead of vma linked list
Date: Mon, 22 Aug 2022 15:06:30 +0000

Handle overflow checking in count_mm_mlocked_page_nr() differently.

Link: https://lkml.kernel.org/r/20220822150128.1562046-58-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
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

 mm/mlock.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/mm/mlock.c~mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list
+++ a/mm/mlock.c
@@ -471,6 +471,7 @@ static int apply_vma_lock_flags(unsigned
 	unsigned long nstart, end, tmp;
 	struct vm_area_struct *vma, *prev;
 	int error;
+	MA_STATE(mas, &current->mm->mm_mt, start, start);
 
 	VM_BUG_ON(offset_in_page(start));
 	VM_BUG_ON(len != PAGE_ALIGN(len));
@@ -479,13 +480,14 @@ static int apply_vma_lock_flags(unsigned
 		return -EINVAL;
 	if (end == start)
 		return 0;
-	vma = find_vma(current->mm, start);
-	if (!vma || vma->vm_start > start)
+	vma = mas_walk(&mas);
+	if (!vma)
 		return -ENOMEM;
 
-	prev = vma->vm_prev;
 	if (start > vma->vm_start)
 		prev = vma;
+	else
+		prev = mas_prev(&mas, 0);
 
 	for (nstart = start ; ; ) {
 		vm_flags_t newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
@@ -505,7 +507,7 @@ static int apply_vma_lock_flags(unsigned
 		if (nstart >= end)
 			break;
 
-		vma = prev->vm_next;
+		vma = find_vma(prev->vm_mm, prev->vm_end);
 		if (!vma || vma->vm_start != nstart) {
 			error = -ENOMEM;
 			break;
@@ -526,24 +528,23 @@ static unsigned long count_mm_mlocked_pa
 {
 	struct vm_area_struct *vma;
 	unsigned long count = 0;
+	unsigned long end;
+	VMA_ITERATOR(vmi, mm, start);
 
 	if (mm == NULL)
 		mm = current->mm;
 
-	vma = find_vma(mm, start);
-	if (vma == NULL)
-		return 0;
-
-	for (; vma ; vma = vma->vm_next) {
-		if (start >= vma->vm_end)
-			continue;
-		if (start + len <=  vma->vm_start)
-			break;
+	/* Don't overflow past ULONG_MAX */
+	if (unlikely(ULONG_MAX - len < start))
+		end = ULONG_MAX;
+	else
+		end = start + len;
+	for_each_vma_range(vmi, vma, end) {
 		if (vma->vm_flags & VM_LOCKED) {
 			if (start > vma->vm_start)
 				count -= (start - vma->vm_start);
-			if (start + len < vma->vm_end) {
-				count += start + len - vma->vm_start;
+			if (end < vma->vm_end) {
+				count += end - vma->vm_start;
 				break;
 			}
 			count += vma->vm_end - vma->vm_start;
@@ -659,6 +660,7 @@ SYSCALL_DEFINE2(munlock, unsigned long,
  */
 static int apply_mlockall_flags(int flags)
 {
+	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 	struct vm_area_struct *vma, *prev = NULL;
 	vm_flags_t to_add = 0;
 
@@ -679,7 +681,7 @@ static int apply_mlockall_flags(int flag
 			to_add |= VM_LOCKONFAULT;
 	}
 
-	for (vma = current->mm->mmap; vma ; vma = prev->vm_next) {
+	mas_for_each(&mas, vma, ULONG_MAX) {
 		vm_flags_t newflags;
 
 		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
@@ -687,6 +689,7 @@ static int apply_mlockall_flags(int flag
 
 		/* Ignore errors */
 		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
+		mas_pause(&mas);
 		cond_resched();
 	}
 out:
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

