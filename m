Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 945ECC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbjDFCtC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbjDFCsB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:48:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C996EA25A
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EBBC64259
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A164CC433EF;
        Thu,  6 Apr 2023 02:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749139;
        bh=/5ZgpI6jqrBmv12+K5W93f6ecPHd8TKfhs7GLcmZVTs=;
        h=Date:To:From:Subject:From;
        b=GatrGe2yLp/sklfXyPVl5aoGD1DVdNsW8Psz3nkq/RmRbCFGk51CGRJQfOJ7jJ52V
         15HWCQqVqXNvG4MUZ3akUpu0e6DkkKE2buG8RxdZudLYNFEyXxLZzd0akPag94InOt
         ISEVgTfunGUYYLJdgYC6mY8D/fwtFXRRgSHfxsvA=
Date:   Wed, 05 Apr 2023 19:45:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vernon2gm@gmail.com, vbabka@suse.cz, Liam.Howlett@oracle.com,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-vma_merge-explicitly-assign-res-vma-extend-invariants.patch removed from -mm tree
Message-Id: <20230406024539.A164CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: explicitly assign res, vma, extend invariants
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-explicitly-assign-res-vma-extend-invariants.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/mmap/vma_merge: explicitly assign res, vma, extend invariants
Date: Wed, 22 Mar 2023 20:18:59 +0000

Previously, vma was an uninitialised variable which was only definitely
assigned as a result of the logic covering all possible input cases - for
it to have remained uninitialised, prev would have to be NULL, and next
would _have_ to be mergeable.

The value of res defaults to NULL, so we can neatly eliminate the
assignment to res and vma in the if (prev) block and ensure that both res
and vma are both explicitly assigned, by just setting both to prev.

In addition we add an explanation as to under what circumstances both
might change, and since we absolutely do rely on addr == curr->vm_start
should curr exist, assert that this is the case.

Link: https://lkml.kernel.org/r/83938bed24422cbe5954bbf491341674becfe567.1679516210.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-explicitly-assign-res-vma-extend-invariants
+++ a/mm/mmap.c
@@ -898,7 +898,7 @@ struct vm_area_struct *vma_merge(struct
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	pgoff_t vma_pgoff;
-	struct vm_area_struct *curr, *next, *res = NULL;
+	struct vm_area_struct *curr, *next, *res;
 	struct vm_area_struct *vma, *adjust, *remove, *remove2;
 	int err = -1;
 	bool merge_prev = false;
@@ -926,14 +926,18 @@ struct vm_area_struct *vma_merge(struct
 	else
 		next = NULL;		/* case 5 */
 
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
@@ -944,6 +948,7 @@ struct vm_area_struct *vma_merge(struct
 			vma_prev(vmi);
 		}
 	}
+
 	/* Can we merge the successor? */
 	if (next && mpol_equal(policy, vma_policy(next)) &&
 	    can_vma_merge_before(next, vm_flags,
@@ -984,6 +989,10 @@ struct vm_area_struct *vma_merge(struct
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


