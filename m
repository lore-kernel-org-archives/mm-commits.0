From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-add-internal-helper-and-convenience-function-for-per-cpu-lookup.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:22 -0800
Message-ID: <54e4eb96.RFYaHNqgQ9rQxrww%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbbBRToX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, davem@davemloft.net, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add internal helper and convenience function for per-cpu lookup
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-internal-helper-and-convenience-function-for-per-cpu-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add internal helper and convenience function for per-cpu lookup

This function allows to obtain a per-cpu variable, either of the current
or an explicitly specified CPU.

Note: sparc64 version is untested.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py  |   68 +++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 
 2 files changed, 69 insertions(+)

diff -puN /dev/null scripts/gdb/linux/cpus.py
--- /dev/null
+++ a/scripts/gdb/linux/cpus.py
@@ -0,0 +1,68 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  per-cpu tools
+#
+# Copyright (c) Siemens AG, 2011-2013
+#
+# Authors:
+#  Jan Kiszka <jan.kiszka@siemens.com>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import gdb
+
+from linux import tasks, utils
+
+
+MAX_CPUS = 4096
+
+
+def get_current_cpu():
+    if utils.get_gdbserver_type() == utils.GDBSERVER_QEMU:
+        return gdb.selected_thread().num - 1
+    elif utils.get_gdbserver_type() == utils.GDBSERVER_KGDB:
+        tid = gdb.selected_thread().ptid[2]
+        if tid > (0x100000000 - MAX_CPUS - 2):
+            return 0x100000000 - tid - 2
+        else:
+            return tasks.get_thread_info(tasks.get_task_by_pid(tid))['cpu']
+    else:
+        raise gdb.GdbError("Sorry, obtaining the current CPU is not yet "
+                           "supported with this gdb server.")
+
+
+def per_cpu(var_ptr, cpu):
+    if cpu == -1:
+        cpu = get_current_cpu()
+    if utils.is_target_arch("sparc:v9"):
+        offset = gdb.parse_and_eval(
+            "trap_block[{0}].__per_cpu_base".format(str(cpu)))
+    else:
+        try:
+            offset = gdb.parse_and_eval(
+                "__per_cpu_offset[{0}]".format(str(cpu)))
+        except gdb.error:
+            # !CONFIG_SMP case
+            offset = 0
+    pointer = var_ptr.cast(utils.get_long_type()) + offset
+    return pointer.cast(var_ptr.type).dereference()
+
+
+class PerCpu(gdb.Function):
+    """Return per-cpu variable.
+
+$lx_per_cpu("VAR"[, CPU]): Return the per-cpu variable called VAR for the
+given CPU number. If CPU is omitted, the CPU of the current context is used.
+Note that VAR has to be quoted as string."""
+
+    def __init__(self):
+        super(PerCpu, self).__init__("lx_per_cpu")
+
+    def invoke(self, var_name, cpu=-1):
+        var_ptr = gdb.parse_and_eval("&" + var_name.string())
+        return per_cpu(var_ptr, cpu)
+
+
+PerCpu()
diff -puN scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-internal-helper-and-convenience-function-for-per-cpu-lookup scripts/gdb/vmlinux-gdb.py
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-internal-helper-and-convenience-function-for-per-cpu-lookup
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -27,3 +27,4 @@ else:
     import linux.modules
     import linux.dmesg
     import linux.tasks
+    import linux.cpus
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

