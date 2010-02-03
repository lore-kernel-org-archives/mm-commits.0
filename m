From: akpm@linux-foundation.org
Subject: + reiser4-fixup-checkin-checkout-jnodes-for-entd.patch added to -mm tree
Date: Wed, 03 Feb 2010 12:20:48 -0800
Message-ID: <201002032020.o13KKmvg016772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932473Ab0BCUUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:20:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com


The patch titled
     reiser4: fixup checkin-checkout jnodes for entd
has been added to the -mm tree.  Its filename is
     reiser4-fixup-checkin-checkout-jnodes-for-entd.patch

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

vfs-improve-writeback_inodes_wb.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4.patch
reiser4-writeback_inodes-implementation.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch

