From: akpm@linux-foundation.org
Subject: + dquot-do-full-inode-dirty-in-allocating-space.patch added to -mm tree
Date: Mon, 23 Aug 2010 13:52:18 -0700
Message-ID: <201008232052.o7NKqI6c014187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818Ab0HWUwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 16:52:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, alex.shi@intel.com, jack@suse.cz


The patch titled
     dquot: do full inode dirty in allocating space
has been added to the -mm tree.  Its filename is
     dquot-do-full-inode-dirty-in-allocating-space.patch

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
Subject: dquot: do full inode dirty in allocating space
From: Shaohua Li <shaohua.li@intel.com>

Alex Shi found a regression when doing ffsb test.  The test has several
threads, and each thread creates a small file, write to it and then delete
it.  ffsb reports about 20% regression and Alex bisected it to
43d2932d88e4 ("quota: Use mark_inode_dirty_sync instead of
mark_inode_dirty").

The test will call __mark_inode_dirty 3 times.  Without this commit, we
only take inode_lock one time, while with it, we take the lock 3 times
with flags ( I_DIRTY_SYNC,I_DIRTY_PAGES,I_DIRTY).  Perf shows the lock
contention increased too much.  Below proposed patch fixes it.

fs is allocating blocks, which usually means file writes and the inode
will be dirtied soon. We fully dirty the inode to reduce some inode_lock
contention in several calls of __mark_inode_dirty.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quotaops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/quotaops.h~dquot-do-full-inode-dirty-in-allocating-space include/linux/quotaops.h
--- a/include/linux/quotaops.h~dquot-do-full-inode-dirty-in-allocating-space
+++ a/include/linux/quotaops.h
@@ -275,7 +275,7 @@ static inline int dquot_alloc_space(stru
 
 	ret = dquot_alloc_space_nodirty(inode, nr);
 	if (!ret)
-		mark_inode_dirty_sync(inode);
+		mark_inode_dirty(inode);
 	return ret;
 }
 
_

Patches currently in -mm which might be from shaohua.li@intel.com are

dquot-do-full-inode-dirty-in-allocating-space.patch

