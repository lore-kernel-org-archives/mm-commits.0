From: akpm@linux-foundation.org
Subject: - atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:00:56 -0700
Message-ID: <200710180700.l9I70uwG031125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45846 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755171AbXJRHet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mattilinnanvuori@yahoo.com, npiggin@suse.de, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     atomic_ops.txt has incorrect, misleading and insufficient information [Bug 9020]
has been removed from the -mm tree.  Its filename was
     atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atomic_ops.txt has incorrect, misleading and insufficient information [Bug 9020]
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

atomic_ops.txt has incorrect, misleading and insufficient information about
semantics of initializer, atomic_set, atomic_read and atomic_xchg.

It also incorrectly implies that operations mentioned above are not actual
atomic operations.

Included is most of the patch Document non-semantics of atomic_read() and
atomic_set() by Chris Snook, except the word "assignment".

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/atomic_ops.txt |   53 ++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 4 deletions(-)

diff -puN Documentation/atomic_ops.txt~atomic_opstxt-has-incorrect-misleading-and-insufficient-information Documentation/atomic_ops.txt
--- a/Documentation/atomic_ops.txt~atomic_opstxt-has-incorrect-misleading-and-insufficient-information
+++ a/Documentation/atomic_ops.txt
@@ -14,12 +14,15 @@ suffice:
 
 	typedef struct { volatile int counter; } atomic_t;
 
+Historically, counter has been declared volatile.  This is now discouraged.
+See Documentation/volatile-considered-harmful.txt for the complete rationale.
+
 local_t is very similar to atomic_t. If the counter is per CPU and only
 updated by one CPU, local_t is probably more appropriate. Please see
 Documentation/local_ops.txt for the semantics of local_t.
 
-	The first operations to implement for atomic_t's are the
-initializers and plain reads.
+The first operations to implement for atomic_t's are the initializers and
+plain reads.
 
 	#define ATOMIC_INIT(i)		{ (i) }
 	#define atomic_set(v, i)	((v)->counter = (i))
@@ -28,6 +31,12 @@ The first macro is used in definitions, 
 
 static atomic_t my_counter = ATOMIC_INIT(1);
 
+The initializer is atomic in that the return values of the atomic operations
+are guaranteed to be correct reflecting the initialized value if the
+initializer is used before runtime.  If the initializer is used at runtime, a
+proper implicit or explicit read memory barrier is needed before reading the
+value with atomic_read from another thread.
+
 The second interface can be used at runtime, as in:
 
 	struct foo { atomic_t counter; };
@@ -40,13 +49,43 @@ The second interface can be used at runt
 		return -ENOMEM;
 	atomic_set(&k->counter, 0);
 
+The setting is atomic in that the return values of the atomic operations by
+all threads are guaranteed to be correct reflecting either the value that has
+been set with this operation or set with another operation.  A proper implicit
+or explicit memory barrier is needed before the value set with the operation
+is guaranteed to be readable with atomic_read from another thread.
+
 Next, we have:
 
 	#define atomic_read(v)	((v)->counter)
 
-which simply reads the current value of the counter.
+which simply reads the counter value currently visible to the calling thread.
+The read is atomic in that the return value is guaranteed to be one of the
+values initialized or modified with the interface operations if a proper
+implicit or explicit memory barrier is used after possible runtime
+initialization by any other thread and the value is modified only with the
+interface operations.  atomic_read does not guarantee that the runtime
+initialization by any other thread is visible yet, so the user of the
+interface must take care of that with a proper implicit or explicit memory
+barrier.
+
+*** WARNING: atomic_read() and atomic_set() DO NOT IMPLY BARRIERS! ***
+
+Some architectures may choose to use the volatile keyword, barriers, or inline
+assembly to guarantee some degree of immediacy for atomic_read() and
+atomic_set().  This is not uniformly guaranteed, and may change in the future,
+so all users of atomic_t should treat atomic_read() and atomic_set() as simple
+C statements that may be reordered or optimized away entirely by the compiler
+or processor, and explicitly invoke the appropriate compiler and/or memory
+barrier for each use case.  Failure to do so will result in code that may
+suddenly break when used with different architectures or compiler
+optimizations, or even changes in unrelated code which changes how the
+compiler optimizes the section accessing atomic_t variables.
 
-Now, we move onto the actual atomic operation interfaces.
+*** YOU HAVE BEEN WARNED! ***
+
+Now, we move onto the atomic operation interfaces typically implemented with
+the help of assembly code.
 
 	void atomic_add(int i, atomic_t *v);
 	void atomic_sub(int i, atomic_t *v);
@@ -121,6 +160,12 @@ operation.
 
 Then:
 
+	int atomic_xchg(atomic_t *v, int new);
+
+This performs an atomic exchange operation on the atomic variable v, setting
+the given new value.  It returns the old value that the atomic variable v had
+just before the operation.
+
 	int atomic_cmpxchg(atomic_t *v, int old, int new);
 
 This performs an atomic compare exchange operation on the atomic value v,
_

Patches currently in -mm which might be from mattilinnanvuori@yahoo.com are

origin.patch
