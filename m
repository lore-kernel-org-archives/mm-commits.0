From: akpm@linux-foundation.org
Subject: - local_t-documentation-fix.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:18:51 -0800
Message-ID: <200702100818.l1A8IqiO007089@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39487 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbXBJITB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:19:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     local_t : Documentation - update
has been removed from the -mm tree.  Its filename was
     local_t-documentation-fix.patch

This patch was dropped because it was folded into local_t-documentation.patch

------------------------------------------------------
Subject: local_t : Documentation - update
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/local_ops.txt |   15 +++++++++++++++
 1 files changed, 15 insertions(+)

diff -puN Documentation/local_ops.txt~local_t-documentation-fix Documentation/local_ops.txt
--- a/Documentation/local_ops.txt~local_t-documentation-fix
+++ a/Documentation/local_ops.txt
@@ -22,6 +22,13 @@ require disabling interrupts to protect 
 coherent counters in NMI handlers. It is especially useful for tracing purposes
 and for various performance monitoring counters.
 
+Local atomic operations only guarantee variable modification atomicity wrt the
+CPU which owns the data. Therefore, care must taken to make sure that only one
+CPU writes to the local_t data. This is done by using per cpu data and making
+sure that we modify it from within a preemption safe context. It is however
+permitted to read local_t data from any CPU : it will then appear to be written
+out of order wrt other memory writes on the owner CPU.
+
 
 * Implementation for a given architecture
 
@@ -31,6 +38,12 @@ i386 and x86_64) and any SMP sychronizat
 not have a different behavior between SMP and UP, including asm-generic/local.h
 in your archtecture's local.h is sufficient.
 
+The local_t type is defined as an opaque signed long by embedding an
+atomic_long_t inside a structure. This is made so a cast from this type to a
+long fails. The definition looks like :
+
+typedef struct { atomic_long_t a; } local_t;
+
 
 * How to use local atomic operations
 
@@ -42,6 +55,8 @@ static DEFINE_PER_CPU(local_t, counters)
 
 * Counting
 
+Counting is done on all the bits of a signed long.
+
 In preemptible context, use get_cpu_var() and put_cpu_var() around local atomic
 operations : it makes sure that preemption is disabled around write access to
 the per cpu variable. For instance :
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
kernel-time-clocksourcec-needs-struct-task_struct-on-m68k.patch
relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
local_t-documentation-fix.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
