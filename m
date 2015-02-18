From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-lx-dmesg-command.patch removed from -mm
 tree
Date: Wed, 18 Feb 2015 11:44:07 -0800
Message-ID: <54e4eb87.3IY+q9pnVCkSZuWC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbbBRToI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, kay@vrfy.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add lx-dmesg command
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-lx-dmesg-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add lx-dmesg command

This pokes into the log buffer of the debugged kernel, dumping it to the
gdb console.  Helping in case the target should or can no longer execute
dmesg itself.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/dmesg.py |   64 +++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 
 2 files changed, 65 insertions(+)

diff -puN /dev/null scripts/gdb/linux/dmesg.py
--- /dev/null
+++ a/scripts/gdb/linux/dmesg.py
@@ -0,0 +1,64 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  kernel log buffer dump
+#
+# Copyright (c) Siemens AG, 2011, 2012
+#
+# Authors:
+#  Jan Kiszka <jan.kiszka@siemens.com>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import gdb
+import string
+
+from linux import utils
+
+
+class LxDmesg(gdb.Command):
+    """Print Linux kernel log buffer."""
+
+    def __init__(self):
+        super(LxDmesg, self).__init__("lx-dmesg", gdb.COMMAND_DATA)
+
+    def invoke(self, arg, from_tty):
+        log_buf_addr = int(str(gdb.parse_and_eval("log_buf")).split()[0], 16)
+        log_first_idx = int(gdb.parse_and_eval("log_first_idx"))
+        log_next_idx = int(gdb.parse_and_eval("log_next_idx"))
+        log_buf_len = int(gdb.parse_and_eval("log_buf_len"))
+
+        inf = gdb.inferiors()[0]
+        start = log_buf_addr + log_first_idx
+        if log_first_idx < log_next_idx:
+            log_buf_2nd_half = -1
+            length = log_next_idx - log_first_idx
+            log_buf = inf.read_memory(start, length)
+        else:
+            log_buf_2nd_half = log_buf_len - log_first_idx
+            log_buf = inf.read_memory(start, log_buf_2nd_half) + \
+                inf.read_memory(log_buf_addr, log_next_idx)
+
+        pos = 0
+        while pos < log_buf.__len__():
+            length = utils.read_u16(log_buf[pos + 8:pos + 10])
+            if length == 0:
+                if log_buf_2nd_half == -1:
+                    gdb.write("Corrupted log buffer!\n")
+                    break
+                pos = log_buf_2nd_half
+                continue
+
+            text_len = utils.read_u16(log_buf[pos + 10:pos + 12])
+            time_stamp = utils.read_u64(log_buf[pos:pos + 8])
+
+            for line in log_buf[pos + 16:pos + 16 + text_len].splitlines():
+                gdb.write("[{time:12.6f}] {line}\n".format(
+                    time=time_stamp / 1000000000.0,
+                    line=line))
+
+            pos += length
+
+
+LxDmesg()
diff -puN scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-lx-dmesg-command scripts/gdb/vmlinux-gdb.py
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-lx-dmesg-command
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -25,3 +25,4 @@ else:
     import linux.utils
     import linux.symbols
     import linux.modules
+    import linux.dmesg
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

