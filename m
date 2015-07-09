From: akpm@linux-foundation.org
Subject: + parse_integer-convert-ext2-ext3-ext4.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:26:23 -0700
Message-ID: <559ecadf.Xs28Z3RHsYlcWyZW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbbGIT0Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:26:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, jack@suse.cz, linux@rasmusvillemoes.dk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert ext2, ext3, ext4
has been added to the -mm tree.  Its filename is
     parse_integer-convert-ext2-ext3-ext4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parse_integer-convert-ext2-ext3-ext4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parse_integer-convert-ext2-ext3-ext4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: parse_integer: convert ext2, ext3, ext4

Convert away from deprecated simple_strto*() interfaces.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    6 ++++--
 fs/ext3/super.c |    7 ++++---
 fs/ext4/super.c |   15 +++++++--------
 3 files changed, 15 insertions(+), 13 deletions(-)

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
diff -puN fs/ext3/super.c~parse_integer-convert-ext2-ext3-ext4 fs/ext3/super.c
--- a/fs/ext3/super.c~parse_integer-convert-ext2-ext3-ext4
+++ a/fs/ext3/super.c
@@ -902,17 +902,18 @@ static ext3_fsblk_t get_sb_block(void **
 {
 	ext3_fsblk_t	sb_block;
 	char		*options = (char *) *data;
+	int rv;
 
 	if (!options || strncmp(options, "sb=", 3) != 0)
 		return 1;	/* Default location */
 	options += 3;
-	/*todo: use simple_strtoll with >32bit ext3 */
-	sb_block = simple_strtoul(options, &options, 0);
-	if (*options && *options != ',') {
+	rv = parse_integer(options, 0, &sb_block);
+	if (rv < 0 || (options[rv] && options[rv] != ',')) {
 		ext3_msg(sb, KERN_ERR, "error: invalid sb specification: %s",
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
@@ -1238,18 +1238,19 @@ static ext4_fsblk_t get_sb_block(void **
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
@@ -2519,10 +2520,10 @@ static ssize_t inode_readahead_blks_stor
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
 
@@ -2546,13 +2547,11 @@ static ssize_t sbi_ui_store(struct ext4_
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
add-parse_integer-replacement-for-simple_strto.patch
parse_integer-add-runtime-testsuite.patch
parse-integer-rewrite-kstrto.patch
parse_integer-convert-scanf.patch
scanf-fix-type-range-overflow.patch
parse_integer-convert-lib.patch
parse_integer-convert-mm.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch

