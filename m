From: akpm@linux-foundation.org
Subject: - fs-reiser4-possible-cleanups-2.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:04:28 -0800
Message-ID: <200703060204.l2624SYS008810@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46896 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965726AbXCFCHo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:07:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     fs/reiser4/: possible cleanups
has been removed from the -mm tree.  Its filename was
     fs-reiser4-possible-cleanups-2.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: fs/reiser4/: possible cleanups
From: Adrian Bunk <bunk@stusta.de>

- make the following needlessly global functions statis:
  - plugin/file/file_conversion.c: prepped_dclust_ok()
  - plugin/file/file_conversion.c: cryptcompress2unixfile()

- #if 0 the following unused global functions:
  - plugin/file/cryptcompress.c: prepare_write_cryptcompress()
  - plugin/file/file_conversion.c: prot_delete_object_cryptcompress()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/file/cryptcompress.c   |    2 ++
 fs/reiser4/plugin/file/file.h            |    3 ---
 fs/reiser4/plugin/file/file_conversion.c |    8 +++++---
 3 files changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~fs-reiser4-possible-cleanups-2 fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~fs-reiser4-possible-cleanups-2
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -3769,11 +3769,13 @@ int release_cryptcompress(struct inode *
 	return 0;
 }
 
+#if 0
 int prepare_write_cryptcompress(struct file *file, struct page *page,
 				unsigned from, unsigned to)
 {
 	return prepare_write_common(file, page, from, to);
 }
+#endif  /*  0  */
 
 
 /*
diff -puN fs/reiser4/plugin/file/file.h~fs-reiser4-possible-cleanups-2 fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~fs-reiser4-possible-cleanups-2
+++ a/fs/reiser4/plugin/file/file.h
@@ -203,8 +203,6 @@ ssize_t read_cryptcompress(struct file *
 ssize_t prot_read_cryptcompress(struct file *, char __user *buf,
 				size_t read_amount, loff_t * off);
 
-int prepare_write_cryptcompress(struct file *file, struct page *page,
-				unsigned from, unsigned to);
 ssize_t write_cryptcompress(struct file *, const char __user *buf, size_t write_amount,
 			    loff_t * off, int * conv);
 ssize_t prot_write_cryptcompress(struct file *, const char __user *buf, size_t write_amount,
@@ -230,7 +228,6 @@ int key_by_inode_cryptcompress(struct in
 int create_cryptcompress(struct inode *, struct inode *,
 			 reiser4_object_create_data *);
 int delete_object_cryptcompress(struct inode *);
-int prot_delete_object_cryptcompress(struct inode *);
 void init_inode_data_cryptcompress(struct inode *, reiser4_object_create_data *,
 				   int create);
 int cut_tree_worker_cryptcompress(tap_t *, const reiser4_key * from_key,
diff -puN fs/reiser4/plugin/file/file_conversion.c~fs-reiser4-possible-cleanups-2 fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~fs-reiser4-possible-cleanups-2
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -247,7 +247,7 @@ static void finish_check_compressibility
 }
 
 #if REISER4_DEBUG
-int prepped_dclust_ok(hint_t * hint)
+static int prepped_dclust_ok(hint_t * hint)
 {
 	reiser4_key key;
 	coord_t * coord = &hint->ext_coord.coord;
@@ -418,8 +418,8 @@ static int complete_file_conversion(stru
 
 
 /* do conversion */
-int cryptcompress2unixfile(struct file *file, struct inode * inode,
-			   reiser4_cluster_t * clust)
+static int cryptcompress2unixfile(struct file *file, struct inode * inode,
+				  reiser4_cluster_t * clust)
 {
 	int i;
 	int result = 0;
@@ -585,10 +585,12 @@ ssize_t prot_sendfile_cryptcompress(stru
 			    (file, ppos, count, actor, target));
 }
 
+#if 0
 int prot_delete_object_cryptcompress(struct inode *inode)
 {
 	return PROT_PASSIVE(int, delete_object, (inode));
 }
+#endif  /*  0  */
 
 /*
   Local variables:
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
