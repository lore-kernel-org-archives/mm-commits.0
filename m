From: akpm@linux-foundation.org
Subject: + proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:57:56 -0800
Message-ID: <200802180958.m1I9wrBF018831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756521AbYBRKAX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:00:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, swhiteho@redhat.com


The patch titled
     proper extern for gfs2/locking/dlm/mount.c:gdlm_ops
has been added to the -mm tree.  Its filename is
     proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops.patch

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

git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops.patch
gfs2-ops_filec-should-include-ops_inodeh.patch
git-kbuild.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
make-ocfs2_downconvert_thread-static.patch
ocfs-make-dlm_do_assert_master-static.patch
if-0-pci_cleanup_aer_correct_error_status.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
make-lpfc_disable_node-static.patch
if-0-ses_match_host.patch
scsi_transport_iscsic-make-2-functions-static.patch
remove-ps2esdi.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ipwireless-remove-dead-code.patch
git-xtensa.patch
sparc-fix-build.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-printk_recursion_bug_msg-static.patch
make-udf_error-static.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-block_devc-remove-if-0ed-code.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
make-struct-def_blk_aops-static.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch
