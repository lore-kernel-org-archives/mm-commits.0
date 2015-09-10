From: akpm@linux-foundation.org
Subject: [nacked] parse_integer-convert-ext2-ext3-ext4.patch removed from
 -mm tree
Date: Thu, 10 Sep 2015 13:40:52 -0700
Message-ID: <55f1ead4.o0H70gw3BdA9DBzI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbIJUkx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 16:40:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, jack@suse.cz, linux@rasmusvillemoes.dk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert ext2, ext4
has been removed from the -mm tree.  Its filename was
     parse_integer-convert-ext2-ext3-ext4.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: parse_integer: convert ext2, ext4

Convert away from deprecated simple_strto*() interfaces.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    6 ++++--
 fs/ext4/super.c |   15 +++++++--------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff -puN fs/ext2/super.c~parse_integer-convert-ext2-ext3-ext4 fs/ext2/super.c
--- a/fs/ext2/super.c~parse_integer-convert-ext2-ext3-ext4
+++ a/fs/ext2/super.c
@@ -383,16 +383,18 @@ static unsigned long get_sb_block(void *
 {
 	unsigned long 	sb_block;
 	char 		*options = (char *) *data;
+	int rv;
 
 	if (!options || strncmp(options, "sb=", 3) != 0)
 		return 1;	/* Default location */
 	options += 3;
-	sb_block = simple_strtoul(options, &options, 0);
-	if (*options && *options != ',') {
+	rv = parse_integer(options, 0, &sb_block);
+	if (rv < 0 || (options[rv] && options[rv] != ',')) {
 		printk("EXT2-fs: Invalid sb specification: %s\n",
 		       (char *) *data);
 		return 1;
 	}
+	options += rv;
 	if (*options == ',')
 		options++;
 	*data = (void *) options;
diff -puN fs/ext4/super.c~parse_integer-convert-ext2-ext3-ext4 fs/ext4/super.c
--- a/fs/ext4/super.c~parse_integer-convert-ext2-ext3-ext4
+++ a/fs/ext4/super.c
@@ -1251,18 +1251,19 @@ static ext4_fsblk_t get_sb_block(void **
 {
 	ext4_fsblk_t	sb_block;
 	char		*options = (char *) *data;
+	int rv;
 
 	if (!options || strncmp(options, "sb=", 3) != 0)
 		return 1;	/* Default location */
 
 	options += 3;
-	/* TODO: use simple_strtoll with >32bit ext4 */
-	sb_block = simple_strtoul(options, &options, 0);
-	if (*options && *options != ',') {
+	rv = parse_integer(options, 0, &sb_block);
+	if (rv < 0 || (options[rv] && options[rv] != ',')) {
 		printk(KERN_ERR "EXT4-fs: Invalid sb specification: %s\n",
 		       (char *) *data);
 		return 1;
 	}
+	options += rv;
 	if (*options == ',')
 		options++;
 	*data = (void *) options;
@@ -2532,10 +2533,10 @@ static ssize_t inode_readahead_blks_stor
 					  struct ext4_sb_info *sbi,
 					  const char *buf, size_t count)
 {
-	unsigned long t;
+	unsigned int t;
 	int ret;
 
-	ret = kstrtoul(skip_spaces(buf), 0, &t);
+	ret = kstrtouint(skip_spaces(buf), 0, &t);
 	if (ret)
 		return ret;
 
@@ -2559,13 +2560,11 @@ static ssize_t sbi_ui_store(struct ext4_
 			    const char *buf, size_t count)
 {
 	unsigned int *ui = (unsigned int *) (((char *) sbi) + a->u.offset);
-	unsigned long t;
 	int ret;
 
-	ret = kstrtoul(skip_spaces(buf), 0, &t);
+	ret = kstrtouint(skip_spaces(buf), 0, ui);
 	if (ret)
 		return ret;
-	*ui = t;
 	return count;
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrto-accept-0-for-signed-conversion.patch
parse_integer-convert-fs-ocfs2.patch
parse_integer-convert-fs-9p.patch
parse_integer-convert-fs-exofs.patch
proc-convert-to-kstrto-kstrto_from_user.patch
sound-convert-to-parse_integer.patch

