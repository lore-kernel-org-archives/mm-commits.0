Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7C4C43461
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F9C361421
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhEEBjD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhEEBjC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA53261029;
        Wed,  5 May 2021 01:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178687;
        bh=FzK/MsFcenfF5vrhlbhCv5kC0CfOqe/6rgPo9J3LFag=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=STSOBTDy72HVH3TcHyLCJg8E3Z9NV7kBWdAvzkxnWcjSSbK07fxCupMq4t8wF8Gnb
         J3Nv4GG0DiW/+Qnlgk21HFJBrmqVx0tvDBumKNz+Yl5MLz4gUkhTTw7hWqTNMN9mcp
         9twg6pmunCBOICBSxEHcP+eKoazekovbfcMdQSpM=
Date:   Tue, 04 May 2021 18:38:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, hughd@google.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 101/143] mm/mmap.c: don't unlock VMAs in
 remap_file_pages()
Message-ID: <20210505013806.k_t9jKakt%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap.c: don't unlock VMAs in remap_file_pages()

Since this call uses MAP_FIXED, do_mmap() will munlock the necessary
range.  There is also an error in the loop test expression which will
evaluate as false and the loop body has never execute.

Link: https://lkml.kernel.org/r/20210223235010.2296915-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

--- a/mm/mmap.c~mm-mmap-dont-unlock-vmas-in-remap_file_pages
+++ a/mm/mmap.c
@@ -3029,25 +3029,9 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 
 	flags &= MAP_NONBLOCK;
 	flags |= MAP_SHARED | MAP_FIXED | MAP_POPULATE;
-	if (vma->vm_flags & VM_LOCKED) {
-		struct vm_area_struct *tmp;
+	if (vma->vm_flags & VM_LOCKED)
 		flags |= MAP_LOCKED;
 
-		/* drop PG_Mlocked flag for over-mapped range */
-		for (tmp = vma; tmp->vm_start >= start + size;
-				tmp = tmp->vm_next) {
-			/*
-			 * Split pmd and munlock page on the border
-			 * of the range.
-			 */
-			vma_adjust_trans_huge(tmp, start, start + size, 0);
-
-			munlock_vma_pages_range(tmp,
-					max(tmp->vm_start, start),
-					min(tmp->vm_end, start + size));
-		}
-	}
-
 	file = get_file(vma->vm_file);
 	ret = do_mmap(vma->vm_file, start, size,
 			prot, flags, pgoff, &populate, NULL);
_
