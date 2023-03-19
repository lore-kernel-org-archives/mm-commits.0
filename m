Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85A6C76195
	for <mm-commits@archiver.kernel.org>; Sun, 19 Mar 2023 20:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCSUSD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Mar 2023 16:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjCSUR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 19 Mar 2023 16:17:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A681B570
        for <mm-commits@vger.kernel.org>; Sun, 19 Mar 2023 13:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFF6B61189
        for <mm-commits@vger.kernel.org>; Sun, 19 Mar 2023 20:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD97EC433EF;
        Sun, 19 Mar 2023 20:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679257074;
        bh=W7F6ZWHv5cG6X/xpquKOMy47OjppiFbLq514khmJyQs=;
        h=Date:To:From:Subject:From;
        b=Xmg2COYPzf3k2U0AGM8OpBgXnOcuMPwXFXyJ55WRRwMOIvGtq214TOw+WQzCVMITC
         imhovW8kk7IuRfpLUnUa2WxdDeKVPuKu4qoFKr0eR8dbYfFaoOQ5VBKVS4pt42MtdH
         DApVajQBetao56QLqRzSA8XstP+F36GpNDuoaOAo=
Date:   Sun, 19 Mar 2023 13:17:53 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma.patch added to mm-unstable branch
Message-Id: <20230319201753.DD97EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: extend invariants, avoid invalid res, vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/mmap/vma_merge: extend invariants, avoid invalid res, vma
Date: Sat, 18 Mar 2023 11:13:20 +0000

Previously, vma was an uninitialised variable which was only definitely
assigned as a result of the logic covering all possible input cases - for
it to have remained uninitialised, prev would have to be NULL, and next
would _have_ to be mergeable.

We now reuse vma to assign curr and next, so to be absolutely explicit,
ensure this variable is _always_ assigned, and while we're at it remove
the redundant assignment of both res and vma (if prev is NULL then we
simply assign to NULL).

In addition, we absolutely do rely on addr == curr->vm_start should curr
exist, so assert as much.

Link: https://lkml.kernel.org/r/0b7d3e6c770a2bdc2c307ddde268561135ef3395.1679137163.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma
+++ a/mm/mmap.c
@@ -911,7 +911,7 @@ struct vm_area_struct *vma_merge(struct
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	pgoff_t vma_pgoff;
-	struct vm_area_struct *curr, *next, *res = NULL;
+	struct vm_area_struct *curr, *next, *res;
 	struct vm_area_struct *vma, *adjust, *remove, *remove2;
 	int err = -1;
 	bool merge_prev = false;
@@ -978,14 +978,18 @@ struct vm_area_struct *vma_merge(struct
 	else
 		next = NULL;
 
-	/* verify some invariant that must be enforced by the caller */
+	/*
+	 * By default, we return prev. Cases 3, 4, 8 will instead return next
+	 * and cases 3, 8 will also update vma to point at next.
+	 */
+	res = vma = prev;
+
+	/* Verify some invariant that must be enforced by the caller. */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
-	VM_WARN_ON(curr && end > curr->vm_end);
+	VM_WARN_ON(curr && (addr != curr->vm_start || end > curr->vm_end));
 	VM_WARN_ON(addr >= end);
 
 	if (prev) {
-		res = prev;
-		vma = prev;
 		vma_start = prev->vm_start;
 		vma_pgoff = prev->vm_pgoff;
 		/* Can we merge the predecessor? */
@@ -996,6 +1000,7 @@ struct vm_area_struct *vma_merge(struct
 			vma_prev(vmi);
 		}
 	}
+
 	/* Can we merge the successor? */
 	if (next && mpol_equal(policy, vma_policy(next)) &&
 	    can_vma_merge_before(next, vm_flags,
@@ -1036,6 +1041,10 @@ struct vm_area_struct *vma_merge(struct
 			adj_start = -(prev->vm_end - addr);
 			err = dup_anon_vma(next, prev);
 		} else {
+			/*
+			 * Note that cases 3 and 8 are the ONLY ones where prev
+			 * is permitted to be (but is not necessarily) NULL.
+			 */
 			vma = next;			/* case 3 */
 			vma_start = addr;
 			vma_end = next->vm_end;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch
mm-refactor-do_fault_around.patch
mm-pefer-fault_around_pages-to-fault_around_bytes.patch
mm-mmap-vma_merge-further-improve-prev-next-vma-naming.patch
mm-mmap-vma_merge-set-next-to-null-if-not-applicable.patch
mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma.patch
mm-mmap-vma_merge-be-explicit-about-the-non-mergeable-case.patch
fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch
mm-vmalloc-use-rwsem-mutex-for-vmap_area_lock-and-vmap_block-lock.patch
fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch
mm-vmalloc-convert-vread-to-vread_iter.patch

