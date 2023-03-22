Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD48C6FD1C
	for <mm-commits@archiver.kernel.org>; Wed, 22 Mar 2023 22:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjCVWsN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 18:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjCVWsL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 18:48:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB11CDDE
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 15:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5A78B81D36
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 22:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C72C433EF;
        Wed, 22 Mar 2023 22:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679525280;
        bh=7N3xWaSSbx4adxgA317r48hBtQ465SbSaHdscl4tIgI=;
        h=Date:To:From:Subject:From;
        b=1749AYBQSaxeu8vWo5m1dmzXmgTbIzB3DgXBW0KJmIyogYNZ0n7vHDudcfTp0jJhm
         HQyjYji6zwZ3dlMtegeYAciWKsNwDnNQvHYyCjgsW7OKDk9VBDPYiCR6JQywLTQfqB
         Dxn5NOshlvQQp0boA/9PGqFOgU5aX+rfyKqfX/iY=
Date:   Wed, 22 Mar 2023 15:48:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vernon2gm@gmail.com, vbabka@suse.cz, Liam.Howlett@oracle.com,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-fold-curr-next-assignment-logic.patch added to mm-unstable branch
Message-Id: <20230322224800.A4C72C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: fold curr, next assignment logic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-fold-curr-next-assignment-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-fold-curr-next-assignment-logic.patch

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
Subject: mm/mmap/vma_merge: fold curr, next assignment logic
Date: Wed, 22 Mar 2023 20:18:58 +0000

Use find_vma_intersection() and vma_lookup() to both simplify the logic
and to fold the end == next->vm_start condition into one block.

This groups all of the simple range checks together and establishes the
invariant that, if prev, curr or next are non-NULL then their positions
are as expected.

This has no functional impact.

Link: https://lkml.kernel.org/r/c6d960641b4ba58fa6ad3d07bf68c27d847963c8.1679516210.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-mmap-vma_merge-fold-curr-next-assignment-logic
+++ a/mm/mmap.c
@@ -930,15 +930,14 @@ struct vm_area_struct *vma_merge(struct
 	if (vm_flags & VM_SPECIAL)
 		return NULL;
 
-	curr = find_vma(mm, prev ? prev->vm_end : 0);
-	if (curr && curr->vm_end == end)		/* cases 6, 7, 8 */
-		next = find_vma(mm, curr->vm_end);
-	else
-		next = curr;
+	/* Does the input range span an existing VMA? (cases 5 - 8) */
+	curr = find_vma_intersection(mm, prev ? prev->vm_end : 0, end);
 
-	/* In cases 1 - 4 there's no CCCC vma */
-	if (curr && end <= curr->vm_start)
-		curr = NULL;
+	if (!curr ||			/* cases 1 - 4 */
+	    end == curr->vm_end)	/* cases 6 - 8, adjacent VMA */
+		next = vma_lookup(mm, end);
+	else
+		next = NULL;		/* case 5 */
 
 	/* verify some invariant that must be enforced by the caller */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
@@ -959,11 +958,10 @@ struct vm_area_struct *vma_merge(struct
 		}
 	}
 	/* Can we merge the successor? */
-	if (next && end == next->vm_start &&
-			mpol_equal(policy, vma_policy(next)) &&
-			can_vma_merge_before(next, vm_flags,
-					     anon_vma, file, pgoff+pglen,
-					     vm_userfaultfd_ctx, anon_name)) {
+	if (next && mpol_equal(policy, vma_policy(next)) &&
+	    can_vma_merge_before(next, vm_flags,
+				 anon_vma, file, pgoff+pglen,
+				 vm_userfaultfd_ctx, anon_name)) {
 		merge_next = true;
 	}
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch
mm-refactor-do_fault_around.patch
mm-pefer-fault_around_pages-to-fault_around_bytes.patch
maintainers-add-myself-as-vmalloc-reviewer.patch
mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch
fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch
iov_iter-add-copy_page_to_iter_atomic.patch
mm-vmalloc-convert-vread-to-vread_iter.patch
mm-mmap-vma_merge-further-improve-prev-next-vma-naming.patch
mm-mmap-vma_merge-fold-curr-next-assignment-logic.patch
mm-mmap-vma_merge-explicitly-assign-res-vma-extend-invariants.patch
mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case.patch

