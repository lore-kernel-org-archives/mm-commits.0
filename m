From: akpm@linux-foundation.org
Subject: + fs-cramfs-convert-printk-to-pr_foo.patch added to -mm tree
Date: Tue, 08 Jul 2014 15:24:19 -0700
Message-ID: <53bc6f93.L/do0mirQSkkdKUq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:34781 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaGHWYV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jul 2014 18:24:21 -0400
Received: by mail-ve0-f202.google.com with SMTP id oy12so940031veb.3
        for <mm-commits@vger.kernel.org>; Tue, 08 Jul 2014 15:24:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, sasha.levin@oracle.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/cramfs: convert printk to pr_foo()
has been added to the -mm tree.  Its filename is
     fs-cramfs-convert-printk-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-cramfs-convert-printk-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-cramfs-convert-printk-to-pr_foo.patch

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
Subject: fs/cramfs: convert printk to pr_foo()

Use current logging functions.  No level printk converted to pr_err

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c      |   14 +++++++-------
 fs/cramfs/uncompress.c |    6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/cramfs/inode.c~fs-cramfs-convert-printk-to-pr_foo fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~fs-cramfs-convert-printk-to-pr_foo
+++ a/fs/cramfs/inode.c
@@ -277,7 +277,7 @@ static int cramfs_fill_super(struct supe
 		/* check for wrong endianness */
 		if (super.magic == CRAMFS_MAGIC_WEND) {
 			if (!silent)
-				printk(KERN_ERR "cramfs: wrong endianness\n");
+				pr_err("cramfs: wrong endianness\n");
 			return -EINVAL;
 		}
 
@@ -287,22 +287,22 @@ static int cramfs_fill_super(struct supe
 		mutex_unlock(&read_mutex);
 		if (super.magic != CRAMFS_MAGIC) {
 			if (super.magic == CRAMFS_MAGIC_WEND && !silent)
-				printk(KERN_ERR "cramfs: wrong endianness\n");
+				pr_err("cramfs: wrong endianness\n");
 			else if (!silent)
-				printk(KERN_ERR "cramfs: wrong magic\n");
+				pr_err("cramfs: wrong magic\n");
 			return -EINVAL;
 		}
 	}
 
 	/* get feature flags first */
 	if (super.flags & ~CRAMFS_SUPPORTED_FLAGS) {
-		printk(KERN_ERR "cramfs: unsupported filesystem features\n");
+		pr_err("cramfs: unsupported filesystem features\n");
 		return -EINVAL;
 	}
 
 	/* Check that the root inode is in a sane state */
 	if (!S_ISDIR(super.root.mode)) {
-		printk(KERN_ERR "cramfs: root is not a directory\n");
+		pr_err("cramfs: root is not a directory\n");
 		return -EINVAL;
 	}
 	/* correct strange, hard-coded permissions of mkcramfs */
@@ -321,12 +321,12 @@ static int cramfs_fill_super(struct supe
 	sbi->magic=super.magic;
 	sbi->flags=super.flags;
 	if (root_offset == 0)
-		printk(KERN_INFO "cramfs: empty filesystem");
+		pr_info("cramfs: empty filesystem");
 	else if (!(super.flags & CRAMFS_FLAG_SHIFTED_ROOT_OFFSET) &&
 		 ((root_offset != sizeof(struct cramfs_super)) &&
 		  (root_offset != 512 + sizeof(struct cramfs_super))))
 	{
-		printk(KERN_ERR "cramfs: bad root offset %lu\n", root_offset);
+		pr_err("cramfs: bad root offset %lu\n", root_offset);
 		return -EINVAL;
 	}
 
diff -puN fs/cramfs/uncompress.c~fs-cramfs-convert-printk-to-pr_foo fs/cramfs/uncompress.c
--- a/fs/cramfs/uncompress.c~fs-cramfs-convert-printk-to-pr_foo
+++ a/fs/cramfs/uncompress.c
@@ -37,7 +37,7 @@ int cramfs_uncompress_block(void *dst, i
 
 	err = zlib_inflateReset(&stream);
 	if (err != Z_OK) {
-		printk("zlib_inflateReset error %d\n", err);
+		pr_err("zlib_inflateReset error %d\n", err);
 		zlib_inflateEnd(&stream);
 		zlib_inflateInit(&stream);
 	}
@@ -48,8 +48,8 @@ int cramfs_uncompress_block(void *dst, i
 	return stream.total_out;
 
 err:
-	printk("Error %d while decompressing!\n", err);
-	printk("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
+	pr_err("Error %d while decompressing!\n", err);
+	pr_err("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
 	return -EIO;
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

