From: akpm@linux-foundation.org
Subject: [folded] reiser4-some-comments-were-still-mentioning-pdflush.patch removed from -mm tree
Date: Wed, 03 Feb 2010 12:20:21 -0800
Message-ID: <201002032020.o13KKLiq016755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932473Ab0BCUUZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:20:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buchner.johannes@gmx.at, edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: some comments were still mentioning pdflush
has been removed from the -mm tree.  Its filename was
     reiser4-some-comments-were-still-mentioning-pdflush.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: some comments were still mentioning pdflush
From: Johannes Buchner <buchner.johannes@gmx.at>

Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/context.c |    2 +-
 fs/reiser4/txnmgr.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/reiser4/context.c~reiser4-some-comments-were-still-mentioning-pdflush fs/reiser4/context.c
--- a/fs/reiser4/context.c~reiser4-some-comments-were-still-mentioning-pdflush
+++ a/fs/reiser4/context.c
@@ -147,7 +147,7 @@ static void reiser4_throttle_write_at(re
 	 * call balance_dirty_pages_ratelimited() to process formatted nodes
 	 * dirtied during this system call. Do that only if we are not in mount
 	 * and there were nodes dirtied in this context and we are not in
-	 * writepage (to avoid deadlock) and not in pdflush
+	 * writepage (to avoid deadlock)
 	 */
 	if (sbinfo != NULL && sbinfo->fake != NULL &&
 	    context->nr_marked_dirty != 0 &&
diff -puN fs/reiser4/txnmgr.c~reiser4-some-comments-were-still-mentioning-pdflush fs/reiser4/txnmgr.c
--- a/fs/reiser4/txnmgr.c~reiser4-some-comments-were-still-mentioning-pdflush
+++ a/fs/reiser4/txnmgr.c
@@ -1360,7 +1360,7 @@ static int txn_try_to_fuse_small_atom(tx
    code tries to flush current atom.
 
    flush_some_atom() is called as part of memory clearing process. It is
-   invoked from balance_dirty_pages(), pdflushd, and entd.
+   invoked from balance_dirty_pages() and entd.
 
    If we can flush no nodes, atom is committed, because this frees memory.
 
@@ -1469,7 +1469,7 @@ flush_some_atom(jnode * start, long *nr_
 			 * or atom is too old/large,
 			 * we force current atom to commit */
 			/* wait for commit completion but only if this
-			 * wouldn't stall pdflushd and ent thread. */
+			 * wouldn't stall ent thread. */
 			if (!wbc->nonblocking && !ctx->entd)
 				txnh->flags |= TXNH_WAIT_COMMIT;
 			atom->flags |= ATOM_FORCE_COMMIT;
_

Patches currently in -mm which might be from buchner.johannes@gmx.at are

reiser4.patch
reiser4-some-comments-were-still-mentioning-pdflush.patch

