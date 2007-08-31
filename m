From: akpm@linux-foundation.org
Subject: + local_t-documentation-update-2.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:19:21 -0700
Message-ID: <200708311919.l7VJJLLj022599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45310 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965088AbXHaTTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:19:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, grundler@parisc-linux.org


The patch titled
     local_t Documentation update 2
has been added to the -mm tree.  Its filename is
     local_t-documentation-update-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: local_t Documentation update 2
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Grant Grundler was asking for more detail about correct usage of local
atomic operations and suggested adding the resulting summary to
local_ops.txt.

"Please add a bit more detail.  If DaveM is correct (he normally is), then
there must be limits on how the local_t can be used in the kernel process
and interrupt contexts.  I'd like those rules spelled out very clearly
since it's easy to get wrong and tracking down such a bug is quite
painful."

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/local_ops.txt |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+)

diff -puN Documentation/local_ops.txt~local_t-documentation-update-2 Documentation/local_ops.txt
--- a/Documentation/local_ops.txt~local_t-documentation-update-2
+++ a/Documentation/local_ops.txt
@@ -45,6 +45,29 @@ long fails. The definition looks like :
 typedef struct { atomic_long_t a; } local_t;
 
 
+* Rules to follow when using local atomic operations
+
+- Variables touched by local ops must be per cpu variables.
+- _Only_ the CPU owner of these variables must write to them.
+- This CPU can use local ops from any context (process, irq, softirq, nmi, ...)
+  to update its local_t variables.
+- Preemption (or interrupts) must be disabled when using local ops in
+  process context to   make sure the process won't be migrated to a
+  different CPU between getting the per-cpu variable and doing the
+  actual local op.
+- When using local ops in interrupt context, no special care must be
+  taken on a mainline kernel, since they will run on the local CPU with
+  preemption already disabled. I suggest, however, to explicitly
+  disable preemption anyway to make sure it will still work correctly on
+  -rt kernels.
+- Reading the local cpu variable will provide the current copy of the
+  variable.
+- Reads of these variables can be done from any CPU, because updates to
+  "long", aligned, variables are always atomic. Since no memory
+  synchronization is done by the writer CPU, an outdated copy of the
+  variable can be read when reading some _other_ cpu's variables.
+
+
 * How to use local atomic operations
 
 #include <linux/percpu.h>
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
git-mips.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
local_t-documentation-update-2.patch
local_t-update-documentation.patch
