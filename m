Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C44C74A5B
	for <mm-commits@archiver.kernel.org>; Fri, 17 Mar 2023 04:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCQE3d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Mar 2023 00:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCQE3c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2023 00:29:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497D61A483
        for <mm-commits@vger.kernel.org>; Thu, 16 Mar 2023 21:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84E95621A2
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 04:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1671C433D2;
        Fri, 17 Mar 2023 04:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679027369;
        bh=c1sGwmOoKX3zCBca/gGubutvZohFeSx2ZPK2mn+ixI4=;
        h=Date:To:From:Subject:From;
        b=i1MfIpujdIv3erdd0undzBFg7KOcrsIrp5WlvB0Rq8uICpAY7+Ub6KbXREUjcF9a6
         NJjO3HRozerepj+BWSnsynp2OTj7HLaTeUjCRS4m4ozqkibElYNhnPZGkIbNDY0xYf
         t1oA+xsKwBokxWfh52KQ7ZOGXq1wWLJTBWG8z+bY=
Date:   Thu, 16 Mar 2023 21:29:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-set-mid-to-null-if-not-applicable-fix.patch added to mm-unstable branch
Message-Id: <20230317042929.D1671C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-vma_merge-set-mid-to-null-if-not-applicable-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-set-mid-to-null-if-not-applicable-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-set-mid-to-null-if-not-applicable-fix.patch

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
Subject: mm-mmap-vma_merge-set-mid-to-null-if-not-applicable-fix

adjust/add comments as suggested by Lorenzo

Link: https://lkml.kernel.org/r/def43190-53f7-a607-d1b0-b657565f4288@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-mmap-vma_merge-set-mid-to-null-if-not-applicable-fix
+++ a/mm/mmap.c
@@ -861,8 +861,9 @@ can_vma_merge_after(struct vm_area_struc
  *
  * The following mprotect cases have to be considered, where AAAA is
  * the area passed down from mprotect_fixup, never extending beyond one
- * vma, PPPPPP is the prev vma specified, NNNN is a vma that overlaps
- * the area AAAA and XXXXXX the next vma after AAAA:
+ * vma, PPPP is the previous vma, NNNN is a vma that starts at the same
+ * address as AAAA and is of the same or larger span, and XXXX the next
+ * vma after AAAA:
  *
  *     AAAA             AAAA                   AAAA
  *    PPPPPPXXXXXX    PPPPPPXXXXXX       PPPPPPNNNNNN
@@ -933,6 +934,7 @@ struct vm_area_struct *vma_merge(struct
 	else
 		next = mid;
 
+	/* In cases 1 - 4 there's no NNNN vma */
 	if (mid && end <= mid->vm_start)
 		mid = NULL;
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-reduce-page-alloc-free-sanity-checks.patch
mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch
mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch
mm-mmap-vma_merge-initialize-mid-and-next-in-natural-order.patch
mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch
mm-mmap-vma_merge-set-mid-to-null-if-not-applicable-fix.patch
mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch
mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.patch
mm-mremap-simplify-vma-expansion-again.patch

