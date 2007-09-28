From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-documentation.patch added to -mm tree
Date: Fri, 28 Sep 2007 15:41:30 -0700
Message-ID: <200709282241.l8SMfUfX020934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755176AbXI1WmA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 18:42:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, fche@redhat.com, hch@infradead.org


The patch titled
     Linux Kernel Markers - Documentation
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Linux Kernel Markers - Documentation
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Here is some documentation explaining what is/how to use the Linux
Kernel Markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN /dev/null Documentation/markers.txt
--- /dev/null
+++ a/Documentation/markers.txt
@@ -0,0 +1,81 @@
+ 	             Using the Linux Kernel Markers
+
+			    Mathieu Desnoyers
+
+
+This document introduces Linux Kernel Markers and their use. It provides
+examples of how to insert markers in the kernel and connect probe functions to
+them and provides some examples of probe functions.
+
+
+* Purpose of markers
+
+A marker placed in code provides a hook to call a function (probe) that you can
+provide at runtime. A marker can be "on" (a probe is connected to it) or "off"
+(no probe is attached). When a marker is "off" it has no effect, except for
+adding a tiny time penalty (checking a condition for a branch) and space
+penalty (adding a few bytes for the function call at the end of the
+instrumented function and adds a data structure in a separate section).  When a
+marker is "on", the function you provide is called each time the marker is
+executed, in the execution context of the caller. When the function provided
+ends its execution, it returns to the caller (continuing from the marker site).
+
+You can put markers at important locations in the code. Markers are
+lightweight hooks that can pass an arbitrary number of parameters,
+described in a printk-like format string, to the attached probe function.
+
+They can be used for tracing and performance accounting.
+
+
+* Usage
+
+In order to use the macro trace_mark, you should include linux/marker.h.
+
+#include <linux/marker.h>
+
+And,
+
+trace_mark(subsystem_event, "%d %s", someint, somestring);
+Where :
+- subsystem_event is an identifier unique to your event
+    - subsystem is the name of your subsystem.
+    - event is the name of the event to mark.
+- "%d %s" is the formatted string for the serializer.
+- someint is an integer.
+- somestring is a char pointer.
+
+Connecting a function (probe) to a marker is done by providing a probe (function
+to call) for the specific marker through marker_probe_register() and can be
+activated by calling marker_arm(). Marker deactivation can be done by calling
+marker_disarm() as many times as marker_arm() has been called. Removing a probe
+is done through marker_probe_unregister(); it will disarm the probe and make
+sure there is no caller left using the probe when it returns. Probe removal is
+preempt-safe because preemption is disabled around the probe call. See the
+"Probe example" section below for a sample probe module.
+
+The marker mechanism supports inserting multiple instances of the same marker.
+Markers can be put in inline functions, inlined static functions, and
+unrolled loops as well as regular functions.
+
+The naming scheme "subsystem_event" is suggested here as a convention intended
+to limit collisions. Marker names are global to the kernel: they are considered
+as being the same whether they are in the core kernel image or in modules.
+Conflicting format strings for markers with the same name will cause the markers
+to be detected to have a different format string not to be armed and will output
+a printk warning which identifies the inconsistency:
+
+"Format mismatch for probe probe_name (format), marker (format)"
+
+
+* Probe / marker example
+
+See the example provided in samples/markers/src
+
+Compile them with your kernel.
+
+Run, as root :
+modprobe marker-example (insmod order is not important)
+modprobe probe-example
+cat /proc/marker-example (returns an expected error)
+rmmod marker-example probe-example
+dmesg
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
local_t-documentation-update-2.patch
local_t-update-documentation.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
linux-kernel-markers-documentation.patch
