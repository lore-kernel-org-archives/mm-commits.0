From: akpm@linux-foundation.org
Subject: + fs-block_devc-i_bdev-mustnt-be-inline.patch added to -mm tree
Date: Tue, 29 Apr 2008 16:24:44 -0700
Message-ID: <200804292324.m3TNOi0d015586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbYD2XZD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 19:25:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     fs/block_dev.c:I_BDEV() mustn't be inline
has been added to the -mm tree.  Its filename is
     fs-block_devc-i_bdev-mustnt-be-inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/block_dev.c:I_BDEV() mustn't be inline
From: Adrian Bunk <bunk@kernel.org>

Fix the following build error with UML and gcc 4.3:

/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c: In function `blkdev_get_block':
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c:42: sorry, unimplemented: inlining failed in call to `I_BDEV': function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c:119: sorry, unimplemented: called from here
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c:42: sorry, unimplemented: inlining failed in call to `I_BDEV': function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c:131: sorry, unimplemented: called from here

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/block_dev.c~fs-block_devc-i_bdev-mustnt-be-inline fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-i_bdev-mustnt-be-inline
+++ a/fs/block_dev.c
@@ -38,11 +38,10 @@ static inline struct bdev_inode *BDEV_I(
 	return container_of(inode, struct bdev_inode, vfs_inode);
 }
 
-inline struct block_device *I_BDEV(struct inode *inode)
+struct block_device *I_BDEV(struct inode *inode)
 {
 	return &BDEV_I(inode)->bdev;
 }
-
 EXPORT_SYMBOL(I_BDEV);
 
 static sector_t max_block(struct block_device *bdev)
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
fs-ramfs-extern-cleanup.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
ipmi-make-alloc_recv_msg-static.patch
ipmi-fix-return-from-atca_oem_poweroff_hook.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
git-acpi.patch
arch-x86-video-fbdevc-add-module_license.patch
git-m32r.patch
git-nfsd.patch
git-ocfs2.patch
git-pci.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
make-marker_debug-static.patch
reiser4.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch

