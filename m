From: akpm@linux-foundation.org
Subject: + idr-fix-backtrack-logic-in-idr_remove_all-update.patch added to -mm tree
Date: Thu, 20 May 2010 14:41:25 -0700
Message-ID: <201005202141.o4KLfPme006711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119Ab0ETVls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 17:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imre.deak@nokia.com, eparis@redhat.com, paulmck@linux.vnet.ibm.com, stable@kernel.org, tj@kernel.org


The patch titled
     idr-fix-backtrack-logic-in-idr_remove_all-update
has been added to the -mm tree.  Its filename is
     idr-fix-backtrack-logic-in-idr_remove_all-update.patch

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
Subject: idr-fix-backtrack-logic-in-idr_remove_all-update
From: Imre Deak <imre.deak@nokia.com>

Changes since v1:
- changed nand to xor to save an instruction
- add note on how we calculate the backtrack level

Signed-off-by: Imre Deak <imre.deak@nokia.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: <stable@kernel.org>		[2.6.34.1]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/idr.c~idr-fix-backtrack-logic-in-idr_remove_all-update lib/idr.c
--- a/lib/idr.c~idr-fix-backtrack-logic-in-idr_remove_all-update
+++ a/lib/idr.c
@@ -465,7 +465,8 @@ void idr_remove_all(struct idr *idp)
 
 		bt_mask = id;
 		id += 1 << n;
-		while (n < fls(id & ~bt_mask)) {
+		/* Get the highest bit that the above add changed from 0->1. */
+		while (n < fls(id ^ bt_mask)) {
 			if (p)
 				free_layer(p);
 			n += IDR_BITS;
_

Patches currently in -mm which might be from imre.deak@nokia.com are

idr-fix-backtrack-logic-in-idr_remove_all.patch
idr-fix-backtrack-logic-in-idr_remove_all-update.patch

