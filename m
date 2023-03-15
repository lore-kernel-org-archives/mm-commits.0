Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF01C6FD1D
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 20:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbjCOURa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 16:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjCOURZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 16:17:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB7A1C7D3
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 13:17:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89CFBB81F4F
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 20:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D346C433EF;
        Wed, 15 Mar 2023 20:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678911441;
        bh=j8YNfWQHgi5RSRJFQfZV4IcCOnSw9m4XL5q2a2HOKxQ=;
        h=Date:To:From:Subject:From;
        b=ikLZorxg2aebDhzWnQsqTLjT3qzb8MwTaqrkcFxZJuHPiw+kCfOry1Q5JssDhK2mi
         7NsJPXaID6Ttp3B+8B7JnoK8nYuMM5LhZLytUgGeyMSLwmduEpxLDia6rcaKi0HZ48
         2gXZwH3lrvKqc1etLxmxRz10Ci+MXIu98aZPfUeU=
Date:   Wed, 15 Mar 2023 13:17:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch added to mm-unstable branch
Message-Id: <20230315201721.1D346C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: use the proper vma pointers in cases 1 and 6
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch

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
Subject: mm/mmap/vma_merge: use the proper vma pointers in cases 1 and 6
Date: Thu, 9 Mar 2023 12:12:51 +0100

Case 1 is now shown in the comment as next vma being merged with prev, so
use 'next' instead of 'mid'.  In case 1 they both point to the same vma.

As a consequence, in case 6, the dup_anon_vma() is now tried first on
'next' and then on 'mid', before it was the opposite order.  This is not a
functional change, as those two vma's cannnot have a different anon_vma,
as that would have prevented the merging in the first place.

Link: https://lkml.kernel.org/r/20230309111258.24079-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6
+++ a/mm/mmap.c
@@ -618,7 +618,7 @@ again:
 
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
-		 * we must remove the one after next as well.
+		 * we are removing both mid and next vmas
 		 */
 		if (vp->remove2) {
 			vp->remove = vp->remove2;
@@ -961,13 +961,14 @@ struct vm_area_struct *vma_merge(struct
 	/* Can we merge both the predecessor and the successor? */
 	if (merge_prev && merge_next &&
 	    is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL)) {
-		remove = mid;				/* case 1 */
+		remove = next;				/* case 1 */
 		vma_end = next->vm_end;
-		err = dup_anon_vma(prev, mid);
+		err = dup_anon_vma(prev, next);
 		if (mid != next) {			/* case 6 */
+			remove = mid;
 			remove2 = next;
-			if (!mid->anon_vma)
-				err = dup_anon_vma(prev, next);
+			if (!next->anon_vma)
+				err = dup_anon_vma(prev, mid);
 		}
 	} else if (merge_prev) {
 		err = 0;				/* case 2 */
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

