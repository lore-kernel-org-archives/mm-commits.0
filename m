Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3F7C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6483461242
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhKEUis (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhKEUin (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5685F611C0;
        Fri,  5 Nov 2021 20:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144563;
        bh=wkTASAhiipzxDonZhbRjk6v7zkBquZBk9Uduri6FL+Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ss7q6Nfj1FVdCH3Xj99rcQ4c2NVRBN8LeE0X3a0Vu3ttpk/qngLiYDRcXN20GnpRL
         xUnVY+wOUdoO0HP1P0EYgZOnsQLym65WL7q+IEPRNpSk6x2HabFdS/k1snC+FG9rvn
         Fa4S86W741MJJDQ6dvHWBHj8TO1A+hGS4OszvkPE=
Date:   Fri, 05 Nov 2021 13:36:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 028/262] mm/smaps: use vma->vm_pgoff directly when
 counting partial swap
Message-ID: <20211105203602.PAtMTScF1%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/smaps: use vma->vm_pgoff directly when counting partial swap

As it's trying to cover the whole vma anyways, use direct vm_pgoff value
and vma_pages() rather than linear_page_index.

Link: https://lkml.kernel.org/r/20210917164756.8586-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap
+++ a/mm/shmem.c
@@ -856,9 +856,8 @@ unsigned long shmem_swap_usage(struct vm
 		return swapped << PAGE_SHIFT;
 
 	/* Here comes the more involved part */
-	return shmem_partial_swap_usage(mapping,
-			linear_page_index(vma, vma->vm_start),
-			linear_page_index(vma, vma->vm_end));
+	return shmem_partial_swap_usage(mapping, vma->vm_pgoff,
+					vma->vm_pgoff + vma_pages(vma));
 }
 
 /*
_
