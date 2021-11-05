Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E2CC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6E2661263
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbhKEUir (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232736AbhKEUik (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DAA061252;
        Fri,  5 Nov 2021 20:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144560;
        bh=POl68rlaiFepkgXhJo1XMNxFC/jPqk7URJQ1Z3yPjBA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XJ4gy82mwUyGEXNia1N/d2ASstsEB0cMZs6tHKBay6Gvw49eIqad8/PAnRZ+Pqks+
         LvbY5IKR/D3H7v1WJB/yKbAKOnABK6+cc5wbB04lyQm+eC0X6bfvkC+5z14L/7WCX7
         j/a2PxB8GTN5d9Juhd7sBMWOxa76ZMM8TtbP4gzw=
Date:   Fri, 05 Nov 2021 13:35:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 027/262] mm/smaps: fix shmem pte hole swap
 calculation
Message-ID: <20211105203559.qOWoE4JSh%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/smaps: fix shmem pte hole swap calculation

Patch series "mm/smaps: Fixes and optimizations on shmem swap handling".


This patch (of 3):

The shmem swap calculation on the privately writable mappings are using
wrong parameters as spotted by Vlastimil.  Fix them.  That's introduced in
commit 48131e03ca4e, when rework shmem_swap_usage to
shmem_partial_swap_usage.

Test program:

==================

void main(void)
{
    char *buffer, *p;
    int i, fd;

    fd = memfd_create("test", 0);
    assert(fd > 0);

    /* isize==2M*3, fill in pages, swap them out */
    ftruncate(fd, SIZE_2M * 3);
    buffer = mmap(NULL, SIZE_2M * 3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    assert(buffer);
    for (i = 0, p = buffer; i < SIZE_2M * 3 / 4096; i++) {
        *p = 1;
        p += 4096;
    }
    madvise(buffer, SIZE_2M * 3, MADV_PAGEOUT);
    munmap(buffer, SIZE_2M * 3);

    /*
     * Remap with private+writtable mappings on partial of the inode (<= 2M*3),
     * while the size must also be >= 2M*2 to make sure there's a none pmd so
     * smaps_pte_hole will be triggered.
     */
    buffer = mmap(NULL, SIZE_2M * 2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
    printf("pid=%d, buffer=%p
", getpid(), buffer);

    /* Check /proc/$PID/smap_rollup, should see 4MB swap */
    sleep(1000000);
}
==================

Before the patch, smaps_rollup shows <4MB swap and the number will be
random depending on the alignment of the buffer of mmap() allocated. 
After this patch, it'll show 4MB.

Link: https://lkml.kernel.org/r/20210917164756.8586-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20210917164756.8586-2-peterx@redhat.com
Fixes: 48131e03ca4e ("mm, proc: reduce cost of /proc/pid/smaps for unpopulated shmem mappings")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~mm-smaps-fix-shmem-pte-hole-swap-calculation
+++ a/fs/proc/task_mmu.c
@@ -478,9 +478,11 @@ static int smaps_pte_hole(unsigned long
 			  __always_unused int depth, struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
+	struct vm_area_struct *vma = walk->vma;
 
-	mss->swap += shmem_partial_swap_usage(
-			walk->vma->vm_file->f_mapping, addr, end);
+	mss->swap += shmem_partial_swap_usage(walk->vma->vm_file->f_mapping,
+					      linear_page_index(vma, addr),
+					      linear_page_index(vma, end));
 
 	return 0;
 }
_
