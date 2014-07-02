From: akpm@linux-foundation.org
Subject: + fs-bfs-use-bfs-prefix-for-dump_imap.patch added to -mm tree
Date: Wed, 02 Jul 2014 13:03:20 -0700
Message-ID: <53b46588.qG8IBegL8FOPa9Ee%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:63794 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbaGBUDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 16:03:21 -0400
Received: by mail-pd0-f201.google.com with SMTP id v10so1993749pde.0
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 13:03:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, tigran@aivazian.fsnet.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/bfs: use bfs prefix for dump_imap
has been added to the -mm tree.  Its filename is
     fs-bfs-use-bfs-prefix-for-dump_imap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-bfs-use-bfs-prefix-for-dump_imap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-bfs-use-bfs-prefix-for-dump_imap.patch

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
Subject: fs/bfs: use bfs prefix for dump_imap

All bfs related functions use bfs_ prefix.  This patch also moves extern
declaration to bfs.h and removes prototype from inode.c

This fixes checkpatch warning:
'WARNING: externs should be avoided in .c files'

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/bfs.h   |    1 +
 fs/bfs/dir.c   |    4 +---
 fs/bfs/inode.c |    8 +++-----
 3 files changed, 5 insertions(+), 8 deletions(-)

diff -puN fs/bfs/bfs.h~fs-bfs-use-bfs-prefix-for-dump_imap fs/bfs/bfs.h
--- a/fs/bfs/bfs.h~fs-bfs-use-bfs-prefix-for-dump_imap
+++ a/fs/bfs/bfs.h
@@ -46,6 +46,7 @@ static inline struct bfs_inode_info *BFS
 
 /* inode.c */
 extern struct inode *bfs_iget(struct super_block *sb, unsigned long ino);
+extern void bfs_dump_imap(const char *, struct super_block *);
 
 /* file.c */
 extern const struct inode_operations bfs_file_inops;
diff -puN fs/bfs/dir.c~fs-bfs-use-bfs-prefix-for-dump_imap fs/bfs/dir.c
--- a/fs/bfs/dir.c~fs-bfs-use-bfs-prefix-for-dump_imap
+++ a/fs/bfs/dir.c
@@ -75,8 +75,6 @@ const struct file_operations bfs_dir_ope
 	.llseek		= generic_file_llseek,
 };
 
-extern void dump_imap(const char *, struct super_block *);
-
 static int bfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 						bool excl)
 {
@@ -110,7 +108,7 @@ static int bfs_create(struct inode *dir,
 	BFS_I(inode)->i_eblock = 0;
 	insert_inode_hash(inode);
         mark_inode_dirty(inode);
-	dump_imap("create", s);
+	bfs_dump_imap("create", s);
 
 	err = bfs_add_entry(dir, dentry->d_name.name, dentry->d_name.len,
 							inode->i_ino);
diff -puN fs/bfs/inode.c~fs-bfs-use-bfs-prefix-for-dump_imap fs/bfs/inode.c
--- a/fs/bfs/inode.c~fs-bfs-use-bfs-prefix-for-dump_imap
+++ a/fs/bfs/inode.c
@@ -30,8 +30,6 @@ MODULE_LICENSE("GPL");
 #define dprintf(x...)
 #endif
 
-void dump_imap(const char *prefix, struct super_block *s);
-
 struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 {
 	struct bfs_inode *di;
@@ -194,7 +192,7 @@ static void bfs_evict_inode(struct inode
 			info->si_freeb += bi->i_eblock + 1 - bi->i_sblock;
 		info->si_freei++;
 		clear_bit(ino, info->si_imap);
-		dump_imap("delete_inode", s);
+		bfs_dump_imap("delete_inode", s);
         }
 
 	/*
@@ -297,7 +295,7 @@ static const struct super_operations bfs
 	.statfs		= bfs_statfs,
 };
 
-void dump_imap(const char *prefix, struct super_block *s)
+void bfs_dump_imap(const char *prefix, struct super_block *s)
 {
 #ifdef DEBUG
 	int i;
@@ -443,7 +441,7 @@ static int bfs_fill_super(struct super_b
 	}
 	brelse(bh);
 	brelse(sbh);
-	dump_imap("read_super", s);
+	bfs_dump_imap("read_super", s);
 	return 0;
 
 out3:
_

Patches currently in -mm which might be from fabf@skynet.be are

kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-squashfs-superc-logging-clean-up.patch
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
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
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
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

