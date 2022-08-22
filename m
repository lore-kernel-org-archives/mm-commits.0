Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C868C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbiHVTYi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238702AbiHVTWt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:22:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D26F52802
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:21:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48D8AB818AD
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A09C433D6;
        Mon, 22 Aug 2022 19:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196107;
        bh=QpYHbvakq1Disa6WjlI/yhOFWlJm56caQs8Bfm9p56o=;
        h=Date:To:From:Subject:From;
        b=vX9Mr9554u4zRF426ecmC4GDKFRVEFi8Oj5FOHO4z9PfRmBOSYhWSotMASfu47718
         BdZOC371VDTFm484aIC5zg6eH9jQ/SRzTavsn6O5cH2W8d/w+Wa1y9sepB+GL+U11O
         Hu2Dgh4RBvjI2llfBxza+nMvi5+fNjEzDgL7EP1U=
Date:   Mon, 22 Aug 2022 12:21:46 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + i915-use-the-vma-iterator.patch added to mm-unstable branch
Message-Id: <20220822192146.F0A09C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: i915: use the VMA iterator
has been added to the -mm mm-unstable branch.  Its filename is
     i915-use-the-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/i915-use-the-vma-iterator.patch

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
Subject: i915: use the VMA iterator
Date: Mon, 22 Aug 2022 15:06:32 +0000

Replace the linked list in probe_range() with the VMA iterator.

Link: https://lkml.kernel.org/r/20220822150128.1562046-65-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_userptr.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c~i915-use-the-vma-iterator
+++ a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -426,12 +426,11 @@ static const struct drm_i915_gem_object_
 static int
 probe_range(struct mm_struct *mm, unsigned long addr, unsigned long len)
 {
-	const unsigned long end = addr + len;
+	VMA_ITERATOR(vmi, mm, addr);
 	struct vm_area_struct *vma;
-	int ret = -EFAULT;
 
 	mmap_read_lock(mm);
-	for (vma = find_vma(mm, addr); vma; vma = vma->vm_next) {
+	for_each_vma_range(vmi, vma, addr + len) {
 		/* Check for holes, note that we also update the addr below */
 		if (vma->vm_start > addr)
 			break;
@@ -439,16 +438,13 @@ probe_range(struct mm_struct *mm, unsign
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 			break;
 
-		if (vma->vm_end >= end) {
-			ret = 0;
-			break;
-		}
-
 		addr = vma->vm_end;
 	}
 	mmap_read_unlock(mm);
 
-	return ret;
+	if (vma)
+		return -EFAULT;
+	return 0;
 }
 
 /*
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

