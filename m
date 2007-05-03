From: akpm@linux-foundation.org
Subject: - idr-fix-obscure-bug-in-allocation-path.patch removed from -mm tree
Date: Thu, 03 May 2007 12:30:54 -0700
Message-ID: <200705031930.l43JUsog018219@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767821AbXECTc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:32:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: teheo@suse.de, greg@kroah.com, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     idr: fix obscure bug in allocation path
has been removed from the -mm tree.  Its filename was
     idr-fix-obscure-bug-in-allocation-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: idr: fix obscure bug in allocation path
From: Tejun Heo <teheo@suse.de>

In sub_alloc(), when bitmap search fails, it goes up one level to continue
search.  This is done by updating the id cursor and searching the upper
level again.  If the cursor was at the end of the upper level, we need to
go further than that.

This wasn't implemented and when that happens the part of the cursor which
indexes into the upper level wraps and sub_alloc() ends up searching the
wrong bitmap.  It allocates id which doesn't match the actual slot.

This patch fixes this by restarting from the top if the search needs to go
higher than one level.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff -puN lib/idr.c~idr-fix-obscure-bug-in-allocation-path lib/idr.c
--- a/lib/idr.c~idr-fix-obscure-bug-in-allocation-path
+++ a/lib/idr.c
@@ -100,10 +100,11 @@ static int sub_alloc(struct idr *idp, vo
 	int n, m, sh;
 	struct idr_layer *p, *new;
 	struct idr_layer *pa[MAX_LEVEL];
-	int l, id;
+	int l, id, oid;
 	long bm;
 
 	id = *starting_id;
+ restart:
 	p = idp->top;
 	l = idp->layers;
 	pa[l--] = NULL;
@@ -117,12 +118,23 @@ static int sub_alloc(struct idr *idp, vo
 		if (m == IDR_SIZE) {
 			/* no space available go back to previous layer. */
 			l++;
+			oid = id;
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
+
+			/* if already at the top layer, we need to grow */
 			if (!(p = pa[l])) {
 				*starting_id = id;
 				return -2;
 			}
-			continue;
+
+			/* If we need to go up one layer, continue the
+			 * loop; otherwise, restart from the top.
+			 */
+			sh = IDR_BITS * (l + 1);
+			if (oid >> sh == id >> sh)
+				continue;
+			else
+				goto restart;
 		}
 		if (m != n) {
 			sh = IDR_BITS*l;
_

Patches currently in -mm which might be from teheo@suse.de are
