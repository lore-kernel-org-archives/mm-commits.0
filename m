From: akpm@linux-foundation.org
Subject: + dont-unlink-an-active-swapfile.patch added to -mm tree
Date: Fri, 14 Nov 2008 16:41:30 -0800
Message-ID: <200811150041.mAF0fUEp026567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbYKOAm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 19:42:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, 7eggert@gmx.de, davidn@davidnewall.com, hch@infradead.org, peter@cordes.ca, peterz@infradead.org, w@1wt.eu


The patch titled
     don't unlink an active swapfile
has been added to the -mm tree.  Its filename is
     dont-unlink-an-active-swapfile.patch

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
@@ -1380,7 +1380,7 @@ static int may_delete(struct inode *dir,
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
sprint_symbol-use-less-stack.patch
migration-fix-writepage-error.patch
vmscan-let-gfp_nofs-go-to-swap-again.patch
dont-unlink-an-active-swapfile.patch
mm-implement-remap_pfn_range-with-apply_to_page_range.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remap_pfn_range-restore-missing-flush.patch
prio_tree-debugging-patch.patch

