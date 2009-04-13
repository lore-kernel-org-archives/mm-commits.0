From: akpm@linux-foundation.org
Subject: + squashfs-fix-breakage-when-pagesize-blocksize.patch added to -mm tree
Date: Mon, 13 Apr 2009 15:51:09 -0700
Message-ID: <200904132251.n3DMp9LY024322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbZDMWxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Apr 2009 18:53:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: doug.chapman@hp.com, phillip@lougher.demon.co.uk


The patch titled
     squashfs: fix breakage when pagesize > blocksize
has been added to the -mm tree.  Its filename is
     squashfs-fix-breakage-when-pagesize-blocksize.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: squashfs: fix breakage when pagesize > blocksize
From: Doug Chapman <doug.chapman@hp.com>

Squashfs is broken on any system where the pageszie is larger than either
the block size of the squashfs image or larger than the metadata size
(8192).  This is easily fixed by ensuring cache->pages is always > 0.

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
+	cache->pages = cache->pages?cache->pages:1;
 	cache->name = name;
 	cache->num_waiters = 0;
 	spin_lock_init(&cache->lock);
_

Patches currently in -mm which might be from doug.chapman@hp.com are

squashfs-fix-breakage-when-pagesize-blocksize.patch

