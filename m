From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-cmdline-reader-command.patch removed
 from -mm tree
Date: Wed, 23 Mar 2016 10:42:32 -0700
Message-ID: <56f2d588.2XCtckO3wTDE3ySI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbcCWRmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, jan.kiszka@siemens.com, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add cmdline reader command
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-cmdline-reader-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kieran Bingham <kieran.bingham@linaro.org>
Subject: scripts/gdb: add cmdline reader command

lx-cmdline  Report the Linux Commandline used in the current kernel

[jan.kiszka@siemens.com: remove blank line from help output and fix pep8 warning]
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/proc.py |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN scripts/gdb/linux/proc.py~scripts-gdb-add-cmdline-reader-command scripts/gdb/linux/proc.py
--- a/scripts/gdb/linux/proc.py~scripts-gdb-add-cmdline-reader-command
+++ a/scripts/gdb/linux/proc.py
@@ -14,6 +14,19 @@
 import gdb
 
 
+class LxCmdLine(gdb.Command):
+    """ Report the Linux Commandline used in the current kernel.
+        Equivalent to cat /proc/cmdline on a running target"""
+
+    def __init__(self):
+        super(LxCmdLine, self).__init__("lx-cmdline", gdb.COMMAND_DATA)
+
+    def invoke(self, arg, from_tty):
+        gdb.write(gdb.parse_and_eval("saved_command_line").string() + "\n")
+
+LxCmdLine()
+
+
 class LxVersion(gdb.Command):
     """ Report the Linux Version of the current kernel.
         Equivalent to cat /proc/version on a running target"""
_

Patches currently in -mm which might be from kieran.bingham@linaro.org are


