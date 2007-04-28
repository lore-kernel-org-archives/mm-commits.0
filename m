From: akpm@linux-foundation.org
Subject: - fs-ocfs2-make-3-functions-static.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:54:22 -0700
Message-ID: <200704281054.l3SAsMQZ020123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965724AbXD1Kyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:54:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     fs/ocfs2/: make 3 functions static
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-make-3-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/ocfs2/: make 3 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes the following needlessly global functions static:
- aops.c: ocfs2_write_data_page()
- dlmglue.c: ocfs2_dump_meta_lvb_info()
- file.c: ocfs2_set_inode_size()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c    |    6 ++--
 fs/ocfs2/dlmglue.c |   54 +++++++++++++++++++++++--------------------
 fs/ocfs2/dlmglue.h |    7 -----
 fs/ocfs2/file.c    |    8 +++---
 fs/ocfs2/file.h    |    5 ---
 5 files changed, 36 insertions(+), 44 deletions(-)

diff -puN fs/ocfs2/aops.c~fs-ocfs2-make-3-functions-static fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~fs-ocfs2-make-3-functions-static
+++ a/fs/ocfs2/aops.c
@@ -939,9 +939,9 @@ out:
  * Returns a negative error code or the number of bytes copied into
  * the page.
  */
-int ocfs2_write_data_page(struct inode *inode, handle_t *handle,
-			  u64 *p_blkno, struct page *page,
-			  struct ocfs2_write_ctxt *wc, int new)
+static int ocfs2_write_data_page(struct inode *inode, handle_t *handle,
+				 u64 *p_blkno, struct page *page,
+				 struct ocfs2_write_ctxt *wc, int new)
 {
 	int ret, copied = 0;
 	unsigned int from = 0, to = 0;
diff -puN fs/ocfs2/dlmglue.c~fs-ocfs2-make-3-functions-static fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~fs-ocfs2-make-3-functions-static
+++ a/fs/ocfs2/dlmglue.c
@@ -104,6 +104,35 @@ static int ocfs2_dentry_convert_worker(s
 static void ocfs2_dentry_post_unlock(struct ocfs2_super *osb,
 				     struct ocfs2_lock_res *lockres);
 
+
+#define mlog_meta_lvb(__level, __lockres) ocfs2_dump_meta_lvb_info(__level, __PRETTY_FUNCTION__, __LINE__, __lockres)
+
+/* This aids in debugging situations where a bad LVB might be involved. */
+static void ocfs2_dump_meta_lvb_info(u64 level,
+				     const char *function,
+				     unsigned int line,
+				     struct ocfs2_lock_res *lockres)
+{
+	struct ocfs2_meta_lvb *lvb = (struct ocfs2_meta_lvb *) lockres->l_lksb.lvb;
+
+	mlog(level, "LVB information for %s (called from %s:%u):\n",
+	     lockres->l_name, function, line);
+	mlog(level, "version: %u, clusters: %u, generation: 0x%x\n",
+	     lvb->lvb_version, be32_to_cpu(lvb->lvb_iclusters),
+	     be32_to_cpu(lvb->lvb_igeneration));
+	mlog(level, "size: %llu, uid %u, gid %u, mode 0x%x\n",
+	     (unsigned long long)be64_to_cpu(lvb->lvb_isize),
+	     be32_to_cpu(lvb->lvb_iuid), be32_to_cpu(lvb->lvb_igid),
+	     be16_to_cpu(lvb->lvb_imode));
+	mlog(level, "nlink %u, atime_packed 0x%llx, ctime_packed 0x%llx, "
+	     "mtime_packed 0x%llx iattr 0x%x\n", be16_to_cpu(lvb->lvb_inlink),
+	     (long long)be64_to_cpu(lvb->lvb_iatime_packed),
+	     (long long)be64_to_cpu(lvb->lvb_ictime_packed),
+	     (long long)be64_to_cpu(lvb->lvb_imtime_packed),
+	     be32_to_cpu(lvb->lvb_iattr));
+}
+
+
 /*
  * OCFS2 Lock Resource Operations
  *
@@ -3076,28 +3105,3 @@ static void ocfs2_schedule_blocked_lock(
 
 	mlog_exit_void();
 }
-
-/* This aids in debugging situations where a bad LVB might be involved. */
-void ocfs2_dump_meta_lvb_info(u64 level,
-			      const char *function,
-			      unsigned int line,
-			      struct ocfs2_lock_res *lockres)
-{
-	struct ocfs2_meta_lvb *lvb = (struct ocfs2_meta_lvb *) lockres->l_lksb.lvb;
-
-	mlog(level, "LVB information for %s (called from %s:%u):\n",
-	     lockres->l_name, function, line);
-	mlog(level, "version: %u, clusters: %u, generation: 0x%x\n",
-	     lvb->lvb_version, be32_to_cpu(lvb->lvb_iclusters),
-	     be32_to_cpu(lvb->lvb_igeneration));
-	mlog(level, "size: %llu, uid %u, gid %u, mode 0x%x\n",
-	     (unsigned long long)be64_to_cpu(lvb->lvb_isize),
-	     be32_to_cpu(lvb->lvb_iuid), be32_to_cpu(lvb->lvb_igid),
-	     be16_to_cpu(lvb->lvb_imode));
-	mlog(level, "nlink %u, atime_packed 0x%llx, ctime_packed 0x%llx, "
-	     "mtime_packed 0x%llx iattr 0x%x\n", be16_to_cpu(lvb->lvb_inlink),
-	     (long long)be64_to_cpu(lvb->lvb_iatime_packed),
-	     (long long)be64_to_cpu(lvb->lvb_ictime_packed),
-	     (long long)be64_to_cpu(lvb->lvb_imtime_packed),
-	     be32_to_cpu(lvb->lvb_iattr));
-}
diff -puN fs/ocfs2/dlmglue.h~fs-ocfs2-make-3-functions-static fs/ocfs2/dlmglue.h
--- a/fs/ocfs2/dlmglue.h~fs-ocfs2-make-3-functions-static
+++ a/fs/ocfs2/dlmglue.h
@@ -119,11 +119,4 @@ void ocfs2_process_blocked_lock(struct o
 struct ocfs2_dlm_debug *ocfs2_new_dlm_debug(void);
 void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
 
-/* aids in debugging and tracking lvbs */
-void ocfs2_dump_meta_lvb_info(u64 level,
-			      const char *function,
-			      unsigned int line,
-			      struct ocfs2_lock_res *lockres);
-#define mlog_meta_lvb(__level, __lockres) ocfs2_dump_meta_lvb_info(__level, __PRETTY_FUNCTION__, __LINE__, __lockres)
-
 #endif	/* DLMGLUE_H */
diff -puN fs/ocfs2/file.c~fs-ocfs2-make-3-functions-static fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~fs-ocfs2-make-3-functions-static
+++ a/fs/ocfs2/file.c
@@ -207,10 +207,10 @@ out:
 	return ret;
 }
 
-int ocfs2_set_inode_size(handle_t *handle,
-			 struct inode *inode,
-			 struct buffer_head *fe_bh,
-			 u64 new_i_size)
+static int ocfs2_set_inode_size(handle_t *handle,
+				struct inode *inode,
+				struct buffer_head *fe_bh,
+				u64 new_i_size)
 {
 	int status;
 
diff -puN fs/ocfs2/file.h~fs-ocfs2-make-3-functions-static fs/ocfs2/file.h
--- a/fs/ocfs2/file.h~fs-ocfs2-make-3-functions-static
+++ a/fs/ocfs2/file.h
@@ -56,11 +56,6 @@ int ocfs2_getattr(struct vfsmount *mnt, 
 int ocfs2_permission(struct inode *inode, int mask,
 		     struct nameidata *nd);
 
-int ocfs2_set_inode_size(handle_t *handle,
-			 struct inode *inode,
-			 struct buffer_head *fe_bh,
-			 u64 new_i_size);
-
 int ocfs2_should_update_atime(struct inode *inode,
 			      struct vfsmount *vfsmnt);
 int ocfs2_update_inode_atime(struct inode *inode,
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-netdev-all.patch
git-ocfs2.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-ipwireless_cs.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
add-file-position-info-to-proc-fix.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
fix-race-between-rmmod-and-cat-proc-kallsyms-fix.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
ext2-reservations.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
