From: akpm@linux-foundation.org
Subject: + fs-affs-filec-unlock-release-page-on-error-v2.patch added to
 -mm tree
Date: Mon, 23 Mar 2015 16:46:53 -0700
Message-ID: <5510a5ed.WQ+YrSI/66LPOid+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbbCWXqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Mar 2015 19:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsgatesv@gmail.com, fabf@skynet.be, geert@linux-m68k.org, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-affs-filec-unlock-release-page-on-error-v2
has been added to the -mm tree.  Its filename is
     fs-affs-filec-unlock-release-page-on-error-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-filec-unlock-release-page-on-error-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-filec-unlock-release-page-on-error-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Taesoo Kim <tsgatesv@gmail.com>
Subject: fs-affs-filec-unlock-release-page-on-error-v2

Signed-off-by: Taesoo Kim <tsgatesv@gmail.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/affs/file.c~fs-affs-filec-unlock-release-page-on-error-v2 fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-unlock-release-page-on-error-v2
+++ a/fs/affs/file.c
@@ -701,7 +701,7 @@ static int affs_write_end_ofs(struct fil
 		bh = affs_bread_ino(inode, bidx, 0);
 		if (IS_ERR(bh)) {
 			written = PTR_ERR(bh);
-			goto err;
+			goto err_first_bh;
 		}
 		tmp = min(bsize - boff, to - from);
 		BUG_ON(boff + tmp > bsize || tmp > bsize);
@@ -716,14 +716,14 @@ static int affs_write_end_ofs(struct fil
 		bh = affs_bread_ino(inode, bidx - 1, 0);
 		if (IS_ERR(bh)) {
 			written = PTR_ERR(bh);
-			goto err;
+			goto err_first_bh;
 		}
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
@@ -755,7 +755,7 @@ static int affs_write_end_ofs(struct fil
 		prev_bh = bh;
 		bh = affs_bread_ino(inode, bidx, 1);
 		if (IS_ERR(bh))
-			goto out;
+			goto err_bh;
 		tmp = min(bsize, to - from);
 		BUG_ON(tmp > bsize);
 		memcpy(AFFS_DATA(bh), data + from, tmp);
@@ -794,13 +794,13 @@ done:
 	if (tmp > inode->i_size)
 		inode->i_size = AFFS_I(inode)->mmu_private = tmp;
 
-err:
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

fs-affs-filec-unlock-release-page-on-error.patch
fs-affs-filec-unlock-release-page-on-error-v2.patch

