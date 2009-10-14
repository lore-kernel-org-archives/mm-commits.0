From: akpm@linux-foundation.org
Subject: + reiser4-drop-journal-info.patch added to -mm tree
Date: Tue, 13 Oct 2009 19:56:38 -0700
Message-ID: <200910140256.n9E2ucD5020492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761591AbZJNC5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 22:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com


The patch titled
     reiser4: drop journal info
has been added to the -mm tree.  Its filename is
     reiser4-drop-journal-info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: drop journal info
From: Edward Shishkin <edward.shishkin@gmail.com>

1. Fix up the problem:
Reiser4 steps to the journal code of other journalling file systems:

EXT3 complaints: "called recursively, non-PF_MEMALLOC"
Call Trace:
 [<c0535873>] ext3_write_inode+0x1e/0x3a
 [<c04b16bc>] __writeback_single_inode+0x193/0x2ad
 [<c0508d86>] ? flush_some_atom+0x427/0x44d
 [<c04b1bb5>] ? generic_sync_sb_inodes+0x27c/0x338
 [<c04b1b68>] generic_sync_sb_inodes+0x22f/0x338
 [<c04b1c8e>] sync_sb_inodes+0x1d/0x20
 [<c04b1e1e>] writeback_inodes+0x79/0xb9
 [<c047c76a>] balance_dirty_pages_ratelimited_nr+0x119/0x21d
 [<c0504803>] reiser4_exit_context+0x5f/0xf6
 [<c051e5a3>] reiser4_write_careful+0x3ba/0x3cc
 [<c049bc3c>] ? do_sync_read+0xab/0xe9
 [<c0613dae>] ? selinux_file_permission+0x44/0x48
 [<c060fea6>] ? security_file_permission+0xf/0x11
 [<c051e1e9>] ? reiser4_write_careful+0x0/0x3cc
 [<c049c494>] vfs_write+0x84/0xdf
 [<c049c588>] sys_write+0x3b/0x60
 [<c0403178>] sysenter_do_call+0x12/0x2d

Solution:
Drop current->journal_info before calling
balance_dirty_pages_ratelimited().

2. Update comments in plugin_header.h

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/context.c                     |   13 +++---
 fs/reiser4/plugin/file/cryptcompress.c   |    3 -
 fs/reiser4/plugin/file/file.c            |    9 +---
 fs/reiser4/plugin/file/tail_conversion.c |   14 +++++--
 fs/reiser4/plugin/item/tail.h            |    2 -
 fs/reiser4/plugin/plugin_header.h        |   42 ++++++++-------------
 fs/reiser4/txnmgr.c                      |    3 +
 fs/reiser4/vfs_ops.c                     |   12 ++++--
 fs/reiser4/vfs_ops.h                     |    2 -
 9 files changed, 49 insertions(+), 51 deletions(-)

diff -puN fs/reiser4/context.c~reiser4-drop-journal-info fs/reiser4/context.c
--- a/fs/reiser4/context.c~reiser4-drop-journal-info
+++ a/fs/reiser4/context.c
@@ -37,8 +37,8 @@
 #include "debug.h"
 #include "super.h"
 #include "context.h"
+#include "vfs_ops.h"	/* for reiser4_throttle_write() */
 
-#include <linux/writeback.h>	/* balance_dirty_pages() */
 #include <linux/hardirq.h>
 
 static void _reiser4_init_context(reiser4_context * context,
@@ -139,7 +139,7 @@ int is_in_reiser4_context(void)
  * because some important lock (like ->i_mutex on the parent directory) is
  * held. To achieve this, ->nobalance flag can be set in the current context.
  */
-static void balance_dirty_pages_at(reiser4_context *context)
+static void reiser4_throttle_write_at(reiser4_context *context)
 {
 	reiser4_super_info_data *sbinfo = get_super_private(context->super);
 
@@ -152,7 +152,8 @@ static void balance_dirty_pages_at(reise
 	if (sbinfo != NULL && sbinfo->fake != NULL &&
 	    context->nr_marked_dirty != 0 &&
 	    !(current->flags & PF_MEMALLOC))
-		balance_dirty_pages_ratelimited(sbinfo->fake->i_mapping);
+		/* FIXME-EDWARD: throttle with nr_marked_dirty? */
+		reiser4_throttle_write(sbinfo->fake, 1);
 }
 
 /* release resources associated with context.
@@ -225,10 +226,8 @@ void reiser4_exit_context(reiser4_contex
 	assert("nikita-3021", reiser4_schedulable());
 
 	if (context->nr_children == 0) {
-		if (!context->nobalance) {
-			reiser4_txn_restart(context);
-			balance_dirty_pages_at(context);
-		}
+		if (!context->nobalance)
+			reiser4_throttle_write_at(context);
 
 		/* if filesystem is mounted with -o sync or -o dirsync - commit
 		   transaction.  FIXME: TXNH_DONT_COMMIT is used to avoid
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-drop-journal-info fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-drop-journal-info
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -1973,8 +1973,7 @@ static int balance_dirty_page_cluster(st
 	info = cryptcompress_inode_data(inode);
 
 	mutex_unlock(&info->checkin_mutex);
-	reiser4_txn_restart_current();
-	balance_dirty_pages_ratelimited_nr(inode->i_mapping, nr_dirtied);
+	reiser4_throttle_write(inode, nr_dirtied);
 	mutex_lock(&info->checkin_mutex);
 	return 0;
 }
diff -puN fs/reiser4/plugin/file/file.c~reiser4-drop-journal-info fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-drop-journal-info
+++ a/fs/reiser4/plugin/file/file.c
@@ -2227,16 +2227,13 @@ ssize_t write_unix_file(struct file *fil
 		}
 		drop_access(uf_info);
 		ea = NEITHER_OBTAINED;
-		reiser4_txn_restart(ctx);
-		current->journal_info = NULL;
+
 		/*
 		 * tell VM how many pages were dirtied. Maybe number of pages
 		 * which were dirty already should not be counted
 		 */
-		balance_dirty_pages_ratelimited_nr(inode->i_mapping,
-						   (written + PAGE_CACHE_SIZE - 1) / PAGE_CACHE_SIZE);
-		current->journal_info = ctx;
-
+		reiser4_throttle_write(inode,
+			     (written + PAGE_CACHE_SIZE - 1) / PAGE_CACHE_SIZE);
 		left -= written;
 		buf += written;
 		*pos += written;
diff -puN fs/reiser4/plugin/file/tail_conversion.c~reiser4-drop-journal-info fs/reiser4/plugin/file/tail_conversion.c
--- a/fs/reiser4/plugin/file/tail_conversion.c~reiser4-drop-journal-info
+++ a/fs/reiser4/plugin/file/tail_conversion.c
@@ -486,8 +486,10 @@ int tail2extent(struct unix_file_info *u
 			 * on partially converted files.
 			 */
 			drop_exclusive_access(uf_info);
-			/* throttle the conversion */
-			reiser4_throttle_write(inode);
+			/* throttle the conversion
+			   FIXME-EDWARD: Pass the precise number of pages
+			   that was dirtied */
+			reiser4_throttle_write(inode, 1);
 			get_exclusive_access(uf_info);
 
 			/*
@@ -685,8 +687,12 @@ int extent2tail(struct file * file, stru
 		page_cache_release(page);
 
 		drop_exclusive_access(uf_info);
-		/* throttle the conversion */
-		reiser4_throttle_write(inode);
+		/*
+		 * throttle the conversion.
+		 * FIXME-EDWARD: Calculate and pass the precise number
+		 * of pages that was dirtied
+		 */
+		reiser4_throttle_write(inode, 1);
 		get_exclusive_access(uf_info);
 		/*
 		 * nobody is allowed to complete conversion but a process which
diff -puN fs/reiser4/plugin/item/tail.h~reiser4-drop-journal-info fs/reiser4/plugin/item/tail.h
--- a/fs/reiser4/plugin/item/tail.h~reiser4-drop-journal-info
+++ a/fs/reiser4/plugin/item/tail.h
@@ -40,8 +40,6 @@ int readpage_tail(void *vp, struct page 
 reiser4_key *append_key_tail(const coord_t *, reiser4_key *);
 void init_coord_extension_tail(uf_coord_t *, loff_t offset);
 int get_block_address_tail(const coord_t *, sector_t, sector_t *);
-int item_balance_dirty_pages(struct address_space *, const flow_t *,
-			     hint_t *, int back_to_dirty, int set_hint);
 
 /* __REISER4_TAIL_H__ */
 #endif
diff -puN fs/reiser4/plugin/plugin_header.h~reiser4-drop-journal-info fs/reiser4/plugin/plugin_header.h
--- a/fs/reiser4/plugin/plugin_header.h~reiser4-drop-journal-info
+++ a/fs/reiser4/plugin/plugin_header.h
@@ -10,32 +10,24 @@
 #include "../debug.h"
 #include "../dformat.h"
 
-/* Every plugin type can be considered as a class of virtual objects
-   {(type, i) | i = 0, 1, ...}, which has one the following categories
-   of virtualization:
-   A - no virtualization;
-   F - per-file virtualization;
-   S - per-superblock virtualization;
-   FIXME-EDWARD: Define every such category */
-
-/* Supported plugin types: (id, (virtualization category), short description) */
+/* The list of Reiser4 interfaces */
 typedef enum {
-	REISER4_FILE_PLUGIN_TYPE,             /* (F) service VFS enry-points */
-	REISER4_DIR_PLUGIN_TYPE,              /* (F) service VFS enry-points */
-	REISER4_ITEM_PLUGIN_TYPE,             /* (F) manage items */
-	REISER4_NODE_PLUGIN_TYPE,             /* (S) manage formatted nodes */
-	REISER4_HASH_PLUGIN_TYPE,             /* (F) compute hash */
-	REISER4_FIBRATION_PLUGIN_TYPE,        /* (F) directory fibrations */
-	REISER4_FORMATTING_PLUGIN_TYPE,       /* (F) tail-packing policy */
-	REISER4_PERM_PLUGIN_TYPE,             /*       stub (vacancy)     */
-	REISER4_SD_EXT_PLUGIN_TYPE,           /* (A) stat-data extensions */
-	REISER4_FORMAT_PLUGIN_TYPE,           /* (S) specify disk format */
-	REISER4_JNODE_PLUGIN_TYPE,            /* (A) in-memory node headers */
-	REISER4_CIPHER_PLUGIN_TYPE,           /* (F) cipher transform algs */
-	REISER4_DIGEST_PLUGIN_TYPE,           /* (F) digest transform algs */
-	REISER4_COMPRESSION_PLUGIN_TYPE,      /* (F) compression tfm algs */
-	REISER4_COMPRESSION_MODE_PLUGIN_TYPE, /* (F) compression heuristic */
-	REISER4_CLUSTER_PLUGIN_TYPE,          /* (F) size of logical cluster */
+	REISER4_FILE_PLUGIN_TYPE,             /* manage VFS objects */
+	REISER4_DIR_PLUGIN_TYPE,              /* manage directories */
+	REISER4_ITEM_PLUGIN_TYPE,             /* manage items */
+	REISER4_NODE_PLUGIN_TYPE,             /* manage formatted nodes */
+	REISER4_HASH_PLUGIN_TYPE,             /* hash methods */
+	REISER4_FIBRATION_PLUGIN_TYPE,        /* directory fibrations */
+	REISER4_FORMATTING_PLUGIN_TYPE,       /* dispatching policy */
+	REISER4_PERM_PLUGIN_TYPE,             /* stub (vacancy) */
+	REISER4_SD_EXT_PLUGIN_TYPE,           /* manage stat-data extensions */
+	REISER4_FORMAT_PLUGIN_TYPE,           /* disk format specifications */
+	REISER4_JNODE_PLUGIN_TYPE,            /* manage in-memory headers */
+	REISER4_CIPHER_PLUGIN_TYPE,           /* cipher transform methods */
+	REISER4_DIGEST_PLUGIN_TYPE,           /* digest transform methods */
+	REISER4_COMPRESSION_PLUGIN_TYPE,      /* compression methods */
+	REISER4_COMPRESSION_MODE_PLUGIN_TYPE, /* dispatching policies */
+	REISER4_CLUSTER_PLUGIN_TYPE,          /* manage logical clusters */
 	REISER4_PLUGIN_TYPES
 } reiser4_plugin_type;
 
diff -puN fs/reiser4/txnmgr.c~reiser4-drop-journal-info fs/reiser4/txnmgr.c
--- a/fs/reiser4/txnmgr.c~reiser4-drop-journal-info
+++ a/fs/reiser4/txnmgr.c
@@ -2328,7 +2328,8 @@ static void do_jnode_make_dirty(jnode * 
 
 	JF_SET(node, JNODE_DIRTY);
 
-	get_current_context()->nr_marked_dirty++;
+	if (!JF_ISSET(node, JNODE_CLUSTER_PAGE))
+		get_current_context()->nr_marked_dirty++;
 
 	/* We grab2flush_reserve one additional block only if node was
 	   not CREATED and jnode_flush did not sort it into neither
diff -puN fs/reiser4/vfs_ops.c~reiser4-drop-journal-info fs/reiser4/vfs_ops.c
--- a/fs/reiser4/vfs_ops.c~reiser4-drop-journal-info
+++ a/fs/reiser4/vfs_ops.c
@@ -201,10 +201,16 @@ void reiser4_writeout(struct super_block
 	} while (wbc->nr_to_write > 0);
 }
 
-void reiser4_throttle_write(struct inode *inode)
+/* tell VM how many pages were dirtied */
+void reiser4_throttle_write(struct inode *inode, int nrpages)
 {
-	reiser4_txn_restart_current();
-	balance_dirty_pages_ratelimited(inode->i_mapping);
+	reiser4_context *ctx;
+
+	ctx = get_current_context();
+	reiser4_txn_restart(ctx);
+	current->journal_info = NULL;
+	balance_dirty_pages_ratelimited_nr(inode->i_mapping, nrpages);
+	current->journal_info = ctx;
 }
 
 const char *REISER4_SUPER_MAGIC_STRING = "ReIsEr4";
diff -puN fs/reiser4/vfs_ops.h~reiser4-drop-journal-info fs/reiser4/vfs_ops.h
--- a/fs/reiser4/vfs_ops.h~reiser4-drop-journal-info
+++ a/fs/reiser4/vfs_ops.h
@@ -30,7 +30,7 @@ extern int reiser4_add_nlink(struct inod
 extern int reiser4_del_nlink(struct inode *, struct inode *, int);
 
 extern int reiser4_start_up_io(struct page *page);
-extern void reiser4_throttle_write(struct inode *);
+extern void reiser4_throttle_write(struct inode *, int nrpages);
 extern int jnode_is_releasable(jnode *);
 
 #define CAPTURE_APAGE_BURST (1024l)
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

vfs-take-2add-set_page_dirty_notag.patch
reiser4-vfs-add-super_operationssync_inodes-2.patch
reiser4.patch
reiser4-adjust-to-the-new-aops.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch
reiser4-update-names-of-quota-methods.patch
reiser4-use-set_page_dirty_notag.patch
fs-reiser4-add-parenths-around-x-y.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-rename-psched-to-dispatch.patch
reiser4-drop-journal-info.patch
reiser4-fix-compile-warnings.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data.patch
reiser4-reduce-frame-size-of-reiser4_init_super_data-fixup.patch
reiser4-disable.patch

