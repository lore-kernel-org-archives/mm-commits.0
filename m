From: akpm@linux-foundation.org
Subject: - rcu-1q08-rcu-doc-update-add-call_rcu_sched.patch removed from -mm tree
Date: Fri, 02 May 2008 15:20:29 -0700
Message-ID: <200805022220.m42MKTrt017844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932353AbYEBWVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 18:21:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, josh@kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     rcu: 1Q08 RCU doc update, add call_rcu_sched()
has been removed from the -mm tree.  Its filename was
     rcu-1q08-rcu-doc-update-add-call_rcu_sched.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: 1Q08 RCU doc update, add call_rcu_sched()
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Long-delayed update to the RCU documentation, including adding the new
call_rcu_sched() and rcu_barrier_sched() APIs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/RCU/NMI-RCU.txt   |    3 
 Documentation/RCU/RTFP.txt      |  108 ++++++++++++++++++++++++++++++
 Documentation/RCU/checklist.txt |   89 ++++++++++++++++--------
 Documentation/RCU/whatisRCU.txt |   58 ++++++++++------
 4 files changed, 210 insertions(+), 48 deletions(-)

diff -puN Documentation/RCU/NMI-RCU.txt~rcu-1q08-rcu-doc-update-add-call_rcu_sched Documentation/RCU/NMI-RCU.txt
--- a/Documentation/RCU/NMI-RCU.txt~rcu-1q08-rcu-doc-update-add-call_rcu_sched
+++ a/Documentation/RCU/NMI-RCU.txt
@@ -93,6 +93,9 @@ Since NMI handlers disable preemption, s
 not to return until all ongoing NMI handlers exit.  It is therefore safe
 to free up the handler's data as soon as synchronize_sched() returns.
 
+Important note: for this to work, the architecture in question must
+invoke irq_enter() and irq_exit() on NMI entry and exit, respectively.
+
 
 Answer to Quick Quiz
 
diff -puN Documentation/RCU/RTFP.txt~rcu-1q08-rcu-doc-update-add-call_rcu_sched Documentation/RCU/RTFP.txt
--- a/Documentation/RCU/RTFP.txt~rcu-1q08-rcu-doc-update-add-call_rcu_sched
+++ a/Documentation/RCU/RTFP.txt
@@ -52,6 +52,10 @@ of each iteration.  Unfortunately, chaot
 structured data, such as the matrices used in scientific programs, and
 is thus inapplicable to most data structures in operating-system kernels.
 
+In 1992, Henry (now Alexia) Massalin completed a dissertation advising
+parallel programmers to defer processing when feasible to simplify
+synchronization.  RCU makes extremely heavy use of this advice.
+
 In 1993, Jacobson [Jacobson93] verbally described what is perhaps the
 simplest deferred-free technique: simply waiting a fixed amount of time
 before freeing blocks awaiting deferred free.  Jacobson did not describe
@@ -138,6 +142,13 @@ blocking in read-side critical sections 
 Robert Olsson described an RCU-protected trie-hash combination
 [RobertOlsson2006a].
 
+2007 saw the journal version of the award-winning RCU paper from 2006
+[ThomasEHart2007a], as well as a paper demonstrating use of Promela
+and Spin to mechanically verify an optimization to Oleg Nesterov's
+QRCU [PaulEMcKenney2007QRCUspin], a design document describing
+preemptible RCU [PaulEMcKenney2007PreemptibleRCU], and the three-part
+LWN "What is RCU?" series [PaulEMcKenney2007WhatIsRCUFundamentally,
+PaulEMcKenney2008WhatIsRCUUsage, and PaulEMcKenney2008WhatIsRCUAPI].
 
 Bibtex Entries
 
@@ -202,6 +213,20 @@ Bibtex Entries
 ,Year="1991"
 }
 
+@phdthesis{HMassalinPhD
+,author="H. Massalin"
+,title="Synthesis: An Efficient Implementation of Fundamental Operating
+System Services"
+,school="Columbia University"
+,address="New York, NY"
+,year="1992"
+,annotation="
+	Mondo optimizing compiler.
+	Wait-free stuff.
+	Good advice: defer work to avoid synchronization.
+"
+}
+
 @unpublished{Jacobson93
 ,author="Van Jacobson"
 ,title="Avoid Read-Side Locking Via Delayed Free"
@@ -635,3 +660,86 @@ Revised:
 "
 }
 
+@unpublished{PaulEMcKenney2007PreemptibleRCU
+,Author="Paul E. McKenney"
+,Title="The design of preemptible read-copy-update"
+,month="October"
+,day="8"
+,year="2007"
+,note="Available:
+\url{http://lwn.net/Articles/253651/}
+[Viewed October 25, 2007]"
+,annotation="
+	LWN article describing the design of preemptible RCU.
+"
+}
+
+########################################################################
+#
+#	"What is RCU?" LWN series.
+#
+
+@unpublished{PaulEMcKenney2007WhatIsRCUFundamentally
+,Author="Paul E. McKenney and Jonathan Walpole"
+,Title="What is {RCU}, Fundamentally?"
+,month="December"
+,day="17"
+,year="2007"
+,note="Available:
+\url{http://lwn.net/Articles/262464/}
+[Viewed December 27, 2007]"
+,annotation="
+	Lays out the three basic components of RCU: (1) publish-subscribe,
+	(2) wait for pre-existing readers to complete, and (2) maintain
+	multiple versions.
+"
+}
+
+@unpublished{PaulEMcKenney2008WhatIsRCUUsage
+,Author="Paul E. McKenney"
+,Title="What is {RCU}? Part 2: Usage"
+,month="January"
+,day="4"
+,year="2008"
+,note="Available:
+\url{http://lwn.net/Articles/263130/}
+[Viewed January 4, 2008]"
+,annotation="
+	Lays out six uses of RCU:
+	1. RCU is a Reader-Writer Lock Replacement
+	2. RCU is a Restricted Reference-Counting Mechanism
+	3. RCU is a Bulk Reference-Counting Mechanism
+	4. RCU is a Poor Man's Garbage Collector
+	5. RCU is a Way of Providing Existence Guarantees
+	6. RCU is a Way of Waiting for Things to Finish
+"
+}
+
+@unpublished{PaulEMcKenney2008WhatIsRCUAPI
+,Author="Paul E. McKenney"
+,Title="{RCU} part 3: the {RCU} {API}"
+,month="January"
+,day="17"
+,year="2008"
+,note="Available:
+\url{http://lwn.net/Articles/264090/}
+[Viewed January 10, 2008]"
+,annotation="
+	Gives an overview of the Linux-kernel RCU API and a brief annotated RCU
+	bibliography.
+"
+}
+
+@article{DinakarGuniguntala2008IBMSysJ
+,author="D. Guniguntala and P. E. McKenney and J. Triplett and J. Walpole"
+,title="The read-copy-update mechanism for supporting real-time applications on shared-memory multiprocessor systems with {Linux}"
+,Year="2008"
+,Month="April"
+,journal="IBM Systems Journal"
+,volume="47"
+,number="2"
+,pages="@@-@@"
+,annotation="
+	RCU, realtime RCU, sleepable RCU, performance.
+"
+}
diff -puN Documentation/RCU/checklist.txt~rcu-1q08-rcu-doc-update-add-call_rcu_sched Documentation/RCU/checklist.txt
--- a/Documentation/RCU/checklist.txt~rcu-1q08-rcu-doc-update-add-call_rcu_sched
+++ a/Documentation/RCU/checklist.txt
@@ -13,10 +13,13 @@ over a rather long period of time, but i
 	detailed performance measurements show that RCU is nonetheless
 	the right tool for the job.
 
-	The other exception would be where performance is not an issue,
-	and RCU provides a simpler implementation.  An example of this
-	situation is the dynamic NMI code in the Linux 2.6 kernel,
-	at least on architectures where NMIs are rare.
+	Another exception is where performance is not an issue, and RCU
+	provides a simpler implementation.  An example of this situation
+	is the dynamic NMI code in the Linux 2.6 kernel, at least on
+	architectures where NMIs are rare.
+
+	Yet another exception is where the low real-time latency of RCU's
+	read-side primitives is critically important.
 
 1.	Does the update code have proper mutual exclusion?
 
@@ -39,9 +42,10 @@ over a rather long period of time, but i
 
 2.	Do the RCU read-side critical sections make proper use of
 	rcu_read_lock() and friends?  These primitives are needed
-	to suppress preemption (or bottom halves, in the case of
-	rcu_read_lock_bh()) in the read-side critical sections,
-	and are also an excellent aid to readability.
+	to prevent grace periods from ending prematurely, which
+	could result in data being unceremoniously freed out from
+	under your read-side code, which can greatly increase the
+	actuarial risk of your kernel.
 
 	As a rough rule of thumb, any dereference of an RCU-protected
 	pointer must be covered by rcu_read_lock() or rcu_read_lock_bh()
@@ -54,15 +58,30 @@ over a rather long period of time, but i
 	be running while updates are in progress.  There are a number
 	of ways to handle this concurrency, depending on the situation:
 
-	a.	Make updates appear atomic to readers.  For example,
+	a.	Use the RCU variants of the list and hlist update
+		primitives to add, remove, and replace elements on an
+		RCU-protected list.  Alternatively, use the RCU-protected
+		trees that have been added to the Linux kernel.
+
+		This is almost always the best approach.
+
+	b.	Proceed as in (a) above, but also maintain per-element
+		locks (that are acquired by both readers and writers)
+		that guard per-element state.  Of course, fields that
+		the readers refrain from accessing can be guarded by the
+		update-side lock.
+
+		This works quite well, also.
+
+	c.	Make updates appear atomic to readers.  For example,
 		pointer updates to properly aligned fields will appear
 		atomic, as will individual atomic primitives.  Operations
 		performed under a lock and sequences of multiple atomic
 		primitives will -not- appear to be atomic.
 
-		This is almost always the best approach.
+		This can work, but is starting to get a bit tricky.
 
-	b.	Carefully order the updates and the reads so that
+	d.	Carefully order the updates and the reads so that
 		readers see valid data at all phases of the update.
 		This is often more difficult than it sounds, especially
 		given modern CPUs' tendency to reorder memory references.
@@ -123,18 +142,22 @@ over a rather long period of time, but i
 		when publicizing a pointer to a structure that can
 		be traversed by an RCU read-side critical section.
 
-5.	If call_rcu(), or a related primitive such as call_rcu_bh(),
-	is used, the callback function must be written to be called
-	from softirq context.  In particular, it cannot block.
+5.	If call_rcu(), or a related primitive such as call_rcu_bh() or
+	call_rcu_sched(), is used, the callback function must be
+	written to be called from softirq context.  In particular,
+	it cannot block.
 
 6.	Since synchronize_rcu() can block, it cannot be called from
-	any sort of irq context.
+	any sort of irq context.  Ditto for synchronize_sched() and
+	synchronize_srcu().
 
 7.	If the updater uses call_rcu(), then the corresponding readers
 	must use rcu_read_lock() and rcu_read_unlock().  If the updater
 	uses call_rcu_bh(), then the corresponding readers must use
-	rcu_read_lock_bh() and rcu_read_unlock_bh().  Mixing things up
-	will result in confusion and broken kernels.
+	rcu_read_lock_bh() and rcu_read_unlock_bh().  If the updater
+	uses call_rcu_sched(), then the corresponding readers must
+	disable preemption.  Mixing things up will result in confusion
+	and broken kernels.
 
 	One exception to this rule: rcu_read_lock() and rcu_read_unlock()
 	may be substituted for rcu_read_lock_bh() and rcu_read_unlock_bh()
@@ -143,9 +166,9 @@ over a rather long period of time, but i
 	such cases is a must, of course!  And the jury is still out on
 	whether the increased speed is worth it.
 
-8.	Although synchronize_rcu() is a bit slower than is call_rcu(),
-	it usually results in simpler code.  So, unless update
-	performance is critically important or the updaters cannot block,
+8.	Although synchronize_rcu() is slower than is call_rcu(), it
+	usually results in simpler code.  So, unless update performance
+	is critically important or the updaters cannot block,
 	synchronize_rcu() should be used in preference to call_rcu().
 
 	An especially important property of the synchronize_rcu()
@@ -187,23 +210,23 @@ over a rather long period of time, but i
 		number of updates per grace period.
 
 9.	All RCU list-traversal primitives, which include
-	list_for_each_rcu(), list_for_each_entry_rcu(),
+	rcu_dereference(), list_for_each_rcu(), list_for_each_entry_rcu(),
 	list_for_each_continue_rcu(), and list_for_each_safe_rcu(),
-	must be within an RCU read-side critical section.  RCU
+	must be either within an RCU read-side critical section or
+	must be protected by appropriate update-side locks.  RCU
 	read-side critical sections are delimited by rcu_read_lock()
 	and rcu_read_unlock(), or by similar primitives such as
 	rcu_read_lock_bh() and rcu_read_unlock_bh().
 
-	Use of the _rcu() list-traversal primitives outside of an
-	RCU read-side critical section causes no harm other than
-	a slight performance degradation on Alpha CPUs.  It can
-	also be quite helpful in reducing code bloat when common
-	code is shared between readers and updaters.
+	The reason that it is permissible to use RCU list-traversal
+	primitives when the update-side lock is held is that doing so
+	can be quite helpful in reducing code bloat when common code is
+	shared between readers and updaters.
 
 10.	Conversely, if you are in an RCU read-side critical section,
-	you -must- use the "_rcu()" variants of the list macros.
-	Failing to do so will break Alpha and confuse people reading
-	your code.
+	and you don't hold the appropriate update-side lock, you -must-
+	use the "_rcu()" variants of the list macros.  Failing to do so
+	will break Alpha and confuse people reading your code.
 
 11.	Note that synchronize_rcu() -only- guarantees to wait until
 	all currently executing rcu_read_lock()-protected RCU read-side
@@ -230,6 +253,14 @@ over a rather long period of time, but i
 	must use whatever locking or other synchronization is required
 	to safely access and/or modify that data structure.
 
+	RCU callbacks are -usually- executed on the same CPU that executed
+	the corresponding call_rcu(), call_rcu_bh(), or call_rcu_sched(),
+	but are by -no- means guaranteed to be.  For example, if a given
+	CPU goes offline while having an RCU callback pending, then that
+	RCU callback will execute on some surviving CPU.  (If this was
+	not the case, a self-spawning RCU callback would prevent the
+	victim CPU from ever going offline.)
+
 14.	SRCU (srcu_read_lock(), srcu_read_unlock(), and synchronize_srcu())
 	may only be invoked from process context.  Unlike other forms of
 	RCU, it -is- permissible to block in an SRCU read-side critical
diff -puN Documentation/RCU/whatisRCU.txt~rcu-1q08-rcu-doc-update-add-call_rcu_sched Documentation/RCU/whatisRCU.txt
--- a/Documentation/RCU/whatisRCU.txt~rcu-1q08-rcu-doc-update-add-call_rcu_sched
+++ a/Documentation/RCU/whatisRCU.txt
@@ -1,3 +1,11 @@
+Please note that the "What is RCU?" LWN series is an excellent place
+to start learning about RCU:
+
+1.	What is RCU, Fundamentally?  http://lwn.net/Articles/262464/
+2.	What is RCU? Part 2: Usage   http://lwn.net/Articles/263130/
+3.	RCU part 3: the RCU API      http://lwn.net/Articles/264090/
+
+
 What is RCU?
 
 RCU is a synchronization mechanism that was added to the Linux kernel
@@ -772,26 +780,18 @@ Linux-kernel source code, but it helps t
 APIs, since there does not appear to be a way to categorize them
 in docbook.  Here is the list, by category.
 
-Markers for RCU read-side critical sections:
-
-	rcu_read_lock
-	rcu_read_unlock
-	rcu_read_lock_bh
-	rcu_read_unlock_bh
-	srcu_read_lock
-	srcu_read_unlock
-
 RCU pointer/list traversal:
 
 	rcu_dereference
+	list_for_each_entry_rcu
+	hlist_for_each_entry_rcu
+
 	list_for_each_rcu		(to be deprecated in favor of
 					 list_for_each_entry_rcu)
-	list_for_each_entry_rcu
 	list_for_each_continue_rcu	(to be deprecated in favor of new
 					 list_for_each_entry_continue_rcu)
-	hlist_for_each_entry_rcu
 
-RCU pointer update:
+RCU pointer/list update:
 
 	rcu_assign_pointer
 	list_add_rcu
@@ -799,16 +799,36 @@ RCU pointer update:
 	list_del_rcu
 	list_replace_rcu
 	hlist_del_rcu
+	hlist_add_after_rcu
+	hlist_add_before_rcu
 	hlist_add_head_rcu
+	hlist_replace_rcu
+	list_splice_init_rcu()
 
-RCU grace period:
+RCU:	Critical sections	Grace period		Barrier
+
+	rcu_read_lock		synchronize_net		rcu_barrier
+	rcu_read_unlock		synchronize_rcu
+				call_rcu
+
+
+bh:	Critical sections	Grace period		Barrier
+
+	rcu_read_lock_bh	call_rcu_bh		rcu_barrier_bh
+	rcu_read_unlock_bh
+
+
+sched:	Critical sections	Grace period		Barrier
+
+	[preempt_disable]	synchronize_sched	rcu_barrier_sched
+	[and friends]		call_rcu_sched
+
+
+SRCU:	Critical sections	Grace period		Barrier
+
+	srcu_read_lock		synchronize_srcu	N/A
+	srcu_read_unlock
 
-	synchronize_net
-	synchronize_sched
-	synchronize_rcu
-	synchronize_srcu
-	call_rcu
-	call_rcu_bh
 
 See the comment headers in the source code (or the docbook generated
 from them) for more information.
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
linux-next.patch
add-rcu_assign_index-if-ever-needed.patch
rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch
add-warn_on_secs-macro.patch
use-warn_on_secs-in-rcupreempth.patch

