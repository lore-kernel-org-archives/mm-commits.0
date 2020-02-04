From: akpm@linux-foundation.org
Subject: [merged]
 smp_mb__beforeafter_atomic-update-documentation.patch removed from -mm tree
Date: Tue, 04 Feb 2020 10:40:28 -0800
Message-ID: <20200204184028.-wkdHhDUO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727456AbgBDSk3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 1vier1@web.de, dave@stgolabs.net, longman@redhat.com, manfred@colorfullife.com, mm-commits@vger.kernel.org, peterz@infradead.org, will.deacon@arm.com


The patch titled
     Subject: smp_mb__{before,after}_atomic(): update Documentation
has been removed from the -mm tree.  Its filename was
     smp_mb__beforeafter_atomic-update-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: smp_mb__{before,after}_atomic(): update Documentation

When adding the _{acquire|release|relaxed}() variants of some atomic
operations, it was forgotten to update Documentation/memory_barrier.txt:

smp_mb__{before,after}_atomic() is now intended for all RMW operations
that do not imply a memory barrier.

1)
	smp_mb__before_atomic();
	atomic_add();

2)
	smp_mb__before_atomic();
	atomic_xchg_relaxed();

3)
	smp_mb__before_atomic();
	atomic_fetch_add_relaxed();

Invalid would be:
	smp_mb__before_atomic();
	atomic_set();

In addition, the patch splits the long sentence into multiple shorter
sentences.

Link: http://lkml.kernel.org/r/20191020123305.14715-2-manfred@colorfullife.com
Fixes: 654672d4ba1a ("locking/atomics: Add _{acquire|release|relaxed}() variants of some atomic operations")
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <1vier1@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-barriers.txt |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/Documentation/memory-barriers.txt~smp_mb__beforeafter_atomic-update-documentation
+++ a/Documentation/memory-barriers.txt
@@ -1868,12 +1868,16 @@ There are some more advanced barrier fun
  (*) smp_mb__before_atomic();
  (*) smp_mb__after_atomic();
 
-     These are for use with atomic (such as add, subtract, increment and
-     decrement) functions that don't return a value, especially when used for
-     reference counting.  These functions do not imply memory barriers.
+     These are for use with atomic RMW functions that do not imply memory
+     barriers, but where the code needs a memory barrier. Examples for atomic
+     RMW functions that do not imply are memory barrier are e.g. add,
+     subtract, (failed) conditional operations, _relaxed functions,
+     but not atomic_read or atomic_set. A common example where a memory
+     barrier may be required is when atomic ops are used for reference
+     counting.
 
-     These are also used for atomic bitop functions that do not return a
-     value (such as set_bit and clear_bit).
+     These are also used for atomic RMW bitop functions that do not imply a
+     memory barrier (such as set_bit and clear_bit).
 
      As an example, consider a piece of code that marks an object as being dead
      and then decrements the object's reference count:
_

Patches currently in -mm which might be from manfred@colorfullife.com are
