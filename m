From: akpm@linux-foundation.org
Subject: + idr-revert-misallocation-bug-fix.patch added to -mm tree
Date: Thu, 04 Feb 2010 11:00:43 -0800
Message-ID: <201002041900.o14J0hPB015595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757798Ab0BDTBZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 14:01:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org


The patch titled
     idr: revert misallocation bug fix
has been added to the -mm tree.  Its filename is
     idr-revert-misallocation-bug-fix.patch

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
idr-revert-misallocation-bug-fix.patch
linux-next.patch
ata-call-flush_dcache_page-around-pio-data-transfers-in-libata-affc.patch
core-workqueue-return-on-workqueue-recursion.patch

