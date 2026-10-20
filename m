Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792518016;
	b=SHYhnsLcc28YN9gUshz+xz8N6wTg4mLuUVjF5TPPv0qFCw2sITmWla177vpuLoa9TbFk
	 zZJHS98m8mN05ZiC9QXONq7I981WEJnd5gWxMbIwvjph8eJXDGdRUL1qHc2P0csS7xWdD
	 l8u53ZO5VwVk+4Ot35RnSiaKEXg9oPOsFD7DHydE7pMgqf4clPOAVjSV76JWyeyk+ZPz2
	 mmiQM9CYUumgvRZIH+O/Ob4SoXIpd+M2pltyMMXUVKi50IJFJ6K1TLxjoScpUTTHWUA3D
	 Olp9fQNMUR3vjv9oBlMGdbBC4GsohK1UMgxYDpWJdLVnJazjYkW6qaBaUQA8+zibrVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792518016;
	h=Received:Date:To:From:Subject:Message-Id;
	bh=a7RAAWI9m+XhT8uZOklXdWq5gNflwzo9VHxv4VIatFg=;
	b=JsLSarnsYiNLmRBBKN5T+84Ct8FX0wt1dU0JkMOohMFjr8+lQUb7qrryNAOFV9UrxD8M
	 XprObUu3gIwlG7f6bX8RSC4u2jIp/CS3SehyPcp6+Kf1osKTpp5z3pS5hQzUNmF8shooB
	 8c0El40Z70sYH0+45KiWdzVBFYY/J1NIeul/vg2x4ZYh/QU21fBt2urpx775k+RP65xz2
	 QNFmbhPO9RlOV3CEadJJAc1qLdiUIpAlYrtJfmjbOduWjq1kszV8g+TobrELMbDuZ6vdU
	 zCAleEYpVRrTtQcarWkShP2X+xgIxPCMjZxfn+UtoflL5kNqvPs09zeKo7RjPQN+qQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C97606A31E;
	Tue, 20 Oct 2026 17:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AC51F000C9;
	Tue, 20 Oct 2026 17:40:15 +0000 (UTC)
Date: Tue, 20 Oct 2026 10:39:44 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tz2294@columbia.edu,stable@vger.kernel.org,l1za0.sec@gmail.com,kbusch@kernel.org,hch@lst.de,hare@kernel.org,axboe@kernel.dk,4ncienth@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] block-restore-the-iterator-when-rejecting-a-misaligned-bio.patch removed from -mm tree
Message-Id: <20261020174015.24AC51F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: block: restore the iterator when rejecting a misaligned bio
has been removed from the -mm tree.  Its filename was
     block-restore-the-iterator-when-rejecting-a-misaligned-bio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hannes Reinecke <hare@kernel.org>
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
 block/bio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/block/bio.c~block-restore-the-iterator-when-rejecting-a-misaligned-bio
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

mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

