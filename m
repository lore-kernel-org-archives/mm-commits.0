From: akpm@linux-foundation.org
Subject: - reiser4-fix-trivial-tyops-which-were-hard-to-hit.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:19 -0800
Message-ID: <200703060159.l261xJik008590@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46519 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965641AbXCFB7Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:59:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vs@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix trivial typos which were hard to hit
has been removed from the -mm tree.  Its filename was
     reiser4-fix-trivial-tyops-which-were-hard-to-hit.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: fix trivial typos which were hard to hit
From: Vladimir Saveliev <vs@namesys.com>

The attached patch fixes 3 trivial bugs in reiser4.  To hit them one would
have to either run with REISER4_DEBUG turned on or to encounter partially
converted file.

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/page_cache.c          |    2 +-
 fs/reiser4/plugin/file/file.c    |    1 +
 fs/reiser4/plugin/space/bitmap.c |    4 +++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/page_cache.c~reiser4-fix-trivial-tyops-which-were-hard-to-hit fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-fix-trivial-tyops-which-were-hard-to-hit
+++ a/fs/reiser4/page_cache.c
@@ -517,7 +517,7 @@ int reiser4_writepage(struct page *page,
 	s = page->mapping->host->i_sb;
 	ctx = get_current_context_check();
 
-	assert("", !can_hit_entd(ctx, s));
+	assert("", can_hit_entd(ctx, s));
 
 	return write_page_by_ent(page, wbc);
 }
diff -puN fs/reiser4/plugin/file/file.c~reiser4-fix-trivial-tyops-which-were-hard-to-hit fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fix-trivial-tyops-which-were-hard-to-hit
+++ a/fs/reiser4/plugin/file/file.c
@@ -1981,6 +1981,7 @@ int open_unix_file(struct inode *inode, 
 	assert("vs-1712",
 	       ergo(result == 0, (!inode_get_flag(inode, REISER4_PART_MIXED) &&
 				  !inode_get_flag(inode, REISER4_PART_IN_CONV))));
+	drop_exclusive_access(uf_info);
 	reiser4_exit_context(ctx);
 	return result;
 }
diff -puN fs/reiser4/plugin/space/bitmap.c~reiser4-fix-trivial-tyops-which-were-hard-to-hit fs/reiser4/plugin/space/bitmap.c
--- a/fs/reiser4/plugin/space/bitmap.c~reiser4-fix-trivial-tyops-which-were-hard-to-hit
+++ a/fs/reiser4/plugin/space/bitmap.c
@@ -742,8 +742,10 @@ prepare_bnode(struct bitmap_node *bnode,
 	super = reiser4_get_current_sb();
 
 	*wjnode_ret = wjnode = bnew();
-	if (wjnode == NULL)
+	if (wjnode == NULL) {
+		*cjnode_ret = NULL;
 		return RETERR(-ENOMEM);
+	}
 
 	*cjnode_ret = cjnode = bnew();
 	if (cjnode == NULL)
_

Patches currently in -mm which might be from vs@namesys.com are

reiser4.patch
reiser4-fix-trivial-tyops-which-were-hard-to-hit.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-bug-fixes.patch
reiser4-fix-gcc-ws-compains.patch
fs-reiser4-possible-cleanups.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-vs-streamline-generic_file_-interfaces-and-filemap.patch
reiser4-rename-generic_sounding_globalspatch.patch
reiser4-possible-cleanups-2.patch
reiser4-temp-fix.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-freeze-and-corruption.patch
