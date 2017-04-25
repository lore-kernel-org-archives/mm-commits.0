From: akpm@linux-foundation.org
Subject: + fs-affs-bugfix-enable-writes-on-ofs-disks.patch added to -mm
 tree
Date: Tue, 25 Apr 2017 13:51:45 -0700
Message-ID: <58ffb6e1.yA2jKs8H3WIqtLqS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50892 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1950936AbdDYUvu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2017 16:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: bugfix: enable writes on OFS disks
has been added to the -mm tree.  Its filename is
     fs-affs-bugfix-enable-writes-on-ofs-disks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-bugfix-enable-writes-on-ofs-disks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-bugfix-enable-writes-on-ofs-disks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: bugfix: enable writes on OFS disks

We called unconditionally affs_bread_ino() with create 0 resulting in
"error (device ...): get_block(): strange block request 0" when trying to
write on AFFS OFS format.

This patch adds create parameter to that function.
0 for affs_readpage_ofs()
1 for affs_write_begin_ofs()

Bug was found here:
https://bugzilla.kernel.org/show_bug.cgi?id=114961

Link: http://lkml.kernel.org/r/20170424201257.1575-1-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/affs/file.c~fs-affs-bugfix-enable-writes-on-ofs-disks fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-bugfix-enable-writes-on-ofs-disks
+++ a/fs/affs/file.c
@@ -499,7 +499,7 @@ affs_getemptyblk_ino(struct inode *inode
 }
 
 static int
-affs_do_readpage_ofs(struct page *page, unsigned to)
+affs_do_readpage_ofs(struct page *page, unsigned to, int create)
 {
 	struct inode *inode = page->mapping->host;
 	struct super_block *sb = inode->i_sb;
@@ -518,7 +518,7 @@ affs_do_readpage_ofs(struct page *page,
 	boff = tmp % bsize;
 
 	while (pos < to) {
-		bh = affs_bread_ino(inode, bidx, 0);
+		bh = affs_bread_ino(inode, bidx, create);
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
 		tmp = min(bsize - boff, to - pos);
@@ -620,7 +620,7 @@ affs_readpage_ofs(struct file *file, str
 		memset(page_address(page) + to, 0, PAGE_SIZE - to);
 	}
 
-	err = affs_do_readpage_ofs(page, to);
+	err = affs_do_readpage_ofs(page, to, 0);
 	if (!err)
 		SetPageUptodate(page);
 	unlock_page(page);
@@ -657,7 +657,7 @@ static int affs_write_begin_ofs(struct f
 		return 0;
 
 	/* XXX: inefficient but safe in the face of short writes */
-	err = affs_do_readpage_ofs(page, PAGE_SIZE);
+	err = affs_do_readpage_ofs(page, PAGE_SIZE, 1);
 	if (err) {
 		unlock_page(page);
 		put_page(page);
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-affs-bugfix-make-symbolic-links-work-again.patch
fs-affs-bugfix-enable-writes-on-ofs-disks.patch
fs-affs-bugfix-write-files-greater-than-page-size-on-ofs.patch

