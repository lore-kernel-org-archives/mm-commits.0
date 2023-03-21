Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1305C6FD20
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 21:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjCUVMa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 17:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjCUVM3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 17:12:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8271857D2A
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED39DB81907
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A3AC433EF;
        Tue, 21 Mar 2023 21:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679433123;
        bh=dAuJpJhNJZ8ywyirlopAscxhcschkijyGQ9ZlYx+r5U=;
        h=Date:To:From:Subject:From;
        b=0lipKgvJMumhcmMsuTcBkUtb22tgs6dG3+PC7pNnzCE+aE9qU4sRvfxvI3Ddi5lQz
         p2dfaw3zCPyU71Pdcb2NSaG26Shd+cs+4+TxcmNblVzp8nfAIJL/M6uqo5L9bh8GSF
         rK87P7DO4QkQupTjdKROnxQuTOAMBB7MDZYAEAQk=
Date:   Tue, 21 Mar 2023 14:12:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vernon2gm@gmail.com, vbabka@suse.cz, liam.howlett@oracle.com,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-set-next-to-null-if-not-applicable.patch added to mm-unstable branch
Message-Id: <20230321211203.93A3AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: set next to NULL if not applicable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-set-next-to-null-if-not-applicable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-set-next-to-null-if-not-applicable.patch

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
Subject: mm/mmap/vma_merge: set next to NULL if not applicable
Date: Tue, 21 Mar 2023 20:45:56 +0000

We are only interested in next if end == next->vm_start (in which case we
check to see if we can set merge_next), so perform this check alongside
checking whether curr should be set.

This groups all of the simple range checks together and establishes the
invariant that, if prev, curr or next are non-NULL then their positions
are as expected.

This has no functional impact.

Link: https://lkml.kernel.org/r/3506997a8146a287ec13ee7a53cf916707537bf8.1679431180.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-set-next-to-null-if-not-applicable
+++ a/mm/mmap.c
@@ -930,15 +930,15 @@ struct vm_area_struct *vma_merge(struct
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
+	if (curr && end == curr->vm_end)
+		/* Is there is a VMA immediately adjacent (cases 6 - 8)? */
+		next = vma_lookup(mm, curr->vm_end);
+	else if (!curr)
+		/* Is there a VMA next to a hole (case 1 - 3) or prev (4)? */
+		next = vma_lookup(mm, end);
 
 	/* verify some invariant that must be enforced by the caller */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
@@ -959,11 +959,10 @@ struct vm_area_struct *vma_merge(struct
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
fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch
mm-vmalloc-use-rwsem-mutex-for-vmap_area_lock-and-vmap_block-lock.patch
fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch
mm-vmalloc-convert-vread-to-vread_iter.patch
maintainers-add-myself-as-vmalloc-reviewer.patch
mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
mm-mmap-vma_merge-further-improve-prev-next-vma-naming.patch
mm-mmap-vma_merge-set-next-to-null-if-not-applicable.patch
mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma.patch
mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case.patch

