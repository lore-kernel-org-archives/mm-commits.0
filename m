From: akpm@linux-foundation.org
Subject: + scripts-gdb-add-version-command.patch added to -mm tree
Date: Tue, 26 Jan 2016 19:33:55 -0800
Message-ID: <56a83aa3.8csDQduloTkb1PI7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbcA0Dd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 22:33:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, jan.kiszka@siemens.com, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: Add version command
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-version-command.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-version-command.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-version-command.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kieran Bingham <kieran.bingham@linaro.org>
Subject: scripts/gdb: Add version command

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

scripts-gdb-add-version-command.patch
scripts-gdb-add-cmdline-reader-command.patch

