From: akpm@linux-foundation.org
Subject: - reiser4-restore-fibmap-ioctl-support-for-packed-files.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:21 -0800
Message-ID: <200703060200.l2620LaM008723@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46627 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965689AbXCFCA2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zam@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     Reiser4: restore FIBMAP ioctl support for packed files
has been removed from the -mm tree.  Its filename was
     reiser4-restore-fibmap-ioctl-support-for-packed-files.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: Reiser4: restore FIBMAP ioctl support for packed files
From: Alexaner Zarochentsev <zam@namesys.com>

restore FIBMAP ioctl support for packed files, don't report block numbers for
not yet mapped to disk nodes.

Signed-off-by: Alexander Zarochentsev <zam@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/item/item.c |    2 +-
 fs/reiser4/plugin/item/tail.c |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/plugin/item/item.c~reiser4-restore-fibmap-ioctl-support-for-packed-files fs/reiser4/plugin/item/item.c
--- a/fs/reiser4/plugin/item/item.c~reiser4-restore-fibmap-ioctl-support-for-packed-files
+++ a/fs/reiser4/plugin/item/item.c
@@ -614,7 +614,7 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 				.write = reiser4_write_tail,
 				.read = reiser4_read_tail,
 				.readpage = readpage_tail,
-				.get_block = NULL,
+				.get_block = get_block_address_tail,
 				.append_key = append_key_tail,
 				.init_coord_extension =
 				init_coord_extension_tail
diff -puN fs/reiser4/plugin/item/tail.c~reiser4-restore-fibmap-ioctl-support-for-packed-files fs/reiser4/plugin/item/tail.c
--- a/fs/reiser4/plugin/item/tail.c~reiser4-restore-fibmap-ioctl-support-for-packed-files
+++ a/fs/reiser4/plugin/item/tail.c
@@ -790,7 +790,13 @@ get_block_address_tail(const coord_t * c
 {
 	assert("nikita-3252", znode_get_level(coord->node) == LEAF_LEVEL);
 
-	*block = *znode_get_block(coord->node);
+	if (reiser4_blocknr_is_fake(znode_get_block(coord->node)))
+		/* if node has'nt obtainet its block number yet, return 0.
+		 * Lets avoid upsetting users with some cosmic numbers beyond
+		 * the device capacity.*/
+		*block = 0;
+	else
+		*block = *znode_get_block(coord->node);
 	return 0;
 }
 
_

Patches currently in -mm which might be from zam@namesys.com are

reiser4.patch
reiser4-restore-fibmap-ioctl-support-for-packed-files.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
