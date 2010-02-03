From: akpm@linux-foundation.org
Subject: [folded] fs-reiser4-add-parenths-around-x-y.patch removed from -mm tree
Date: Wed, 03 Feb 2010 12:19:49 -0800
Message-ID: <201002032019.o13KJnqb016686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932216Ab0BCUTw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:19:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs: reiser4, add parenths around !X & Y
has been removed from the -mm tree.  Its filename was
     fs-reiser4-add-parenths-around-x-y.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: reiser4, add parenths around !X & Y
From: Jiri Slaby <jirislaby@gmail.com>

Change !X & Y to !(X & Y) to avoid compiler confusion and fix a bug.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/carry_ops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/carry_ops.c~fs-reiser4-add-parenths-around-x-y fs/reiser4/carry_ops.c
--- a/fs/reiser4/carry_ops.c~fs-reiser4-add-parenths-around-x-y
+++ a/fs/reiser4/carry_ops.c
@@ -79,7 +79,7 @@ static carry_node *find_left_neighbor(ca
 	left->free = 1;
 
 	flags = GN_TRY_LOCK;
-	if (!op->u.insert.flags & COPI_LOAD_LEFT)
+	if (!(op->u.insert.flags & COPI_LOAD_LEFT))
 		flags |= GN_NO_ALLOC;
 
 	/* then, feeling lucky, peek left neighbor in the cache. */
@@ -203,7 +203,7 @@ static carry_node *find_right_neighbor(c
 	read_unlock_tree(tree);
 
 	flags = GN_CAN_USE_UPPER_LEVELS;
-	if (!op->u.insert.flags & COPI_LOAD_RIGHT)
+	if (!(op->u.insert.flags & COPI_LOAD_RIGHT))
 		flags = GN_NO_ALLOC;
 
 	/* then, try to lock right neighbor */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
agp-amd64-fix-pci-reference-leaks.patch
isdn-misdn-dont-compile-unused-stuff.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

