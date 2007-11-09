From: akpm@linux-foundation.org
Subject: - make-jffs2_get_acl-static.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:13:15 -0800
Message-ID: <200711091913.lA9JDFlw027995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755331AbXKITNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:13:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, dwmw2@infradead.org, kaigai@ak.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     make jffs2_get_acl() static
has been removed from the -mm tree.  Its filename was
     make-jffs2_get_acl-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make jffs2_get_acl() static
From: Adrian Bunk <bunk@kernel.org>

jffs2_get_acl() can now become static again.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/acl.c |    2 +-
 fs/jffs2/acl.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/jffs2/acl.c~make-jffs2_get_acl-static fs/jffs2/acl.c
--- a/fs/jffs2/acl.c~make-jffs2_get_acl-static
+++ a/fs/jffs2/acl.c
@@ -176,7 +176,7 @@ static void jffs2_iset_acl(struct inode 
 	spin_unlock(&inode->i_lock);
 }
 
-struct posix_acl *jffs2_get_acl(struct inode *inode, int type)
+static struct posix_acl *jffs2_get_acl(struct inode *inode, int type)
 {
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 	struct posix_acl *acl;
diff -puN fs/jffs2/acl.h~make-jffs2_get_acl-static fs/jffs2/acl.h
--- a/fs/jffs2/acl.h~make-jffs2_get_acl-static
+++ a/fs/jffs2/acl.h
@@ -28,7 +28,6 @@ struct jffs2_acl_header {
 
 #define JFFS2_ACL_NOT_CACHED ((void *)-1)
 
-extern struct posix_acl *jffs2_get_acl(struct inode *inode, int type);
 extern int jffs2_permission(struct inode *, int, struct nameidata *);
 extern int jffs2_acl_chmod(struct inode *);
 extern int jffs2_init_acl_pre(struct inode *, struct inode *, int *);
@@ -40,7 +39,6 @@ extern struct xattr_handler jffs2_acl_de
 
 #else
 
-#define jffs2_get_acl(inode, type)		(NULL)
 #define jffs2_permission			(NULL)
 #define jffs2_acl_chmod(inode)			(0)
 #define jffs2_init_acl_pre(dir_i,inode,mode)	(0)
_

Patches currently in -mm which might be from bunk@kernel.org are

lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
git-avr32.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-mtd.patch
git-net.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
git-ocfs2.patch
proper-prototype-for-kernel-schedcmigration_init.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
