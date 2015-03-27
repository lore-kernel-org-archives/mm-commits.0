From: akpm@linux-foundation.org
Subject: [merged] fs-affs-filec-unlock-release-page-on-error.patch removed from -mm tree
Date: Fri, 27 Mar 2015 11:16:58 -0700
Message-ID: <55159e9a.MwcLhkMEJujLkgb+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbbC0SQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsgatesv@gmail.com, fabf@skynet.be, geert@linux-m68k.org, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/file.c: unlock/release page on error
has been removed from the -mm tree.  Its filename was
     fs-affs-filec-unlock-release-page-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Taesoo Kim <tsgatesv@gmail.com>
Subject: fs/affs/file.c: unlock/release page on error

When affs_bread_ino() fails, correctly unlock the page and release the
page cache with proper error value.  All write_end() should unlock/release
the page that was locked by write_beg().

Signed-off-by: Taesoo Kim <tsgatesv@gmail.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN fs/affs/file.c~fs-affs-filec-unlock-release-page-on-error fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-unlock-release-page-on-error
+++ a/fs/affs/file.c
@@ -699,8 +699,10 @@ static int affs_write_end_ofs(struct fil
 	boff = tmp % bsize;
 	if (boff) {
 		bh = affs_bread_ino(inode, bidx, 0);
-		if (IS_ERR(bh))
-			return PTR_ERR(bh);
+		if (IS_ERR(bh)) {
+			written = PTR_ERR(bh);
+			goto err_first_bh;
+		}
 		tmp = min(bsize - boff, to - from);
 		BUG_ON(boff + tmp > bsize || tmp > bsize);
 		memcpy(AFFS_DATA(bh) + boff, data + from, tmp);
@@ -712,14 +714,16 @@ static int affs_write_end_ofs(struct fil
 		bidx++;
 	} else if (bidx) {
 		bh = affs_bread_ino(inode, bidx - 1, 0);
-		if (IS_ERR(bh))
-			return PTR_ERR(bh);
+		if (IS_ERR(bh)) {
+			written = PTR_ERR(bh);
+			goto err_first_bh;
+		}
 	}
 	while (from + bsize <= to) {
 		prev_bh = bh;
 		bh = affs_getemptyblk_ino(inode, bidx);
 		if (IS_ERR(bh))
-			goto out;
+			goto err_bh;
 		memcpy(AFFS_DATA(bh), data + from, bsize);
 		if (buffer_new(bh)) {
 			AFFS_DATA_HEAD(bh)->ptype = cpu_to_be32(T_DATA);
@@ -751,7 +755,7 @@ static int affs_write_end_ofs(struct fil
 		prev_bh = bh;
 		bh = affs_bread_ino(inode, bidx, 1);
 		if (IS_ERR(bh))
-			goto out;
+			goto err_bh;
 		tmp = min(bsize, to - from);
 		BUG_ON(tmp > bsize);
 		memcpy(AFFS_DATA(bh), data + from, tmp);
@@ -790,12 +794,13 @@ done:
 	if (tmp > inode->i_size)
 		inode->i_size = AFFS_I(inode)->mmu_private = tmp;
 
+err_first_bh:
 	unlock_page(page);
 	page_cache_release(page);
 
 	return written;
 
-out:
+err_bh:
 	bh = prev_bh;
 	if (!written)
 		written = PTR_ERR(bh);
_

Patches currently in -mm which might be from tsgatesv@gmail.com are

origin.patch
linux-next.patch

