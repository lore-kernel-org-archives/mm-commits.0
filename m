From: akpm@linux-foundation.org
Subject: + idr-fix-backtrack-logic-in-idr_remove_all.patch added to -mm tree
Date: Thu, 13 May 2010 14:17:38 -0700
Message-ID: <201005132117.o4DLHcSw020780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875Ab0EMVSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 17:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imre.deak@nokia.com, eparis@redhat.com, paulmck@linux.vnet.ibm.com, stable@kernel.org, tj@kernel.org


The patch titled
     idr: fix backtrack logic in idr_remove_all
has been added to the -mm tree.  Its filename is
     idr-fix-backtrack-logic-in-idr_remove_all.patch

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
Subject: idr: fix backtrack logic in idr_remove_all
From: Imre Deak <imre.deak@nokia.com>

Currently idr_remove_all will fail with a use after free error if
idr::layers is bigger than 2, which on 32 bit systems corresponds to items
more than 1024.  This is due to stepping back too many levels during
backtracking.  For simplicity let's assume that IDR_SIZE=1 -> we have 2
nodes at each level below the root node and each leaf node stores two IDs.
 (In reality for 32 bit systems IDR_SIZE=5, with 32 nodes at each sub-root
level and 32 IDs in each leaf node).  The sequence of freeing the nodes at
the moment is as follows:

layer
1 ->                       a(7)
2 ->            b(3)                  c(5)
3 ->        d(1)   e(2)           f(4)    g(6)

Until step 4 things go fine, but then node c is freed, whereas node g
should be freed first.  Since node c contains the pointer to node g we'll
have a use after free error at step 6.

How many levels we step back after visiting the leaf nodes is currently
determined by the msb of the id we are currently visiting:

Step
1.          node d with IDs 0,1 is freed, current ID is advanced to 2.
            msb of the current ID bit 1. This means we need to step back
            1 level to node b and take the next sibling, node e.
2-3.        node e with IDs 2,3 is freed, current ID is 4, msb is bit 2.
            This means we need to step back 2 levels to node a, freeing
            node b on the way.
4-5.        node f with IDs 4,5 is freed, current ID is 6, msb is still
            bit 2. This means we again need to step back 2 levels to node
            a and free c on the way.
6.          We should visit node g, but its pointer is not available as
            node c was freed.

The fix changes how we determine the number of levels to step back. 
Instead of deducting this merely from the msb of the current ID, we should
really check if advancing the ID causes an overflow to a bit position
corresponding to a given layer.  In the above example overflow from bit 0
to bit 1 should mean stepping back 1 level.  Overflow from bit 1 to bit 2
should mean stepping back 2 level and so on.

The fix was tested with elements up to 1 << 20, which corresponds to
4 layers on 32 bit systems.

Signed-off-by: Imre Deak <imre.deak@nokia.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: <stable@kernel.org>		[2.6.34.1]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN lib/idr.c~idr-fix-backtrack-logic-in-idr_remove_all lib/idr.c
--- a/lib/idr.c~idr-fix-backtrack-logic-in-idr_remove_all
+++ a/lib/idr.c
@@ -445,6 +445,7 @@ EXPORT_SYMBOL(idr_remove);
 void idr_remove_all(struct idr *idp)
 {
 	int n, id, max;
+	int bt_mask;
 	struct idr_layer *p;
 	struct idr_layer *pa[MAX_LEVEL];
 	struct idr_layer **paa = &pa[0];
@@ -462,8 +463,9 @@ void idr_remove_all(struct idr *idp)
 			p = p->ary[(id >> n) & IDR_MASK];
 		}
 
+		bt_mask = id;
 		id += 1 << n;
-		while (n < fls(id)) {
+		while (n < fls(id & ~bt_mask)) {
 			if (p)
 				free_layer(p);
 			n += IDR_BITS;
_

Patches currently in -mm which might be from imre.deak@nokia.com are

idr-fix-backtrack-logic-in-idr_remove_all.patch

