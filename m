From: akpm@linux-foundation.org
Subject: + aio-bump-i_count-instead-of-using-igrab.patch added to -mm tree
Date: Mon, 27 Sep 2010 14:54:59 -0700
Message-ID: <201009272154.o8RLsx8L018852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780Ab0I0Vzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 17:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, jmoyer@redhat.com, npiggin@kernel.dk, zach.brown@oracle.com


The patch titled
     aio: bump i_count instead of using igrab
has been added to the -mm tree.  Its filename is
     aio-bump-i_count-instead-of-using-igrab.patch

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
Subject: aio: bump i_count instead of using igrab
From: Chris Mason <chris.mason@oracle.com>

The aio batching code is using igrab to get an extra reference on the
inode so it can safely batch.  igrab will go ahead and take the global
inode spinlock, which can be a bottleneck on large machines doing lots of
AIO.

In this case, igrab isn't required because we already have a reference on
the file handle.  It is safe to just bump the i_count directly on the
inode.

Benchmarking shows this patch brings IOP/s on tons of flash up by about
2.5X.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN fs/aio.c~aio-bump-i_count-instead-of-using-igrab fs/aio.c
--- a/fs/aio.c~aio-bump-i_count-instead-of-using-igrab
+++ a/fs/aio.c
@@ -1543,7 +1543,20 @@ static void aio_batch_add(struct address
 	}
 
 	abe = mempool_alloc(abe_pool, GFP_KERNEL);
-	BUG_ON(!igrab(mapping->host));
+
+	/*
+	 * we should be using igrab here, but
+	 * we don't want to hammer on the global
+	 * inode spinlock just to take an extra
+	 * reference on a file that we must already
+	 * have a reference to.
+	 *
+	 * When we're called, we always have a reference
+	 * on the file, so we must always have a reference
+	 * on the inode, so igrab must always just
+	 * bump the count and move on.
+	 */
+	atomic_inc(&mapping->host->i_count);
 	abe->mapping = mapping;
 	hlist_add_head(&abe->list, &batch_hash[bucket]);
 	return;
_

Patches currently in -mm which might be from chris.mason@oracle.com are

linux-next.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
btrfs-only-bug_on-when-the-errno-is-not-enoent.patch
fs-btrfs-inodec-eliminate-memory-leak.patch
writeback-remove-nonblocking-encountered_congestion-references.patch
aio-bump-i_count-instead-of-using-igrab.patch

