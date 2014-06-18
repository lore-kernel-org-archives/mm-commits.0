From: akpm@linux-foundation.org
Subject: + fs-romfs-superc-use-pr_fmt-in-logging.patch added to -mm tree
Date: Wed, 18 Jun 2014 14:31:04 -0700
Message-ID: <53a20518.XELAgzTLHQ5wqbVA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbaFRVbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 17:31:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be


The patch titled
     Subject: fs/romfs/super.c: use pr_fmt in logging
has been added to the -mm tree.  Its filename is
     fs-romfs-superc-use-pr_fmt-in-logging.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-romfs-superc-use-pr_fmt-in-logging.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-romfs-superc-use-pr_fmt-in-logging.patch

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
Subject: fs/romfs/super.c: use pr_fmt in logging

- Remove "Error" in format logging (already in pr_ level)

- Use modulename in pr_fmt instead of ROMFS: in each pr_ callsites.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/super.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/romfs/super.c~fs-romfs-superc-use-pr_fmt-in-logging fs/romfs/super.c
--- a/fs/romfs/super.c~fs-romfs-superc-use-pr_fmt-in-logging
+++ a/fs/romfs/super.c
@@ -56,6 +56,8 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
@@ -380,7 +382,7 @@ static struct inode *romfs_iget(struct s
 eio:
 	ret = -EIO;
 error:
-	pr_err("ROMFS: read error for inode 0x%lx\n", pos);
+	pr_err("read error for inode 0x%lx\n", pos);
 	return ERR_PTR(ret);
 }
 
@@ -513,8 +515,7 @@ static int romfs_fill_super(struct super
 	}
 
 	if (romfs_checksum(rsb, min_t(size_t, img_size, 512))) {
-		pr_err("ROMFS: bad initial checksum on dev %s.\n",
-		       sb->s_id);
+		pr_err("bad initial checksum on dev %s.\n", sb->s_id);
 		goto error_rsb_inval;
 	}
 
@@ -522,8 +523,8 @@ static int romfs_fill_super(struct super
 
 	len = strnlen(rsb->name, ROMFS_MAXFN);
 	if (!silent)
-		pr_notice("ROMFS: Mounting image '%*.*s' through %s\n",
-		       (unsigned) len, (unsigned) len, rsb->name, storage);
+		pr_notice("Mounting image '%*.*s' through %s\n",
+			  (unsigned) len, (unsigned) len, rsb->name, storage);
 
 	kfree(rsb);
 	rsb = NULL;
@@ -622,12 +623,12 @@ static int __init init_romfs_fs(void)
 				  romfs_i_init_once);
 
 	if (!romfs_inode_cachep) {
-		pr_err("ROMFS error: Failed to initialise inode cache\n");
+		pr_err("Failed to initialise inode cache\n");
 		return -ENOMEM;
 	}
 	ret = register_filesystem(&romfs_fs_type);
 	if (ret) {
-		pr_err("ROMFS error: Failed to register filesystem\n");
+		pr_err("Failed to register filesystem\n");
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

