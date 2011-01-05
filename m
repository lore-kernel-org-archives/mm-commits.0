From: akpm@linux-foundation.org
Subject: [folded] reiser4-fixup-checkin-checkout-jnodes-for-entd.patch removed from -mm tree
Date: Tue, 04 Jan 2011 16:36:15 -0800
Message-ID: <201101050036.p050aFXD000812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116Ab1AEAgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 19:36:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fixup checkin-checkout jnodes for entd
has been removed from the -mm tree.  Its filename was
     reiser4-fixup-checkin-checkout-jnodes-for-entd.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: fixup checkin-checkout jnodes for entd
From: Edward Shishkin <edward.shishkin@gmail.com>

The bug: reiser4_writeout() calls jput for jnode
which is already destroyed:

Fix up: take  the reference earler (at the point where the
jnode is attached for entd work).

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file.c |    6 ++++--
 fs/reiser4/vfs_ops.c          |    4 +++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-fixup-checkin-checkout-jnodes-for-entd fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fixup-checkin-checkout-jnodes-for-entd
+++ a/fs/reiser4/plugin/file/file.c
@@ -824,14 +824,16 @@ int find_or_create_extent(struct page *p
 
 	BUG_ON(node->atom == NULL);
 	JF_CLR(node, JNODE_WRITE_PREPARED);
-	jput(node);
 
 	if (get_current_context()->entd) {
 		entd_context *ent = get_entd_context(node->tree->super);
 
 		if (ent->cur_request->page == page)
-			ent->cur_request->node = node;
+			/* the following reference will be
+			   dropped in reiser4_writeout */
+			ent->cur_request->node = jref(node);
 	}
+	jput(node);
 	return 0;
 }
 
diff -puN fs/reiser4/vfs_ops.c~reiser4-fixup-checkin-checkout-jnodes-for-entd fs/reiser4/vfs_ops.c
--- a/fs/reiser4/vfs_ops.c~reiser4-fixup-checkin-checkout-jnodes-for-entd
+++ a/fs/reiser4/vfs_ops.c
@@ -184,7 +184,7 @@ void reiser4_writeout(struct super_block
 				 * requested page itself - start flush from
 				 * that page
 				 */
-				node = jref(ent->cur_request->node);
+				node = ent->cur_request->node;
 		}
 
 		result = flush_some_atom(node, &nr_submitted, wbc,
@@ -192,6 +192,8 @@ void reiser4_writeout(struct super_block
 		if (result != 0)
 			warning("nikita-31001", "Flush failed: %i", result);
 		if (node)
+			/* drop the reference aquired
+			   in find_or_create_extent() */
 			jput(node);
 		if (!nr_submitted)
 			break;
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

linux-next.patch
reiserfs-make-sure-va_end-is-always-called-after-va_start.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
vfs-take-2add-set_page_dirty_notag.patch
vfs-change-writeback_inodes-signature.patch
reiser4.patch
reiser4-fixups.patch
reiser4-broke.patch

