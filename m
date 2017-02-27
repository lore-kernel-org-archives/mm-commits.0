From: akpm@linux-foundation.org
Subject: [patch 22/78] fs/affs: add validation block function
Date: Mon, 27 Feb 2017 14:27:46 -0800
Message-ID: <58b4a7e2.lF/lZgkaOj8TlvBo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751891AbdB0WgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:36:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, fabf@skynet.be, viro@zeniv.linux.org.uk

From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: add validation block function

Avoid repeating 4 times the same calculation.

Link: http://lkml.kernel.org/r/20170109191208.6085-3-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN fs/affs/affs.h~fs-affs-add-validation-block-function fs/affs/affs.h
--- a/fs/affs/affs.h~fs-affs-add-validation-block-function
+++ a/fs/affs/affs.h
@@ -212,6 +212,12 @@ extern const struct address_space_operat
 extern const struct dentry_operations	 affs_dentry_operations;
 extern const struct dentry_operations	 affs_intl_dentry_operations;
 
+static inline bool affs_validblock(struct super_block *sb, int block)
+{
+	return(block >= AFFS_SB(sb)->s_reserved &&
+	       block < AFFS_SB(sb)->s_partition_size);
+}
+
 static inline void
 affs_set_blocksize(struct super_block *sb, int size)
 {
@@ -221,7 +227,7 @@ static inline struct buffer_head *
 affs_bread(struct super_block *sb, int block)
 {
 	pr_debug("%s: %d\n", __func__, block);
-	if (block >= AFFS_SB(sb)->s_reserved && block < AFFS_SB(sb)->s_partition_size)
+	if (affs_validblock(sb, block))
 		return sb_bread(sb, block);
 	return NULL;
 }
@@ -229,7 +235,7 @@ static inline struct buffer_head *
 affs_getblk(struct super_block *sb, int block)
 {
 	pr_debug("%s: %d\n", __func__, block);
-	if (block >= AFFS_SB(sb)->s_reserved && block < AFFS_SB(sb)->s_partition_size)
+	if (affs_validblock(sb, block))
 		return sb_getblk(sb, block);
 	return NULL;
 }
@@ -238,7 +244,7 @@ affs_getzeroblk(struct super_block *sb,
 {
 	struct buffer_head *bh;
 	pr_debug("%s: %d\n", __func__, block);
-	if (block >= AFFS_SB(sb)->s_reserved && block < AFFS_SB(sb)->s_partition_size) {
+	if (affs_validblock(sb, block)) {
 		bh = sb_getblk(sb, block);
 		lock_buffer(bh);
 		memset(bh->b_data, 0 , sb->s_blocksize);
@@ -253,7 +259,7 @@ affs_getemptyblk(struct super_block *sb,
 {
 	struct buffer_head *bh;
 	pr_debug("%s: %d\n", __func__, block);
-	if (block >= AFFS_SB(sb)->s_reserved && block < AFFS_SB(sb)->s_partition_size) {
+	if (affs_validblock(sb, block)) {
 		bh = sb_getblk(sb, block);
 		wait_on_buffer(bh);
 		set_buffer_uptodate(bh);
_
