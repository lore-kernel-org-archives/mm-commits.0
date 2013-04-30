From: akpm@linux-foundation.org
Subject: [merged] lib-int_sqrtc-optimize-square-root-algorithm.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:14 -0700
Message-ID: <20130430185314.8C62B31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:63168 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3D3SxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:15 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so86591vcb.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidlohr.bueso@hp.com, jgonzlez@linets.cl, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/int_sqrt.c: optimize square root algorithm
has been removed from the -mm tree.  Its filename was
     lib-int_sqrtc-optimize-square-root-algorithm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: lib/int_sqrt.c: optimize square root algorithm

Optimize the current version of the shift-and-subtract (hardware)
algorithm, described by John von Newmann[1] and Guy L.  Steele.

Iterating 1,000,000 times, perf shows for the current version:

 Performance counter stats for './sqrt-curr' (10 runs):

         27.170996 task-clock                #    0.979 CPUs utilized            ( +-  3.19% )
                 3 context-switches          #    0.103 K/sec                    ( +-  4.76% )
                 0 cpu-migrations            #    0.004 K/sec                    ( +-100.00% )
               104 page-faults               #    0.004 M/sec                    ( +-  0.16% )
        64,921,199 cycles                    #    2.389 GHz                      ( +-  0.03% )
        28,967,789 stalled-cycles-frontend   #   44.62% frontend cycles idle     ( +-  0.18% )
   <not supported> stalled-cycles-backend
       104,502,623 instructions              #    1.61  insns per cycle
                                             #    0.28  stalled cycles per insn  ( +-  0.00% )
        34,088,368 branches                  # 1254.587 M/sec                    ( +-  0.00% )
             4,901 branch-misses             #    0.01% of all branches          ( +-  1.32% )

       0.027763015 seconds time elapsed                                          ( +-  3.22% )

And for the new version:

Performance counter stats for './sqrt-new' (10 runs):

          0.496869 task-clock                #    0.519 CPUs utilized            ( +-  2.38% )
                 0 context-switches          #    0.000 K/sec
                 0 cpu-migrations            #    0.403 K/sec                    ( +-100.00% )
               104 page-faults               #    0.209 M/sec                    ( +-  0.15% )
           590,760 cycles                    #    1.189 GHz                      ( +-  2.35% )
           395,053 stalled-cycles-frontend   #   66.87% frontend cycles idle     ( +-  3.67% )
   <not supported> stalled-cycles-backend
           398,963 instructions              #    0.68  insns per cycle
                                             #    0.99  stalled cycles per insn  ( +-  0.39% )
            70,228 branches                  #  141.341 M/sec                    ( +-  0.36% )
             3,364 branch-misses             #    4.79% of all branches          ( +-  5.45% )

       0.000957440 seconds time elapsed                                          ( +-  2.42% )

Furthermore, this saves space in instruction text:

   text    data     bss     dec     hex filename
    111       0       0     111      6f lib/int_sqrt-baseline.o
     89       0       0      89      59 lib/int_sqrt.o

[1] http://en.wikipedia.org/wiki/First_Draft_of_a_Report_on_the_EDVAC

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Reviewed-by: Jonathan Gonzalez <jgonzlez@linets.cl>
Tested-by: Jonathan Gonzalez <jgonzlez@linets.cl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/int_sqrt.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff -puN lib/int_sqrt.c~lib-int_sqrtc-optimize-square-root-algorithm lib/int_sqrt.c
--- a/lib/int_sqrt.c~lib-int_sqrtc-optimize-square-root-algorithm
+++ a/lib/int_sqrt.c
@@ -1,3 +1,9 @@
+/*
+ * Copyright (C) 2013 Davidlohr Bueso <davidlohr.bueso@hp.com>
+ *
+ *  Based on the shift-and-subtract algorithm for computing integer
+ *  square root from Guy L. Steele.
+ */
 
 #include <linux/kernel.h>
 #include <linux/export.h>
@@ -10,23 +16,23 @@
  */
 unsigned long int_sqrt(unsigned long x)
 {
-	unsigned long op, res, one;
+	unsigned long b, m, y = 0;
 
-	op = x;
-	res = 0;
+	if (x <= 1)
+		return x;
 
-	one = 1UL << (BITS_PER_LONG - 2);
-	while (one > op)
-		one >>= 2;
-
-	while (one != 0) {
-		if (op >= res + one) {
-			op = op - (res + one);
-			res = res +  2 * one;
+	m = 1UL << (BITS_PER_LONG - 2);
+	while (m != 0) {
+		b = y + m;
+		y >>= 1;
+
+		if (x >= b) {
+			x -= b;
+			y += m;
 		}
-		res /= 2;
-		one /= 4;
+		m >>= 2;
 	}
-	return res;
+
+	return y;
 }
 EXPORT_SYMBOL(int_sqrt);
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch
linux-next.patch
ipc-remove-bogus-lock-comment-for-ipc_checkid.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipc-introduce-lockless-pre_down-ipcctl.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch
ipcsem-fine-grained-locking-for-semtimedop-fix-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-fix-locking-in-semctl_main.patch
ipcsem-fine-grained-locking-for-semtimedop-untangle-rcu-locking-with-find_alloc_undo.patch
ipcsem-fine-grained-locking-for-semtimedop-do-not-call-sem_lock-when-bogus-sma.patch
ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic.patch
ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic-fix.patch
rbtree_test-add-extra-rbtree-integrity-check.patch
rbtree_test-add-__init-__exit-annotations.patch

