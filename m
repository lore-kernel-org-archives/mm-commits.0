From: akpm@linux-foundation.org
Subject: - proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:21:58 -0800
Message-ID: <200802232021.m1NKLwu0013380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760831AbYBWUWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:22:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     proper extern for gfs2/locking/dlm/mount.c:gdlm_ops
has been removed from the -mm tree.  Its filename was
     proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proper extern for gfs2/locking/dlm/mount.c:gdlm_ops
From: Adrian Bunk <bunk@kernel.org>

Add a proper extern declaration for gdlm_ops in fs/gfs2/locking/dlm/lock_dlm.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/locking/dlm/lock_dlm.h |    5 +++++
 fs/gfs2/locking/dlm/main.c     |    2 --
 fs/gfs2/locking/dlm/sysfs.c    |    2 --
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/gfs2/locking/dlm/lock_dlm.h~proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops fs/gfs2/locking/dlm/lock_dlm.h
--- a/fs/gfs2/locking/dlm/lock_dlm.h~proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops
+++ a/fs/gfs2/locking/dlm/lock_dlm.h
@@ -183,5 +183,10 @@ int gdlm_plock_get(void *, struct lm_loc
 		struct file_lock *);
 int gdlm_punlock(void *, struct lm_lockname *, struct file *,
 		struct file_lock *);
+
+/* mount.c */
+
+extern const struct lm_lockops gdlm_ops;
+
 #endif
 
diff -puN fs/gfs2/locking/dlm/main.c~proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops fs/gfs2/locking/dlm/main.c
--- a/fs/gfs2/locking/dlm/main.c~proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops
+++ a/fs/gfs2/locking/dlm/main.c
@@ -11,8 +11,6 @@
 
 #include "lock_dlm.h"
 
-extern struct lm_lockops gdlm_ops;
-
 static int __init init_lock_dlm(void)
 {
 	int error;
diff -puN fs/gfs2/locking/dlm/sysfs.c~proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops fs/gfs2/locking/dlm/sysfs.c
--- a/fs/gfs2/locking/dlm/sysfs.c~proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops
+++ a/fs/gfs2/locking/dlm/sysfs.c
@@ -12,8 +12,6 @@
 
 #include "lock_dlm.h"
 
-extern struct lm_lockops gdlm_ops;
-
 static ssize_t proto_name_show(struct gdlm_ls *ls, char *buf)
 {
 	return sprintf(buf, "%s\n", gdlm_ops.lm_proto_name);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
sparc-fix-build.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-net.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-udf_error-static.patch
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
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch
