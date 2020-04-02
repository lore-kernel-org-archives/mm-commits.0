From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 029/155] mm/filemap.c: don't bother dropping
 mmap_sem for zero size readahead
Date: Wed, 01 Apr 2020 21:04:40 -0700
Message-ID: <20200402040440.RCDEWJbKc%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEEl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:04:41 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, josef@toxicpanda.com, linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org, snazy@gmx.de, torvalds@linux-foundation.org

From: Jan Kara <jack@suse.cz>
Subject: mm/filemap.c: don't bother dropping mmap_sem for zero size readahead

When handling a page fault, we drop mmap_sem to start async readahead so
that we don't block on IO submission with mmap_sem held.  However there's
no point to drop mmap_sem in case readahead is disabled.  Handle that case
to avoid pointless dropping of mmap_sem and retrying the fault.  This was
actually reported to block mlockall(MCL_CURRENT) indefinitely.

Link: http://lkml.kernel.org/r/20200212101356.30759-1-jack@suse.cz
Fixes: 6b4c9f446981 ("filemap: drop the mmap_sem for all blocking operations")
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Minchan Kim <minchan@kernel.org>
Reported-by: Robert Stupp <snazy@gmx.de>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-dont-bother-dropping-mmap_sem-for-zero-size-readahead
+++ a/mm/filemap.c
@@ -2416,7 +2416,7 @@ static struct file *do_async_mmap_readah
 	pgoff_t offset = vmf->pgoff;
 
 	/* If we don't want any read-ahead, don't bother */
-	if (vmf->vma->vm_flags & VM_RAND_READ)
+	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
 		return fpin;
 	if (ra->mmap_miss > 0)
 		ra->mmap_miss--;
_
