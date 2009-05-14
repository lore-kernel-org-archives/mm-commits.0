From: akpm@linux-foundation.org
Subject: [merged] squashfs-fix-breakage-when-pagesize-blocksize.patch removed from -mm tree
Date: Thu, 14 May 2009 09:10:35 -0700
Message-ID: <200905141610.n4EGAZPg008120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbZENQLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 May 2009 12:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: doug.chapman@hp.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     squashfs: fix breakage when pagesize > blocksize
has been removed from the -mm tree.  Its filename was
     squashfs-fix-breakage-when-pagesize-blocksize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: squashfs: fix breakage when pagesize > blocksize
From: Doug Chapman <doug.chapman@hp.com>

Squashfs is broken on any system where the pageszie is larger than either
the block size of the squashfs image or larger than the metadata size
(8192).  This is easily fixed by ensuring cache->pages is always > 0.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Doug Chapman <doug.chapman@hp.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/cache.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/squashfs/cache.c~squashfs-fix-breakage-when-pagesize-blocksize fs/squashfs/cache.c
--- a/fs/squashfs/cache.c~squashfs-fix-breakage-when-pagesize-blocksize
+++ a/fs/squashfs/cache.c
@@ -252,6 +252,7 @@ struct squashfs_cache *squashfs_cache_in
 	cache->entries = entries;
 	cache->block_size = block_size;
 	cache->pages = block_size >> PAGE_CACHE_SHIFT;
+	cache->pages = cache->pages ? cache->pages : 1;
 	cache->name = name;
 	cache->num_waiters = 0;
 	spin_lock_init(&cache->lock);
_

Patches currently in -mm which might be from doug.chapman@hp.com are

origin.patch

