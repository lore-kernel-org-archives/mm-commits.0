From: akpm@linux-foundation.org
Subject: + fs-freevxfs-proper-externs.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:11:10 -0800
Message-ID: <200802181012.m1IAC8vi019567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59265 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756186AbYBRKM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:12:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, hch@infradead.org


The patch titled
     fs/freevxfs/: proper externs
has been added to the -mm tree.  Its filename is
     fs-freevxfs-proper-externs.patch

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
Subject: fs/freevxfs/: proper externs
From: Adrian Bunk <bunk@kernel.org>

Move the extern declarations of several structs to vxfs_extern.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_extern.h |    5 +++++
 fs/freevxfs/vxfs_immed.c  |    1 +
 fs/freevxfs/vxfs_inode.c  |    5 -----
 3 files changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/freevxfs/vxfs_extern.h~fs-freevxfs-proper-externs fs/freevxfs/vxfs_extern.h
--- a/fs/freevxfs/vxfs_extern.h~fs-freevxfs-proper-externs
+++ a/fs/freevxfs/vxfs_extern.h
@@ -50,7 +50,11 @@ extern daddr_t			vxfs_bmap1(struct inode
 /* vxfs_fshead.c */
 extern int			vxfs_read_fshead(struct super_block *);
 
+/* vxfs_immed.c */
+extern const struct inode_operations vxfs_immed_symlink_iops;
+
 /* vxfs_inode.c */
+extern const struct address_space_operations vxfs_immed_aops;
 extern struct kmem_cache	*vxfs_inode_cachep;
 extern void			vxfs_dumpi(struct vxfs_inode_info *, ino_t);
 extern struct inode *		vxfs_get_fake_inode(struct super_block *,
@@ -69,6 +73,7 @@ extern const struct file_operations	vxfs
 extern int			vxfs_read_olt(struct super_block *, u_long);
 
 /* vxfs_subr.c */
+extern const struct address_space_operations vxfs_aops;
 extern struct page *		vxfs_get_page(struct address_space *, u_long);
 extern void			vxfs_put_page(struct page *);
 extern struct buffer_head *	vxfs_bread(struct inode *, int);
diff -puN fs/freevxfs/vxfs_immed.c~fs-freevxfs-proper-externs fs/freevxfs/vxfs_immed.c
--- a/fs/freevxfs/vxfs_immed.c~fs-freevxfs-proper-externs
+++ a/fs/freevxfs/vxfs_immed.c
@@ -35,6 +35,7 @@
 #include <linux/namei.h>
 
 #include "vxfs.h"
+#include "vxfs_extern.h"
 #include "vxfs_inode.h"
 
 
diff -puN fs/freevxfs/vxfs_inode.c~fs-freevxfs-proper-externs fs/freevxfs/vxfs_inode.c
--- a/fs/freevxfs/vxfs_inode.c~fs-freevxfs-proper-externs
+++ a/fs/freevxfs/vxfs_inode.c
@@ -41,11 +41,6 @@
 #include "vxfs_extern.h"
 
 
-extern const struct address_space_operations vxfs_aops;
-extern const struct address_space_operations vxfs_immed_aops;
-
-extern const struct inode_operations vxfs_immed_symlink_iops;
-
 struct kmem_cache		*vxfs_inode_cachep;
 
 
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
