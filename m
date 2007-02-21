From: akpm@linux-foundation.org
Subject: - fs-fix-libfs-data-leak.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:07 -0800
Message-ID: <200702211046.l1LAk7kL006437@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46924 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbXBUKqU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs: fix libfs data leak
has been removed from the -mm tree.  Its filename was
     fs-fix-libfs-data-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: fix libfs data leak
From: Nick Piggin <npiggin@suse.de>

simple_prepare_write leaks uninitialised kernel data.  This happens because
the it leaves an uninitialised "hole" over the part of the page that the
write is expected to go to.  This is fine, but it then marks the page
uptodate, which means a concurrent read can come in and copy the
uninitialised memory into userspace before it written to.

Fix it by simply marking it uptodate in simple_commit_write instead, after
the hole has been filled in.  This could theoretically break an fs that
uses simple_prepare_write and not simple_commit_write, and that relies on
the incorrect simple_prepare_write behaviour.  Luckily, none of those
exists in the tree.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |    5 +++++
 fs/libfs.c                        |    5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~fs-fix-libfs-data-leak Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~fs-fix-libfs-data-leak
+++ a/Documentation/filesystems/vfs.txt
@@ -617,6 +617,11 @@ struct address_space_operations {
 	In this case the prepare_write will be retried one the lock is
   	regained.
 
+	Note: the page _must not_ be marked uptodate in this function
+	(or anywhere else) unless it actually is uptodate right now. As
+	soon as a page is marked uptodate, it is possible for a concurrent
+	read(2) to copy it to userspace.
+
   commit_write: If prepare_write succeeds, new data will be copied
         into the page and then commit_write will be called.  It will
         typically update the size of the file (if appropriate) and
diff -puN fs/libfs.c~fs-fix-libfs-data-leak fs/libfs.c
--- a/fs/libfs.c~fs-fix-libfs-data-leak
+++ a/fs/libfs.c
@@ -335,17 +335,18 @@ int simple_prepare_write(struct file *fi
 			flush_dcache_page(page);
 			kunmap_atomic(kaddr, KM_USER0);
 		}
-		SetPageUptodate(page);
 	}
 	return 0;
 }
 
 int simple_commit_write(struct file *file, struct page *page,
-			unsigned offset, unsigned to)
+			unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
 
+	if (!PageUptodate(page))
+		SetPageUptodate(page);
 	/*
 	 * No need to use i_size_read() here, the i_size
 	 * cannot change under us because we hold the i_mutex.
_

Patches currently in -mm which might be from npiggin@suse.de are

git-block.patch
