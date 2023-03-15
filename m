Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83976C6FD1D
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 20:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbjCOURY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 16:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjCOURX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 16:17:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011A01BAE8
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 13:17:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A2C8B81F1B
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 20:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F93FC433EF;
        Wed, 15 Mar 2023 20:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678911439;
        bh=j+bMDDYx+WmIw2aqhuGGvBzdt/kgJcBFB3NjVdgg4Kc=;
        h=Date:To:From:Subject:From;
        b=Glm9xOMMkw8zNRPa8+itQ/xFXCU2e1S0ewBLwGN5W7gwhkCUMu3YozS6l7CpBHz9B
         9rbNTcO6sCZacOLuZaRSqEP6gIOa+BSX4+NrazmPpfaavHi/qAUnQGfN7ivsmAc+lZ
         0QCLsCHuBoByIsNnIxfH6SEzKl8RcO/RpKY6e26s=
Date:   Wed, 15 Mar 2023 13:17:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch added to mm-unstable branch
Message-Id: <20230315201719.3F93FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: use the proper vma pointer in case 3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch

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
Subject: mm/mmap/vma_merge: use the proper vma pointer in case 3
Date: Thu, 9 Mar 2023 12:12:50 +0100

In case 3 we we use 'next' for everything but vma_pgoff.  So use 'next'
for that as well, instead of 'mid', for consistency.  Then in case 8 we
have to use 'mid' explicitly, which should also make the intent more
obvious.

Adjust the diagram for cases 1-3 in the comment to match the code - we are
using 'next' for case 3 so mark the range with XXXX instead of NNNN.  For
case 2 that's a no-op as the code doesn't touch 'next' or 'mid'.  For case
1 it's now wrong but that will be fixed next.

No functional change.

Link: https://lkml.kernel.org/r/20230309111258.24079-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3
+++ a/mm/mmap.c
@@ -870,11 +870,11 @@ can_vma_merge_after(struct vm_area_struc
  *    mmap, brk or    case 4 below       case 5 below
  *    mremap move:
  *                        AAAA               AAAA
- *                    PPPP    NNNN       PPPPNNNNXXXX
+ *                    PPPP    XXXX       PPPPNNNNXXXX
  *                    might become       might become
  *                    PPPPPPPPPPPP 1 or  PPPPPPPPPPPP 6 or
- *                    PPPPPPPPNNNN 2 or  PPPPPPPPXXXX 7 or
- *                    PPPPNNNNNNNN 3     PPPPXXXXXXXX 8
+ *                    PPPPPPPPXXXX 2 or  PPPPPPPPXXXX 7 or
+ *                    PPPPXXXXXXXX 3     PPPPXXXXXXXX 8
  *
  * It is important for case 8 that the vma NNNN overlapping the
  * region AAAA is never going to extended over XXXX. Instead XXXX must
@@ -991,9 +991,10 @@ struct vm_area_struct *vma_merge(struct
 			vma = next;			/* case 3 */
 			vma_start = addr;
 			vma_end = next->vm_end;
-			vma_pgoff = mid->vm_pgoff;
+			vma_pgoff = next->vm_pgoff;
 			err = 0;
 			if (mid != next) {		/* case 8 */
+				vma_pgoff = mid->vm_pgoff;
 				remove = mid;
 				err = dup_anon_vma(next, mid);
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

