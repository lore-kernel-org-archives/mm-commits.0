From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-kconfig-menus.patch removed from -mm tree
Date: Thu, 10 May 2007 15:32:00 -0700
Message-ID: <200705102232.l4AMW0NX032583@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758948AbXEJWcY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:32:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, bunk@stusta.de, jkenisto@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers: Kconfig menus
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-kconfig-menus.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Linux Kernel Markers: Kconfig menus
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
different cache size, abnormal Linux scheduler latency (just to name a few
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
branch is used to skip the hook stack setup and function call when the marker
is "disabled" (no probe is connected).  Further optimizations can be
implemented for each architecture to make this branch faster.

Instrumentation of a subsystem becomes therefore a straightforward task.  One
has to add instrumentation within the key locations of the kernel code in the
following form :

trace_mark(subsystem_event, "%d %p", myint, myptr);


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




Jim Keniston <jkenisto@us.ibm.com> adds:

kprobes remains a vital foundation for SystemTap.  But markers are attractive
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
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig     |    6 ++++++
 arch/arm/Kconfig       |    6 ++++++
 arch/arm26/Kconfig     |    6 ++++++
 arch/cris/Kconfig      |    6 ++++++
 arch/frv/Kconfig       |    6 ++++++
 arch/h8300/Kconfig     |    6 ++++++
 arch/i386/Kconfig      |    2 ++
 arch/ia64/Kconfig      |    3 +++
 arch/m32r/Kconfig      |    6 ++++++
 arch/m68k/Kconfig      |    6 ++++++
 arch/m68knommu/Kconfig |    6 ++++++
 arch/mips/Kconfig      |    6 ++++++
 arch/parisc/Kconfig    |    6 ++++++
 arch/powerpc/Kconfig   |    3 +++
 arch/ppc/Kconfig       |    6 ++++++
 arch/s390/Kconfig      |    2 ++
 arch/sh/Kconfig        |    6 ++++++
 arch/sh64/Kconfig      |    6 ++++++
 arch/sparc/Kconfig     |    2 ++
 arch/sparc64/Kconfig   |    3 +++
 arch/um/Kconfig        |    6 ++++++
 arch/v850/Kconfig      |    6 ++++++
 arch/x86_64/Kconfig    |    3 +++
 arch/xtensa/Kconfig    |    6 ++++++
 kernel/Kconfig.marker  |   20 ++++++++++++++++++++
 kernel/module.c        |    1 +
 26 files changed, 141 insertions(+)

diff -puN arch/alpha/Kconfig~linux-kernel-markers-kconfig-menus arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/alpha/Kconfig
@@ -642,6 +642,12 @@ source "fs/Kconfig"
 
 source "arch/alpha/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/alpha/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/arm/Kconfig~linux-kernel-markers-kconfig-menus arch/arm/Kconfig
--- a/arch/arm/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/arm/Kconfig
@@ -1026,6 +1026,12 @@ source "fs/Kconfig"
 
 source "arch/arm/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/arm/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/arm26/Kconfig~linux-kernel-markers-kconfig-menus arch/arm26/Kconfig
--- a/arch/arm26/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/arm26/Kconfig
@@ -241,6 +241,12 @@ source "drivers/misc/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/arm26/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/cris/Kconfig~linux-kernel-markers-kconfig-menus arch/cris/Kconfig
--- a/arch/cris/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/cris/Kconfig
@@ -198,6 +198,12 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/frv/Kconfig~linux-kernel-markers-kconfig-menus arch/frv/Kconfig
--- a/arch/frv/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/frv/Kconfig
@@ -385,6 +385,12 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/h8300/Kconfig~linux-kernel-markers-kconfig-menus arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/h8300/Kconfig
@@ -220,6 +220,12 @@ endmenu
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/i386/Kconfig~linux-kernel-markers-kconfig-menus arch/i386/Kconfig
--- a/arch/i386/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/i386/Kconfig
@@ -1236,6 +1236,8 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+source "kernel/Kconfig.marker"
+
 endif # INSTRUMENTATION
 
 source "arch/i386/Kconfig.debug"
diff -puN arch/ia64/Kconfig~linux-kernel-markers-kconfig-menus arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/ia64/Kconfig
@@ -591,6 +591,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/ia64/Kconfig.debug"
diff -puN arch/m32r/Kconfig~linux-kernel-markers-kconfig-menus arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/m32r/Kconfig
@@ -405,6 +405,12 @@ source "fs/Kconfig"
 
 source "arch/m32r/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/m32r/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m68k/Kconfig~linux-kernel-markers-kconfig-menus arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/m68k/Kconfig
@@ -670,6 +670,12 @@ endmenu
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m68knommu/Kconfig~linux-kernel-markers-kconfig-menus arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/m68knommu/Kconfig
@@ -676,6 +676,12 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/mips/Kconfig~linux-kernel-markers-kconfig-menus arch/mips/Kconfig
--- a/arch/mips/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/mips/Kconfig
@@ -2150,6 +2150,12 @@ source "fs/Kconfig"
 
 source "arch/mips/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/mips/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/parisc/Kconfig~linux-kernel-markers-kconfig-menus arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/parisc/Kconfig
@@ -269,6 +269,12 @@ source "fs/Kconfig"
 
 source "arch/parisc/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/parisc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/powerpc/Kconfig~linux-kernel-markers-kconfig-menus arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/powerpc/Kconfig
@@ -901,6 +901,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/powerpc/Kconfig.debug"
diff -puN arch/ppc/Kconfig~linux-kernel-markers-kconfig-menus arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/ppc/Kconfig
@@ -1453,8 +1453,14 @@ endmenu
 
 source "lib/Kconfig"
 
+menu "Instrumentation Support"
+
 source "arch/powerpc/oprofile/Kconfig"
 
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/ppc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/s390/Kconfig~linux-kernel-markers-kconfig-menus arch/s390/Kconfig
--- a/arch/s390/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/s390/Kconfig
@@ -567,6 +567,8 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/s390/Kconfig.debug"
diff -puN arch/sh/Kconfig~linux-kernel-markers-kconfig-menus arch/sh/Kconfig
--- a/arch/sh/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/sh/Kconfig
@@ -723,6 +723,12 @@ source "fs/Kconfig"
 
 source "arch/sh/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/sh/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sh64/Kconfig~linux-kernel-markers-kconfig-menus arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/sh64/Kconfig
@@ -281,6 +281,12 @@ source "fs/Kconfig"
 
 source "arch/sh64/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/sh64/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sparc/Kconfig~linux-kernel-markers-kconfig-menus arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/sparc/Kconfig
@@ -306,6 +306,8 @@ menu "Instrumentation Support"
 
 source "arch/sparc/oprofile/Kconfig"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/sparc/Kconfig.debug"
diff -puN arch/sparc64/Kconfig~linux-kernel-markers-kconfig-menus arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/sparc64/Kconfig
@@ -444,6 +444,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/sparc64/Kconfig.debug"
diff -puN arch/um/Kconfig~linux-kernel-markers-kconfig-menus arch/um/Kconfig
--- a/arch/um/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/um/Kconfig
@@ -334,4 +334,10 @@ config INPUT
 	bool
 	default n
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/um/Kconfig.debug"
diff -puN arch/v850/Kconfig~linux-kernel-markers-kconfig-menus arch/v850/Kconfig
--- a/arch/v850/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/v850/Kconfig
@@ -339,6 +339,12 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/x86_64/Kconfig~linux-kernel-markers-kconfig-menus arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/x86_64/Kconfig
@@ -792,6 +792,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/x86_64/Kconfig.debug"
diff -puN arch/xtensa/Kconfig~linux-kernel-markers-kconfig-menus arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/xtensa/Kconfig
@@ -251,6 +251,12 @@ config EMBEDDED_RAMDISK_IMAGE
 	  provide one yourself.
 endmenu
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN /dev/null kernel/Kconfig.marker
--- /dev/null
+++ a/kernel/Kconfig.marker
@@ -0,0 +1,20 @@
+# Code markers configuration
+
+config MARKERS
+	bool "Activate markers"
+	depends on MODULES
+	help
+	  Place an empty function call at each marker site. Can be
+	  dynamically changed for a probe function.
+
+config MARKERS_DISABLE_OPTIMIZATION
+	bool "Disable marker optimization"
+	depends on MARKERS && EMBEDDED
+	default n
+	help
+	  Disable code replacement jump optimisations. Especially useful if your
+	  code is in a read-only rom/flash.
+
+config MARKERS_ENABLE_OPTIMIZATION
+	def_bool y
+	depends on MARKERS && !MARKERS_DISABLE_OPTIMIZATION
diff -puN kernel/module.c~linux-kernel-markers-kconfig-menus kernel/module.c
--- a/kernel/module.c~linux-kernel-markers-kconfig-menus
+++ a/kernel/module.c
@@ -32,6 +32,7 @@
 #include <linux/cpu.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
+#include <linux/marker.h>
 #include <linux/err.h>
 #include <linux/vermagic.h>
 #include <linux/notifier.h>
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
powerpc-promc-remove-undef-printk.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-update.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-update.patch
linux-kernel-markers-architecture-independant-code-update-fix.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-update.patch
linux-kernel-markers-powerpc-optimization-fix.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-update.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architectures-update.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-update.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
