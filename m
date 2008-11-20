From: akpm@linux-foundation.org
Subject: - dont-unlink-an-active-swapfile.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:09 -0800
Message-ID: <200811202043.mAKKh9w0007334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754749AbYKTUvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, 7eggert@gmx.de, davidn@davidnewall.com, hch@infradead.org, peter@cordes.ca, peterz@infradead.org, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     don't unlink an active swapfile
has been removed from the -mm tree.  Its filename was
     dont-unlink-an-active-swapfile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: don't unlink an active swapfile
From: Hugh Dickins <hugh@veritas.com>

Peter Cordes is sorry that he rm'ed his swapfiles while they were in use,
he then had no pathname to swapoff.  It's a curious little oversight, but
not one worth a lot of hackery.  Kudos to Willy Tarreau for turning this
around from a discussion of synthetic pathnames to how to prevent unlink.
Mimic immutable: prohibit unlinking an active swapfile in may_delete()
(and don't worry my little head over the tiny race window).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Willy Tarreau <w@1wt.eu>
Acked-by: Christoph Hellwig <hch@infradead.org>
Cc: Peter Cordes <peter@cordes.ca>
Cc: Bodo Eggert <7eggert@gmx.de>
Cc: David Newall <davidn@davidnewall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/namei.c~dont-unlink-an-active-swapfile fs/namei.c
--- a/fs/namei.c~dont-unlink-an-active-swapfile
+++ a/fs/namei.c
@@ -1378,7 +1378,7 @@ static int may_delete(struct inode *dir,
 	if (IS_APPEND(dir))
 		return -EPERM;
 	if (check_sticky(dir, victim->d_inode)||IS_APPEND(victim->d_inode)||
-	    IS_IMMUTABLE(victim->d_inode))
+	    IS_IMMUTABLE(victim->d_inode) || IS_SWAPFILE(victim->d_inode))
 		return -EPERM;
 	if (isdir) {
 		if (!S_ISDIR(victim->d_inode->i_mode))
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
prio_tree-debugging-patch.patch

