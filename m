From: akpm@linux-foundation.org
Subject: - limit-minixfs-printks-on-corrupted-dir-i_size.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:23 -0700
Message-ID: <200710180656.l9I6uNPL030696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59073 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755851AbXJRHVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:21:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, 7eggert@gmx.de, mm-commits@vger.kernel.org


The patch titled
     limit minixfs printks on corrupted dir i_size
has been removed from the -mm tree.  Its filename was
     limit-minixfs-printks-on-corrupted-dir-i_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: limit minixfs printks on corrupted dir i_size
From: Eric Sandeen <sandeen@redhat.com>

This attempts to address CVE-2006-6058
http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6058

first reported at http://projects.info-pull.com/mokb/MOKB-17-11-2006.html

Essentially a corrupted minix dir inode reporting a very large
i_size will loop for a very long time in minix_readdir, minix_find_entry,
etc, because on EIO they just move on to try the next page.  This is
under the BKL, printk-storming as well.  This can lock up the machine
for a very long time.  Simply ratelimiting the printks gets things back
under control.  Make the message a bit more informative while we're here.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Bodo Eggert <7eggert@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/itree_v1.c |    9 +++++++--
 fs/minix/itree_v2.c |    9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff -puN fs/minix/itree_v1.c~limit-minixfs-printks-on-corrupted-dir-i_size fs/minix/itree_v1.c
--- a/fs/minix/itree_v1.c~limit-minixfs-printks-on-corrupted-dir-i_size
+++ a/fs/minix/itree_v1.c
@@ -23,11 +23,16 @@ static inline block_t *i_data(struct ino
 static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 {
 	int n = 0;
+	char b[BDEVNAME_SIZE];
 
 	if (block < 0) {
-		printk("minix_bmap: block<0\n");
+		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
+			block, bdevname(inode->i_sb->s_bdev, b));
 	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {
-		printk("minix_bmap: block>big\n");
+		if (printk_ratelimit())
+			printk("MINIX-fs: block_to_path: "
+			       "block %ld too big on dev %s\n",
+				block, bdevname(inode->i_sb->s_bdev, b));
 	} else if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 512) {
diff -puN fs/minix/itree_v2.c~limit-minixfs-printks-on-corrupted-dir-i_size fs/minix/itree_v2.c
--- a/fs/minix/itree_v2.c~limit-minixfs-printks-on-corrupted-dir-i_size
+++ a/fs/minix/itree_v2.c
@@ -23,12 +23,17 @@ static inline block_t *i_data(struct ino
 static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 {
 	int n = 0;
+	char b[BDEVNAME_SIZE];
 	struct super_block *sb = inode->i_sb;
 
 	if (block < 0) {
-		printk("minix_bmap: block<0\n");
+		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
+			block, bdevname(sb->s_bdev, b));
 	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/sb->s_blocksize)) {
-		printk("minix_bmap: block>big\n");
+		if (printk_ratelimit())
+			printk("MINIX-fs: block_to_path: "
+			       "block %ld too big on dev %s\n",
+				block, bdevname(sb->s_bdev, b));
 	} else if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 256) {
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
ext4-remove-ifdef-config_ext4_index.patch
ext3-fix-setup_new_group_blocks-locking.patch
