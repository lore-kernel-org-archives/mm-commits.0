From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-documentation-update-adds-context.patch added to -mm tree
Date: Fri, 16 Feb 2007 13:55:28 -0800
Message-ID: <200702162155.l1GLtSfH010844@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37873 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946141AbXBPVzg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 16:55:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     Linux Kernel Markers: Documentation update (adds context)
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-documentation-update-adds-context.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Linux Kernel Markers: Documentation update (adds context)
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Following a comment from David Wilder, who read the documentation from a
non-expert-yet point of view, I decided to add some paragraphs explaining
"what is a marker" a little better.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/marker.txt |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff -puN Documentation/marker.txt~linux-kernel-markers-documentation-update-adds-context Documentation/marker.txt
--- a/Documentation/marker.txt~linux-kernel-markers-documentation-update-adds-context
+++ a/Documentation/marker.txt
@@ -3,14 +3,21 @@
 			    Mathieu Desnoyers
 
 
-	This document discusses the purpose of markers. It shows some usage
-examples of the Linux Kernel Markers : how to insert markers within the kernel
-and how to connect probes to a marker. Finally, it has some probe module
-examples. This is what connects to a marker.
+	This document introduces to markers and discusses its purpose. It
+shows some usage examples of the Linux Kernel Markers : how to insert markers
+within the kernel and how to connect probes to a marker. Finally, it has some
+probe module examples. This is what connects to a marker.
 
 
 * Purpose of markers
 
+A marker placed in your code provides a hook to a function (probe) that
+you can provide at runtime. A marker can be on (a probe is connected to it)
+or off (no probe is attached). An "off" marker has no effect. When turned on,
+the function you provide is called each time the marker is executed in the
+execution context of the caller. When the function provided ends its execution,
+it returns to the caller (probe site).
+
 You can put markers at important locations in the code. They act as
 lightweight hooks that can pass an arbitrary number of parameters,
 described in a printk-like format string, to a function whenever the marker
@@ -42,6 +49,16 @@ The expression %p[struct task_struct] is
 standard that could eventually be used for pointer type checking in
 sparse. The brackets contain the type to which the pointer refers.
 
+In order to use the macro MARK, you should include linux/marker.h or
+linux/kernel.h (which also includes linux/marker.h).
+
+Connecting a function (probe) to a marker is done by providing a probe
+(function to call) for the specific marker through marker_set_probe(). It will
+automatically connect the function and enable the marker site. Removing a probe
+is done through marker_remove_probe(). Probe removal is preempt safe because
+preemption is disabled around the probe call. See the "Probe example" section
+below for a sample probe module.
+
 The marker mechanism supports multiple instances of the same marker.
 Markers can be put in inline functions, inlined static functions and
 unrolled loops.
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-powerpc.patch
powerpc-move-of_irq_to_resource-to-prom_parsec.patch
git-mips.patch
git-s390.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-powerpc-extension-fix.patch
local_t-powerpc-extension-shrink-powerpc-localh.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-kconfig-menus-fix-2.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-documentation-update-adds-context.patch
