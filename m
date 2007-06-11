From: akpm@linux-foundation.org
Subject: + document-the-fact-that-rcu-callbacks-can-run-in-parallel.patch added to -mm tree
Date: Mon, 11 Jun 2007 11:15:59 -0700
Message-ID: <200706111815.l5BIFx69025680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753473AbXFKSQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 14:16:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, rostedt@goodmis.org


The patch titled
     Document the fact that RCU callbacks can run in parallel
has been added to the -mm tree.  Its filename is
     document-the-fact-that-rcu-callbacks-can-run-in-parallel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 9 insertions(+), 1 deletion(-)

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

document-the-fact-that-rcu-callbacks-can-run-in-parallel.patch
