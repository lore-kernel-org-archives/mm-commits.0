From: akpm@linux-foundation.org
Subject: + xfs-free-temporary-cursor-in-xfs_dialloc.patch added to -mm tree
Date: Wed, 28 Oct 2009 16:29:51 -0700
Message-ID: <200910282329.n9SNTpCu017552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755068AbZJ1XaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 19:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@sandeen.net, aelder@sgi.com, felixb@sgi.com, hch@lst.de


The patch titled
     xfs: free temporary cursor in xfs_dialloc()
has been added to the -mm tree.  Its filename is
     xfs-free-temporary-cursor-in-xfs_dialloc.patch

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
Subject: xfs: free temporary cursor in xfs_dialloc()
From: Eric Sandeen <sandeen@sandeen.net>

Commit bd169565993b39b9b4b102cdac8b13e0a259ce2f ("xfs: speed up free inode
search") seems to have a slight regression where this code path:

   if (!--searchdistance) {
       /*
        * Not in range - save last search
        * location and allocate a new inode
        */
       ...
       goto newino;
   }

doesn't free the temporary cursor (tcur) that got dup'd in this
function.

This leaks an item in the xfs_btree_cur zone, and it's caught on module
unload:

===========================================================
BUG xfs_btree_cur: Objects remaining on kmem_cache_close()
-----------------------------------------------------------

It seems like maybe a single free at the end of the function might be
cleaner, but for now put a del_cursor right in this code block similar
to the handling in the rest of the function.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alex Elder <aelder@sgi.com>
Cc: Felix Blyakher <felixb@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/xfs/xfs_ialloc.c~xfs-free-temporary-cursor-in-xfs_dialloc fs/xfs/xfs_ialloc.c
--- a/fs/xfs/xfs_ialloc.c~xfs-free-temporary-cursor-in-xfs_dialloc
+++ a/fs/xfs/xfs_ialloc.c
@@ -880,6 +880,7 @@ nextag:
 				 * Not in range - save last search
 				 * location and allocate a new inode
 				 */
+				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
 				pag->pagl_leftrec = trec.ir_startino;
 				pag->pagl_rightrec = rec.ir_startino;
 				pag->pagl_pagino = pagino;
_

Patches currently in -mm which might be from sandeen@sandeen.net are

xfs-free-temporary-cursor-in-xfs_dialloc.patch

