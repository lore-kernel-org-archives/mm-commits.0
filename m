From: akpm@linux-foundation.org
Subject: - documentation-memory-barrierstxt-various-fixes.patch removed from -mm tree
Date: Tue, 29 May 2007 11:53:15 -0700
Message-ID: <200705291853.l4TIrErg008454@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765103AbXE2SyO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:54:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkao2@o2.pl, dhowells@redhat.com, rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/memory-barriers.txt: various fixes
has been removed from the -mm tree.  Its filename was
     documentation-memory-barrierstxt-various-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation/memory-barriers.txt: various fixes
From: Jarek Poplawski <jarkao2@o2.pl>

Fix various grammatical issues in Documentation/memory-barriers.txt.

Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-barriers.txt |   98 ++++++++++++++--------------
 1 files changed, 49 insertions(+), 49 deletions(-)

diff -puN Documentation/memory-barriers.txt~documentation-memory-barrierstxt-various-fixes Documentation/memory-barriers.txt
--- a/Documentation/memory-barriers.txt~documentation-memory-barrierstxt-various-fixes
+++ a/Documentation/memory-barriers.txt
@@ -24,7 +24,7 @@ Contents:
  (*) Explicit kernel barriers.
 
      - Compiler barrier.
-     - The CPU memory barriers.
+     - CPU memory barriers.
      - MMIO write barrier.
 
  (*) Implicit kernel memory barriers.
@@ -265,7 +265,7 @@ Memory barriers are such interventions. 
 ordering over the memory operations on either side of the barrier.
 
 Such enforcement is important because the CPUs and other devices in a system
-can use a variety of tricks to improve performance - including reordering,
+can use a variety of tricks to improve performance, including reordering,
 deferral and combination of memory operations; speculative loads; speculative
 branch prediction and various types of caching.  Memory barriers are used to
 override or suppress these tricks, allowing the code to sanely control the
@@ -457,7 +457,7 @@ sequence, Q must be either &A or &B, and
 	(Q == &A) implies (D == 1)
 	(Q == &B) implies (D == 4)
 
-But! CPU 2's perception of P may be updated _before_ its perception of B, thus
+But!  CPU 2's perception of P may be updated _before_ its perception of B, thus
 leading to the following situation:
 
 	(Q == &B) and (D == 2) ????
@@ -573,7 +573,7 @@ Basically, the read barrier always has t
 the "weaker" type.
 
 [!] Note that the stores before the write barrier would normally be expected to
-match the loads after the read barrier or data dependency barrier, and vice
+match the loads after the read barrier or the data dependency barrier, and vice
 versa:
 
 	CPU 1                           CPU 2
@@ -588,7 +588,7 @@ versa:
 EXAMPLES OF MEMORY BARRIER SEQUENCES
 ------------------------------------
 
-Firstly, write barriers act as a partial orderings on store operations.
+Firstly, write barriers act as partial orderings on store operations.
 Consider the following sequence of events:
 
 	CPU 1
@@ -608,15 +608,15 @@ STORE B, STORE C } all occurring before 
 	+-------+       :      :
 	|       |       +------+
 	|       |------>| C=3  |     }     /\
-	|       |  :    +------+     }-----  \  -----> Events perceptible
-	|       |  :    | A=1  |     }        \/       to rest of system
+	|       |  :    +------+     }-----  \  -----> Events perceptible to
+	|       |  :    | A=1  |     }        \/       the rest of the system
 	|       |  :    +------+     }
 	| CPU 1 |  :    | B=2  |     }
 	|       |       +------+     }
 	|       |   wwwwwwwwwwwwwwww }   <--- At this point the write barrier
 	|       |       +------+     }        requires all stores prior to the
 	|       |  :    | E=5  |     }        barrier to be committed before
-	|       |  :    +------+     }        further stores may be take place.
+	|       |  :    +------+     }        further stores may take place
 	|       |------>| D=4  |     }
 	|       |       +------+
 	+-------+       :      :
@@ -626,7 +626,7 @@ STORE B, STORE C } all occurring before 
 	                   V
 
 
-Secondly, data dependency barriers act as a partial orderings on data-dependent
+Secondly, data dependency barriers act as partial orderings on data-dependent
 loads.  Consider the following sequence of events:
 
 	CPU 1			CPU 2
@@ -975,7 +975,7 @@ compiler from moving the memory accesses
 
 	barrier();
 
-This a general barrier - lesser varieties of compiler barrier do not exist.
+This is a general barrier - lesser varieties of compiler barrier do not exist.
 
 The compiler barrier has no direct effect on the CPU, which may then reorder
 things however it wishes.
@@ -997,7 +997,7 @@ The Linux kernel has eight basic CPU mem
 All CPU memory barriers unconditionally imply compiler barriers.
 
 SMP memory barriers are reduced to compiler barriers on uniprocessor compiled
-systems because it is assumed that a CPU will be appear to be self-consistent,
+systems because it is assumed that a CPU will appear to be self-consistent,
 and will order overlapping accesses correctly with respect to itself.
 
 [!] Note that SMP memory barriers _must_ be used to control the ordering of
@@ -1146,9 +1146,9 @@ for each construct.  These operations al
 Therefore, from (1), (2) and (4) an UNLOCK followed by an unconditional LOCK is
 equivalent to a full barrier, but a LOCK followed by an UNLOCK is not.
 
-[!] Note: one of the consequence of LOCKs and UNLOCKs being only one-way
-    barriers is that the effects instructions outside of a critical section may
-    seep into the inside of the critical section.
+[!] Note: one of the consequences of LOCKs and UNLOCKs being only one-way
+    barriers is that the effects of instructions outside of a critical section
+    may seep into the inside of the critical section.
 
 A LOCK followed by an UNLOCK may not be assumed to be full memory barrier
 because it is possible for an access preceding the LOCK to happen after the
@@ -1239,7 +1239,7 @@ three CPUs; then should the following se
 	UNLOCK M			UNLOCK Q
 	*D = d;				*H = h;
 
-Then there is no guarantee as to what order CPU #3 will see the accesses to *A
+Then there is no guarantee as to what order CPU 3 will see the accesses to *A
 through *H occur in, other than the constraints imposed by the separate locks
 on the separate CPUs. It might, for example, see:
 
@@ -1269,12 +1269,12 @@ However, if the following occurs:
 					UNLOCK M	[2]
 					*H = h;
 
-CPU #3 might see:
+CPU 3 might see:
 
 	*E, LOCK M [1], *C, *B, *A, UNLOCK M [1],
 		LOCK M [2], *H, *F, *G, UNLOCK M [2], *D
 
-But assuming CPU #1 gets the lock first, it won't see any of:
+But assuming CPU 1 gets the lock first, CPU 3 won't see any of:
 
 	*B, *C, *D, *F, *G or *H preceding LOCK M [1]
 	*A, *B or *C following UNLOCK M [1]
@@ -1327,12 +1327,12 @@ spinlock, for example:
 					mmiowb();
 					spin_unlock(Q);
 
-this will ensure that the two stores issued on CPU #1 appear at the PCI bridge
-before either of the stores issued on CPU #2.
+this will ensure that the two stores issued on CPU 1 appear at the PCI bridge
+before either of the stores issued on CPU 2.
 
 
-Furthermore, following a store by a load to the same device obviates the need
-for an mmiowb(), because the load forces the store to complete before the load
+Furthermore, following a store by a load from the same device obviates the need
+for the mmiowb(), because the load forces the store to complete before the load
 is performed:
 
 	CPU 1				CPU 2
@@ -1363,7 +1363,7 @@ circumstances in which reordering defini
 
  (*) Atomic operations.
 
- (*) Accessing devices (I/O).
+ (*) Accessing devices.
 
  (*) Interrupts.
 
@@ -1399,7 +1399,7 @@ To wake up a particular waiter, the up_r
  (1) read the next pointer from this waiter's record to know as to where the
      next waiter record is;
 
- (4) read the pointer to the waiter's task structure;
+ (2) read the pointer to the waiter's task structure;
 
  (3) clear the task pointer to tell the waiter it has been given the semaphore;
 
@@ -1407,7 +1407,7 @@ To wake up a particular waiter, the up_r
 
  (5) release the reference held on the waiter's task struct.
 
-In otherwords, it has to perform this sequence of events:
+In other words, it has to perform this sequence of events:
 
 	LOAD waiter->list.next;
 	LOAD waiter->task;
@@ -1502,7 +1502,7 @@ operations and adjusting reference count
 such the implicit memory barrier effects are necessary.
 
 
-The following operation are potential problems as they do _not_ imply memory
+The following operations are potential problems as they do _not_ imply memory
 barriers, but might be used for implementing such things as UNLOCK-class
 operations:
 
@@ -1517,7 +1517,7 @@ With these the appropriate explicit memo
 
 The following also do _not_ imply memory barriers, and so may require explicit
 memory barriers under some circumstances (smp_mb__before_atomic_dec() for
-instance)):
+instance):
 
 	atomic_add();
 	atomic_sub();
@@ -1641,8 +1641,8 @@ functions:
      indeed have special I/O space access cycles and instructions, but many
      CPUs don't have such a concept.
 
-     The PCI bus, amongst others, defines an I/O space concept - which on such
-     CPUs as i386 and x86_64 cpus readily maps to the CPU's concept of I/O
+     The PCI bus, amongst others, defines an I/O space concept which - on such
+     CPUs as i386 and x86_64 - readily maps to the CPU's concept of I/O
      space.  However, it may also be mapped as a virtual I/O space in the CPU's
      memory map, particularly on those CPUs that don't support alternate I/O
      spaces.
@@ -1664,7 +1664,7 @@ functions:
      i386 architecture machines, for example, this is controlled by way of the
      MTRR registers.
 
-     Ordinarily, these will be guaranteed to be fully ordered and uncombined,,
+     Ordinarily, these will be guaranteed to be fully ordered and uncombined,
      provided they're not accessing a prefetchable device.
 
      However, intermediary hardware (such as a PCI bridge) may indulge in
@@ -1689,7 +1689,7 @@ functions:
 
  (*) ioreadX(), iowriteX()
 
-     These will perform as appropriate for the type of access they're actually
+     These will perform appropriately for the type of access they're actually
      doing, be it inX()/outX() or readX()/writeX().
 
 
@@ -1705,7 +1705,7 @@ of arch-specific code.
 
 This means that it must be considered that the CPU will execute its instruction
 stream in any order it feels like - or even in parallel - provided that if an
-instruction in the stream depends on the an earlier instruction, then that
+instruction in the stream depends on an earlier instruction, then that
 earlier instruction must be sufficiently complete[*] before the later
 instruction may proceed; in other words: provided that the appearance of
 causality is maintained.
@@ -1795,8 +1795,8 @@ eventually become visible on all CPUs, t
 become apparent in the same order on those other CPUs.
 
 
-Consider dealing with a system that has pair of CPUs (1 & 2), each of which has
-a pair of parallel data caches (CPU 1 has A/B, and CPU 2 has C/D):
+Consider dealing with a system that has a pair of CPUs (1 & 2), each of which
+has a pair of parallel data caches (CPU 1 has A/B, and CPU 2 has C/D):
 
 	            :
 	            :                          +--------+
@@ -1835,7 +1835,7 @@ Imagine the system has the following pro
 
  (*) the coherency queue is not flushed by normal loads to lines already
      present in the cache, even though the contents of the queue may
-     potentially effect those loads.
+     potentially affect those loads.
 
 Imagine, then, that two writes are made on the first CPU, with a write barrier
 between them to guarantee that they will appear to reach that CPU's caches in
@@ -1845,7 +1845,7 @@ the requisite order:
 	===============	===============	=======================================
 					u == 0, v == 1 and p == &u, q == &u
 	v = 2;
-	smp_wmb();			Make sure change to v visible before
+	smp_wmb();			Make sure change to v is visible before
 					 change to p
 	<A:modify v=2>			v is now in cache A exclusively
 	p = &v;
@@ -1853,7 +1853,7 @@ the requisite order:
 
 The write memory barrier forces the other CPUs in the system to perceive that
 the local CPU's caches have apparently been updated in the correct order.  But
-now imagine that the second CPU that wants to read those values:
+now imagine that the second CPU wants to read those values:
 
 	CPU 1		CPU 2		COMMENT
 	===============	===============	=======================================
@@ -1861,7 +1861,7 @@ now imagine that the second CPU that wan
 			q = p;
 			x = *q;
 
-The above pair of reads may then fail to happen in expected order, as the
+The above pair of reads may then fail to happen in the expected order, as the
 cacheline holding p may get updated in one of the second CPU's caches whilst
 the update to the cacheline holding v is delayed in the other of the second
 CPU's caches by some other cache event:
@@ -1916,7 +1916,7 @@ access depends on a read, not all do, so
 
 Other CPUs may also have split caches, but must coordinate between the various
 cachelets for normal memory accesses.  The semantics of the Alpha removes the
-need for coordination in absence of memory barriers.
+need for coordination in the absence of memory barriers.
 
 
 CACHE COHERENCY VS DMA
@@ -1931,10 +1931,10 @@ invalidate them as well).
 
 In addition, the data DMA'd to RAM by a device may be overwritten by dirty
 cache lines being written back to RAM from a CPU's cache after the device has
-installed its own data, or cache lines simply present in a CPUs cache may
-simply obscure the fact that RAM has been updated, until at such time as the
-cacheline is discarded from the CPU's cache and reloaded.  To deal with this,
-the appropriate part of the kernel must invalidate the overlapping bits of the
+installed its own data, or cache lines present in the CPU's cache may simply
+obscure the fact that RAM has been updated, until at such time as the cacheline
+is discarded from the CPU's cache and reloaded.  To deal with this, the
+appropriate part of the kernel must invalidate the overlapping bits of the
 cache on each CPU.
 
 See Documentation/cachetlb.txt for more information on cache management.
@@ -1944,7 +1944,7 @@ CACHE COHERENCY VS MMIO
 -----------------------
 
 Memory mapped I/O usually takes place through memory locations that are part of
-a window in the CPU's memory space that have different properties assigned than
+a window in the CPU's memory space that has different properties assigned than
 the usual RAM directed window.
 
 Amongst these properties is usually the fact that such accesses bypass the
@@ -1960,7 +1960,7 @@ THE THINGS CPUS GET UP TO
 =========================
 
 A programmer might take it for granted that the CPU will perform memory
-operations in exactly the order specified, so that if a CPU is, for example,
+operations in exactly the order specified, so that if the CPU is, for example,
 given the following piece of code to execute:
 
 	a = *A;
@@ -1969,7 +1969,7 @@ given the following piece of code to exe
 	d = *D;
 	*E = e;
 
-They would then expect that the CPU will complete the memory operation for each
+they would then expect that the CPU will complete the memory operation for each
 instruction before moving on to the next one, leading to a definite sequence of
 operations as seen by external observers in the system:
 
@@ -1986,8 +1986,8 @@ assumption doesn't hold because:
  (*) loads may be done speculatively, and the result discarded should it prove
      to have been unnecessary;
 
- (*) loads may be done speculatively, leading to the result having being
-     fetched at the wrong time in the expected sequence of events;
+ (*) loads may be done speculatively, leading to the result having been fetched
+     at the wrong time in the expected sequence of events;
 
  (*) the order of the memory accesses may be rearranged to promote better use
      of the CPU buses and caches;
@@ -2069,12 +2069,12 @@ AND THEN THERE'S THE ALPHA
 
 The DEC Alpha CPU is one of the most relaxed CPUs there is.  Not only that,
 some versions of the Alpha CPU have a split data cache, permitting them to have
-two semantically related cache lines updating at separate times.  This is where
+two semantically-related cache lines updated at separate times.  This is where
 the data dependency barrier really becomes necessary as this synchronises both
 caches with the memory coherence system, thus making it seem like pointer
 changes vs new data occur in the right order.
 
-The Alpha defines the Linux's kernel's memory barrier model.
+The Alpha defines the Linux kernel's memory barrier model.
 
 See the subsection on "Cache Coherency" above.
 
_

Patches currently in -mm which might be from jarkao2@o2.pl are

smpboot-cachesize-comparison-fix-in-smp_tune_scheduling.patch
