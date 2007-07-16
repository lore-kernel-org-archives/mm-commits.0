From: akpm@linux-foundation.org
Subject: - document-the-fact-that-rcu-callbacks-can-run-in-parallel.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:47 -0700
Message-ID: <200707162056.l6GKul74002120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52090 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756822AbXGPVOx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:14:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Document the fact that RCU callbacks can run in parallel
has been removed from the -mm tree.  Its filename was
     document-the-fact-that-rcu-callbacks-can-run-in-parallel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Document the fact that RCU callbacks can run in parallel
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Add an item to the RCU documentation checklist noting that RCU callbacks
can run in parallel.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/RCU/checklist.txt |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN Documentation/RCU/checklist.txt~document-the-fact-that-rcu-callbacks-can-run-in-parallel Documentation/RCU/checklist.txt
--- a/Documentation/RCU/checklist.txt~document-the-fact-that-rcu-callbacks-can-run-in-parallel
+++ a/Documentation/RCU/checklist.txt
@@ -222,7 +222,15 @@ over a rather long period of time, but i
 	deadlock as soon as the RCU callback happens to interrupt that
 	acquisition's critical section.
 
-13.	SRCU (srcu_read_lock(), srcu_read_unlock(), and synchronize_srcu())
+13.	RCU callbacks can be and are executed in parallel.  In many cases,
+	the callback code simply wrappers around kfree(), so that this
+	is not an issue (or, more accurately, to the extent that it is
+	an issue, the memory-allocator locking handles it).  However,
+	if the callbacks do manipulate a shared data structure, they
+	must use whatever locking or other synchronization is required
+	to safely access and/or modify that data structure.
+
+14.	SRCU (srcu_read_lock(), srcu_read_unlock(), and synchronize_srcu())
 	may only be invoked from process context.  Unlike other forms of
 	RCU, it -is- permissible to block in an SRCU read-side critical
 	section (demarked by srcu_read_lock() and srcu_read_unlock()),
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
