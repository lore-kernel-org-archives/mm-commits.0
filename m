From: akpm@linux-foundation.org
Subject: + uml-style-fixes-pass-1.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:14:16 -0700
Message-ID: <200708162114.l7GLEGB5007080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757813AbXHPVOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:14:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: style fixes pass 1
has been added to the -mm tree.  Its filename is
     uml-style-fixes-pass-1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: style fixes pass 1
From: Jeff Dike <jdike@addtoit.com>

Formatting changes in the files which have been changed in the
tt-removal patchset so far.  These include:
	copyright updates
	header file trimming
	style fixes
	adding severity to printks
	indenting Kconfig help according to the predominant kernel style

These changes should be entirely non-functional.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig                          |  199 ++++++++++-----------
 arch/um/Kconfig.char                     |  139 +++++++-------
 arch/um/Kconfig.debug                    |   24 +-
 arch/um/Makefile                         |    8 
 arch/um/include/sysdep-i386/sigcontext.h |   12 -
 arch/um/kernel/Makefile                  |    2 
 arch/um/kernel/init_task.c               |    8 
 arch/um/kernel/smp.c                     |   31 +--
 arch/um/kernel/trap.c                    |  111 +++++------
 arch/um/os-Linux/Makefile                |    2 
 arch/um/os-Linux/sys-i386/Makefile       |    2 
 arch/um/os-Linux/time.c                  |   38 +---
 arch/um/os-Linux/tls.c                   |    4 
 arch/um/sys-i386/Makefile                |    4 
 arch/um/sys-i386/ptrace_user.c           |   13 -
 15 files changed, 283 insertions(+), 314 deletions(-)

diff -puN arch/um/Kconfig~uml-style-fixes-pass-1 arch/um/Kconfig
--- a/arch/um/Kconfig~uml-style-fixes-pass-1
+++ a/arch/um/Kconfig
@@ -66,12 +66,12 @@ config STATIC_LINK
 	bool "Force a static link"
 	default n
 	help
-	This option gives you the ability to force a static link of UML.
-	Normally, UML is linked as a shared binary.  This is inconvenient for
-	use in a chroot jail.  So, if you intend to run UML inside a chroot,
-	you probably want to say Y here.
-	Additionally, this option enables using higher memory spaces (up to
-	2.75G) for UML.
+	  This option gives you the ability to force a static link of UML.
+	  Normally, UML is linked as a shared binary.  This is inconvenient for
+	  use in a chroot jail.  So, if you intend to run UML inside a chroot,
+	  you probably want to say Y here.
+	  Additionally, this option enables using higher memory spaces (up to
+	  2.75G) for UML.
 
 source "arch/um/Kconfig.arch"
 source "mm/Kconfig"
@@ -89,18 +89,18 @@ config LD_SCRIPT_DYN
 config NET
 	bool "Networking support"
 	help
-	Unless you really know what you are doing, you should say Y here.
-	The reason is that some programs need kernel networking support even
-	when running on a stand-alone machine that isn't connected to any
-	other computer. If you are upgrading from an older kernel, you
-	should consider updating your networking tools too because changes
-	in the kernel and the tools often go hand in hand. The tools are
-	contained in the package net-tools, the location and version number
-	of which are given in <file:Documentation/Changes>.
-
-	For a general introduction to Linux networking, it is highly
-	recommended to read the NET-HOWTO, available from
-	<http://www.tldp.org/docs.html#howto>.
+	  Unless you really know what you are doing, you should say Y here.
+	  The reason is that some programs need kernel networking support even
+	  when running on a stand-alone machine that isn't connected to any
+	  other computer. If you are upgrading from an older kernel, you
+	  should consider updating your networking tools too because changes
+	  in the kernel and the tools often go hand in hand. The tools are
+	  contained in the package net-tools, the location and version number
+	  of which are given in <file:Documentation/Changes>.
+
+	  For a general introduction to Linux networking, it is highly
+	  recommended to read the NET-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
 
 
 source "fs/Kconfig.binfmt"
@@ -108,74 +108,74 @@ source "fs/Kconfig.binfmt"
 config HOSTFS
 	tristate "Host filesystem"
 	help
-        While the User-Mode Linux port uses its own root file system for
-        booting and normal file access, this module lets the UML user
-        access files stored on the host.  It does not require any
-        network connection between the Host and UML.  An example use of
-        this might be:
-
-        mount none /tmp/fromhost -t hostfs -o /tmp/umlshare
-
-        where /tmp/fromhost is an empty directory inside UML and
-        /tmp/umlshare is a directory on the host with files the UML user
-        wishes to access.
+          While the User-Mode Linux port uses its own root file system for
+          booting and normal file access, this module lets the UML user
+          access files stored on the host.  It does not require any
+          network connection between the Host and UML.  An example use of
+          this might be:
+
+          mount none /tmp/fromhost -t hostfs -o /tmp/umlshare
+
+          where /tmp/fromhost is an empty directory inside UML and
+          /tmp/umlshare is a directory on the host with files the UML user
+          wishes to access.
 
-        For more information, see
-        <http://user-mode-linux.sourceforge.net/hostfs.html>.
+          For more information, see
+          <http://user-mode-linux.sourceforge.net/hostfs.html>.
 
-        If you'd like to be able to work with files stored on the host,
-        say Y or M here; otherwise say N.
+          If you'd like to be able to work with files stored on the host,
+          say Y or M here; otherwise say N.
 
 config HPPFS
 	tristate "HoneyPot ProcFS (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	help
-	hppfs (HoneyPot ProcFS) is a filesystem which allows UML /proc
-	entries to be overridden, removed, or fabricated from the host.
-	Its purpose is to allow a UML to appear to be a physical machine
-	by removing or changing anything in /proc which gives away the
-	identity of a UML.
+	  hppfs (HoneyPot ProcFS) is a filesystem which allows UML /proc
+	  entries to be overridden, removed, or fabricated from the host.
+	  Its purpose is to allow a UML to appear to be a physical machine
+	  by removing or changing anything in /proc which gives away the
+	  identity of a UML.
 
-	See <http://user-mode-linux.sf.net/hppfs.html> for more information.
+	  See <http://user-mode-linux.sf.net/hppfs.html> for more information.
 
-	You only need this if you are setting up a UML honeypot.  Otherwise,
-	it is safe to say 'N' here.
+	  You only need this if you are setting up a UML honeypot.  Otherwise,
+	  it is safe to say 'N' here.
 
 config MCONSOLE
 	bool "Management console"
 	default y
 	help
-        The user mode linux management console is a low-level interface to
-        the kernel, somewhat like the i386 SysRq interface.  Since there is
-        a full-blown operating system running under every user mode linux
-        instance, there is much greater flexibility possible than with the
-        SysRq mechanism.
-
-        If you answer 'Y' to this option, to use this feature, you need the
-        mconsole client (called uml_mconsole) which is present in CVS in
-        2.4.5-9um and later (path /tools/mconsole), and is also in the
-        distribution RPM package in 2.4.6 and later.
+          The user mode linux management console is a low-level interface to
+          the kernel, somewhat like the i386 SysRq interface.  Since there is
+          a full-blown operating system running under every user mode linux
+          instance, there is much greater flexibility possible than with the
+          SysRq mechanism.
+
+          If you answer 'Y' to this option, to use this feature, you need the
+          mconsole client (called uml_mconsole) which is present in CVS in
+          2.4.5-9um and later (path /tools/mconsole), and is also in the
+          distribution RPM package in 2.4.6 and later.
 
-        It is safe to say 'Y' here.
+          It is safe to say 'Y' here.
 
 config MAGIC_SYSRQ
 	bool "Magic SysRq key"
 	depends on MCONSOLE
-	---help---
-	If you say Y here, you will have some control over the system even
-	if the system crashes for example during kernel debugging (e.g., you
-	will be able to flush the buffer cache to disk, reboot the system
-	immediately or dump some status information). A key for each of the
-	possible requests is provided.
+	help
+	  If you say Y here, you will have some control over the system even
+	  if the system crashes for example during kernel debugging (e.g., you
+	  will be able to flush the buffer cache to disk, reboot the system
+	  immediately or dump some status information). A key for each of the
+	  possible requests is provided.
 
-	This is the feature normally accomplished by pressing a key
-	while holding SysRq (Alt+PrintScreen).
+	  This is the feature normally accomplished by pressing a key
+	  while holding SysRq (Alt+PrintScreen).
 
-	On UML, this is accomplished by sending a "sysrq" command with
-	mconsole, followed by the letter for the requested command.
+	  On UML, this is accomplished by sending a "sysrq" command with
+	  mconsole, followed by the letter for the requested command.
 
-	The keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
-	unless you really know what this hack does.
+	  The keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
+	  unless you really know what this hack does.
 
 config SMP
 	bool "Symmetric multi-processing support (EXPERIMENTAL)"
@@ -183,24 +183,24 @@ config SMP
 	#SMP_BROKEN is for x86_64.
 	depends on EXPERIMENTAL && (!SMP_BROKEN || (BROKEN && SMP_BROKEN))
 	help
-	This option enables UML SMP support.
-	It is NOT related to having a real SMP box. Not directly, at least.
+	  This option enables UML SMP support.
+	  It is NOT related to having a real SMP box. Not directly, at least.
 
-	UML implements virtual SMP by allowing as many processes to run
-	simultaneously on the host as there are virtual processors configured.
+	  UML implements virtual SMP by allowing as many processes to run
+	  simultaneously on the host as there are virtual processors configured.
 
-	Obviously, if the host is a uniprocessor, those processes will
-	timeshare, but, inside UML, will appear to be running simultaneously.
-	If the host is a multiprocessor, then UML processes may run
-	simultaneously, depending on the host scheduler.
-
-	This, however, is supported only in TT mode. So, if you use the SKAS
-	patch on your host, switching to TT mode and enabling SMP usually gives
-	you worse performances.
-	Also, since the support for SMP has been under-developed, there could
-	be some bugs being exposed by enabling SMP.
+	  Obviously, if the host is a uniprocessor, those processes will
+	  timeshare, but, inside UML, will appear to be running simultaneously.
+	  If the host is a multiprocessor, then UML processes may run
+	  simultaneously, depending on the host scheduler.
+
+	  This, however, is supported only in TT mode. So, if you use the SKAS
+	  patch on your host, switching to TT mode and enabling SMP usually
+	  gives	you worse performances.
+	  Also, since the support for SMP has been under-developed, there could
+	  be some bugs being exposed by enabling SMP.
 
-	If you don't know what to do, say N.
+	  If you don't know what to do, say N.
 
 config NR_CPUS
 	int "Maximum number of CPUs (2-32)"
@@ -212,24 +212,24 @@ config NEST_LEVEL
 	int "Nesting level"
 	default "0"
 	help
-        This is set to the number of layers of UMLs that this UML will be run
-        in.  Normally, this is zero, meaning that it will run directly on the
-        host.  Setting it to one will build a UML that can run inside a UML
-        that is running on the host.  Generally, if you intend this UML to run
-        inside another UML, set CONFIG_NEST_LEVEL to one more than the host
-        UML.
+          This is set to the number of layers of UMLs that this UML will be run
+          in.  Normally, this is zero, meaning that it will run directly on the
+          host.  Setting it to one will build a UML that can run inside a UML
+          that is running on the host.  Generally, if you intend this UML to run
+          inside another UML, set CONFIG_NEST_LEVEL to one more than the host
+          UML.
 
 config HIGHMEM
 	bool "Highmem support (EXPERIMENTAL)"
 	depends on !64BIT && EXPERIMENTAL
 	default n
 	help
-	This was used to allow UML to run with big amounts of memory.
-	Currently it is unstable, so if unsure say N.
+	  This was used to allow UML to run with big amounts of memory.
+	  Currently it is unstable, so if unsure say N.
 
-	To use big amounts of memory, it is recommended enable static
-	linking (i.e. CONFIG_STATIC_LINK) - this should allow the
-	guest to use up to 2.75G of memory.
+	  To use big amounts of memory, it is recommended enable static
+	  linking (i.e. CONFIG_STATIC_LINK) - this should allow the
+	  guest to use up to 2.75G of memory.
 
 config KERNEL_STACK_ORDER
 	int "Kernel stack size order"
@@ -237,20 +237,21 @@ config KERNEL_STACK_ORDER
 	range 1 10 if 64BIT
 	default 0 if !64BIT
 	help
-	This option determines the size of UML kernel stacks.  They will
-	be 1 << order pages.  The default is OK unless you're running Valgrind
-	on UML, in which case, set this to 3.
+	  This option determines the size of UML kernel stacks.  They will
+	  be 1 << order pages.  The default is OK unless you're running Valgrind
+	  on UML, in which case, set this to 3.
 
 config UML_REAL_TIME_CLOCK
 	bool "Real-time Clock"
 	default y
 	help
-	This option makes UML time deltas match wall clock deltas.  This should
-	normally be enabled.  The exception would be if you are debugging with
-	UML and spend long times with UML stopped at a breakpoint.  In this
-	case, when UML is restarted, it will call the timer enough times to make
-	up for the time spent at the breakpoint.  This could result in a
-	noticeable lag.  If this is a problem, then disable this option.
+	  This option makes UML time deltas match wall clock deltas.  This
+	  should normally be enabled.  The exception would be if you are
+	  debugging with UML and spend long times with UML stopped at a
+	  breakpoint.  In this case, when UML is restarted, it will call the
+	  timer enough times to make up for the time spent at the breakpoint.
+	  This could result in a noticeable lag.  If this is a problem, then
+	  disable this option.
 
 endmenu
 
diff -puN arch/um/Kconfig.char~uml-style-fixes-pass-1 arch/um/Kconfig.char
--- a/arch/um/Kconfig.char~uml-style-fixes-pass-1
+++ a/arch/um/Kconfig.char
@@ -5,7 +5,7 @@ config STDERR_CONSOLE
 	bool "stderr console"
 	default y
 	help
-	console driver which dumps all printk messages to stderr.
+	  console driver which dumps all printk messages to stderr.
 
 config STDIO_CONSOLE
 	bool
@@ -14,58 +14,58 @@ config STDIO_CONSOLE
 config SSL
 	bool "Virtual serial line"
 	help
-        The User-Mode Linux environment allows you to create virtual serial
-        lines on the UML that are usually made to show up on the host as
-        ttys or ptys.
+          The User-Mode Linux environment allows you to create virtual serial
+          lines on the UML that are usually made to show up on the host as
+          ttys or ptys.
 
-        See <http://user-mode-linux.sourceforge.net/input.html> for more
-        information and command line examples of how to use this facility.
+          See <http://user-mode-linux.sourceforge.net/input.html> for more
+          information and command line examples of how to use this facility.
 
-        Unless you have a specific reason for disabling this, say Y.
+          Unless you have a specific reason for disabling this, say Y.
 
 config NULL_CHAN
 	bool "null channel support"
 	help
-        This option enables support for attaching UML consoles and serial
-        lines to a device similar to /dev/null.  Data written to it disappears
-        and there is never any data to be read.
+          This option enables support for attaching UML consoles and serial
+          lines to a device similar to /dev/null.  Data written to it disappears
+          and there is never any data to be read.
 
 config PORT_CHAN
 	bool "port channel support"
 	help
-        This option enables support for attaching UML consoles and serial
-        lines to host portals.  They may be accessed with 'telnet <host>
-        <port number>'.  Any number of consoles and serial lines may be
-        attached to a single portal, although what UML device you get when
-        you telnet to that portal will be unpredictable.
-        It is safe to say 'Y' here.
+          This option enables support for attaching UML consoles and serial
+          lines to host portals.  They may be accessed with 'telnet <host>
+          <port number>'.  Any number of consoles and serial lines may be
+          attached to a single portal, although what UML device you get when
+          you telnet to that portal will be unpredictable.
+          It is safe to say 'Y' here.
 
 config PTY_CHAN
 	bool "pty channel support"
 	help
-        This option enables support for attaching UML consoles and serial
-        lines to host pseudo-terminals.  Access to both traditional
-        pseudo-terminals (/dev/pty*) and pts pseudo-terminals are controlled
-        with this option.  The assignment of UML devices to host devices
-        will be announced in the kernel message log.
-        It is safe to say 'Y' here.
+          This option enables support for attaching UML consoles and serial
+          lines to host pseudo-terminals.  Access to both traditional
+          pseudo-terminals (/dev/pty*) and pts pseudo-terminals are controlled
+          with this option.  The assignment of UML devices to host devices
+          will be announced in the kernel message log.
+          It is safe to say 'Y' here.
 
 config TTY_CHAN
 	bool "tty channel support"
 	help
-        This option enables support for attaching UML consoles and serial
-        lines to host terminals.  Access to both virtual consoles
-        (/dev/tty*) and the slave side of pseudo-terminals (/dev/ttyp* and
-        /dev/pts/*) are controlled by this option.
-        It is safe to say 'Y' here.
+          This option enables support for attaching UML consoles and serial
+          lines to host terminals.  Access to both virtual consoles
+          (/dev/tty*) and the slave side of pseudo-terminals (/dev/ttyp* and
+          /dev/pts/*) are controlled by this option.
+          It is safe to say 'Y' here.
 
 config XTERM_CHAN
 	bool "xterm channel support"
 	help
-        This option enables support for attaching UML consoles and serial
-        lines to xterms.  Each UML device so assigned will be brought up in
-        its own xterm.
-        It is safe to say 'Y' here.
+          This option enables support for attaching UML consoles and serial
+          lines to xterms.  Each UML device so assigned will be brought up in
+          its own xterm.
+          It is safe to say 'Y' here.
 
 config NOCONFIG_CHAN
 	bool
@@ -75,39 +75,39 @@ config CON_ZERO_CHAN
 	string "Default main console channel initialization"
 	default "fd:0,fd:1"
 	help
-        This is the string describing the channel to which the main console
-        will be attached by default.  This value can be overridden from the
-        command line.  The default value is "fd:0,fd:1", which attaches the
-        main console to stdin and stdout.
-        It is safe to leave this unchanged.
+          This is the string describing the channel to which the main console
+          will be attached by default.  This value can be overridden from the
+          command line.  The default value is "fd:0,fd:1", which attaches the
+          main console to stdin and stdout.
+          It is safe to leave this unchanged.
 
 config CON_CHAN
 	string "Default console channel initialization"
 	default "xterm"
 	help
-        This is the string describing the channel to which all consoles
-        except the main console will be attached by default.  This value can
-        be overridden from the command line.  The default value is "xterm",
-        which brings them up in xterms.
-        It is safe to leave this unchanged, although you may wish to change
-        this if you expect the UML that you build to be run in environments
-        which don't have X or xterm available.
+          This is the string describing the channel to which all consoles
+          except the main console will be attached by default.  This value can
+          be overridden from the command line.  The default value is "xterm",
+          which brings them up in xterms.
+          It is safe to leave this unchanged, although you may wish to change
+          this if you expect the UML that you build to be run in environments
+          which don't have X or xterm available.
 
 config SSL_CHAN
 	string "Default serial line channel initialization"
 	default "pty"
 	help
-        This is the string describing the channel to which the serial lines
-        will be attached by default.  This value can be overridden from the
-        command line.  The default value is "pty", which attaches them to
-        traditional pseudo-terminals.
-        It is safe to leave this unchanged, although you may wish to change
-        this if you expect the UML that you build to be run in environments
-        which don't have a set of /dev/pty* devices.
+          This is the string describing the channel to which the serial lines
+          will be attached by default.  This value can be overridden from the
+          command line.  The default value is "pty", which attaches them to
+          traditional pseudo-terminals.
+          It is safe to leave this unchanged, although you may wish to change
+          this if you expect the UML that you build to be run in environments
+          which don't have a set of /dev/pty* devices.
 
 config UNIX98_PTYS
 	bool "Unix98 PTY support"
-	---help---
+	help
 	  A pseudo terminal (PTY) is a software device consisting of two
 	  halves: a master and a slave. The slave device behaves identical to
 	  a physical terminal; the master device is used by a process to
@@ -130,7 +130,7 @@ config UNIX98_PTYS
 config LEGACY_PTYS
 	bool "Legacy (BSD) PTY support"
 	default y
-	---help---
+	help
 	  A pseudo terminal (PTY) is a software device consisting of two
 	  halves: a master and a slave. The slave device behaves identical to
 	  a physical terminal; the master device is used by a process to
@@ -168,7 +168,7 @@ config LEGACY_PTY_COUNT
 	int "Maximum number of legacy PTY in use"
 	depends on LEGACY_PTYS
 	default "256"
-	---help---
+	help
 	  The maximum number of legacy PTYs that can be used at any one time.
 	  The default is 256, and should be more than enough.  Embedded
 	  systems may want to reduce this to save memory.
@@ -194,10 +194,10 @@ config UML_WATCHDOG
 config UML_SOUND
 	tristate "Sound support"
 	help
-        This option enables UML sound support.  If enabled, it will pull in
-        soundcore and the UML hostaudio relay, which acts as a intermediary
-        between the host's dsp and mixer devices and the UML sound system.
-        It is safe to say 'Y' here.
+          This option enables UML sound support.  If enabled, it will pull in
+          soundcore and the UML hostaudio relay, which acts as a intermediary
+          between the host's dsp and mixer devices and the UML sound system.
+          It is safe to say 'Y' here.
 
 config SOUND
 	tristate
@@ -215,22 +215,21 @@ config HW_RANDOM
 config UML_RANDOM
 	tristate "Hardware random number generator"
 	help
-	This option enables UML's "hardware" random number generator.  It
-	attaches itself to the host's /dev/random, supplying as much entropy
-	as the host has, rather than the small amount the UML gets from its
-	own drivers.  It registers itself as a standard hardware random number
-	generator, major 10, minor 183, and the canonical device name is
-	/dev/hwrng.
-	The way to make use of this is to install the rng-tools package
-	(check your distro, or download from
-	http://sourceforge.net/projects/gkernel/).  rngd periodically reads
-	/dev/hwrng and injects the entropy into /dev/random.
+	  This option enables UML's "hardware" random number generator.  It
+	  attaches itself to the host's /dev/random, supplying as much entropy
+	  as the host has, rather than the small amount the UML gets from its
+	  own drivers.  It registers itself as a standard hardware random number
+	  generator, major 10, minor 183, and the canonical device name is
+	  /dev/hwrng.
+	  The way to make use of this is to install the rng-tools package
+	  (check your distro, or download from
+	  http://sourceforge.net/projects/gkernel/).  rngd periodically reads
+	  /dev/hwrng and injects the entropy into /dev/random.
 
 config MMAPPER
 	tristate "iomem emulation driver"
 	help
-	This driver allows a host file to be used as emulated IO memory inside
-	UML.
+	  This driver allows a host file to be used as emulated IO memory inside
+	  UML.
 
 endmenu
-
diff -puN arch/um/Kconfig.debug~uml-style-fixes-pass-1 arch/um/Kconfig.debug
--- a/arch/um/Kconfig.debug~uml-style-fixes-pass-1
+++ a/arch/um/Kconfig.debug
@@ -6,27 +6,27 @@ config GPROF
 	bool "Enable gprof support"
 	depends on DEBUG_INFO
 	help
-        This allows profiling of a User-Mode Linux kernel with the gprof
-        utility.
+	  This allows profiling of a User-Mode Linux kernel with the gprof
+	  utility.
 
-        See <http://user-mode-linux.sourceforge.net/gprof.html> for more
-        details.
+	  See <http://user-mode-linux.sourceforge.net/gprof.html> for more
+	  details.
 
-        If you're involved in UML kernel development and want to use gprof,
-        say Y.  If you're unsure, say N.
+	  If you're involved in UML kernel development and want to use gprof,
+	  say Y.  If you're unsure, say N.
 
 config GCOV
 	bool "Enable gcov support"
 	depends on DEBUG_INFO
 	help
-        This option allows developers to retrieve coverage data from a UML
-        session.
+	  This option allows developers to retrieve coverage data from a UML
+	  session.
 
-        See <http://user-mode-linux.sourceforge.net/gprof.html> for more
-        details.
+	  See <http://user-mode-linux.sourceforge.net/gprof.html> for more
+	  details.
 
-        If you're involved in UML kernel development and want to use gcov,
-        say Y.  If you're unsure, say N.
+	  If you're involved in UML kernel development and want to use gcov,
+	  say Y.  If you're unsure, say N.
 
 config DEBUG_STACK_USAGE
 	bool "Stack utilization instrumentation"
diff -puN arch/um/Makefile~uml-style-fixes-pass-1 arch/um/Makefile
--- a/arch/um/Makefile~uml-style-fixes-pass-1
+++ a/arch/um/Makefile
@@ -2,7 +2,7 @@
 # This file is included by the global makefile so that you can add your own
 # architecture-specific flags and dependencies.
 #
-# Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+# Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
 # Licensed under the GPL
 #
 
@@ -124,7 +124,7 @@ endif
 CPPFLAGS_vmlinux.lds = -U$(SUBARCH) -DSTART=$(START) -DELF_ARCH=$(ELF_ARCH) \
 	-DELF_FORMAT="$(ELF_FORMAT)" -DKERNEL_STACK_SIZE=$(STACK_SIZE)
 
-#The wrappers will select whether using "malloc" or the kernel allocator.
+# The wrappers will select whether using "malloc" or the kernel allocator.
 LINK_WRAPS = -Wl,--wrap,malloc -Wl,--wrap,free -Wl,--wrap,calloc
 
 CFLAGS_vmlinux := $(LINK-y) $(LINK_WRAPS)
@@ -137,8 +137,8 @@ define cmd_vmlinux__
 	FORCE ,$^) ; rm -f linux
 endef
 
-#When cleaning we don't include .config, so we don't include
-#TT or skas makefiles and don't clean skas_ptregs.h.
+# When cleaning we don't include .config, so we don't include
+# TT or skas makefiles and don't clean skas_ptregs.h.
 CLEAN_FILES += linux x.i gmon.out $(ARCH_DIR)/include/uml-config.h \
 	$(ARCH_DIR)/include/user_constants.h \
 	$(ARCH_DIR)/include/kern_constants.h $(ARCH_DIR)/Kconfig.arch
diff -puN arch/um/include/sysdep-i386/sigcontext.h~uml-style-fixes-pass-1 arch/um/include/sysdep-i386/sigcontext.h
--- a/arch/um/include/sysdep-i386/sigcontext.h~uml-style-fixes-pass-1
+++ a/arch/um/include/sysdep-i386/sigcontext.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -37,13 +37,3 @@ extern unsigned long *sc_sigmask(void *s
 extern int sc_get_fpregs(unsigned long buf, void *sc_ptr);
 
 #endif
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/Makefile~uml-style-fixes-pass-1 arch/um/kernel/Makefile
--- a/arch/um/kernel/Makefile~uml-style-fixes-pass-1
+++ a/arch/um/kernel/Makefile
@@ -1,5 +1,5 @@
 #
-# Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+# Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux,intel}.com)
 # Licensed under the GPL
 #
 
diff -puN arch/um/kernel/init_task.c~uml-style-fixes-pass-1 arch/um/kernel/init_task.c
--- a/arch/um/kernel/init_task.c~uml-style-fixes-pass-1
+++ a/arch/um/kernel/init_task.c
@@ -3,16 +3,12 @@
  * Licensed under the GPL
  */
 
-#include "linux/mm.h"
-#include "linux/fs.h"
-#include "linux/module.h"
 #include "linux/sched.h"
 #include "linux/init_task.h"
+#include "linux/fs.h"
+#include "linux/module.h"
 #include "linux/mqueue.h"
 #include "asm/uaccess.h"
-#include "asm/pgtable.h"
-#include "mem_user.h"
-#include "os.h"
 
 static struct fs_struct init_fs = INIT_FS;
 struct mm_struct init_mm = INIT_MM(init_mm);
diff -puN arch/um/kernel/smp.c~uml-style-fixes-pass-1 arch/um/kernel/smp.c
--- a/arch/um/kernel/smp.c~uml-style-fixes-pass-1
+++ a/arch/um/kernel/smp.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2000 - 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -56,12 +56,12 @@ void smp_send_stop(void)
 	int i;
 
 	printk(KERN_INFO "Stopping all CPUs...");
-	for(i = 0; i < num_online_cpus(); i++){
-		if(i == current_thread->cpu)
+	for (i = 0; i < num_online_cpus(); i++) {
+		if (i == current_thread->cpu)
 			continue;
 		os_write_file(cpu_data[i].ipi_pipe[1], "S", 1);
 	}
-	printk("done\n");
+	printk(KERN_INFO "done\n");
 }
 
 static cpumask_t smp_commenced_mask = CPU_MASK_NONE;
@@ -72,7 +72,7 @@ static int idle_proc(void *cpup)
 	int cpu = (int) cpup, err;
 
 	err = os_pipe(cpu_data[cpu].ipi_pipe, 1, 1);
-	if(err < 0)
+	if (err < 0)
 		panic("CPU#%d failed to create IPI pipe, err = %d", cpu, -err);
 
 	os_set_fd_async(cpu_data[cpu].ipi_pipe[0],
@@ -80,7 +80,7 @@ static int idle_proc(void *cpup)
 
 	wmb();
 	if (cpu_test_and_set(cpu, cpu_callin_map)) {
-		printk("huh, CPU#%d already present??\n", cpu);
+		printk(KERN_ERR "huh, CPU#%d already present??\n", cpu);
 		BUG();
 	}
 
@@ -99,7 +99,7 @@ static struct task_struct *idle_thread(i
 	current->thread.request.u.thread.proc = idle_proc;
 	current->thread.request.u.thread.arg = (void *) cpu;
 	new_task = fork_idle(cpu);
-	if(IS_ERR(new_task))
+	if (IS_ERR(new_task))
 		panic("copy_process failed in idle_thread, error = %ld",
 		      PTR_ERR(new_task));
 
@@ -126,14 +126,14 @@ void smp_prepare_cpus(unsigned int maxcp
 	cpu_set(me, cpu_callin_map);
 
 	err = os_pipe(cpu_data[me].ipi_pipe, 1, 1);
-	if(err < 0)
+	if (err < 0)
 		panic("CPU#0 failed to create IPI pipe, errno = %d", -err);
 
 	os_set_fd_async(cpu_data[me].ipi_pipe[0],
 		     current->thread.mode.tt.extern_pid);
 
-	for(cpu = 1; cpu < ncpus; cpu++){
-		printk("Booting processor %d...\n", cpu);
+	for (cpu = 1; cpu < ncpus; cpu++) {
+		printk(KERN_INFO "Booting processor %d...\n", cpu);
 
 		idle = idle_thread(cpu);
 
@@ -144,8 +144,8 @@ void smp_prepare_cpus(unsigned int maxcp
 			cpu_relax();
 
 		if (cpu_isset(cpu, cpu_callin_map))
-			printk("done\n");
-		else printk("failed\n");
+			printk(KERN_INFO "done\n");
+		else printk(KERN_INFO "failed\n");
 	}
 }
 
@@ -187,13 +187,14 @@ void IPI_handler(int cpu)
 			break;
 
 		case 'S':
-			printk("CPU#%d stopping\n", cpu);
-			while(1)
+			printk(KERN_INFO "CPU#%d stopping\n", cpu);
+			while (1)
 				pause();
 			break;
 
 		default:
-			printk("CPU#%d received unknown IPI [%c]!\n", cpu, c);
+			printk(KERN_ERR "CPU#%d received unknown IPI [%c]!\n",
+			       cpu, c);
 			break;
 		}
 	}
diff -puN arch/um/kernel/trap.c~uml-style-fixes-pass-1 arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-style-fixes-pass-1
+++ a/arch/um/kernel/trap.c
@@ -1,38 +1,24 @@
 /*
- * Copyright (C) 2000, 2001 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/kernel.h"
-#include "asm/errno.h"
-#include "linux/sched.h"
-#include "linux/mm.h"
-#include "linux/spinlock.h"
-#include "linux/init.h"
-#include "linux/ptrace.h"
-#include "asm/semaphore.h"
-#include "asm/pgtable.h"
-#include "asm/pgalloc.h"
-#include "asm/tlbflush.h"
-#include "asm/a.out.h"
-#include "asm/current.h"
-#include "asm/irq.h"
-#include "sysdep/sigcontext.h"
-#include "kern_util.h"
-#include "as-layout.h"
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/hardirq.h>
+#include <asm/current.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
 #include "arch.h"
-#include "kern.h"
-#include "chan_kern.h"
-#include "mconsole_kern.h"
-#include "mem.h"
-#include "mem_kern.h"
-#include "sysdep/sigcontext.h"
-#include "sysdep/ptrace.h"
-#include "os.h"
-#include "skas.h"
+#include "as-layout.h"
+#include "kern_util.h"
 #include "os.h"
+#include "sysdep/sigcontext.h"
 
-/* Note this is constrained to return 0, -EFAULT, -EACCESS, -ENOMEM by segv(). */
+/*
+ * Note this is constrained to return 0, -EFAULT, -EACCESS, -ENOMEM by
+ * segv().
+ */
 int handle_page_fault(unsigned long address, unsigned long ip,
 		      int is_write, int is_user, int *code_out)
 {
@@ -46,31 +32,33 @@ int handle_page_fault(unsigned long addr
 
 	*code_out = SEGV_MAPERR;
 
-	/* If the fault was during atomic operation, don't take the fault, just
-	 * fail. */
+	/*
+	 * If the fault was during atomic operation, don't take the fault, just
+	 * fail.
+	 */
 	if (in_atomic())
 		goto out_nosemaphore;
 
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, address);
-	if(!vma)
+	if (!vma)
 		goto out;
-	else if(vma->vm_start <= address)
+	else if (vma->vm_start <= address)
 		goto good_area;
-	else if(!(vma->vm_flags & VM_GROWSDOWN))
+	else if (!(vma->vm_flags & VM_GROWSDOWN))
 		goto out;
-	else if(is_user && !ARCH_IS_STACKGROW(address))
+	else if (is_user && !ARCH_IS_STACKGROW(address))
 		goto out;
-	else if(expand_stack(vma, address))
+	else if (expand_stack(vma, address))
 		goto out;
 
 good_area:
 	*code_out = SEGV_ACCERR;
-	if(is_write && !(vma->vm_flags & VM_WRITE))
+	if (is_write && !(vma->vm_flags & VM_WRITE))
 		goto out;
 
 	/* Don't require VM_READ|VM_EXEC for write faults! */
-	if(!is_write && !(vma->vm_flags & (VM_READ | VM_EXEC)))
+	if (!is_write && !(vma->vm_flags & (VM_READ | VM_EXEC)))
 		goto out;
 
 	do {
@@ -96,9 +84,10 @@ survive:
 		pud = pud_offset(pgd, address);
 		pmd = pmd_offset(pud, address);
 		pte = pte_offset_kernel(pmd, address);
-	} while(!pte_present(*pte));
+	} while (!pte_present(*pte));
 	err = 0;
-	/* The below warning was added in place of
+	/*
+	 * The below warning was added in place of
 	 *	pte_mkyoung(); if (is_write) pte_mkdirty();
 	 * If it's triggered, we'd see normally a hang here (a clean pte is
 	 * marked read-only to emulate the dirty bit).
@@ -112,7 +101,7 @@ survive:
 out:
 	up_read(&mm->mmap_sem);
 out_nosemaphore:
-	return(err);
+	return err;
 
 /*
  * We ran out of memory, or some other thing happened to us that made
@@ -143,7 +132,7 @@ static void segv_handler(int sig, union 
 {
 	struct faultinfo * fi = UPT_FAULTINFO(regs);
 
-	if(UPT_IS_USER(regs) && !SEGV_IS_FIXABLE(fi)){
+	if (UPT_IS_USER(regs) && !SEGV_IS_FIXABLE(fi)) {
 		bad_segv(*fi, UPT_IP(regs));
 		return;
 	}
@@ -165,37 +154,41 @@ unsigned long segv(struct faultinfo fi, 
 	int is_write = FAULT_WRITE(fi);
 	unsigned long address = FAULT_ADDRESS(fi);
 
-	if(!is_user && (address >= start_vm) && (address < end_vm)){
+	if (!is_user && (address >= start_vm) && (address < end_vm)) {
 		flush_tlb_kernel_vm();
 		return 0;
 	}
-	else if(current->mm == NULL) {
+	else if (current->mm == NULL) {
 		show_regs(container_of(regs, struct pt_regs, regs));
-  		panic("Segfault with no mm");
+		panic("Segfault with no mm");
 	}
 
 	if (SEGV_IS_FIXABLE(&fi) || SEGV_MAYBE_FIXABLE(&fi))
-		err = handle_page_fault(address, ip, is_write, is_user, &si.si_code);
+		err = handle_page_fault(address, ip, is_write, is_user,
+					&si.si_code);
 	else {
 		err = -EFAULT;
-		/* A thread accessed NULL, we get a fault, but CR2 is invalid.
-		 * This code is used in __do_copy_from_user() of TT mode. */
+		/*
+		 * A thread accessed NULL, we get a fault, but CR2 is invalid.
+		 * This code is used in __do_copy_from_user() of TT mode.
+		 * XXX tt mode is gone, so maybe this isn't needed any more
+		 */
 		address = 0;
 	}
 
 	catcher = current->thread.fault_catcher;
-	if(!err)
+	if (!err)
 		return 0;
-	else if(catcher != NULL){
+	else if (catcher != NULL) {
 		current->thread.fault_addr = (void *) address;
 		do_longjmp(catcher, 1);
 	}
-	else if(current->thread.fault_addr != NULL)
+	else if (current->thread.fault_addr != NULL)
 		panic("fault_addr set but no fault catcher");
-	else if(!is_user && arch_fixup(ip, regs))
+	else if (!is_user && arch_fixup(ip, regs))
 		return 0;
 
-	if(!is_user) {
+	if (!is_user) {
 		show_regs(container_of(regs, struct pt_regs, regs));
 		panic("Kernel mode fault at addr 0x%lx, ip 0x%lx",
 		      address, ip);
@@ -209,7 +202,7 @@ unsigned long segv(struct faultinfo fi, 
 		current->thread.arch.faultinfo = fi;
 		force_sig_info(SIGBUS, &si, current);
 	} else if (err == -ENOMEM) {
-		printk("VM: killing process %s\n", current->comm);
+		printk(KERN_INFO "VM: killing process %s\n", current->comm);
 		do_exit(SIGKILL);
 	} else {
 		BUG_ON(err != -EFAULT);
@@ -223,13 +216,13 @@ unsigned long segv(struct faultinfo fi, 
 
 void relay_signal(int sig, union uml_pt_regs *regs)
 {
-	if(arch_handle_signal(sig, regs))
+	if (arch_handle_signal(sig, regs))
 		return;
 
-	if(!UPT_IS_USER(regs)){
-		if(sig == SIGBUS)
-			printk("Bus error - the host /dev/shm or /tmp mount "
-			       "likely just ran out of space\n");
+	if (!UPT_IS_USER(regs)) {
+		if (sig == SIGBUS)
+			printk(KERN_ERR "Bus error - the host /dev/shm or /tmp "
+			       "mount likely just ran out of space\n");
 		panic("Kernel mode signal %d", sig);
 	}
 
@@ -239,7 +232,7 @@ void relay_signal(int sig, union uml_pt_
 
 static void bus_handler(int sig, union uml_pt_regs *regs)
 {
-	if(current->thread.fault_catcher != NULL)
+	if (current->thread.fault_catcher != NULL)
 		do_longjmp(current->thread.fault_catcher, 1);
 	else relay_signal(sig, regs);
 }
diff -puN arch/um/os-Linux/Makefile~uml-style-fixes-pass-1 arch/um/os-Linux/Makefile
--- a/arch/um/os-Linux/Makefile~uml-style-fixes-pass-1
+++ a/arch/um/os-Linux/Makefile
@@ -1,5 +1,5 @@
 # 
-# Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+# Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
 # Licensed under the GPL
 #
 
diff -puN arch/um/os-Linux/sys-i386/Makefile~uml-style-fixes-pass-1 arch/um/os-Linux/sys-i386/Makefile
--- a/arch/um/os-Linux/sys-i386/Makefile~uml-style-fixes-pass-1
+++ a/arch/um/os-Linux/sys-i386/Makefile
@@ -1,5 +1,5 @@
 #
-# Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+# Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
 # Licensed under the GPL
 #
 
diff -puN arch/um/os-Linux/time.c~uml-style-fixes-pass-1 arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-style-fixes-pass-1
+++ a/arch/um/os-Linux/time.c
@@ -1,21 +1,17 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
+#include <stddef.h>
+#include <errno.h>
+#include <signal.h>
 #include <time.h>
 #include <sys/time.h>
-#include <signal.h>
-#include <errno.h>
 #include "kern_util.h"
-#include "user.h"
-#include "process.h"
 #include "kern_constants.h"
 #include "os.h"
-#include "uml-config.h"
+#include "user.h"
 
 int set_interval(int is_virtual)
 {
@@ -24,7 +20,7 @@ int set_interval(int is_virtual)
 	struct itimerval interval = ((struct itimerval) { { 0, usec },
 							  { 0, usec } });
 
-	if(setitimer(timer_type, &interval, NULL) == -1)
+	if (setitimer(timer_type, &interval, NULL) == -1)
 		return -errno;
 
 	return 0;
@@ -33,10 +29,12 @@ int set_interval(int is_virtual)
 void disable_timer(void)
 {
 	struct itimerval disable = ((struct itimerval) { { 0, 0 }, { 0, 0 }});
-	if((setitimer(ITIMER_VIRTUAL, &disable, NULL) < 0) ||
-	   (setitimer(ITIMER_REAL, &disable, NULL) < 0))
-		printk("disnable_timer - setitimer failed, errno = %d\n",
-		       errno);
+
+	if ((setitimer(ITIMER_VIRTUAL, &disable, NULL) < 0) ||
+	    (setitimer(ITIMER_REAL, &disable, NULL) < 0))
+		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
+		       "errno = %d\n", errno);
+
 	/* If there are signals already queued, after unblocking ignore them */
 	signal(SIGALRM, SIG_IGN);
 	signal(SIGVTALRM, SIG_IGN);
@@ -49,7 +47,7 @@ void switch_timers(int to_real)
 							{ 0, 1000000/hz() }});
 	int old, new;
 
-	if(to_real){
+	if (to_real) {
 		old = ITIMER_VIRTUAL;
 		new = ITIMER_REAL;
 	}
@@ -58,10 +56,10 @@ void switch_timers(int to_real)
 		new = ITIMER_VIRTUAL;
 	}
 
-	if((setitimer(old, &disable, NULL) < 0) ||
-	   (setitimer(new, &enable, NULL)))
-		printk("switch_timers - setitimer failed, errno = %d\n",
-		       errno);
+	if ((setitimer(old, &disable, NULL) < 0) ||
+	    (setitimer(new, &enable, NULL)))
+		printk(UM_KERN_ERR "switch_timers - setitimer failed, "
+		       "errno = %d\n", errno);
 }
 
 unsigned long long os_nsecs(void)
@@ -69,7 +67,7 @@ unsigned long long os_nsecs(void)
 	struct timeval tv;
 
 	gettimeofday(&tv, NULL);
-	return((unsigned long long) tv.tv_sec * BILLION + tv.tv_usec * 1000);
+	return (unsigned long long) tv.tv_sec * BILLION + tv.tv_usec * 1000;
 }
 
 void idle_sleep(int secs)
diff -puN arch/um/os-Linux/tls.c~uml-style-fixes-pass-1 arch/um/os-Linux/tls.c
--- a/arch/um/os-Linux/tls.c~uml-style-fixes-pass-1
+++ a/arch/um/os-Linux/tls.c
@@ -1,10 +1,6 @@
 #include <errno.h>
-#include <unistd.h>
 #include <sys/ptrace.h>
-#include <sys/syscall.h>
-#include <asm/ldt.h>
 #include "sysdep/tls.h"
-#include "uml-config.h"
 
 /* TLS support - we basically rely on the host's one.*/
 
diff -puN arch/um/sys-i386/Makefile~uml-style-fixes-pass-1 arch/um/sys-i386/Makefile
--- a/arch/um/sys-i386/Makefile~uml-style-fixes-pass-1
+++ a/arch/um/sys-i386/Makefile
@@ -1,3 +1,7 @@
+#
+# Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+#
+
 obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 	ptrace_user.o setjmp.o signal.o sigcontext.o stub.o stub_segv.o \
 	syscalls.o sysrq.o sys_call_table.o tls.o
diff -puN arch/um/sys-i386/ptrace_user.c~uml-style-fixes-pass-1 arch/um/sys-i386/ptrace_user.c
--- a/arch/um/sys-i386/ptrace_user.c~uml-style-fixes-pass-1
+++ a/arch/um/sys-i386/ptrace_user.c
@@ -1,19 +1,10 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <stdio.h>
-#include <stddef.h>
 #include <errno.h>
-#include <unistd.h>
-#include "ptrace_user.h"
-/* Grr, asm/user.h includes asm/ptrace.h, so has to follow ptrace_user.h */
-#include <asm/user.h>
-#include "kern_util.h"
-#include "user.h"
-#include "os.h"
-#include "uml-config.h"
+#include <sys/ptrace.h>
 
 int ptrace_getregs(long pid, unsigned long *regs_out)
 {
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
