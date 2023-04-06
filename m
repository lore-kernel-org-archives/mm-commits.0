Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0D9C77B76
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbjDFCgi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbjDFCfX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:35:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021415BA0
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 917C864217
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55C8C433EF;
        Thu,  6 Apr 2023 02:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748522;
        bh=hzKjYOqg2/MwC2RBwXGVoHUcMqUFh62WtQ3BkLy/4nk=;
        h=Date:To:From:Subject:From;
        b=vymzM3mhJ2QKeZRajZE9q1iG32bAkcNdxuJ0ssO+nwUmHLldLQdV9qDVGgn09R2Bi
         7X06Lt3l+nRhARf0wqHkCMtHaYJMlFefrNHD6zagkFWyJxAvks26Mf3071WG8XsjhH
         FGE171S43aMQDJmfFJAmILBsDUqmx3z8A8PLB4jA=
Date:   Wed, 05 Apr 2023 19:35:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mmap-vma_merge-set-mid-to-null-if-not-applicable-fix.patch removed from -mm tree
Message-Id: <20230406023521.E55C8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-mmap-vma_merge-set-mid-to-null-if-not-applicable-fix
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-set-mid-to-null-if-not-applicable-fix.patch

This patch was dropped because it was folded into mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-mmap-vma_merge-set-mid-to-null-if-not-applicable-fix

adjust/add comments as suggested by Lorenzo

Link: https://lkml.kernel.org/r/def43190-53f7-a607-d1b0-b657565f4288@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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

mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch
mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch
mm-mmap-vma_merge-initialize-mid-and-next-in-natural-order.patch
mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch
mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch
mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test-fix.patch
mm-mremap-simplify-vma-expansion-again.patch
mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch

