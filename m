From: akpm@linux-foundation.org
Subject: + fs-cramfs-code-clean-up.patch added to -mm tree
Date: Tue, 08 Jul 2014 15:24:21 -0700
Message-ID: <53bc6f95.b7Ui0S+XIUjXKCSh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:36799 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaGHWYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jul 2014 18:24:23 -0400
Received: by mail-oa0-f74.google.com with SMTP id i7so1406193oag.3
        for <mm-commits@vger.kernel.org>; Tue, 08 Jul 2014 15:24:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, sasha.levin@oracle.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/cramfs: code clean-up
has been added to the -mm tree.  Its filename is
     fs-cramfs-code-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-cramfs-code-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-cramfs-code-clean-up.patch

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

kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernfs-kernel-doc-warning-fix.patch
ntfs-kernel-doc-warning-fixes.patch
arch-sh-mm-asids-debugfsc-use-ptr_err_or_zero.patch
arch-sh-kernel-timec-use-ptr_err_or_zero.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-squashfs-superc-logging-clean-up.patch
ubifs-kernel-doc-warning-fix.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-ocfs2-slot_mapc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-internalh-use-nth_page.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch
fs-efs-nameic-return-is-not-a-function.patch
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-coda-use-linux-uaccessh.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
fs-hpfs-dnodec-fix-suspect-code-indent.patch
fs-quota-kernel-doc-warning-fixes.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
proc-constify-seq_operations.patch
fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch
fs-bfs-use-bfs-prefix-for-dump_imap.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cramfs-convert-printk-to-pr_foo.patch
fs-cramfs-use-pr_fmt.patch
fs-cramfs-code-clean-up.patch
fs-cramfs-inodec-use-linux-uaccessh.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
scripts-coccinelle-free-ifnullfreecocci-add-copyright-information.patch
fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

