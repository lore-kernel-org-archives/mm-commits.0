From: akpm@linux-foundation.org
Subject: - immediate-value-documentation.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:28:52 -0700
Message-ID: <200707070033.l670X3oT029889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbXGGAdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Immediate Value: Documentation
has been removed from the -mm tree.  Its filename was
     immediate-value-documentation.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Immediate Value: Documentation
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/immediate.txt |  103 ++++++++++++++++++++++++++++++++++
 1 files changed, 103 insertions(+)

diff -puN /dev/null Documentation/immediate.txt
--- /dev/null
+++ a/Documentation/immediate.txt
@@ -0,0 +1,103 @@
+		        Using the Immediate Values
+
+			    Mathieu Desnoyers
+
+
+This document introduces Immediate Values and their use.
+
+* Purpose of immediate values
+
+An immediate value is used to compile into the kernel a branch that is disabled
+at compile-time that has almost no measurable performance impact on the kernel.
+Then, at runtime, it can be enabled dynamically.
+
+It can be used to compile code in the kernel that is seldomly meant to be
+dynamically activated. It's the case of CPU specific workarounds, profiling,
+tracing, etc.
+
+This infrastructure is specialized in supporting dynamic patching of the values
+in the instruction stream when multiple CPUs are running without disturbing the
+normal system behavior.
+
+
+* Usage
+
+In order to use the macro immediate, you should include linux/immediate.h.
+
+#include <linux/immediate.h>
+
+immediate_t __read_mostly this_immediate;
+EXPORT_SYMBOL(this_immediate);
+
+
+Add, in your code :
+
+if (unlikely(immediate(this_immediate))) {
+	some code...
+}
+
+And then, use:
+
+Use immediate_arm(&this_immediate) to activate the immediate value.
+
+Use immediate_disarm(&this_immediate) to deactivate the immediate value.
+
+Use immediate_query(&this_immediate) to query the immediate value state.
+
+The immediate mechanism supports inserting multiple instances of the same
+immediate. Immediate values can be put in inline functions, inlined static
+functions, and unrolled loops.
+
+
+* Optimization for a given architecture
+
+One can implement optimized immediate values for a given architecture by
+replacing asm-$ARCH/immediate.h.
+
+The IF_* flags can be used to control the type of immediate value. See the
+include/linux/immediate.h header for the list of flags. They can be specified as
+the first parameter of the _immediate() macro, as in the following example,
+which uses flags to declare a immediate that always uses the generic version of
+the immediates. It can be useful to use this when immediates are placed in
+kernel code presenting particular reentrancy challenges.
+
+if (unlikely(_immediate(IF_DEFAULT & ~IF_OPTIMIZED, this_immediate))) {
+	some code...
+}
+
+
+* Performance improvement
+
+Result of a small test comparing:
+
+1 - Branch depending on a cache miss (has to fetch in memory, caused by a 128
+    bytes stride)). This is the test that is likely to look like what
+    side-effect the original profile_hit code was causing, under the
+    assumption that the kernel is already using L1 and L2 caches at
+    their full capacity and that a supplementary data load would cause
+    cache trashing.
+2 - Branch depending on L1 cache hit. Just for comparison.
+3 - Branch depending on a load immediate in the instruction stream.
+
+It has been compiled with gcc -O2. Tests done on a 3GHz P4.
+
+In the first test series, the branch is not taken:
+
+number of tests : 1000
+number of branches per test : 81920
+memory hit cycles per iteration (mean) : 48.252
+L1 cache hit cycles per iteration (mean) : 16.1693
+instruction stream based test, cycles per iteration (mean) : 16.0432
+
+
+In the second test series, the branch is taken and an integer is
+incremented within the block:
+
+number of tests : 1000
+number of branches per test : 81920
+memory hit cycles per iteration (mean) : 48.2691
+L1 cache hit cycles per iteration (mean) : 16.396
+instruction stream based test, cycles per iteration (mean) : 16.0441
+
+Therefore, the memory fetch based test seems to be 200% slower than the
+load immediate based test.
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
scheduler-profiling-use-immediate-values-fix.patch
cxgb3-vs-immediate-stuff.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
