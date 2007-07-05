From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch added to -mm tree
Date: Thu, 05 Jul 2007 13:27:49 -0700
Message-ID: <200707052027.l65KRnxH017437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55104 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759526AbXGEU2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 16:28:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, bunk@stusta.de, jkenisto@us.ibm.com


The patch titled
     Linux Kernel Markers: add kconfig menus for the marker code
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Linux Kernel Markers: add kconfig menus for the marker code
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

With the increasing complexity of today's user-space application and the wide
deployment of SMP systems, the users need an increasing understanding of the
behavior and performance of a system across multiple processes/different
execution contexts/multiple CPUs.  In applications such as large clusters
(Google, IBM), video acquisition (Autodesk), embedded real-time systems (Wind
River, Monta Vista, Sony) or sysadmin/programmer-type tasks (SystemTAP from
Redhat), a tool that permits tracing of kernel-user space interaction becomes
necessary.

Usage of such tools have been made to successfully pinpoint problems such as:
latency issues in a user-space video acquisition application, slowdown
problems in large clusters due to a switch to a different filesystems with a
that I have personally investigated).

The currently existing solutions does not give a system-wide overview of what
- and when - things are happening on the system.  Ptracing a program works
with few processes, but quickly becomes useless when it comes to keeping track
of many processes.

Bugs occuring because of bad interaction of such complex systems can be very
hard to find due to the fact that they occur rarely (sometimes once a week on
hundreds of machines).  One can therefore only hope at having the best
conditions to statistically reproduce the bug while extracting information
from the system.  Some bugs have been successfully found at Google using their
ktrace tracer only because they could enable it on production machines and
therefore recreate the same context where the bug happened.

Therefore, it makes sense to offer an instrumentation set of the most relevant
events occurring in the Linux that can have the smallest performance cost
possible when not active while not requiring a reboot of a production system
to activate.  This is essentially what the markers are providing.

Since we cannot limit the growth of the Linux kernel, nor can we pre-determine
each and every "interesting" instrumentation within each subsystem and driver,
it is sensible to let this task to the persons who knows the best their code.
Adding instrumentation should therefore be as easy as adding and maintaining a
"printk" in the kernel code from the developer's point of view.

Towards a complete tracing mechanism in the Linux kernel, the markers are only
one step forward.  The following step is to connect probes to those markers
that will record the tracing information in buffers exported to user-space,
organized in timestamped "events".  Probe callbacks are responsible for
serializing the information passed as parameter to the markers (described by
the format string) into the events.  A control mechanism to activate/stop the
tracing is required, as well as a daemon that maps the buffers to write them
to disk or send them through the network.

Keeping track of the events also requires a centralized infrastructure : the
idea is to assign a unique ID to each event so they can be later recognized in
the trace.  Keeping in mind that recording the complete instrumentation site
name string for each event would be more that inefficient, assigning a numeric
unique identifier makes sense.

Finally, support for gathering events coming from user-space, with a minimal
performance impact, is very useful to see the interaction between the system's
execution contexts.

The last steps are currently implemented in Linux Trace Toolkit Next
Generation (LTTng).

The SystemTAP project could clearly benefit from such an infrastructure for
tracing.  In addition, they would be providing support for dynamic addition of
kernel probes through breakpoints/jumps when possible, with the associated
restrictions (accessing local variables, reentrancy, speed).

This marker infrastructure is a hook-callback mechanism.  It is meant to have
an impact as low as possible on the system performances when no callback
(probe) is connected so markers (hooks) can be compiled into a production
kernel without noticeable slowdown.

Why use the markers instead of kprobes?

The rationale behind this mechanism the following :

1 - It makes sense to have instrumentation (for tracing, profiling)
    within the kernel source tree so that it can follow its evolution.
    Other options, such as kprobes, imply maintaining an external set of
    instrumentation that must be adapted to each kernel version.
    Although it may make sense for distributions, it is not well suited
    for kernel developers, since they rarely work on a major
    distribution image.
2 - kprobes, although being a very good attempt at providing a dynamic
    hooking mechanism that has no impact when disabled, suffers from
    important limitations :
  a - It cannot access local variables of a function at a particular
      point within its body that will be consistent thorough the kernel
      versions without involving a lot of recurrent hair-pulling.
  b - Kprobes is slow, since it involves going though a trap each time
      a probe site is executed. Even though the djprobes project made a
      good effort to make things faster, it cannot currently instrument
      fully-preemptible kernels and does not solve (1), (2a) and (2c).
  c - On the reentrancy side, going though a trap (thus playing with
      interrupt enable/disable) and taking spinlocks are not suited to
      some code paths, i.e. :
      kernel/lockdep.c, printk (within the lockdep_on()/lockdep_off()).
      It must be understood that some code paths interesting for
      instrumentation often present a particular reentrancy challenge.

Some more details :

The probe callback connection to its markers is done dynamically.  A predicted
branch (see the immediate values infrastructure) is used to skip the hook stack
setup and function call when the marker is "disabled" (no probe is connected).
Further optimizations can be implemented for each architecture to make this
branch faster.

Instrumentation of a subsystem becomes therefore a straightforward task.  One
has to add instrumentation within the key locations of the kernel code in the
following form :

trace_mark(subsystem_event, "%d %p", myint, myptr);

Jim Keniston <jkenisto@us.ibm.com> adds:

kprobes remains a vital foundation for SystemTap.  But markers are attactive
as an alternate source of trace/debug info.  Here's why:

1. Markers will live in the kernel and presumably be kept up to date by
   the maintainers of the enclosing code.  We have a growing set of tapsets
   (probe libraries), each of which "knows" the source code for a certain area
   of the kernel.  Whenever the underlying kernel code changes (e.g., a
   function or one of its args disappears or is renamed), there's a chance
   that the tapset will become invalid until we bring it back in sync with the
   kernel.  As you can imagine, maintaining tapsets separate from the kernel
   source is a maintenance headache.  Markers could mitigate this.

2. Because the kernel code is highly optimized, the kernel's dwarf info
   doesn't always accurately reflect which variables have which values on
   which lines (sometimes even upon entry to a function).  A marker is a way
   to ensure that values of interest are available to SystemTap at marked
   points.

3. Sometimes the overhead of a kprobe probepoint is too much (either in
   terms of time or locking) for the particular hotspot we want to probe.

In OLS2006 proceedings, vol. 1
http://www.linuxsymposium.org/2006/linuxsymposium_procv1.pdf

Frank C. Eigler, from SystemTAP, presents its "static probing markers"
(pp. 261-268) in his paper "Problem Solving With Systemtap".

He explains the advantages :

"In exchange for this effort, systemtap marker-based probes are faster and
 more precise than kprobes.  The better precision comes from not having to
 covet the compiler's favours.  Such fickle favours include retaining
 clean boundaries in the instruction stream between interesting statements,
 and precisely describing positions of variables in the stack frame.  Since
 markers don't rely on debugging information, neither favour is required,
 and the compiler can channel its charms into unabated optimization.  The
 speed advantage comes from using direct call instructions rather than int 3
 breakpoints to dispatch to the systemtap handlers.  We will see below just
 how big a difference this makes."

He does a comparison of his "simple" marker solution with kprobes (his simple
solution looks like my generic markers, but with a major race condition).  I
also posted numbers about the markers performance impact a few months ago in
the initial thread.  I can dig into my emails to find them for you if you
consider it important for the Changelog.

He concludes with :

"To the extent that is true, we propose that these groups consider using a
 shared pool of static markers as the basic kernel-side instrumentation
 mechanism.  If they prove to have as low dormant cost and as high active
 performance as initial experience suggests, perhaps this could motivate the
 various tracing efforts and kernel subsystem developers to finally join
 forces.  Let's designate standard trace/probe points once and for all.
 Tracing backends can attach to these markers the same way systemtap would.
 There would be no need for them to maintain kernel patches any more.
 Let's think about it."

This patch:

Add Kconfig menus for the marker code.

[bunk@stusta.de: Never ever select MODULES]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig       |    2 ++
 arch/arm/Kconfig         |    2 ++
 arch/arm26/Kconfig       |    2 ++
 arch/avr32/Kconfig.debug |    7 +++++++
 arch/cris/Kconfig        |    2 ++
 arch/frv/Kconfig         |    2 ++
 arch/h8300/Kconfig       |    2 ++
 arch/i386/Kconfig        |    2 ++
 arch/ia64/Kconfig        |    2 ++
 arch/m32r/Kconfig        |    2 ++
 arch/m68k/Kconfig        |    2 ++
 arch/m68knommu/Kconfig   |    2 ++
 arch/mips/Kconfig        |    2 ++
 arch/parisc/Kconfig      |    2 ++
 arch/powerpc/Kconfig     |    2 ++
 arch/ppc/Kconfig         |    2 ++
 arch/s390/Kconfig        |    2 ++
 arch/sh/Kconfig          |    2 ++
 arch/sh64/Kconfig        |    2 ++
 arch/sparc/Kconfig       |    2 ++
 arch/sparc64/Kconfig     |    2 ++
 arch/um/Kconfig          |    2 ++
 arch/v850/Kconfig        |    2 ++
 arch/x86_64/Kconfig      |    2 ++
 arch/xtensa/Kconfig      |    2 ++
 kernel/Kconfig.marker    |    7 +++++++
 26 files changed, 62 insertions(+)

diff -puN arch/alpha/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/alpha/Kconfig
@@ -657,6 +657,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/alpha/Kconfig.debug"
diff -puN arch/arm/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/arm/Kconfig
--- a/arch/arm/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/arm/Kconfig
@@ -1050,6 +1050,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/arm/Kconfig.debug"
diff -puN arch/arm26/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/arm26/Kconfig
--- a/arch/arm26/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/arm26/Kconfig
@@ -248,6 +248,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/arm26/Kconfig.debug"
diff -puN arch/avr32/Kconfig.debug~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/avr32/Kconfig.debug
--- a/arch/avr32/Kconfig.debug~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/avr32/Kconfig.debug
@@ -9,6 +9,9 @@ source "lib/Kconfig.debug"
 menu "Instrumentation Support"
 	depends on EXPERIMENTAL
 
+menu "Instrumentation Support"
+	depends on EXPERIMENTAL
+
 config KPROBES
 	bool "Kprobes"
 	depends on DEBUG_KERNEL
@@ -21,6 +24,10 @@ config KPROBES
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
+endmenu
+
 endmenu
 
 endmenu
diff -puN arch/cris/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/cris/Kconfig
--- a/arch/cris/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/cris/Kconfig
@@ -202,6 +202,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/cris/Kconfig.debug"
diff -puN arch/frv/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/frv/Kconfig
--- a/arch/frv/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/frv/Kconfig
@@ -379,6 +379,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/frv/Kconfig.debug"
diff -puN arch/h8300/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/h8300/Kconfig
@@ -227,6 +227,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/h8300/Kconfig.debug"
diff -puN arch/i386/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/i386/Kconfig
--- a/arch/i386/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/i386/Kconfig
@@ -1252,6 +1252,8 @@ config KPROBES
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endif # INSTRUMENTATION
 
 source "arch/i386/Kconfig.debug"
diff -puN arch/ia64/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/ia64/Kconfig
@@ -596,6 +596,8 @@ config KPROBES
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/ia64/Kconfig.debug"
diff -puN arch/m32r/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/m32r/Kconfig
@@ -412,6 +412,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/m32r/Kconfig.debug"
diff -puN arch/m68k/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/m68k/Kconfig
@@ -680,6 +680,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/m68k/Kconfig.debug"
diff -puN arch/m68knommu/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/m68knommu/Kconfig
@@ -672,6 +672,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/m68knommu/Kconfig.debug"
diff -puN arch/mips/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/mips/Kconfig
--- a/arch/mips/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/mips/Kconfig
@@ -1950,6 +1950,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/mips/Kconfig.debug"
diff -puN arch/parisc/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/parisc/Kconfig
@@ -273,6 +273,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/parisc/Kconfig.debug"
diff -puN arch/powerpc/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/powerpc/Kconfig
@@ -653,6 +653,8 @@ config KPROBES
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/powerpc/Kconfig.debug"
diff -puN arch/ppc/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/ppc/Kconfig
@@ -1457,6 +1457,8 @@ source "arch/powerpc/oprofile/Kconfig"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/ppc/Kconfig.debug"
diff -puN arch/s390/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/s390/Kconfig
--- a/arch/s390/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/s390/Kconfig
@@ -549,6 +549,8 @@ config KPROBES
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/s390/Kconfig.debug"
diff -puN arch/sh/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/sh/Kconfig
--- a/arch/sh/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/sh/Kconfig
@@ -725,6 +725,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/sh/Kconfig.debug"
diff -puN arch/sh64/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/sh64/Kconfig
@@ -288,6 +288,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/sh64/Kconfig.debug"
diff -puN arch/sparc/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/sparc/Kconfig
@@ -315,6 +315,8 @@ source "arch/sparc/oprofile/Kconfig"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/sparc/Kconfig.debug"
diff -puN arch/sparc64/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/sparc64/Kconfig
@@ -454,6 +454,8 @@ config KPROBES
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/sparc64/Kconfig.debug"
diff -puN arch/um/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/um/Kconfig
--- a/arch/um/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/um/Kconfig
@@ -339,6 +339,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/um/Kconfig.debug"
diff -puN arch/v850/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/v850/Kconfig
--- a/arch/v850/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/v850/Kconfig
@@ -335,6 +335,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/v850/Kconfig.debug"
diff -puN arch/x86_64/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/x86_64/Kconfig
@@ -845,6 +845,8 @@ config KPROBES
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/x86_64/Kconfig.debug"
diff -puN arch/xtensa/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~linux-kernel-markers-add-kconfig-menus-for-the-marker-code
+++ a/arch/xtensa/Kconfig
@@ -255,6 +255,8 @@ menu "Instrumentation Support"
 
 source "kernel/Kconfig.immediate"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/xtensa/Kconfig.debug"
diff -puN /dev/null kernel/Kconfig.marker
--- /dev/null
+++ a/kernel/Kconfig.marker
@@ -0,0 +1,7 @@
+# Code markers configuration
+
+config MARKERS
+	bool "Activate markers"
+	help
+	  Place an empty function call at each marker site. Can be
+	  dynamically changed for a probe function.
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
i386-text-edit-lock.patch
i386-text-edit-lock-alternative-instructions.patch
i386-text-edit-lock-kprobes.patch
immediate-values-global-modules-list-and-module-mutex.patch
immediate-value-architecture-independent-code.patch
immediate-values-non-optimized-architectures.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
