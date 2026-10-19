Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584952DEA6B;
	Mon, 19 Oct 2026 01:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373936; cv=none; b=I+YBg7N48+yt6LmJIO7Ti3T+4G0zOd6XYBDgKJ+NN4rZXv70bCHrJdGHOigh+gkSwmTPaPwFtjGPKKXDEJpbD6gzN7AxdLUnkQR+t+8cLXAAgAFnTG2kwCRVrDtGldEGcMncTBzmSpqloVnXZ8W9w7JBRXo1X0QZ9LfeZXTIBWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373936; c=relaxed/simple;
	bh=e1A+S82QDWTAONRPnjLEEPItojIP/m4xIXWYdR+ClCM=;
	h=Date:To:From:Subject:Message-Id; b=ouFVV6HUNUZqhEPQj7D4T7eexhRghV12Cz8SuKtDRjaqYfvXr3k3DXSd9h1SK/EA7GMCCexx1B2yy4iqvnLQq9I73WBpsaTyz4stZ/BFVb9CNGtj3Jbn2b04KMEWbrpUqTawnd0sNJVjDEClg3d9LaXVjgzArdZ0Iew/jxawU3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IzkLSvDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IzkLSvDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8B41F000C4;
	Mon, 19 Oct 2026 01:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792373935;
	bh=ENtIP8oiro/3pxgYH2xp772XXdBOuCHVL14pAG7wNC4=;
	h=Date:To:From:Subject;
	b=IzkLSvDB/p6eul17qhzHqDZeBW9M5WnjWygyRa3buCG+HEKyjAiet3MQhzk14jUG+
	 j9hKDu/ABgQtVhPA8O12t21IhczhGZtT8yPKnDpU3sPV4RTbHfr8wBbxlQoq+cgHL4
	 JJq2uoVGzaodO3Y5xSdOtjFSn0JYod1suyErnLbI=
Date: Sun, 18 Oct 2026 18:38:54 -0700
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,stable@vger.kernel.org,l1za0.sec@gmail.com,kbusch@kernel.org,hch@lst.de,axboe@kernel.dk,4ncienth@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bio-iov-iter-rollback.patch added to mm-hotfixes-unstable branch
Message-Id: <20261019013854.EA8B41F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: block: restore the iterator when rejecting a misaligned bio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     bio-iov-iter-rollback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bio-iov-iter-rollback.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: block: restore the iterator when rejecting a misaligned bio
Date: Sun, 18 Oct 2026 17:30:00 -0700

bio_iov_iter_get_pages() can extract some iovecs before encountering a
misaligned one.  It releases the pages and rejects the entire bio, but
leaves the supplied iterator advanced.

An iomap direct-I/O caller may subsequently reexpand the iterator's
byte count and fall back to buffered I/O.  The reexpanded count then
includes bytes before the iterator's current segment, potentially
causing iterate_iovec() to read beyond the imported iovec array.

In a reproducer using an initial empty iovec followed by 10-byte and
1015-byte segments, writev() returned 1015 instead of 1025 and KASAN
reported an 8-byte read beyond the nine-element iovec allocation.
Saving and restoring the iterator on the rejected-bio path makes
writev() return 1025 and eliminates the KASAN report.

Restore the entire iterator rather than reverting a byte count:
advancing past an empty segment changes its position without consuming
any bytes.

Leave successful and partially accepted bio paths unchanged.

Fixes: 14b007e17881 ("block: validate user space vectors during extraction")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Haocheng Yu <l1za0.sec@gmail.com>
Closes: https://lore.kernel.org/20261018081203.2431035-1-l1za0.sec@gmail.com
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Daehyeon Ko <4ncienth@gmail.com>
Cc: <stable@vger.kernel.org>
---
Testing on x86-64 QEMU/KVM with generic KASAN:
- Before: the ext4 writev() reproducer returned 1015 instead of 1025
  and triggered an 8-byte slab out-of-bounds read.
- After: 100 consecutive reproducer runs returned 1025 without KASAN;
  60-second buffered and direct ext4 fio runs passed.
- Daehyeon's alignment patch independently avoids the reproducer.

Tal Zussman's pending atomic-write changes introduce another rejected-bio
cleanup path. If both patches are combined, restore the iterator there too.


---

 block/bio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/block/bio.c~bio-iov-iter-rollback
+++ a/block/bio.c
@@ -1285,6 +1285,7 @@ int bio_iov_iter_get_pages(struct bio *b
 			   unsigned mem_align_mask, unsigned len_align_mask)
 {
 	iov_iter_extraction_t flags = 0;
+	struct iov_iter saved_iter;
 
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return -EIO;
@@ -1303,6 +1304,7 @@ int bio_iov_iter_get_pages(struct bio *b
 	if (bio->bi_bdev && blk_queue_pci_p2pdma(bio->bi_bdev->bd_disk->queue))
 		flags |= ITER_ALLOW_P2PDMA;
 
+	saved_iter = *iter;
 	do {
 		ssize_t ret;
 
@@ -1320,6 +1322,7 @@ int bio_iov_iter_get_pages(struct bio *b
 				bio_release_pages(bio, false);
 				bio_clear_flag(bio, BIO_PAGE_PINNED);
 				bio->bi_vcnt = 0;
+				*iter = saved_iter;
 			}
 			if (!bio->bi_vcnt)
 				return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bio-iov-iter-rollback.patch
mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix.patch

