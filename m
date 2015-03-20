From: akpm@linux-foundation.org
Subject: + fs-affs-filec-unlock-release-page-on-error.patch added to -mm
 tree
Date: Fri, 20 Mar 2015 12:40:15 -0700
Message-ID: <550c779f.qK0VsDZF3uPkUH8M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbCTTkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 15:40:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsgatesv@gmail.com, fabf@skynet.be, geert@linux-m68k.org, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/file.c: unlock/release page on error
has been added to the -mm tree.  Its filename is
     fs-affs-filec-unlock-release-page-on-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-filec-unlock-release-page-on-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-filec-unlock-release-page-on-error.patch

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

 fs/affs/file.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

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
+			goto err;
+		}
 		tmp = min(bsize - boff, to - from);
 		BUG_ON(boff + tmp > bsize || tmp > bsize);
 		memcpy(AFFS_DATA(bh) + boff, data + from, tmp);
@@ -712,8 +714,10 @@ static int affs_write_end_ofs(struct fil
 		bidx++;
 	} else if (bidx) {
 		bh = affs_bread_ino(inode, bidx - 1, 0);
-		if (IS_ERR(bh))
-			return PTR_ERR(bh);
+		if (IS_ERR(bh)) {
+			written = PTR_ERR(bh);
+			goto err;
+		}
 	}
 	while (from + bsize <= to) {
 		prev_bh = bh;
@@ -790,6 +794,7 @@ done:
 	if (tmp > inode->i_size)
 		inode->i_size = AFFS_I(inode)->mmu_private = tmp;
 
+err:
 	unlock_page(page);
 	page_cache_release(page);
 
_

Patches currently in -mm which might be from tsgatesv@gmail.com are

fs-affs-filec-unlock-release-page-on-error.patch

