Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9305C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbiHVTWP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238751AbiHVTVC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:21:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590081EAD5
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8E58611EF
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABA2C433D6;
        Mon, 22 Aug 2022 19:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196050;
        bh=99kUfOeqDX+Jiodp7Liu4FACDYYPkS+DxP0H1WbC1Tc=;
        h=Date:To:From:Subject:From;
        b=Up1sD/W3CQiXsPZ38Mnc6EZ+sKJrGsfD9igQDYpoyhe6QYQ1DIL3Kr2lvy4OBhYPD
         +oU0oIcVuISxvROleWf8jdyDFz6DmFaZbCBoI0Wo7qc0iwKONKEudXcmWpSPIJ7Zqr
         uygz5aii/Tthm7cg9cypWP0vMyzfzLhZM9BDWH+g=
Date:   Mon, 22 Aug 2022 12:20:49 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cxl-remove-vma-linked-list-walk.patch added to mm-unstable branch
Message-Id: <20220822192050.4ABA2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cxl: remove vma linked list walk
has been added to the -mm mm-unstable branch.  Its filename is
     cxl-remove-vma-linked-list-walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cxl-remove-vma-linked-list-walk.patch

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
Subject: cxl: remove vma linked list walk
Date: Mon, 22 Aug 2022 15:06:24 +0000

Use the VMA iterator instead.  This requires a little restructuring of the
surrounding code to hoist the mm to the caller.  That turns
cxl_prefault_one() into a trivial function, so call cxl_fault_segment()
directly.

Link: https://lkml.kernel.org/r/20220822150128.1562046-38-Liam.Howlett@oracle.com
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

 drivers/misc/cxl/fault.c |   45 ++++++++++++-------------------------
 1 file changed, 15 insertions(+), 30 deletions(-)

--- a/drivers/misc/cxl/fault.c~cxl-remove-vma-linked-list-walk
+++ a/drivers/misc/cxl/fault.c
@@ -280,22 +280,6 @@ void cxl_handle_fault(struct work_struct
 		mmput(mm);
 }
 
-static void cxl_prefault_one(struct cxl_context *ctx, u64 ea)
-{
-	struct mm_struct *mm;
-
-	mm = get_mem_context(ctx);
-	if (mm == NULL) {
-		pr_devel("cxl_prefault_one unable to get mm %i\n",
-			 pid_nr(ctx->pid));
-		return;
-	}
-
-	cxl_fault_segment(ctx, mm, ea);
-
-	mmput(mm);
-}
-
 static u64 next_segment(u64 ea, u64 vsid)
 {
 	if (vsid & SLB_VSID_B_1T)
@@ -306,23 +290,16 @@ static u64 next_segment(u64 ea, u64 vsid
 	return ea + 1;
 }
 
-static void cxl_prefault_vma(struct cxl_context *ctx)
+static void cxl_prefault_vma(struct cxl_context *ctx, struct mm_struct *mm)
 {
 	u64 ea, last_esid = 0;
 	struct copro_slb slb;
+	VMA_ITERATOR(vmi, mm, 0);
 	struct vm_area_struct *vma;
 	int rc;
-	struct mm_struct *mm;
-
-	mm = get_mem_context(ctx);
-	if (mm == NULL) {
-		pr_devel("cxl_prefault_vm unable to get mm %i\n",
-			 pid_nr(ctx->pid));
-		return;
-	}
 
 	mmap_read_lock(mm);
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+	for_each_vma(vmi, vma) {
 		for (ea = vma->vm_start; ea < vma->vm_end;
 				ea = next_segment(ea, slb.vsid)) {
 			rc = copro_calculate_slb(mm, ea, &slb);
@@ -337,20 +314,28 @@ static void cxl_prefault_vma(struct cxl_
 		}
 	}
 	mmap_read_unlock(mm);
-
-	mmput(mm);
 }
 
 void cxl_prefault(struct cxl_context *ctx, u64 wed)
 {
+	struct mm_struct *mm = get_mem_context(ctx);
+
+	if (mm == NULL) {
+		pr_devel("cxl_prefault unable to get mm %i\n",
+			 pid_nr(ctx->pid));
+		return;
+	}
+
 	switch (ctx->afu->prefault_mode) {
 	case CXL_PREFAULT_WED:
-		cxl_prefault_one(ctx, wed);
+		cxl_fault_segment(ctx, mm, wed);
 		break;
 	case CXL_PREFAULT_ALL:
-		cxl_prefault_vma(ctx);
+		cxl_prefault_vma(ctx, mm);
 		break;
 	default:
 		break;
 	}
+
+	mmput(mm);
 }
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

