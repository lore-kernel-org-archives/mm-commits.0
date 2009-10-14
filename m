From: akpm@linux-foundation.org
Subject: + reiser4-reduce-frame-size-of-reiser4_init_super_data.patch added to -mm tree
Date: Tue, 13 Oct 2009 19:56:42 -0700
Message-ID: <200910140256.n9E2ugUt020617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761312AbZJNC5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 22:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com


The patch titled
     reiser4: reduce frame size of reiser4_init_super_data
has been added to the -mm tree.  Its filename is
     reiser4-reduce-frame-size-of-reiser4_init_super_data.patch

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
Subject: reiser4: reduce frame size of reiser4_init_super_data
From: Edward Shishkin <edward.shishkin@gmail.com>

Address a gcc warning for x86_64 about large frame size.
Add a new function push_sb_field_opts().

Signed-off-by Edward Shsihkin <edward.shishkin@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/init_super.c |  126 +++++++++++++++++++-------------------
 1 file changed, 66 insertions(+), 60 deletions(-)

diff -puN fs/reiser4/init_super.c~reiser4-reduce-frame-size-of-reiser4_init_super_data fs/reiser4/init_super.c
--- a/fs/reiser4/init_super.c~reiser4-reduce-frame-size-of-reiser4_init_super_data
+++ a/fs/reiser4/init_super.c
@@ -292,66 +292,6 @@ static int parse_options(char *opt_strin
 
 #define MAX_NR_OPTIONS (30)
 
-/**
- * reiser4_init_super_data - initialize reiser4 private super block
- * @super: super block to initialize
- * @opt_string: list of reiser4 mount options
- *
- * Sets various reiser4 parameters to default values. Parses mount options and
- * overwrites default settings.
- */
-int reiser4_init_super_data(struct super_block *super, char *opt_string)
-{
-	int result;
-	struct opt_desc *opts, *p;
-	reiser4_super_info_data *sbinfo = get_super_private(super);
-
-	/* initialize super, export, dentry operations */
-	sbinfo->ops.super = reiser4_super_operations;
-	sbinfo->ops.export = reiser4_export_operations;
-	sbinfo->ops.dentry = reiser4_dentry_operations;
-	super->s_op = &sbinfo->ops.super;
-	super->s_export_op = &sbinfo->ops.export;
-
-	/* initialize transaction manager parameters to default values */
-	sbinfo->tmgr.atom_max_size = totalram_pages / 4;
-	sbinfo->tmgr.atom_max_age = REISER4_ATOM_MAX_AGE / HZ;
-	sbinfo->tmgr.atom_min_size = 256;
-	sbinfo->tmgr.atom_max_flushers = ATOM_MAX_FLUSHERS;
-
-	/* initialize cbk cache parameter */
-	sbinfo->tree.cbk_cache.nr_slots = CBK_CACHE_SLOTS;
-
-	/* initialize flush parameters */
-	sbinfo->flush.relocate_threshold = FLUSH_RELOCATE_THRESHOLD;
-	sbinfo->flush.relocate_distance = FLUSH_RELOCATE_DISTANCE;
-	sbinfo->flush.written_threshold = FLUSH_WRITTEN_THRESHOLD;
-	sbinfo->flush.scan_maxnodes = FLUSH_SCAN_MAXNODES;
-
-	sbinfo->optimal_io_size = REISER4_OPTIMAL_IO_SIZE;
-
-	/* preliminary tree initializations */
-	sbinfo->tree.super = super;
-	sbinfo->tree.carry.new_node_flags = REISER4_NEW_NODE_FLAGS;
-	sbinfo->tree.carry.new_extent_flags = REISER4_NEW_EXTENT_FLAGS;
-	sbinfo->tree.carry.paste_flags = REISER4_PASTE_FLAGS;
-	sbinfo->tree.carry.insert_flags = REISER4_INSERT_FLAGS;
-	rwlock_init(&(sbinfo->tree.tree_lock));
-	spin_lock_init(&(sbinfo->tree.epoch_lock));
-
-	/* initialize default readahead params */
-	sbinfo->ra_params.max = num_physpages / 4;
-	sbinfo->ra_params.flags = 0;
-
-	/* allocate memory for structure describing reiser4 mount options */
-	opts = kmalloc(sizeof(struct opt_desc) * MAX_NR_OPTIONS,
-		       reiser4_ctx_gfp_mask_get());
-	if (opts == NULL)
-		return RETERR(-ENOMEM);
-
-	/* initialize structure describing reiser4 mount options */
-	p = opts;
-
 #if REISER4_DEBUG
 #  define OPT_ARRAY_CHECK if ((p) > (opts) + MAX_NR_OPTIONS) {		\
 		warning("zam-1046", "opt array is overloaded"); break;	\
@@ -370,6 +310,10 @@ do {						\
 #define PUSH_SB_FIELD_OPT(field, format) PUSH_OPT(SB_FIELD_OPT(field, format))
 #define PUSH_BIT_OPT(name, bit) PUSH_OPT(BIT_OPT(name, bit))
 
+static noinline void push_sb_field_opts(struct opt_desc *p,
+					struct opt_desc *opts,
+					reiser4_super_info_data *sbinfo)
+{
 	/*
 	 * tmgr.atom_max_size=N
 	 * Atoms containing more than N blocks will be forced to commit. N is
@@ -435,7 +379,69 @@ do {						\
 	 */
 	PUSH_SB_FIELD_OPT(altsuper, "%lu");
 #endif
+}
+
+/**
+ * reiser4_init_super_data - initialize reiser4 private super block
+ * @super: super block to initialize
+ * @opt_string: list of reiser4 mount options
+ *
+ * Sets various reiser4 parameters to default values. Parses mount options and
+ * overwrites default settings.
+ */
+int reiser4_init_super_data(struct super_block *super, char *opt_string)
+{
+	int result;
+	struct opt_desc *opts, *p;
+	reiser4_super_info_data *sbinfo = get_super_private(super);
+
+	/* initialize super, export, dentry operations */
+	sbinfo->ops.super = reiser4_super_operations;
+	sbinfo->ops.export = reiser4_export_operations;
+	sbinfo->ops.dentry = reiser4_dentry_operations;
+	super->s_op = &sbinfo->ops.super;
+	super->s_export_op = &sbinfo->ops.export;
+
+	/* initialize transaction manager parameters to default values */
+	sbinfo->tmgr.atom_max_size = totalram_pages / 4;
+	sbinfo->tmgr.atom_max_age = REISER4_ATOM_MAX_AGE / HZ;
+	sbinfo->tmgr.atom_min_size = 256;
+	sbinfo->tmgr.atom_max_flushers = ATOM_MAX_FLUSHERS;
+
+	/* initialize cbk cache parameter */
+	sbinfo->tree.cbk_cache.nr_slots = CBK_CACHE_SLOTS;
+
+	/* initialize flush parameters */
+	sbinfo->flush.relocate_threshold = FLUSH_RELOCATE_THRESHOLD;
+	sbinfo->flush.relocate_distance = FLUSH_RELOCATE_DISTANCE;
+	sbinfo->flush.written_threshold = FLUSH_WRITTEN_THRESHOLD;
+	sbinfo->flush.scan_maxnodes = FLUSH_SCAN_MAXNODES;
+
+	sbinfo->optimal_io_size = REISER4_OPTIMAL_IO_SIZE;
+
+	/* preliminary tree initializations */
+	sbinfo->tree.super = super;
+	sbinfo->tree.carry.new_node_flags = REISER4_NEW_NODE_FLAGS;
+	sbinfo->tree.carry.new_extent_flags = REISER4_NEW_EXTENT_FLAGS;
+	sbinfo->tree.carry.paste_flags = REISER4_PASTE_FLAGS;
+	sbinfo->tree.carry.insert_flags = REISER4_INSERT_FLAGS;
+	rwlock_init(&(sbinfo->tree.tree_lock));
+	spin_lock_init(&(sbinfo->tree.epoch_lock));
+
+	/* initialize default readahead params */
+	sbinfo->ra_params.max = num_physpages / 4;
+	sbinfo->ra_params.flags = 0;
+
+	/* allocate memory for structure describing reiser4 mount options */
+	opts = kmalloc(sizeof(struct opt_desc) * MAX_NR_OPTIONS,
+		       reiser4_ctx_gfp_mask_get());
+	if (opts == NULL)
+		return RETERR(-ENOMEM);
+
+	/* initialize structure describing reiser4 mount options */
+	p = opts;
 
+	push_sb_field_opts(p, opts, sbinfo);
 	/* turn on BSD-style gid assignment */
 	PUSH_BIT_OPT("bsdgroups", REISER4_BSD_GID);
 	/* turn on 32 bit times */
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

