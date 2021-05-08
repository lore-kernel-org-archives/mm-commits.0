Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9963C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5F4561421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEHWu6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWu5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 881AA6100C;
        Sat,  8 May 2021 22:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514195;
        bh=GCY0OXRXV/lUJoHXVHI4yyAPycXcnCBm1y4xTVQ7BAY=;
        h=Date:From:To:Subject:From;
        b=v+OWnKBSBX8TcmLzS+sSG/WGoN6Nf/8mv9p6CinLx/anXdQne+nEShfBLsJF+jXS/
         EJTs1GMXFtlDUnFBtNlZOuaJp9gOdWIuH2L5bTPeMGdbvDIZOVa+AmyKfjAw4HXPS5
         7F7ZjdEdWIDpAzl209ThQRtbHbLx2+K+FGL/2Snw=
Date:   Sat, 08 May 2021 15:49:55 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, hughd@google.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-mmap-dont-unlock-vmas-in-remap_file_pages.patch removed from -mm tree
Message-ID: <20210508224955.Q0VNPALCs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: don't unlock VMAs in remap_file_pages()
has been removed from the -mm tree.  Its filename was
     mm-mmap-dont-unlock-vmas-in-remap_file_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from liam.howlett@oracle.com are


