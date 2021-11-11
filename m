Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400FDC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 296D261354
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhKKCnW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:43:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233906AbhKKCnW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:43:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF06761260;
        Thu, 11 Nov 2021 02:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598434;
        bh=q2QdgoImOuBBhB8WJKwgUzYw1pJ0rDFL6DcwiN9OobY=;
        h=Date:From:To:Subject:From;
        b=jHz+wtRfYHZ19DpK9URXGK5+yanWwQH8jZZQF81Pz2fMzJWkeSQsDW8fLyOANavvU
         xXrP+1gL8sf32nSq1TgSHwriG7Uak3IPrmkUeBBo1ULOinunfbmfm8ADJu1F/Ruran
         2ahpilB3RrhbfBHfI8jJtS/OPiSxM6uMFJAjj9Iw=
Date:   Wed, 10 Nov 2021 18:40:33 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, vbabka@suse.cz, willy@infradead.org
Subject:  [merged]
 mm-smaps-fix-shmem-pte-hole-swap-calculation.patch removed from -mm tree
Message-ID: <20211111024033.KGD3B7DtH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/smaps: fix shmem pte hole swap calculation
has been removed from the -mm tree.  Its filename was
     mm-smaps-fix-shmem-pte-hole-swap-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from peterx@redhat.com are


