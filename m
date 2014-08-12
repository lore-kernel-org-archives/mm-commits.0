From: akpm@linux-foundation.org
Subject: [merged] fs-cramfs-code-clean-up.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:06 -0700
Message-ID: <53ea6dd2.R1CbameDfkna6KxZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:36247 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbaHLTlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:07 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2670356pab.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, sasha.levin@oracle.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/cramfs: code clean-up
has been removed from the -mm tree.  Its filename was
     fs-cramfs-code-clean-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/cramfs: code clean-up

Fixes some checkpatch errors/warnings:

WARNING: Missing a blank line after declarations
ERROR: spaces required around that '=' (ctx:VxV)
ERROR: "foo * bar" should be "foo *bar"
ERROR: space prohibited after that open parenthesis '('

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c      |   25 ++++++++++++++-----------
 fs/cramfs/uncompress.c |    2 +-
 2 files changed, 15 insertions(+), 12 deletions(-)

diff -puN fs/cramfs/inode.c~fs-cramfs-code-clean-up fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~fs-cramfs-code-clean-up
+++ a/fs/cramfs/inode.c
@@ -155,7 +155,7 @@ static struct inode *get_cramfs_inode(st
 
 static unsigned char read_buffers[READ_BUFFERS][BUFFER_SIZE];
 static unsigned buffer_blocknr[READ_BUFFERS];
-static struct super_block * buffer_dev[READ_BUFFERS];
+static struct super_block *buffer_dev[READ_BUFFERS];
 static int next_buffer;
 
 /*
@@ -207,6 +207,7 @@ static void *cramfs_read(struct super_bl
 
 	for (i = 0; i < BLKS_PER_BUF; i++) {
 		struct page *page = pages[i];
+
 		if (page) {
 			wait_on_page_locked(page);
 			if (!PageUptodate(page)) {
@@ -225,6 +226,7 @@ static void *cramfs_read(struct super_bl
 	data = read_buffers[buffer];
 	for (i = 0; i < BLKS_PER_BUF; i++) {
 		struct page *page = pages[i];
+
 		if (page) {
 			memcpy(data, kmap(page), PAGE_CACHE_SIZE);
 			kunmap(page);
@@ -239,6 +241,7 @@ static void *cramfs_read(struct super_bl
 static void cramfs_kill_sb(struct super_block *sb)
 {
 	struct cramfs_sb_info *sbi = CRAMFS_SB(sb);
+
 	kill_block_super(sb);
 	kfree(sbi);
 }
@@ -312,16 +315,16 @@ static int cramfs_fill_super(struct supe
 
 	root_offset = super.root.offset << 2;
 	if (super.flags & CRAMFS_FLAG_FSID_VERSION_2) {
-		sbi->size=super.size;
-		sbi->blocks=super.fsid.blocks;
-		sbi->files=super.fsid.files;
+		sbi->size = super.size;
+		sbi->blocks = super.fsid.blocks;
+		sbi->files = super.fsid.files;
 	} else {
-		sbi->size=1<<28;
-		sbi->blocks=0;
-		sbi->files=0;
+		sbi->size = 1<<28;
+		sbi->blocks = 0;
+		sbi->files = 0;
 	}
-	sbi->magic=super.magic;
-	sbi->flags=super.flags;
+	sbi->magic = super.magic;
+	sbi->flags = super.flags;
 	if (root_offset == 0)
 		pr_info("empty filesystem");
 	else if (!(super.flags & CRAMFS_FLAG_SHIFTED_ROOT_OFFSET) &&
@@ -427,7 +430,7 @@ static int cramfs_readdir(struct file *f
 /*
  * Lookup and fill in the inode data..
  */
-static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
+static struct dentry *cramfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 {
 	unsigned int offset = 0;
 	struct inode *inode = NULL;
@@ -485,7 +488,7 @@ out:
 	return NULL;
 }
 
-static int cramfs_readpage(struct file *file, struct page * page)
+static int cramfs_readpage(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	u32 maxblock;
diff -puN fs/cramfs/uncompress.c~fs-cramfs-code-clean-up fs/cramfs/uncompress.c
--- a/fs/cramfs/uncompress.c~fs-cramfs-code-clean-up
+++ a/fs/cramfs/uncompress.c
@@ -59,7 +59,7 @@ int cramfs_uncompress_init(void)
 {
 	if (!initialized++) {
 		stream.workspace = vmalloc(zlib_inflate_workspacesize());
-		if ( !stream.workspace ) {
+		if (!stream.workspace) {
 			initialized = 0;
 			return -ENOMEM;
 		}
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

