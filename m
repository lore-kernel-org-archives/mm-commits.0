Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86872C7618A
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 20:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjCOURb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 16:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjCOUR1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 16:17:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02E21C59B
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 13:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4091AB81F16
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 20:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AF7C433EF;
        Wed, 15 Mar 2023 20:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678911443;
        bh=twEOJzhNaQmpnKU/z+K+r7CIBEiW6e26ecuwN2/zFWk=;
        h=Date:To:From:Subject:From;
        b=DmLaVctqucBZ0vBuC2IuQiXoq0QDHBOYr43oGr2KZA2O4Q02fOl/GIgaYMKaUMiVK
         7j1G2/qKmVsfXYH88rUu8iXnmEGinG28W639t/yel0+sghYab1ZJigCR0hSfZluDGJ
         dYeCqA46vX1cjSXxdTVVlWEgG4FVkm+FWB1kUVaQ=
Date:   Wed, 15 Mar 2023 13:17:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch added to mm-unstable branch
Message-Id: <20230315201722.F2AF7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: use the proper vma pointer in case 4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch

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
Subject: mm/mmap/vma_merge: use the proper vma pointer in case 4
Date: Thu, 9 Mar 2023 12:12:52 +0100

Almost all cases now use the 'next' pointer for the vma following the
merged area, and the cases diagram shows it as XXXX.  Case 4 is different
as it uses 'mid' and NNNN, so change it for consistency.  No functional
change.

Link: https://lkml.kernel.org/r/20230309111258.24079-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4
+++ a/mm/mmap.c
@@ -864,9 +864,9 @@ can_vma_merge_after(struct vm_area_struc
  * vma, PPPPPP is the prev vma specified, and NNNNNN the next vma after:
  *
  *     AAAA             AAAA                   AAAA
- *    PPPPPPNNNNNN    PPPPPPNNNNNN       PPPPPPNNNNNN
+ *    PPPPPPNNNNNN    PPPPPPXXXXXX       PPPPPPNNNNNN
  *    cannot merge    might become       might become
- *                    PPNNNNNNNNNN       PPPPPPPPPPNN
+ *                    PPXXXXXXXXXX       PPPPPPPPPPNN
  *    mmap, brk or    case 4 below       case 5 below
  *    mremap move:
  *                        AAAA               AAAA
@@ -985,9 +985,9 @@ struct vm_area_struct *vma_merge(struct
 		res = next;
 		if (prev && addr < prev->vm_end) {	/* case 4 */
 			vma_end = addr;
-			adjust = mid;
+			adjust = next;
 			adj_next = -(prev->vm_end - addr);
-			err = dup_anon_vma(mid, prev);
+			err = dup_anon_vma(next, prev);
 		} else {
 			vma = next;			/* case 3 */
 			vma_start = addr;
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

