Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CC4C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0A3D60E52
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhISXGh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhISXGg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:06:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5386261107;
        Sun, 19 Sep 2021 23:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632092710;
        bh=QgDgUG5mxnLqXREZByMZti+vYh4bXdVj5OVBlsmpG+U=;
        h=Date:From:To:Subject:From;
        b=yjAuy3PYBQAXl3dJQEHCHs7zRluRVXM95PdjQ/qFdCZ7WBjlx8oWrVdEZlkENCljR
         26N16cyyjALLXgdt9cZeB7JTFgh9gczjjbTqKTbCR2NLWN7WoeB6u02bZWUyFE0wsF
         lvidKCqre49OgLjmMUo3uGi7AIEJZI/V1YNuo+ao=
Date:   Sun, 19 Sep 2021 16:05:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        hughd@google.com, aarcange@redhat.com, peterx@redhat.com
Subject:  + mm-smaps-fix-shmem-pte-hole-swap-calculation.patch added
 to -mm tree
Message-ID: <20210919230509.MtjPn%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/smaps: fix shmem pte hole swap calculation
has been added to the -mm tree.  Its filename is
     mm-smaps-fix-shmem-pte-hole-swap-calculation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-smaps-fix-shmem-pte-hole-swap-calculation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-smaps-fix-shmem-pte-hole-swap-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-smaps-fix-shmem-pte-hole-swap-calculation.patch
mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap.patch
mm-smaps-simplify-shmem-handling-of-pte-holes.patch
mm-shmem-unconditionally-set-pte-dirty-in-mfill_atomic_install_pte.patch
mm-clear-vmf-pte-after-pte_unmap_same-returns.patch
mm-drop-first_index-last_index-in-zap_details.patch
mm-add-zap_skip_check_mapping-helper.patch

