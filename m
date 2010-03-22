From: akpm@linux-foundation.org
Subject: + mempolicy-remove-redundant-check.patch added to -mm tree
Date: Mon, 22 Mar 2010 15:09:54 -0700
Message-ID: <201003222209.o2MM9sdY030367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492Ab0CVWKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 18:10:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, andi@firstfloor.org, lee.schermerhorn@hp.com, rientjes@google.com


The patch titled
     mempolicy: remove redundant check
has been added to the -mm tree.  Its filename is
     mempolicy-remove-redundant-check.patch

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
Subject: mempolicy: remove redundant check
From: Bob Liu <lliubbo@gmail.com>

Lee's patch "mempolicy: use MPOL_PREFERRED for system-wide default policy"
has made the MPOL_DEFAULT only used in the memory policy APIs.  So, no
need to check in __mpol_equal also.  Also get rid of mpol_match_intent()
and move its logic directly into __mpol_equal().

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-remove-redundant-check mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-remove-redundant-check
+++ a/mm/mempolicy.c
@@ -1828,16 +1828,6 @@ struct mempolicy *__mpol_cond_copy(struc
 	return tompol;
 }
 
-static int mpol_match_intent(const struct mempolicy *a,
-			     const struct mempolicy *b)
-{
-	if (a->flags != b->flags)
-		return 0;
-	if (!mpol_store_user_nodemask(a))
-		return 1;
-	return nodes_equal(a->w.user_nodemask, b->w.user_nodemask);
-}
-
 /* Slow path of a mempolicy comparison */
 int __mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
@@ -1845,8 +1835,12 @@ int __mpol_equal(struct mempolicy *a, st
 		return 0;
 	if (a->mode != b->mode)
 		return 0;
-	if (a->mode != MPOL_DEFAULT && !mpol_match_intent(a, b))
+	if (a->flags != b->flags)
 		return 0;
+	if (mpol_store_user_nodemask(a))
+		if (!nodes_equal(a->w.user_nodemask, b->w.user_nodemask))
+			return 0;
+
 	switch (a->mode) {
 	case MPOL_BIND:
 		/* Fall through */
_

Patches currently in -mm which might be from lliubbo@gmail.com are

mempolicy-remove-redundant-code.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch

