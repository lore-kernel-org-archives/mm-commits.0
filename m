Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93554C32774
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbiHVTWL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238752AbiHVTVC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:21:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F0625EB4
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6402B8171F
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EE4C433C1;
        Mon, 22 Aug 2022 19:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196056;
        bh=TGxzE372p0sDZySSr2Hfw26G/U0FAHs/Yr0318F7ptU=;
        h=Date:To:From:Subject:From;
        b=2Iv77XRb3DCb2BkqpY0DIv4f0hN++kzTBftNQItkAiUIo3qQu4vLlqShaOsC6XsJK
         2dVYUOW/m+lj83pwnpSifKGB7PTNrOv4fXWHChyP9eH4YrqB9xzqVsKVUdesB1WDyr
         PDJRhWdZ3VPOZtcqfVdAM8BWDuBzFqlQ1FcA4huM=
Date:   Mon, 22 Aug 2022 12:20:55 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + coredump-remove-vma-linked-list-walk.patch added to mm-unstable branch
Message-Id: <20220822192056.63EE4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: remove vma linked list walk
has been added to the -mm mm-unstable branch.  Its filename is
     coredump-remove-vma-linked-list-walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/coredump-remove-vma-linked-list-walk.patch

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
Subject: coredump: remove vma linked list walk
Date: Mon, 22 Aug 2022 15:06:25 +0000

Use the Maple Tree iterator instead.  This is too complicated for the VMA
iterator to handle, so let's open-code it for now.  If this turns out to
be a common pattern, we can migrate it to common code.

Link: https://lkml.kernel.org/r/20220822150128.1562046-41-Liam.Howlett@oracle.com
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

 fs/coredump.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

--- a/fs/coredump.c~coredump-remove-vma-linked-list-walk
+++ a/fs/coredump.c
@@ -1072,30 +1072,20 @@ whole:
 	return vma->vm_end - vma->vm_start;
 }
 
-static struct vm_area_struct *first_vma(struct task_struct *tsk,
-					struct vm_area_struct *gate_vma)
-{
-	struct vm_area_struct *ret = tsk->mm->mmap;
-
-	if (ret)
-		return ret;
-	return gate_vma;
-}
-
 /*
  * Helper function for iterating across a vma list.  It ensures that the caller
  * will visit `gate_vma' prior to terminating the search.
  */
-static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
+static struct vm_area_struct *coredump_next_vma(struct ma_state *mas,
+				       struct vm_area_struct *vma,
 				       struct vm_area_struct *gate_vma)
 {
-	struct vm_area_struct *ret;
-
-	ret = this_vma->vm_next;
-	if (ret)
-		return ret;
-	if (this_vma == gate_vma)
+	if (gate_vma && (vma == gate_vma))
 		return NULL;
+
+	vma = mas_next(mas, ULONG_MAX);
+	if (vma)
+		return vma;
 	return gate_vma;
 }
 
@@ -1119,9 +1109,10 @@ static void free_vma_snapshot(struct cor
  */
 static bool dump_vma_snapshot(struct coredump_params *cprm)
 {
-	struct vm_area_struct *vma, *gate_vma;
+	struct vm_area_struct *gate_vma, *vma = NULL;
 	struct mm_struct *mm = current->mm;
-	int i;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	int i = 0;
 
 	/*
 	 * Once the stack expansion code is fixed to not change VMA bounds
@@ -1141,8 +1132,7 @@ static bool dump_vma_snapshot(struct cor
 		return false;
 	}
 
-	for (i = 0, vma = first_vma(current, gate_vma); vma != NULL;
-			vma = next_vma(vma, gate_vma), i++) {
+	while ((vma = coredump_next_vma(&mas, vma, gate_vma)) != NULL) {
 		struct core_vma_metadata *m = cprm->vma_meta + i;
 
 		m->start = vma->vm_start;
@@ -1150,10 +1140,10 @@ static bool dump_vma_snapshot(struct cor
 		m->flags = vma->vm_flags;
 		m->dump_size = vma_dump_size(vma, cprm->mm_flags);
 		m->pgoff = vma->vm_pgoff;
-
 		m->file = vma->vm_file;
 		if (m->file)
 			get_file(m->file);
+		i++;
 	}
 
 	mmap_write_unlock(mm);
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

