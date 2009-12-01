From: akpm@linux-foundation.org
Subject: + reiser4-some-changes-from-reiser4-2631-patch.patch added to -mm tree
Date: Tue, 01 Dec 2009 15:54:01 -0800
Message-ID: <200912012354.nB1Ns1Jq032144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754139AbZLAXy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 18:54:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buchner.johannes@gmx.at, edward.shishkin@gmail.com


The patch titled
     reiser4: some changes from reiser4-2.6.31 patch
has been added to the -mm tree.  Its filename is
     reiser4-some-changes-from-reiser4-2631-patch.patch

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
Subject: reiser4: some changes from reiser4-2.6.31 patch
From: Johannes Buchner <buchner.johannes@gmx.at>

> from
> http://www.kernel.org/pub/linux/kernel/people/edward/reiser4/reiser4-for-2.6/
I'm sorry, I did not see half of this is already covered by
vfs-take-2add-set_page_dirty_notag.patch. With that part removed,
this patch is only cosmetics now.

Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/carry.c     |    2 +-
 fs/reiser4/carry_ops.c |    2 +-
 fs/reiser4/znode.h     |    1 -
 mm/filemap.c           |    2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/reiser4/carry.c~reiser4-some-changes-from-reiser4-2631-patch fs/reiser4/carry.c
--- a/fs/reiser4/carry.c~reiser4-some-changes-from-reiser4-2631-patch
+++ a/fs/reiser4/carry.c
@@ -1095,7 +1095,7 @@ static void fatal_carry_error(carry_leve
  *
  * This function itself only manages changes in carry structures and delegates
  * all hard work (allocation of znode for new root, changes of parent and
- * sibling pointers to the reiser4_add_tree_root().
+ * sibling pointers) to the reiser4_add_tree_root().
  *
  * Locking: old tree root is locked by carry at this point. Fake znode is also
  * locked.
diff -puN fs/reiser4/carry_ops.c~reiser4-some-changes-from-reiser4-2631-patch fs/reiser4/carry_ops.c
--- a/fs/reiser4/carry_ops.c~reiser4-some-changes-from-reiser4-2631-patch
+++ a/fs/reiser4/carry_ops.c
@@ -2015,7 +2015,7 @@ static int carry_estimate_bitmaps(void)
 		int bytes;
 
 		bytes = capped_height() * (0 +	/* bnode should be added, but
-						 * its is private to bitmap.c,
+						 * it is private to bitmap.c,
 						 * skip for now. */
 					   2 * sizeof(jnode));
 						/* working and commit jnodes */
diff -puN fs/reiser4/znode.h~reiser4-some-changes-from-reiser4-2631-patch fs/reiser4/znode.h
--- a/fs/reiser4/znode.h~reiser4-some-changes-from-reiser4-2631-patch
+++ a/fs/reiser4/znode.h
@@ -18,7 +18,6 @@
 
 #include <linux/types.h>
 #include <linux/spinlock.h>
-#include <linux/semaphore.h>
 #include <linux/pagemap.h>	/* for PAGE_CACHE_SIZE */
 #include <asm/atomic.h>
 
diff -puN mm/filemap.c~reiser4-some-changes-from-reiser4-2631-patch mm/filemap.c
--- a/mm/filemap.c~reiser4-some-changes-from-reiser4-2631-patch
+++ a/mm/filemap.c
@@ -779,7 +779,6 @@ repeat:
 	rcu_read_unlock();
 	return ret;
 }
-EXPORT_SYMBOL(find_get_pages);
 
 /**
  * find_get_pages_contig - gang contiguous pagecache lookup
@@ -949,6 +948,7 @@ static void shrink_readahead_size_eio(st
 {
 	ra->ra_pages /= 4;
 }
+EXPORT_SYMBOL(find_get_pages);
 
 /**
  * do_generic_file_read - generic file read routine
_

Patches currently in -mm which might be from buchner.johannes@gmx.at are

reiser4-some-changes-from-reiser4-2631-patch.patch
reiser4-some-comments-were-still-mentioning-pdflush.patch
reiser4-generic_sync_sb_inodes-doesnt-exist-anymore.patch
reiser4-fixed-null-pointer-dereference.patch

