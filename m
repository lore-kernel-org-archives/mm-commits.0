From: akpm@linux-foundation.org
Subject: + md-make-dm_dirty_log_initexit-static.patch added to -mm tree
Date: Tue, 29 Apr 2008 17:00:01 -0700
Message-ID: <200804300000.m3U001ix016886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753167AbYD3AAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 20:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     md: make dm_dirty_log_{init,exit}() static
has been added to the -mm tree.  Its filename is
     md-make-dm_dirty_log_initexit-static.patch

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
Subject: md: make dm_dirty_log_{init,exit}() static
From: Adrian Bunk <bunk@kernel.org>

dm_dirty_log_{init,exit}() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log.c |    4 ++--
 drivers/md/dm.h     |    6 ------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/md/dm-log.c~md-make-dm_dirty_log_initexit-static drivers/md/dm-log.c
--- a/drivers/md/dm-log.c~md-make-dm_dirty_log_initexit-static
+++ a/drivers/md/dm-log.c
@@ -831,7 +831,7 @@ static struct dm_dirty_log_type _disk_ty
 	.status = disk_status,
 };
 
-int __init dm_dirty_log_init(void)
+static int __init dm_dirty_log_init(void)
 {
 	int r;
 
@@ -848,7 +848,7 @@ int __init dm_dirty_log_init(void)
 	return r;
 }
 
-void __exit dm_dirty_log_exit(void)
+static void __exit dm_dirty_log_exit(void)
 {
 	dm_dirty_log_type_unregister(&_disk_type);
 	dm_dirty_log_type_unregister(&_core_type);
diff -puN drivers/md/dm.h~md-make-dm_dirty_log_initexit-static drivers/md/dm.h
--- a/drivers/md/dm.h~md-make-dm_dirty_log_initexit-static
+++ a/drivers/md/dm.h
@@ -100,12 +100,6 @@ int dm_lock_for_deletion(struct mapped_d
 
 void dm_kobject_uevent(struct mapped_device *md);
 
-/*
- * Dirty log
- */
-int dm_dirty_log_init(void);
-void dm_dirty_log_exit(void);
-
 int dm_kcopyd_init(void);
 void dm_kcopyd_exit(void);
 
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
fs-block_devc-i_bdev-mustnt-be-inline.patch
block-blk-barrierc-blk_ordered_cur_seq-mustnt-be-inline.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
arch-x86-video-fbdevc-add-module_license.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
git-nfsd.patch
git-ocfs2.patch
git-pci.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
make-marker_debug-static.patch
reiser4.patch
md-make-dm_dirty_log_initexit-static.patch

