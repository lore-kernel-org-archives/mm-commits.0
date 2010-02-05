From: akpm@linux-foundation.org
Subject: [merged] idr-revert-misallocation-bug-fix.patch removed from -mm tree
Date: Fri, 05 Feb 2010 11:58:14 -0800
Message-ID: <201002051958.o15JwEoI017858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933832Ab0BET64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 14:58:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     idr: revert misallocation bug fix
has been removed from the -mm tree.  Its filename was
     idr-revert-misallocation-bug-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: revert misallocation bug fix
From: Tejun Heo <tj@kernel.org>

Commit 859ddf09743a8cc680af33f7259ccd0fd36bfe9d ("idr: fix a critical
misallocation bug") tried to fix misallocation bug but broke full bit
marking by not clearing pa[idp->layers] and also is causing X failures due
to lookup failure in drm code.  The cause of the latter hasn't been found
yet.  Revert the fix for now.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN lib/idr.c~idr-revert-misallocation-bug-fix lib/idr.c
--- a/lib/idr.c~idr-revert-misallocation-bug-fix
+++ a/lib/idr.c
@@ -140,7 +140,8 @@ static int sub_alloc(struct idr *idp, in
 	id = *starting_id;
  restart:
 	p = idp->top;
-	l = p->layer;
+	l = idp->layers;
+	pa[l--] = NULL;
 	while (1) {
 		/*
 		 * We run around this while until we reach the leaf node...
@@ -154,8 +155,8 @@ static int sub_alloc(struct idr *idp, in
 			oid = id;
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
-			/* did id go over the limit? */
-			if (id >= (1 << (idp->layers * IDR_BITS))) {
+			/* if already at the top layer, we need to grow */
+			if (!(p = pa[l])) {
 				*starting_id = id;
 				return IDR_NEED_TO_GROW;
 			}
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
core-workqueue-return-on-workqueue-recursion.patch

