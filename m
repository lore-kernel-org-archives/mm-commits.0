From: akpm@linux-foundation.org
Subject: [merged]
 sys_membarrier-system-wide-memory-barrier-generic-x86.patch removed from
 -mm tree
Date: Mon, 14 Sep 2015 10:28:41 -0700
Message-ID: <55f703c9.ioVnLodqxML888bX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbbINR2m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 13:28:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@efficios.com, bobby.prani@gmail.com, dhowells@redhat.com, gnomes@lxorguk.ukuu.org.uk, josh@joshtriplett.org, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@redhat.com, mtk.manpages@gmail.com, nmiell@comcast.net, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rostedt@goodmis.org, shuahkh@osg.samsung.com, stephen@networkplumber.org, tglx@linutronix.de, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sys_membarrier(): system-wide memory barrier (generic, x86)
has been removed from the -mm tree.  Its filename was
     sys_membarrier-system-wide-memory-barrier-generic-x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: sys_membarrier(): system-wide memory barrier (generic, x86)

Here is an implementation of a new system call, sys_membarrier(), which
executes a memory barrier on all threads running on the system.  It is
implemented by calling synchronize_sched().  It can be used to distribute
the cost of user-space memory barriers asymmetrically by transforming
pairs of memory barriers into pairs consisting of sys_membarrier() and a
compiler barrier.  For synchronization primitives that distinguish between
read-side and write-side (e.g.  userspace RCU [1], rwlocks), the read-side
can be accelerated significantly by moving the bulk of the memory barrier
overhead to the write-side.

The existing applications of which I am aware that would be improved by this
system call are as follows:

* Through Userspace RCU library (http://urcu.so)
  - DNS server (Knot DNS) https://www.knot-dns.cz/
  - Network sniffer (http://netsniff-ng.org/)
  - Distributed object storage (https://sheepdog.github.io/sheepdog/)
  - User-space tracing (http://lttng.org)
  - Network storage system (https://www.gluster.org/)
  - Virtual routers (https://events.linuxfoundation.org/sites/events/files/slides/DPDK_RCU_0MQ.pdf)
  - Financial software (https://lkml.org/lkml/2015/3/23/189)

Those projects use RCU in userspace to increase read-side speed and
scalability compared to locking.  Especially in the case of RCU used by
libraries, sys_membarrier can speed up the read-side by moving the bulk of
the memory barrier cost to synchronize_rcu().

* Direct users of sys_membarrier
  - core dotnet garbage collector (https://github.com/dotnet/coreclr/issues/198)

Microsoft core dotnet GC developers are planning to use the mprotect()
side-effect of issuing memory barriers through IPIs as a way to implement
Windows FlushProcessWriteBuffers() on Linux.  They are referring to
sys_membarrier in their github thread, specifically stating that
sys_membarrier() is what they are looking for.

To explain the benefit of this scheme, let's introduce two example threads:

Thread A (non-frequent, e.g. executing liburcu synchronize_rcu())
Thread B (frequent, e.g. executing liburcu
rcu_read_lock()/rcu_read_unlock())

In a scheme where all smp_mb() in thread A are ordering memory accesses
with respect to smp_mb() present in Thread B, we can change each
smp_mb() within Thread A into calls to sys_membarrier() and each
smp_mb() within Thread B into compiler barriers "barrier()".

Before the change, we had, for each smp_mb() pairs:

Thread A                    Thread B
previous mem accesses       previous mem accesses
smp_mb()                    smp_mb()
following mem accesses      following mem accesses

After the change, these pairs become:

Thread A                    Thread B
prev mem accesses           prev mem accesses
sys_membarrier()            barrier()
follow mem accesses         follow mem accesses

As we can see, there are two possible scenarios: either Thread B memory
accesses do not happen concurrently with Thread A accesses (1), or they
do (2).

1) Non-concurrent Thread A vs Thread B accesses:

Thread A                    Thread B
prev mem accesses
sys_membarrier()
follow mem accesses
                            prev mem accesses
                            barrier()
                            follow mem accesses

In this case, thread B accesses will be weakly ordered. This is OK,
because at that point, thread A is not particularly interested in
ordering them with respect to its own accesses.

2) Concurrent Thread A vs Thread B accesses

Thread A                    Thread B
prev mem accesses           prev mem accesses
sys_membarrier()            barrier()
follow mem accesses         follow mem accesses

In this case, thread B accesses, which are ensured to be in program
order thanks to the compiler barrier, will be "upgraded" to full
smp_mb() by synchronize_sched().

* Benchmarks

On Intel Xeon E5405 (8 cores)
(one thread is calling sys_membarrier, the other 7 threads are busy
looping)

1000 non-expedited sys_membarrier calls in 33s =3D 33 milliseconds/call.

* User-space user of this system call: Userspace RCU library

Both the signal-based and the sys_membarrier userspace RCU schemes
permit us to remove the memory barrier from the userspace RCU
rcu_read_lock() and rcu_read_unlock() primitives, thus significantly
accelerating them. These memory barriers are replaced by compiler
barriers on the read-side, and all matching memory barriers on the
write-side are turned into an invocation of a memory barrier on all
active threads in the process. By letting the kernel perform this
synchronization rather than dumbly sending a signal to every process
threads (as we currently do), we diminish the number of unnecessary wake
ups and only issue the memory barriers on active threads. Non-running
threads do not need to execute such barrier anyway, because these are
implied by the scheduler context switches.

Results in liburcu:

Operations in 10s, 6 readers, 2 writers:

memory barriers in reader:    1701557485 reads, 2202847 writes
signal-based scheme:          9830061167 reads,    6700 writes
sys_membarrier:               9952759104 reads,     425 writes
sys_membarrier (dyn. check):  7970328887 reads,     425 writes

The dynamic sys_membarrier availability check adds some overhead to
the read-side compared to the signal-based scheme, but besides that,
sys_membarrier slightly outperforms the signal-based scheme. However,
this non-expedited sys_membarrier implementation has a much slower grace
period than signal and memory barrier schemes.

Besides diminishing the number of wake-ups, one major advantage of the
membarrier system call over the signal-based scheme is that it does not
need to reserve a signal. This plays much more nicely with libraries,
and with processes injected into for tracing purposes, for which we
cannot expect that signals will be unused by the application.

An expedited version of this system call can be added later on to speed
up the grace period. Its implementation will likely depend on reading
the cpu_curr()->mm without holding each CPU's rq lock.

This patch adds the system call to x86 and to asm-generic.

[1] http://urcu.so


membarrier(2) man page:

MEMBARRIER(2)              Linux Programmer's Manual             MEMBARRIER(2)

NAME
       membarrier - issue memory barriers on a set of threads

SYNOPSIS
       #include <linux/membarrier.h>

       int membarrier(int cmd, int flags);

DESCRIPTION
       The cmd argument is one of the following:

       MEMBARRIER_CMD_QUERY
              Query  the  set  of  supported commands. It returns a bitmask of
              supported commands.

       MEMBARRIER_CMD_SHARED
              Execute a memory barrier on all threads running on  the  system.
              Upon  return from system call, the caller thread is ensured that
              all running threads have passed through a state where all memory
              accesses  to  user-space  addresses  match program order between
              entry to and return from the system  call  (non-running  threads
              are de facto in such a state). This covers threads from all pro=E2=80=90
              cesses running on the system.  This command returns 0.

       The flags argument needs to be 0. For future extensions.

       All memory accesses performed  in  program  order  from  each  targeted
       thread is guaranteed to be ordered with respect to sys_membarrier(). If
       we use the semantic "barrier()" to represent a compiler barrier forcing
       memory  accesses  to  be performed in program order across the barrier,
       and smp_mb() to represent explicit memory barriers forcing full  memory
       ordering  across  the barrier, we have the following ordering table for
       each pair of barrier(), sys_membarrier() and smp_mb():

       The pair ordering is detailed as (O: ordered, X: not ordered):

                              barrier()   smp_mb() sys_membarrier()
              barrier()          X           X            O
              smp_mb()           X           O            O
              sys_membarrier()   O           O            O

RETURN VALUE
       On success, these system calls return zero.  On error, -1 is  returned,
       and errno is set appropriately. For a given command, with flags
       argument set to 0, this system call is guaranteed to always return the
       same value until reboot.

ERRORS
       ENOSYS System call is not implemented.

       EINVAL Invalid arguments.

Linux                             2015-04-15                     MEMBARRIER(2)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Nicholas Miell <nmiell@comcast.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                            |    8 ++
 arch/x86/entry/syscalls/syscall_32.tbl |    1 
 arch/x86/entry/syscalls/syscall_64.tbl |    1 
 include/linux/syscalls.h               |    2 
 include/uapi/asm-generic/unistd.h      |    4 +
 include/uapi/linux/Kbuild              |    1 
 include/uapi/linux/membarrier.h        |   53 ++++++++++++++++++
 init/Kconfig                           |   12 ++++
 kernel/Makefile                        |    1 
 kernel/membarrier.c                    |   66 +++++++++++++++++++++++
 kernel/sys_ni.c                        |    3 +
 11 files changed, 151 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~sys_membarrier-system-wide-memory-barrier-generic-x86 MAINTAINERS
--- a/MAINTAINERS~sys_membarrier-system-wide-memory-barrier-generic-x86
+++ a/MAINTAINERS
@@ -6789,6 +6789,14 @@ W:	http://www.mellanox.com
 Q:	http://patchwork.ozlabs.org/project/netdev/list/
 F:	drivers/net/ethernet/mellanox/mlxsw/
 
+MEMBARRIER SUPPORT
+M:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	kernel/membarrier.c
+F:	include/uapi/linux/membarrier.h
+
 MEMORY MANAGEMENT
 L:	linux-mm@kvack.org
 W:	http://www.linux-mm.org
diff -puN arch/x86/entry/syscalls/syscall_32.tbl~sys_membarrier-system-wide-memory-barrier-generic-x86 arch/x86/entry/syscalls/syscall_32.tbl
--- a/arch/x86/entry/syscalls/syscall_32.tbl~sys_membarrier-system-wide-memory-barrier-generic-x86
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -381,3 +381,4 @@
 372	i386	recvmsg			sys_recvmsg			compat_sys_recvmsg
 373	i386	shutdown		sys_shutdown
 374	i386	userfaultfd		sys_userfaultfd
+375	i386	membarrier		sys_membarrier
diff -puN arch/x86/entry/syscalls/syscall_64.tbl~sys_membarrier-system-wide-memory-barrier-generic-x86 arch/x86/entry/syscalls/syscall_64.tbl
--- a/arch/x86/entry/syscalls/syscall_64.tbl~sys_membarrier-system-wide-memory-barrier-generic-x86
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -330,6 +330,7 @@
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
 323	common	userfaultfd		sys_userfaultfd
+324	common	membarrier		sys_membarrier
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff -puN include/linux/syscalls.h~sys_membarrier-system-wide-memory-barrier-generic-x86 include/linux/syscalls.h
--- a/include/linux/syscalls.h~sys_membarrier-system-wide-memory-barrier-generic-x86
+++ a/include/linux/syscalls.h
@@ -885,4 +885,6 @@ asmlinkage long sys_execveat(int dfd, co
 			const char __user *const __user *argv,
 			const char __user *const __user *envp, int flags);
 
+asmlinkage long sys_membarrier(int cmd, int flags);
+
 #endif
diff -puN include/uapi/asm-generic/unistd.h~sys_membarrier-system-wide-memory-barrier-generic-x86 include/uapi/asm-generic/unistd.h
--- a/include/uapi/asm-generic/unistd.h~sys_membarrier-system-wide-memory-barrier-generic-x86
+++ a/include/uapi/asm-generic/unistd.h
@@ -709,9 +709,11 @@ __SYSCALL(__NR_memfd_create, sys_memfd_c
 __SYSCALL(__NR_bpf, sys_bpf)
 #define __NR_execveat 281
 __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
+#define __NR_membarrier 282
+__SYSCALL(__NR_membarrier, sys_membarrier)
 
 #undef __NR_syscalls
-#define __NR_syscalls 282
+#define __NR_syscalls 283
 
 /*
  * All syscalls below here should go away really,
diff -puN include/uapi/linux/Kbuild~sys_membarrier-system-wide-memory-barrier-generic-x86 include/uapi/linux/Kbuild
--- a/include/uapi/linux/Kbuild~sys_membarrier-system-wide-memory-barrier-generic-x86
+++ a/include/uapi/linux/Kbuild
@@ -252,6 +252,7 @@ header-y += mdio.h
 header-y += media.h
 header-y += media-bus-format.h
 header-y += mei.h
+header-y += membarrier.h
 header-y += memfd.h
 header-y += mempolicy.h
 header-y += meye.h
diff -puN /dev/null include/uapi/linux/membarrier.h
--- /dev/null
+++ a/include/uapi/linux/membarrier.h
@@ -0,0 +1,53 @@
+#ifndef _UAPI_LINUX_MEMBARRIER_H
+#define _UAPI_LINUX_MEMBARRIER_H
+
+/*
+ * linux/membarrier.h
+ *
+ * membarrier system call API
+ *
+ * Copyright (c) 2010, 2015 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to deal
+ * in the Software without restriction, including without limitation the rights
+ * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
+ * copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+/**
+ * enum membarrier_cmd - membarrier system call command
+ * @MEMBARRIER_CMD_QUERY:   Query the set of supported commands. It returns
+ *                          a bitmask of valid commands.
+ * @MEMBARRIER_CMD_SHARED:  Execute a memory barrier on all running threads.
+ *                          Upon return from system call, the caller thread
+ *                          is ensured that all running threads have passed
+ *                          through a state where all memory accesses to
+ *                          user-space addresses match program order between
+ *                          entry to and return from the system call
+ *                          (non-running threads are de facto in such a
+ *                          state). This covers threads from all processes
+ *                          running on the system. This command returns 0.
+ *
+ * Command to be passed to the membarrier system call. The commands need to
+ * be a single bit each, except for MEMBARRIER_CMD_QUERY which is assigned to
+ * the value 0.
+ */
+enum membarrier_cmd {
+	MEMBARRIER_CMD_QUERY = 0,
+	MEMBARRIER_CMD_SHARED = (1 << 0),
+};
+
+#endif /* _UAPI_LINUX_MEMBARRIER_H */
diff -puN init/Kconfig~sys_membarrier-system-wide-memory-barrier-generic-x86 init/Kconfig
--- a/init/Kconfig~sys_membarrier-system-wide-memory-barrier-generic-x86
+++ a/init/Kconfig
@@ -1602,6 +1602,18 @@ config PCI_QUIRKS
 	  bugs/quirks. Disable this only if your target machine is
 	  unaffected by PCI quirks.
 
+config MEMBARRIER
+	bool "Enable membarrier() system call" if EXPERT
+	default y
+	help
+	  Enable the membarrier() system call that allows issuing memory
+	  barriers across all running threads, which can be used to distribute
+	  the cost of user-space memory barriers asymmetrically by transforming
+	  pairs of memory barriers into pairs consisting of membarrier() and a
+	  compiler barrier.
+
+	  If unsure, say Y.
+
 config EMBEDDED
 	bool "Embedded system"
 	option allnoconfig_y
diff -puN kernel/Makefile~sys_membarrier-system-wide-memory-barrier-generic-x86 kernel/Makefile
--- a/kernel/Makefile~sys_membarrier-system-wide-memory-barrier-generic-x86
+++ a/kernel/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
+obj-$(CONFIG_MEMBARRIER) += membarrier.o
 
 obj-$(CONFIG_HAS_IOMEM) += memremap.o
 
diff -puN /dev/null kernel/membarrier.c
--- /dev/null
+++ a/kernel/membarrier.c
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2010, 2015 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * membarrier system call
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/syscalls.h>
+#include <linux/membarrier.h>
+
+/*
+ * Bitmask made from a "or" of all commands within enum membarrier_cmd,
+ * except MEMBARRIER_CMD_QUERY.
+ */
+#define MEMBARRIER_CMD_BITMASK	(MEMBARRIER_CMD_SHARED)
+
+/**
+ * sys_membarrier - issue memory barriers on a set of threads
+ * @cmd:   Takes command values defined in enum membarrier_cmd.
+ * @flags: Currently needs to be 0. For future extensions.
+ *
+ * If this system call is not implemented, -ENOSYS is returned. If the
+ * command specified does not exist, or if the command argument is invalid,
+ * this system call returns -EINVAL. For a given command, with flags argument
+ * set to 0, this system call is guaranteed to always return the same value
+ * until reboot.
+ *
+ * All memory accesses performed in program order from each targeted thread
+ * is guaranteed to be ordered with respect to sys_membarrier(). If we use
+ * the semantic "barrier()" to represent a compiler barrier forcing memory
+ * accesses to be performed in program order across the barrier, and
+ * smp_mb() to represent explicit memory barriers forcing full memory
+ * ordering across the barrier, we have the following ordering table for
+ * each pair of barrier(), sys_membarrier() and smp_mb():
+ *
+ * The pair ordering is detailed as (O: ordered, X: not ordered):
+ *
+ *                        barrier()   smp_mb() sys_membarrier()
+ *        barrier()          X           X            O
+ *        smp_mb()           X           O            O
+ *        sys_membarrier()   O           O            O
+ */
+SYSCALL_DEFINE2(membarrier, int, cmd, int, flags)
+{
+	if (unlikely(flags))
+		return -EINVAL;
+	switch (cmd) {
+	case MEMBARRIER_CMD_QUERY:
+		return MEMBARRIER_CMD_BITMASK;
+	case MEMBARRIER_CMD_SHARED:
+		if (num_online_cpus() > 1)
+			synchronize_sched();
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
diff -puN kernel/sys_ni.c~sys_membarrier-system-wide-memory-barrier-generic-x86 kernel/sys_ni.c
--- a/kernel/sys_ni.c~sys_membarrier-system-wide-memory-barrier-generic-x86
+++ a/kernel/sys_ni.c
@@ -245,3 +245,6 @@ cond_syscall(sys_bpf);
 
 /* execveat */
 cond_syscall(sys_execveat);
+
+/* membarrier */
+cond_syscall(sys_membarrier);
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are


