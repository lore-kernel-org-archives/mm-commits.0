From: akpm@linux-foundation.org
Subject: + scripts-gdb-add-basic-documentation.patch added to -mm tree
Date: Fri, 30 Jan 2015 15:36:57 -0800
Message-ID: <54cc1599.BRuBu2KCBWKM04vR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761475AbbA3Xg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:36:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, rob@landley.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add basic documentation
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-basic-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-basic-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-basic-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add basic documentation

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gdb-kernel-debugging.txt |  160 +++++++++++++++++++++++
 1 file changed, 160 insertions(+)

diff -puN /dev/null Documentation/gdb-kernel-debugging.txt
--- /dev/null
+++ a/Documentation/gdb-kernel-debugging.txt
@@ -0,0 +1,160 @@
+Debugging kernel and modules via gdb
+====================================
+
+The kernel debugger kgdb, hypervisors like QEMU or JTAG-based hardware
+interfaces allow to debug the Linux kernel and its modules during runtime
+using gdb. Gdb comes with a powerful scripting interface for python. The
+kernel provides a collection of helper scripts that can simplify typical
+kernel debugging steps. This is a short tutorial about how to enable and use
+them. It focuses on QEMU/KVM virtual machines as target, but the examples can
+be transferred to the other gdb stubs as well.
+
+
+Requirements
+------------
+
+ o gdb 7.2+ (recommended: 7.4+) with python support enabled (typically true
+   for distributions)
+
+
+Setup
+-----
+
+ o Create a virtual Linux machine for QEMU/KVM (see www.linux-kvm.org and
+   www.qemu.org for more details). For cross-development,
+   http://landley.net/aboriginal/bin keeps a pool of machine images and
+   toolchains that can be helpful to start from.
+
+ o Build the kernel with CONFIG_GDB_SCRIPTS enabled, but leave
+   CONFIG_DEBUG_INFO_REDUCED off. If your architecture supports
+   CONFIG_FRAME_POINTER, keep it enabled.
+
+ o Install that kernel on the guest.
+
+   Alternatively, QEMU allows to boot the kernel directly using -kernel,
+   -append, -initrd command line switches. This is generally only useful if
+   you do not depend on modules. See QEMU documentation for more details on
+   this mode.
+
+ o Enable the gdb stub of QEMU/KVM, either
+    - at VM startup time by appending "-s" to the QEMU command line
+   or
+    - during runtime by issuing "gdbserver" from the QEMU monitor
+      console
+
+ o cd /path/to/linux-build
+
+ o Start gdb: gdb vmlinux
+
+   Note: Some distros may restrict auto-loading of gdb scripts to known safe
+   directories. In case gdb reports to refuse loading vmlinux-gdb.py, add
+
+    add-auto-load-safe-path /path/to/linux-build
+
+   to ~/.gdbinit. See gdb help for more details.
+
+ o Attach to the booted guest:
+    (gdb) target remote :1234
+
+
+Examples of using the Linux-provided gdb helpers
+------------------------------------------------
+
+ o Load module (and main kernel) symbols:
+    (gdb) lx-symbols
+    loading vmlinux
+    scanning for modules in /home/user/linux/build
+    loading @0xffffffffa0020000: /home/user/linux/build/net/netfilter/xt_tcpudp.ko
+    loading @0xffffffffa0016000: /home/user/linux/build/net/netfilter/xt_pkttype.ko
+    loading @0xffffffffa0002000: /home/user/linux/build/net/netfilter/xt_limit.ko
+    loading @0xffffffffa00ca000: /home/user/linux/build/net/packet/af_packet.ko
+    loading @0xffffffffa003c000: /home/user/linux/build/fs/fuse/fuse.ko
+    ...
+    loading @0xffffffffa0000000: /home/user/linux/build/drivers/ata/ata_generic.ko
+
+ o Set a breakpoint on some not yet loaded module function, e.g.:
+    (gdb) b btrfs_init_sysfs
+    Function "btrfs_init_sysfs" not defined.
+    Make breakpoint pending on future shared library load? (y or [n]) y
+    Breakpoint 1 (btrfs_init_sysfs) pending.
+
+ o Continue the target
+    (gdb) c
+
+ o Load the module on the target and watch the symbols being loaded as well as
+   the breakpoint hit:
+    loading @0xffffffffa0034000: /home/user/linux/build/lib/libcrc32c.ko
+    loading @0xffffffffa0050000: /home/user/linux/build/lib/lzo/lzo_compress.ko
+    loading @0xffffffffa006e000: /home/user/linux/build/lib/zlib_deflate/zlib_deflate.ko
+    loading @0xffffffffa01b1000: /home/user/linux/build/fs/btrfs/btrfs.ko
+
+    Breakpoint 1, btrfs_init_sysfs () at /home/user/linux/fs/btrfs/sysfs.c:36
+    36              btrfs_kset = kset_create_and_add("btrfs", NULL, fs_kobj);
+
+ o Dump the log buffer of the target kernel:
+    (gdb) lx-dmesg
+    [     0.000000] Initializing cgroup subsys cpuset
+    [     0.000000] Initializing cgroup subsys cpu
+    [     0.000000] Linux version 3.8.0-rc4-dbg+ (...
+    [     0.000000] Command line: root=/dev/sda2 resume=/dev/sda1 vga=0x314
+    [     0.000000] e820: BIOS-provided physical RAM map:
+    [     0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
+    [     0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
+    ....
+
+ o Examine fields of the current task struct:
+    (gdb) p $lx_current().pid
+    $1 = 4998
+    (gdb) p $lx_current().comm
+    $2 = "modprobe\000\000\000\000\000\000\000"
+
+ o Make use of the per-cpu function for the current or a specified CPU:
+    (gdb) p $lx_per_cpu("runqueues").nr_running
+    $3 = 1
+    (gdb) p $lx_per_cpu("runqueues", 2).nr_running
+    $4 = 0
+
+ o Dig into hrtimers using the container_of helper:
+    (gdb) set $next = $lx_per_cpu("hrtimer_bases").clock_base[0].active.next
+    (gdb) p *$container_of($next, "struct hrtimer", "node")
+    $5 = {
+      node = {
+        node = {
+          __rb_parent_color = 18446612133355256072,
+          rb_right = 0x0 <irq_stack_union>,
+          rb_left = 0x0 <irq_stack_union>
+        },
+        expires = {
+          tv64 = 1835268000000
+        }
+      },
+      _softexpires = {
+        tv64 = 1835268000000
+      },
+      function = 0xffffffff81078232 <tick_sched_timer>,
+      base = 0xffff88003fd0d6f0,
+      state = 1,
+      start_pid = 0,
+      start_site = 0xffffffff81055c1f <hrtimer_start_range_ns+20>,
+      start_comm = "swapper/2\000\000\000\000\000\000"
+    }
+
+
+List of commands and functions
+------------------------------
+
+The number of commands and convenience functions may evolve over the time,
+this is just a snapshot of the initial version:
+
+ (gdb) apropos lx
+ function lx_current -- Return current task
+ function lx_module -- Find module by name and return the module variable
+ function lx_per_cpu -- Return per-cpu variable
+ function lx_task_by_pid -- Find Linux task by PID and return the task_struct variable
+ function lx_thread_info -- Calculate Linux thread_info from task variable
+ lx-dmesg -- Print Linux kernel log buffer
+ lx-lsmod -- List currently loaded modules
+ lx-symbols -- (Re-)load symbols of Linux kernel and currently loaded modules
+
+Detailed help can be obtained via "help <command-name>" for commands and "help
+function <function-name>" for convenience functions.
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

scripts-gdb-add-infrastructure.patch
scripts-gdb-add-cache-for-type-objects.patch
scripts-gdb-add-container_of-helper-and-convenience-function.patch
scripts-gdb-add-module-iteration-class.patch
scripts-gdb-add-lx-symbols-command.patch
module-do-not-inline-do_init_module.patch
scripts-gdb-add-automatic-symbol-reloading-on-module-insertion.patch
scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module.patch
scripts-gdb-add-get_target_endianness-helper.patch
scripts-gdb-add-read_u16-32-64-helpers.patch
scripts-gdb-add-lx-dmesg-command.patch
scripts-gdb-add-task-iteration-class.patch
scripts-gdb-add-helper-and-convenience-function-to-look-up-tasks.patch
scripts-gdb-add-is_target_arch-helper.patch
scripts-gdb-add-internal-helper-and-convenience-function-to-retrieve-thread_info.patch
scripts-gdb-add-get_gdbserver_type-helper.patch
scripts-gdb-add-internal-helper-and-convenience-function-for-per-cpu-lookup.patch
scripts-gdb-add-lx_current-convenience-function.patch
scripts-gdb-add-class-to-iterate-over-cpu-masks.patch
scripts-gdb-add-lx-lsmod-command.patch
scripts-gdb-add-basic-documentation.patch
scripts-gdb-port-to-python3-gdb77.patch
scripts-gdb-ignore-byte-compiled-python-files.patch
scripts-gdb-use-a-generator-instead-of-iterator-for-task-list.patch
scripts-gdb-convert-modulelist-to-generator-function.patch
scripts-gdb-convert-cpulist-to-generator-function.patch
scripts-gdb-define-maintainer.patch
scripts-gdb-disable-pagination-while-printing-from-breakpoint-handler.patch

