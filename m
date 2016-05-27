From: akpm@linux-foundation.org
Subject: [merged] nilfs2-constify-nilfs_sc_operations-structures.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:42:38 -0700
Message-ID: <5748951e.UejUAOENsKr/Gxep%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbcE0Smj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:42:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: constify nilfs_sc_operations structures
has been removed from the -mm tree.  Its filename was
     nilfs2-constify-nilfs_sc_operations-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: nilfs2: constify nilfs_sc_operations structures

The nilfs_sc_operations structures are never modified, so declare them
as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/nilfs2/segment.c~nilfs2-constify-nilfs_sc_operations-structures fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-constify-nilfs_sc_operations-structures
+++ a/fs/nilfs2/segment.c
@@ -617,7 +617,7 @@ static void nilfs_write_file_node_binfo(
 	*vblocknr = binfo->bi_v.bi_vblocknr;
 }
 
-static struct nilfs_sc_operations nilfs_sc_file_ops = {
+static const struct nilfs_sc_operations nilfs_sc_file_ops = {
 	.collect_data = nilfs_collect_file_data,
 	.collect_node = nilfs_collect_file_node,
 	.collect_bmap = nilfs_collect_file_bmap,
@@ -666,7 +666,7 @@ static void nilfs_write_dat_node_binfo(s
 	*binfo_dat = binfo->bi_dat;
 }
 
-static struct nilfs_sc_operations nilfs_sc_dat_ops = {
+static const struct nilfs_sc_operations nilfs_sc_dat_ops = {
 	.collect_data = nilfs_collect_dat_data,
 	.collect_node = nilfs_collect_file_node,
 	.collect_bmap = nilfs_collect_dat_bmap,
@@ -674,7 +674,7 @@ static struct nilfs_sc_operations nilfs_
 	.write_node_binfo = nilfs_write_dat_node_binfo,
 };
 
-static struct nilfs_sc_operations nilfs_sc_dsync_ops = {
+static const struct nilfs_sc_operations nilfs_sc_dsync_ops = {
 	.collect_data = nilfs_collect_file_data,
 	.collect_node = NULL,
 	.collect_bmap = NULL,
@@ -1043,7 +1043,7 @@ static size_t nilfs_segctor_buffer_rest(
 
 static int nilfs_segctor_scan_file(struct nilfs_sc_info *sci,
 				   struct inode *inode,
-				   struct nilfs_sc_operations *sc_ops)
+				   const struct nilfs_sc_operations *sc_ops)
 {
 	LIST_HEAD(data_buffers);
 	LIST_HEAD(node_buffers);
@@ -1550,7 +1550,7 @@ nilfs_segctor_update_payload_blocknr(str
 	sector_t blocknr;
 	unsigned long nfinfo = segbuf->sb_sum.nfinfo;
 	unsigned long nblocks = 0, ndatablk = 0;
-	struct nilfs_sc_operations *sc_op = NULL;
+	const struct nilfs_sc_operations *sc_op = NULL;
 	struct nilfs_segsum_pointer ssp;
 	struct nilfs_finfo *finfo = NULL;
 	union nilfs_binfo binfo;
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are


