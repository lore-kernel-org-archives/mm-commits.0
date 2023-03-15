Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B467C61DA4
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 20:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjCOURV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 16:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjCOURU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 16:17:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5691BAE8
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 13:17:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15BE16187A
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 20:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699ACC433EF;
        Wed, 15 Mar 2023 20:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678911437;
        bh=sQ1Yv/tlXAR954a8zX51E12Qz5Wp0/tQjaOkD2fnVbk=;
        h=Date:To:From:Subject:From;
        b=SEZsKM7/AEGQZ1xTYU8EbFI4x2qTViLbiQvh5dHzCJuRaI2OttQVQLW8YUysU7Akw
         EifxAFLTnhpRmXXnzfB/1v/Put/SYGBSEAK49b7TGu/4NliOFJPLxLAZPPUJaKhK1p
         n2J49Ec1J78fPLBhBBwlsIf3/EhMb2Q1XdNA9tUk=
Date:   Wed, 15 Mar 2023 13:17:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch added to mm-unstable branch
Message-Id: <20230315201717.699ACC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: use only primary pointers for preparing merge
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mmap/vma_merge: use only primary pointers for preparing merge
Date: Thu, 9 Mar 2023 12:12:49 +0100

Patch series "cleanup vma_merge() and improve mergeability tests".

My initial goal here was to try making the check for vm_ops->close in
is_mergeable_vma() only be applied for vma's that would be truly removed
as part of the merge (see Patch 9).  This would then allow reverting the
quick fix d014cd7c1c35 ("mm, mremap: fix mremap() expanding for vma's with
vm_ops->close()").  This was successful enough to allow the revert (Patch
10).  Checks using can_vma_merge_before() are still pessimistic about
possible vma removal, and making them precise would probably complicate
the vma_merge() code too much.

Liam's 6.3-rc1 simplification of vma_merge() and removal of __vma_adjust()
was very much helpful in understanding the vma_merge() implementation and
especially when vma removals can happen, which is now very obvious.  While
studing the code, I've found ways to make it hopefully even more easy to
follow, so that's the patches 1-8.  That made me also notice a bug that's
now already fixed in 6.3-rc1.


This patch (of 10):

In the merging preparation part of vma_merge(), some vma pointer variables
are assigned for later execution of the merge, but also read from in the
block itself.  The code is easier follow and check against the cases
diagram in the comment if the code reads only from the "primary" vma
variables prev, mid, next instead.  No functional change.

Link: https://lkml.kernel.org/r/20230309111258.24079-1-vbabka@suse.cz
Link: https://lkml.kernel.org/r/20230309111258.24079-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>]
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge
+++ a/mm/mmap.c
@@ -963,16 +963,16 @@ struct vm_area_struct *vma_merge(struct
 	    is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL)) {
 		remove = mid;				/* case 1 */
 		vma_end = next->vm_end;
-		err = dup_anon_vma(res, remove);
+		err = dup_anon_vma(prev, mid);
 		if (mid != next) {			/* case 6 */
 			remove2 = next;
-			if (!remove->anon_vma)
-				err = dup_anon_vma(res, remove2);
+			if (!mid->anon_vma)
+				err = dup_anon_vma(prev, next);
 		}
 	} else if (merge_prev) {
 		err = 0;				/* case 2 */
 		if (mid && end > mid->vm_start) {
-			err = dup_anon_vma(res, mid);
+			err = dup_anon_vma(prev, mid);
 			if (end == mid->vm_end) {	/* case 7 */
 				remove = mid;
 			} else {			/* case 5 */
@@ -985,8 +985,8 @@ struct vm_area_struct *vma_merge(struct
 		if (prev && addr < prev->vm_end) {	/* case 4 */
 			vma_end = addr;
 			adjust = mid;
-			adj_next = -(vma->vm_end - addr);
-			err = dup_anon_vma(adjust, prev);
+			adj_next = -(prev->vm_end - addr);
+			err = dup_anon_vma(mid, prev);
 		} else {
 			vma = next;			/* case 3 */
 			vma_start = addr;
@@ -995,7 +995,7 @@ struct vm_area_struct *vma_merge(struct
 			err = 0;
 			if (mid != next) {		/* case 8 */
 				remove = mid;
-				err = dup_anon_vma(res, remove);
+				err = dup_anon_vma(next, mid);
 			}
 		}
 	}
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-reduce-page-alloc-free-sanity-checks.patch
mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch
mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch
mm-mmap-vma_merge-initialize-mid-and-next-in-natural-order.patch
mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch
mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch
mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch
mm-mremap-simplify-vma-expansion-again.patch

