From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-constify-ocfs2_extent_tree_operations-structures.patch removed from
 -mm tree
Date: Fri, 15 Jan 2016 14:31:35 -0800
Message-ID: <56997347.TntsspNR8g8aaY7R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbcAOWbf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: constify ocfs2_extent_tree_operations structures
has been removed from the -mm tree.  Its filename was
     ocfs2-constify-ocfs2_extent_tree_operations-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: ocfs2: constify ocfs2_extent_tree_operations structures

The ocfs2_extent_tree_operations structures are never modified, so declare
them as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   12 ++++++------
 fs/ocfs2/alloc.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-constify-ocfs2_extent_tree_operations-structures fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-constify-ocfs2_extent_tree_operations-structures
+++ a/fs/ocfs2/alloc.c
@@ -164,7 +164,7 @@ static int ocfs2_dinode_insert_check(str
 				     struct ocfs2_extent_rec *rec);
 static int ocfs2_dinode_sanity_check(struct ocfs2_extent_tree *et);
 static void ocfs2_dinode_fill_root_el(struct ocfs2_extent_tree *et);
-static struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
+static const struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_dinode_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_dinode_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_dinode_update_clusters,
@@ -286,7 +286,7 @@ static void ocfs2_xattr_value_update_clu
 	le32_add_cpu(&vb->vb_xv->xr_clusters, clusters);
 }
 
-static struct ocfs2_extent_tree_operations ocfs2_xattr_value_et_ops = {
+static const struct ocfs2_extent_tree_operations ocfs2_xattr_value_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_xattr_value_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_xattr_value_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_xattr_value_update_clusters,
@@ -332,7 +332,7 @@ static void ocfs2_xattr_tree_update_clus
 	le32_add_cpu(&xb->xb_attrs.xb_root.xt_clusters, clusters);
 }
 
-static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
+static const struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_xattr_tree_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_xattr_tree_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_xattr_tree_update_clusters,
@@ -379,7 +379,7 @@ static void ocfs2_dx_root_fill_root_el(s
 	et->et_root_el = &dx_root->dr_list;
 }
 
-static struct ocfs2_extent_tree_operations ocfs2_dx_root_et_ops = {
+static const struct ocfs2_extent_tree_operations ocfs2_dx_root_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_dx_root_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_dx_root_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_dx_root_update_clusters,
@@ -425,7 +425,7 @@ ocfs2_refcount_tree_extent_contig(struct
 	return CONTIG_NONE;
 }
 
-static struct ocfs2_extent_tree_operations ocfs2_refcount_tree_et_ops = {
+static const struct ocfs2_extent_tree_operations ocfs2_refcount_tree_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_refcount_tree_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_refcount_tree_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_refcount_tree_update_clusters,
@@ -438,7 +438,7 @@ static void __ocfs2_init_extent_tree(str
 				     struct buffer_head *bh,
 				     ocfs2_journal_access_func access,
 				     void *obj,
-				     struct ocfs2_extent_tree_operations *ops)
+				     const struct ocfs2_extent_tree_operations *ops)
 {
 	et->et_ops = ops;
 	et->et_root_bh = bh;
diff -puN fs/ocfs2/alloc.h~ocfs2-constify-ocfs2_extent_tree_operations-structures fs/ocfs2/alloc.h
--- a/fs/ocfs2/alloc.h~ocfs2-constify-ocfs2_extent_tree_operations-structures
+++ a/fs/ocfs2/alloc.h
@@ -54,7 +54,7 @@
  */
 struct ocfs2_extent_tree_operations;
 struct ocfs2_extent_tree {
-	struct ocfs2_extent_tree_operations	*et_ops;
+	const struct ocfs2_extent_tree_operations *et_ops;
 	struct buffer_head			*et_root_bh;
 	struct ocfs2_extent_list		*et_root_el;
 	struct ocfs2_caching_info		*et_ci;
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

fat-constify-fatent_operations-structures.patch

