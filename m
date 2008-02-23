From: akpm@linux-foundation.org
Subject: + fs-affs-filec-use-bug_on.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:44 -0800
Message-ID: <200802230734.m1N7YX2A018298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbYBWHyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, zippel@linux-m68k.org


The patch titled
     fs/affs/file.c: Use BUG_ON
has been added to the -mm tree.  Its filename is
     fs-affs-filec-use-bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/affs/file.c: Use BUG_ON
From: Julia Lawall <julia@diku.dk>


if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
side-effects to allow a definition of BUG_ON that drops the code completely.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ disable unlikely @ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (unlikely(E)) { BUG(); }
+ BUG_ON(E);
)

@@ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (E) { BUG(); }
+ BUG_ON(E);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff -puN fs/affs/file.c~fs-affs-filec-use-bug_on fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-use-bug_on
+++ a/fs/affs/file.c
@@ -325,8 +325,7 @@ affs_get_block(struct inode *inode, sect
 	pr_debug("AFFS: get_block(%u, %lu)\n", (u32)inode->i_ino, (unsigned long)block);
 
 
-	if (block > (sector_t)0x7fffffffUL)
-		BUG();
+	BUG_ON(block > (sector_t)0x7fffffffUL);
 
 	if (block >= AFFS_I(inode)->i_blkcnt) {
 		if (block > AFFS_I(inode)->i_blkcnt || !create)
@@ -493,8 +492,7 @@ affs_do_readpage_ofs(struct file *file, 
 	u32 tmp;
 
 	pr_debug("AFFS: read_page(%u, %ld, %d, %d)\n", (u32)inode->i_ino, page->index, from, to);
-	if (from > to || to > PAGE_CACHE_SIZE)
-		BUG();
+	BUG_ON(from > to || to > PAGE_CACHE_SIZE);
 	kmap(page);
 	data = page_address(page);
 	bsize = AFFS_SB(sb)->s_data_blksize;
@@ -507,8 +505,7 @@ affs_do_readpage_ofs(struct file *file, 
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
 		tmp = min(bsize - boff, to - from);
-		if (from + tmp > to || tmp > bsize)
-			BUG();
+		BUG_ON(from + tmp > to || tmp > bsize);
 		memcpy(data + from, AFFS_DATA(bh) + boff, tmp);
 		affs_brelse(bh);
 		bidx++;
@@ -540,8 +537,7 @@ affs_extent_file_ofs(struct inode *inode
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
 		tmp = min(bsize - boff, newsize - size);
-		if (boff + tmp > bsize || tmp > bsize)
-			BUG();
+		BUG_ON(boff + tmp > bsize || tmp > bsize);
 		memset(AFFS_DATA(bh) + boff, 0, tmp);
 		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(be32_to_cpu(AFFS_DATA_HEAD(bh)->size) + tmp);
 		affs_fix_checksum(sb, bh);
@@ -560,8 +556,7 @@ affs_extent_file_ofs(struct inode *inode
 		if (IS_ERR(bh))
 			goto out;
 		tmp = min(bsize, newsize - size);
-		if (tmp > bsize)
-			BUG();
+		BUG_ON(tmp > bsize);
 		AFFS_DATA_HEAD(bh)->ptype = cpu_to_be32(T_DATA);
 		AFFS_DATA_HEAD(bh)->key = cpu_to_be32(inode->i_ino);
 		AFFS_DATA_HEAD(bh)->sequence = cpu_to_be32(bidx);
@@ -683,8 +678,7 @@ static int affs_write_end_ofs(struct fil
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
 		tmp = min(bsize - boff, to - from);
-		if (boff + tmp > bsize || tmp > bsize)
-			BUG();
+		BUG_ON(boff + tmp > bsize || tmp > bsize);
 		memcpy(AFFS_DATA(bh) + boff, data + from, tmp);
 		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(be32_to_cpu(AFFS_DATA_HEAD(bh)->size) + tmp);
 		affs_fix_checksum(sb, bh);
@@ -732,8 +726,7 @@ static int affs_write_end_ofs(struct fil
 		if (IS_ERR(bh))
 			goto out;
 		tmp = min(bsize, to - from);
-		if (tmp > bsize)
-			BUG();
+		BUG_ON(tmp > bsize);
 		memcpy(AFFS_DATA(bh), data + from, tmp);
 		if (buffer_new(bh)) {
 			AFFS_DATA_HEAD(bh)->ptype = cpu_to_be32(T_DATA);
_

Patches currently in -mm which might be from julia@diku.dk are

sound-use-bug_on.patch
git-hid.patch
git-net.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
fs-ocfs2-use-bug_on.patch
s390-use-div_round_up.patch
drivers-block-viodasdc-use-field_sizeof.patch
usb-use-div_round_up.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch
