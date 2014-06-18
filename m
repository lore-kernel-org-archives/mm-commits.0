From: akpm@linux-foundation.org
Subject: + fs-romfs-superc-convert-printk-to-pr_foo.patch added to -mm
 tree
Date: Wed, 18 Jun 2014 14:31:03 -0700
Message-ID: <53a20517.jNNlYt14Fh2mV6GA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbaFRVbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 17:31:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be


The patch titled
     Subject: fs/romfs/super.c: convert printk to pr_foo()
has been added to the -mm tree.  Its filename is
     fs-romfs-superc-convert-printk-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-romfs-superc-convert-printk-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-romfs-superc-convert-printk-to-pr_foo.patch

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
Subject: fs/romfs/super.c: convert printk to pr_foo()

Use current logging functions. Coalesce formats.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/super.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN fs/romfs/super.c~fs-romfs-superc-convert-printk-to-pr_foo fs/romfs/super.c
--- a/fs/romfs/super.c~fs-romfs-superc-convert-printk-to-pr_foo
+++ a/fs/romfs/super.c
@@ -380,7 +380,7 @@ static struct inode *romfs_iget(struct s
 eio:
 	ret = -EIO;
 error:
-	printk(KERN_ERR "ROMFS: read error for inode 0x%lx\n", pos);
+	pr_err("ROMFS: read error for inode 0x%lx\n", pos);
 	return ERR_PTR(ret);
 }
 
@@ -507,14 +507,13 @@ static int romfs_fill_super(struct super
 	if (rsb->word0 != ROMSB_WORD0 || rsb->word1 != ROMSB_WORD1 ||
 	    img_size < ROMFH_SIZE) {
 		if (!silent)
-			printk(KERN_WARNING "VFS:"
-			       " Can't find a romfs filesystem on dev %s.\n",
+			pr_warn("VFS: Can't find a romfs filesystem on dev %s.\n",
 			       sb->s_id);
 		goto error_rsb_inval;
 	}
 
 	if (romfs_checksum(rsb, min_t(size_t, img_size, 512))) {
-		printk(KERN_ERR "ROMFS: bad initial checksum on dev %s.\n",
+		pr_err("ROMFS: bad initial checksum on dev %s.\n",
 		       sb->s_id);
 		goto error_rsb_inval;
 	}
@@ -523,7 +522,7 @@ static int romfs_fill_super(struct super
 
 	len = strnlen(rsb->name, ROMFS_MAXFN);
 	if (!silent)
-		printk(KERN_NOTICE "ROMFS: Mounting image '%*.*s' through %s\n",
+		pr_notice("ROMFS: Mounting image '%*.*s' through %s\n",
 		       (unsigned) len, (unsigned) len, rsb->name, storage);
 
 	kfree(rsb);
@@ -614,7 +613,7 @@ static int __init init_romfs_fs(void)
 {
 	int ret;
 
-	printk(KERN_INFO "ROMFS MTD (C) 2007 Red Hat, Inc.\n");
+	pr_info("ROMFS MTD (C) 2007 Red Hat, Inc.\n");
 
 	romfs_inode_cachep =
 		kmem_cache_create("romfs_i",
@@ -623,13 +622,12 @@ static int __init init_romfs_fs(void)
 				  romfs_i_init_once);
 
 	if (!romfs_inode_cachep) {
-		printk(KERN_ERR
-		       "ROMFS error: Failed to initialise inode cache\n");
+		pr_err("ROMFS error: Failed to initialise inode cache\n");
 		return -ENOMEM;
 	}
 	ret = register_filesystem(&romfs_fs_type);
 	if (ret) {
-		printk(KERN_ERR "ROMFS error: Failed to register filesystem\n");
+		pr_err("ROMFS error: Failed to register filesystem\n");
 		goto error_register;
 	}
 	return 0;
_

Patches currently in -mm which might be from fabf@skynet.be are

kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-internalh-use-nth_page.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

