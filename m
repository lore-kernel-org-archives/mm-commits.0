From: akpm@linux-foundation.org
Subject: - fs-affs-filec-use-bug_on.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:06 -0700
Message-ID: <200804300540.m3U5e6ft028932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559AbYD3FkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fs/affs/file.c: use BUG_ON
has been removed from the -mm tree.  Its filename was
     fs-affs-filec-use-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/affs/file.c: use BUG_ON
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

origin.patch
git-acpi.patch
drivers-scsi-use-time_before-time_before_eq-etc.patch
git-cryptodev.patch
fs-ext4-use-bug_on.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

