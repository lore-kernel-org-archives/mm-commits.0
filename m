From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-version-command.patch removed from -mm
 tree
Date: Wed, 23 Mar 2016 10:42:30 -0700
Message-ID: <56f2d586.J0lMsByEv+3+B4WK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbcCWRmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, jan.kiszka@siemens.com, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add version command
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-version-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kieran Bingham <kieran.bingham@linaro.org>
Subject: scripts/gdb: add version command

lx-version  Report the Linux Version of the current kernel.

Add a command to identify the version specified by the banner in the
debugged kernel.

This lets the user identify the kernel of the running kernel, and will let
later scripts compare the banner of the attached kernel against the banner
in the vmlinux symbols files to verify that the files are correct.

[jan.kiszka@siemens.com: remove blank line from help output and fix pep8 warning]
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/proc.py  |   28 ++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 +
 2 files changed, 29 insertions(+)

diff -puN /dev/null scripts/gdb/linux/proc.py
--- /dev/null
+++ a/scripts/gdb/linux/proc.py
@@ -0,0 +1,28 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  Kernel proc information reader
+#
+# Copyright (c) 2016 Linaro Ltd
+#
+# Authors:
+#  Kieran Bingham <kieran.bingham@linaro.org>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import gdb
+
+
+class LxVersion(gdb.Command):
+    """ Report the Linux Version of the current kernel.
+        Equivalent to cat /proc/version on a running target"""
+
+    def __init__(self):
+        super(LxVersion, self).__init__("lx-version", gdb.COMMAND_DATA)
+
+    def invoke(self, arg, from_tty):
+        # linux_banner should contain a newline
+        gdb.write(gdb.parse_and_eval("linux_banner").string())
+
+LxVersion()
diff -puN scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-version-command scripts/gdb/vmlinux-gdb.py
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-version-command
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -29,3 +29,4 @@ else:
     import linux.tasks
     import linux.cpus
     import linux.lists
+    import linux.proc
_

Patches currently in -mm which might be from kieran.bingham@linaro.org are


