From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-dont-bother-dropping-mmap_sem-for-zero-size-readahead.patch added to -mm
 tree
Date: Wed, 12 Feb 2020 14:26:30 -0800
Message-ID: <20200212222630.FED3w-DxX%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbgBLW0c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 17:26:32 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, josef@toxicpanda.com, minchan@kernel.org, mm-commits@vger.kernel.org, snazy@gmx.de


The patch titled
     Subject: mm/filemap.c: don't bother dropping mmap_sem for zero size readahead
has been added to the -mm tree.  Its filename is
     mm-dont-bother-dropping-mmap_sem-for-zero-size-readahead.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-bother-dropping-mmap_sem-for-zero-size-readahead.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-bother-dropping-mmap_sem-for-zero-size-readahead.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2419,7 +2419,7 @@ static struct file *do_async_mmap_readah
 	pgoff_t offset = vmf->pgoff;
 
 	/* If we don't want any read-ahead, don't bother */
-	if (vmf->vma->vm_flags & VM_RAND_READ)
+	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
 		return fpin;
 	mmap_miss = READ_ONCE(ra->mmap_miss);
 	if (mmap_miss)
_

Patches currently in -mm which might be from jack@suse.cz are

mm-dont-bother-dropping-mmap_sem-for-zero-size-readahead.patch
