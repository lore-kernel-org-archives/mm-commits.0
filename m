From: akpm@linux-foundation.org
Subject: - reiser4-possible-cleanups-2.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:24 -0800
Message-ID: <200703060200.l2620OqX008726@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46753 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965700AbXCFCDl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:03:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, reiser@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     fs/reiser4/: possible cleanups
has been removed from the -mm tree.  Its filename was
     reiser4-possible-cleanups-2.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: fs/reiser4/: possible cleanups
From: Adrian Bunk <bunk@stusta.de>

- make the following needlessly global function static:
  - plugin/file/file.c: hint_validate()

- #if 0 the following unused global function:
  - jnode.c: page_detach_jnode()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/jnode.c            |    2 ++
 fs/reiser4/jnode.h            |    3 ---
 fs/reiser4/plugin/file/file.c |    4 +++-
 fs/reiser4/plugin/file/file.h |    2 --
 4 files changed, 5 insertions(+), 6 deletions(-)

diff -puN fs/reiser4/jnode.c~reiser4-possible-cleanups-2 fs/reiser4/jnode.c
--- a/fs/reiser4/jnode.c~reiser4-possible-cleanups-2
+++ a/fs/reiser4/jnode.c
@@ -697,6 +697,7 @@ void page_clear_jnode(struct page *page,
 	page_cache_release(page);
 }
 
+#if 0
 /* it is only used in one place to handle error */
 void
 page_detach_jnode(struct page *page, struct address_space *mapping,
@@ -716,6 +717,7 @@ page_detach_jnode(struct page *page, str
 	}
 	unlock_page(page);
 }
+#endif  /*  0  */
 
 /* return @node page locked.
 
diff -puN fs/reiser4/jnode.h~reiser4-possible-cleanups-2 fs/reiser4/jnode.h
--- a/fs/reiser4/jnode.h~reiser4-possible-cleanups-2
+++ a/fs/reiser4/jnode.h
@@ -486,9 +486,6 @@ static inline int jnode_is_loaded(const 
 	return atomic_read(&node->d_count) > 0;
 }
 
-extern void page_detach_jnode(struct page *page,
-			      struct address_space *mapping,
-			      unsigned long index) NONNULL;
 extern void page_clear_jnode(struct page *page, jnode * node) NONNULL;
 
 static inline void jnode_set_reloc(jnode * node)
diff -puN fs/reiser4/plugin/file/file.c~reiser4-possible-cleanups-2 fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-possible-cleanups-2
+++ a/fs/reiser4/plugin/file/file.c
@@ -25,6 +25,8 @@
 
 static int unpack(struct file *file, struct inode *inode, int forever);
 static void drop_access(unix_file_info_t *);
+static int hint_validate(hint_t * hint, const reiser4_key * key, int check_key,
+			 znode_lock_mode lock_mode);
 
 /* get unix file plugin specific portion of inode */
 unix_file_info_t *unix_file_inode_data(const struct inode *inode)
@@ -746,7 +748,7 @@ static int all_but_offset_key_eq(const r
 }
 #endif
 
-int
+static int
 hint_validate(hint_t * hint, const reiser4_key * key, int check_key,
 	      znode_lock_mode lock_mode)
 {
diff -puN fs/reiser4/plugin/file/file.h~reiser4-possible-cleanups-2 fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-possible-cleanups-2
+++ a/fs/reiser4/plugin/file/file.h
@@ -155,8 +155,6 @@ struct hint {
 void reiser4_set_hint(hint_t *, const reiser4_key *, znode_lock_mode);
 int hint_is_set(const hint_t *);
 void reiser4_unset_hint(hint_t *);
-int hint_validate(hint_t *, const reiser4_key *, int check_key,
-		  znode_lock_mode);
 void hint_init_zero(hint_t *);
 
 int reiser4_update_file_size(struct inode *, reiser4_key *, int update_sd);
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
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
