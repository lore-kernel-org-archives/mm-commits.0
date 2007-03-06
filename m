From: akpm@linux-foundation.org
Subject: - fs-reiser4-more-possible-cleanups.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:04:31 -0800
Message-ID: <200703060204.l2624Vvd008813@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46807 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965724AbXCFCEv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:04:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     fs/reiser4/: more possible cleanups
has been removed from the -mm tree.  Its filename was
     fs-reiser4-more-possible-cleanups.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: fs/reiser4/: more possible cleanups
From: Adrian Bunk <bunk@stusta.de>

- make needlessly global functions static
- #if 0 unused functions
- #if REISER4_DEBUG functions that are only used with debugging enabled

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Vladimir Saveliev <vs@namesys.com>
Cc: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/coord.c                |    8 ++---
 fs/reiser4/debug.c                |    6 ++++
 fs/reiser4/debug.h                |    4 --
 fs/reiser4/plugin/cluster.h       |    8 -----
 fs/reiser4/plugin/item/ctail.c    |   10 ++++++-
 fs/reiser4/plugin/item/ctail.h    |    1 
 fs/reiser4/plugin/item/internal.c |    4 ++
 fs/reiser4/plugin/item/item.c     |    4 ++
 fs/reiser4/super.c                |    4 ++
 fs/reiser4/txnmgr.c               |   40 +++++++++++++++-------------
 fs/reiser4/txnmgr.h               |    6 ----
 11 files changed, 52 insertions(+), 43 deletions(-)

diff -puN fs/reiser4/coord.c~fs-reiser4-more-possible-cleanups fs/reiser4/coord.c
--- a/fs/reiser4/coord.c~fs-reiser4-more-possible-cleanups
+++ a/fs/reiser4/coord.c
@@ -568,11 +568,6 @@ int coord_sideof_unit(coord_t * coord, s
 }
 
 #if REISER4_DEBUG
-#define DEBUG_COORD_FIELDS (sizeof(c1->plug_v) + sizeof(c1->body_v))
-#else
-#define DEBUG_COORD_FIELDS (0)
-#endif
-
 int coords_equal(const coord_t * c1, const coord_t * c2)
 {
 	assert("nikita-2840", c1 != NULL);
@@ -583,6 +578,7 @@ int coords_equal(const coord_t * c1, con
 	    c1->item_pos == c2->item_pos &&
 	    c1->unit_pos == c2->unit_pos && c1->between == c2->between;
 }
+#endif  /*  REISER4_DEBUG  */
 
 /* If coord_is_after_rightmost return NCOORD_ON_THE_RIGHT, if coord_is_after_leftmost
    return NCOORD_ON_THE_LEFT, otherwise return NCOORD_INSIDE. */
@@ -683,6 +679,7 @@ int coord_is_between_items(const coord_t
 	return 0;
 }
 
+#if REISER4_DEBUG
 /* Returns true if the coordinates are positioned at adjacent units, regardless of
    before-after or item boundaries. */
 int coord_are_neighbors(coord_t * c1, coord_t * c2)
@@ -721,6 +718,7 @@ int coord_are_neighbors(coord_t * c1, co
 		return 0;
 	}
 }
+#endif  /*  REISER4_DEBUG  */
 
 /* Assuming two coordinates are positioned in the same node, return COORD_CMP_ON_RIGHT,
    COORD_CMP_ON_LEFT, or COORD_CMP_SAME depending on c1's position relative to c2.  */
diff -puN fs/reiser4/debug.c~fs-reiser4-more-possible-cleanups fs/reiser4/debug.c
--- a/fs/reiser4/debug.c~fs-reiser4-more-possible-cleanups
+++ a/fs/reiser4/debug.c
@@ -40,11 +40,13 @@
 #include <linux/sysctl.h>
 #include <linux/hardirq.h>
 
+#if 0
 #if REISER4_DEBUG
 static void reiser4_report_err(void);
 #else
 #define reiser4_report_err() noop
 #endif
+#endif  /*  0  */
 
 /*
  * global buffer where message given to reiser4_panic is formatted.
@@ -95,6 +97,7 @@ void reiser4_do_panic(const char *format
 	panic("%s", panic_buf);
 }
 
+#if 0
 void
 reiser4_print_prefix(const char *level, int reperr, const char *mid,
 		     const char *function, const char *file, int lineno)
@@ -114,6 +117,7 @@ reiser4_print_prefix(const char *level, 
 	if (reperr)
 		reiser4_report_err();
 }
+#endif  /*  0  */
 
 /* Preemption point: this should be called periodically during long running
    operations (carry, allocate, and squeeze are best examples) */
@@ -258,6 +262,7 @@ void reiser4_return_err(int code, const 
 	}
 }
 
+#if 0
 /*
  * report error information recorder by reiser4_return_err().
  */
@@ -272,6 +277,7 @@ static void reiser4_report_err(void)
 		}
 	}
 }
+#endif  /*  0  */
 
 #endif				/* REISER4_DEBUG */
 
diff -puN fs/reiser4/debug.h~fs-reiser4-more-possible-cleanups fs/reiser4/debug.h
--- a/fs/reiser4/debug.h~fs-reiser4-more-possible-cleanups
+++ a/fs/reiser4/debug.h
@@ -223,10 +223,6 @@ extern int is_in_reiser4_context(void);
 extern void reiser4_do_panic(const char *format, ...)
     __attribute__ ((noreturn, format(printf, 1, 2)));
 
-extern void reiser4_print_prefix(const char *level, int reperr, const char *mid,
-				 const char *function,
-				 const char *file, int lineno);
-
 extern int reiser4_preempt_point(void);
 extern void reiser4_print_stats(void);
 
diff -puN fs/reiser4/plugin/cluster.h~fs-reiser4-more-possible-cleanups fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~fs-reiser4-more-possible-cleanups
+++ a/fs/reiser4/plugin/cluster.h
@@ -226,14 +226,6 @@ static inline int dclust_get_extension_s
 	return hint->ext_coord.extension.ctail.shift;
 }
 
-static inline void dclust_set_extension_shift(hint_t * hint)
-{
-	assert("edward-1270",
-	       item_id_by_coord(&hint->ext_coord.coord) == CTAIL_ID);
-	hint->ext_coord.extension.ctail.shift =
-	    cluster_shift_by_coord(&hint->ext_coord.coord);
-}
-
 static inline int hint_is_unprepped_dclust(hint_t * hint)
 {
 	assert("edward-1451", hint_is_valid(hint));
diff -puN fs/reiser4/plugin/item/ctail.c~fs-reiser4-more-possible-cleanups fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~fs-reiser4-more-possible-cleanups
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -45,11 +45,19 @@ static ctail_item_format *ctail_formatte
 	return item_body_by_coord(coord);
 }
 
-int cluster_shift_by_coord(const coord_t * coord)
+static int cluster_shift_by_coord(const coord_t * coord)
 {
 	return get_unaligned(&ctail_formatted_at(coord)->cluster_shift);
 }
 
+static inline void dclust_set_extension_shift(hint_t * hint)
+{
+	assert("edward-1270",
+	       item_id_by_coord(&hint->ext_coord.coord) == CTAIL_ID);
+	hint->ext_coord.extension.ctail.shift =
+	    cluster_shift_by_coord(&hint->ext_coord.coord);
+}
+
 static loff_t off_by_coord(const coord_t * coord)
 {
 	reiser4_key key;
diff -puN fs/reiser4/plugin/item/ctail.h~fs-reiser4-more-possible-cleanups fs/reiser4/plugin/item/ctail.h
--- a/fs/reiser4/plugin/item/ctail.h~fs-reiser4-more-possible-cleanups
+++ a/fs/reiser4/plugin/item/ctail.h
@@ -78,7 +78,6 @@ int utmost_child_ctail(const coord_t *, 
 int scan_ctail(flush_scan *);
 int convert_ctail(flush_pos_t *);
 size_t inode_scaled_cluster_size(struct inode *);
-int cluster_shift_by_coord(const coord_t * coord);
 
 #endif				/* __FS_REISER4_CTAIL_H__ */
 
diff -puN fs/reiser4/plugin/item/internal.c~fs-reiser4-more-possible-cleanups fs/reiser4/plugin/item/internal.c
--- a/fs/reiser4/plugin/item/internal.c~fs-reiser4-more-possible-cleanups
+++ a/fs/reiser4/plugin/item/internal.c
@@ -144,6 +144,8 @@ utmost_child_internal(const coord_t * co
 	return 0;
 }
 
+#if REISER4_DEBUG
+
 static void check_link(znode * left, znode * right)
 {
 	znode *scan;
@@ -209,6 +211,8 @@ int check__internal(const coord_t * coor
 	return 0;
 }
 
+#endif  /*  REISER4_DEBUG  */
+
 /* return true only if this item really points to "block" */
 /* Audited by: green(2002.06.14) */
 int has_pointer_to_internal(const coord_t * coord /* coord of item */ ,
diff -puN fs/reiser4/plugin/item/item.c~fs-reiser4-more-possible-cleanups fs/reiser4/plugin/item/item.c
--- a/fs/reiser4/plugin/item/item.c~fs-reiser4-more-possible-cleanups
+++ a/fs/reiser4/plugin/item/item.c
@@ -271,6 +271,8 @@ int item_is_tail(const coord_t * item)
 	return item_id_by_coord(item) == FORMATTING_ID;
 }
 
+#if REISER4_DEBUG
+
 int item_is_statdata(const coord_t * item)
 {
 	assert("vs-516", coord_is_existing_item(item));
@@ -283,6 +285,8 @@ int item_is_ctail(const coord_t * item)
 	return item_id_by_coord(item) == CTAIL_ID;
 }
 
+#endif  /*  REISER4_DEBUG  */
+
 static int change_item(struct inode *inode,
 		       reiser4_plugin * plugin,
 		       pset_member memb)
diff -puN fs/reiser4/super.c~fs-reiser4-more-possible-cleanups fs/reiser4/super.c
--- a/fs/reiser4/super.c~fs-reiser4-more-possible-cleanups
+++ a/fs/reiser4/super.c
@@ -47,6 +47,7 @@ __u64 reiser4_block_count(const struct s
 	return get_super_private(super)->block_count;
 }
 
+#if REISER4_DEBUG
 /*
  * number of blocks in the current file system
  */
@@ -54,6 +55,7 @@ __u64 reiser4_current_block_count(void)
 {
 	return get_current_super_private()->block_count;
 }
+#endif  /*  REISER4_DEBUG  */
 
 /* set number of block in filesystem */
 void reiser4_set_block_count(const struct super_block *super, __u64 nr)
@@ -293,6 +295,7 @@ reiser4_blocknr_is_sane_for(const struct
 	return *blk < sbinfo->block_count;
 }
 
+#if REISER4_DEBUG
 /*
  * true, if block number @blk makes sense for the current file system
  */
@@ -300,6 +303,7 @@ int reiser4_blocknr_is_sane(const reiser
 {
 	return reiser4_blocknr_is_sane_for(reiser4_get_current_sb(), blk);
 }
+#endif  /*  REISER4_DEBUG  */
 
 /* Make Linus happy.
    Local variables:
diff -puN fs/reiser4/txnmgr.c~fs-reiser4-more-possible-cleanups fs/reiser4/txnmgr.c
--- a/fs/reiser4/txnmgr.c~fs-reiser4-more-possible-cleanups
+++ a/fs/reiser4/txnmgr.c
@@ -977,6 +977,28 @@ static int current_atom_complete_writes(
 	return current_atom_finish_all_fq();
 }
 
+#if REISER4_DEBUG
+
+static void reiser4_info_atom(const char *prefix, const txn_atom * atom)
+{
+	if (atom == NULL) {
+		printk("%s: no atom\n", prefix);
+		return;
+	}
+
+	printk("%s: refcount: %i id: %i flags: %x txnh_count: %i"
+	       " capture_count: %i stage: %x start: %lu, flushed: %i\n", prefix,
+	       atomic_read(&atom->refcount), atom->atom_id, atom->flags,
+	       atom->txnh_count, atom->capture_count, atom->stage,
+	       atom->start_time, atom->flushed);
+}
+
+#else  /*  REISER4_DEBUG  */
+
+static inline void reiser4_info_atom(const char *prefix, const txn_atom * atom) {}
+
+#endif  /*  REISER4_DEBUG  */
+
 #define TOOMANYFLUSHES (1 << 13)
 
 /* Called with the atom locked and no open "active" transaction handlers except
@@ -3094,24 +3116,6 @@ void insert_into_atom_ovrwr_list(txn_ato
 	ON_DEBUG(count_jnode(atom, node, NODE_LIST(node), OVRWR_LIST, 1));
 }
 
-#if REISER4_DEBUG
-
-void reiser4_info_atom(const char *prefix, const txn_atom * atom)
-{
-	if (atom == NULL) {
-		printk("%s: no atom\n", prefix);
-		return;
-	}
-
-	printk("%s: refcount: %i id: %i flags: %x txnh_count: %i"
-	       " capture_count: %i stage: %x start: %lu, flushed: %i\n", prefix,
-	       atomic_read(&atom->refcount), atom->atom_id, atom->flags,
-	       atom->txnh_count, atom->capture_count, atom->stage,
-	       atom->start_time, atom->flushed);
-}
-
-#endif
-
 static int count_deleted_blocks_actor(txn_atom * atom,
 				      const reiser4_block_nr * a,
 				      const reiser4_block_nr * b, void *data)
diff -puN fs/reiser4/txnmgr.h~fs-reiser4-more-possible-cleanups fs/reiser4/txnmgr.h
--- a/fs/reiser4/txnmgr.h~fs-reiser4-more-possible-cleanups
+++ a/fs/reiser4/txnmgr.h
@@ -695,12 +695,6 @@ void protected_jnodes_init(protected_jno
 void protected_jnodes_done(protected_jnodes * list);
 void reiser4_invalidate_list(struct list_head * head);
 
-#if REISER4_DEBUG
-void reiser4_info_atom(const char *prefix, const txn_atom * atom);
-#else
-#define reiser4_info_atom(p,a) noop
-#endif
-
 # endif				/* __REISER4_TXNMGR_H__ */
 
 /* Make Linus happy.
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
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
