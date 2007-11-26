From: akpm@linux-foundation.org
Subject: - fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch removed from -mm tree
Date: Mon, 26 Nov 2007 11:36:23 -0800
Message-ID: <200711261936.lAQJaNuM019305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754166AbXKZTg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 14:36:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs: introduce write_begin, write_end, and perform_write aops (revoke)
has been removed from the -mm tree.  Its filename was
     fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fs: introduce write_begin, write_end, and perform_write aops (revoke)
From: Nick Piggin <npiggin@suse.de>

These are intended to replace prepare_write and commit_write with more
flexible alternatives that are also able to avoid the buffered write deadlock
problems efficiently (which prepare_write is unable to do).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoked_inode.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

diff -puN fs/revoked_inode.c~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke fs/revoked_inode.c
--- a/fs/revoked_inode.c~fs-introduce-write_begin-write_end-and-perform_write-aops-revoke
+++ a/fs/revoked_inode.c
@@ -384,6 +384,20 @@ static int revoked_commit_write(struct f
 	return -EIO;
 }
 
+static int revoked_write_begin(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata)
+{
+	return -EIO;
+}
+
+static int revoked_write_end(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
+{
+	return -EIO;
+}
+
 static ssize_t revoked_direct_IO(int rw, struct kiocb *iocb,
 				 const struct iovec *iov, loff_t offset,
 				 unsigned long nr_segs)
_

Patches currently in -mm which might be from npiggin@suse.de are

nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
vt-bitlock-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4.patch
