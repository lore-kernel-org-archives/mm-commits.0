From: akpm@linux-foundation.org
Subject: + rcu-documentation-1q09-update.patch added to -mm tree
Date: Mon, 09 Mar 2009 13:35:24 -0700
Message-ID: <200903092035.n29KZOH8003999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbZCIUf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 16:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu


The patch titled
     rcu: documentation 1Q09 update
has been added to the -mm tree.  Its filename is
     rcu-documentation-1q09-update.patch

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
Subject: rcu: documentation 1Q09 update
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Update the RCU documentation to call out the need for callers of
primitives like call_rcu() and synchronize_rcu() to prevent subsequent RCU
readers from hazard.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/RCU/checklist.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN Documentation/RCU/checklist.txt~rcu-documentation-1q09-update Documentation/RCU/checklist.txt
--- a/Documentation/RCU/checklist.txt~rcu-documentation-1q09-update
+++ a/Documentation/RCU/checklist.txt
@@ -298,3 +298,15 @@ over a rather long period of time, but i
 
 	Note that, rcu_assign_pointer() and rcu_dereference() relate to
 	SRCU just as they do to other forms of RCU.
+
+15.	The whole point of call_rcu(), synchronize_rcu(), and friends
+	is to wait until all pre-existing readers have finished before
+	carrying out some otherwise-destructive operation.  It is
+	therefore critically important to -first- remove any path
+	that readers can follow that could be affected by the
+	destructive operation, and -only- -then- invoke call_rcu(),
+	synchronize_rcu(), or friends.
+
+	Because these primitives only wait for pre-existing readers,
+	it is the caller's responsibility to guarantee safety to
+	any subsequent readers.
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
idr-make-idr_remove_all-do-removal-before-free_layer.patch
rcu-documentation-1q09-update.patch
linux-next.patch

