From: akpm@linux-foundation.org
Subject: + hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch
 added to -mm tree
Date: Tue, 07 Jul 2015 15:20:11 -0700
Message-ID: <559c509b.z/7/1UcNv+hmQ/6J%akpm__18030.8513729416$1436307628$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbbGGWUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 18:20:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htl10@users.sourceforge.net, anton@tuxera.com, hch@infradead.org, joe@perches.com, saproj@gmail.com, slava@dubeyko.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: fix B-tree corruption after insertion at position 0
has been added to the -mm tree.  Its filename is
     hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: hfs: fix B-tree corruption after insertion at position 0

Fix B-tree corruption when a new record is inserted at position 0 in the
node in hfs_brec_insert().

This is an identical change to the corresponding hfs b-tree code to Sergei
Antonov's "hfsplus: fix B-tree corruption after insertion at position 0",
to keep similar code paths in the hfs and hfsplus drivers in sync, where
appropriate.

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Sergei Antonov <saproj@gmail.com>
Cc: Joe Perches <joe@perches.com>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/brec.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN fs/hfs/brec.c~hfs-fix-b-tree-corruption-after-insertion-at-position-0 fs/hfs/brec.c
--- a/fs/hfs/brec.c~hfs-fix-b-tree-corruption-after-insertion-at-position-0
+++ a/fs/hfs/brec.c
@@ -131,13 +131,16 @@ skip:
 	hfs_bnode_write(node, entry, data_off + key_len, entry_len);
 	hfs_bnode_dump(node);
 
-	if (new_node) {
-		/* update parent key if we inserted a key
-		 * at the start of the first node
-		 */
-		if (!rec && new_node != node)
-			hfs_brec_update_parent(fd);
+	/*
+	 * update parent key if we inserted a key
+	 * at the start of the node and it is not the new node
+	 */
+	if (!rec && new_node != node) {
+		hfs_bnode_read_key(node, fd->search_key, data_off + size);
+		hfs_brec_update_parent(fd);
+	}
 
+	if (new_node) {
 		hfs_bnode_put(fd->bnode);
 		if (!new_node->parent) {
 			hfs_btree_inc_height(tree);
@@ -166,9 +169,6 @@ skip:
 		goto again;
 	}
 
-	if (!rec)
-		hfs_brec_update_parent(fd);
