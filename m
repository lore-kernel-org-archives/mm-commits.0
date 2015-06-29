From: akpm@linux-foundation.org
Subject: [merged] fs-befs-btreec-remove-unneeded-initializations.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:49:13 -0700
Message-ID: <5591af49.rt8eq5GJPfctqWGy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbbF2UtN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:49:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/btree.c: remove unneeded initializations
has been removed from the -mm tree.  Its filename was
     fs-befs-btreec-remove-unneeded-initializations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/befs/btree.c: remove unneeded initializations

bh, od_sup and this_node are unconditionally initialized in
befs_bt_read_super() and befs_btree_find()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/btree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/befs/btree.c~fs-befs-btreec-remove-unneeded-initializations fs/befs/btree.c
--- a/fs/befs/btree.c~fs-befs-btreec-remove-unneeded-initializations
+++ a/fs/befs/btree.c
@@ -137,8 +137,8 @@ static int
 befs_bt_read_super(struct super_block *sb, befs_data_stream * ds,
 		   befs_btree_super * sup)
 {
-	struct buffer_head *bh = NULL;
-	befs_disk_btree_super *od_sup = NULL;
+	struct buffer_head *bh;
+	befs_disk_btree_super *od_sup;
 
 	befs_debug(sb, "---> %s", __func__);
 
@@ -250,7 +250,7 @@ int
 befs_btree_find(struct super_block *sb, befs_data_stream * ds,
 		const char *key, befs_off_t * value)
 {
-	struct befs_btree_node *this_node = NULL;
+	struct befs_btree_node *this_node;
 	befs_btree_super bt_super;
 	befs_off_t node_off;
 	int res;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-affs-inodec-remove-unneeded-initialization.patch
fs-affs-amigaffsc-remove-unneeded-initialization.patch
fs-affs-symlinkc-remove-unneeded-err-variable.patch
w1-masters-omap_hdq-add-support-for-1-wire-mode.patch
linux-next.patch

