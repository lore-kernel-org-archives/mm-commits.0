From: akpm@linux-foundation.org
Subject: + scripts-gdb-add-cmdline-reader-command.patch added to -mm tree
Date: Tue, 26 Jan 2016 19:33:54 -0800
Message-ID: <56a83aa2.9dofSVpVtyn/Xxrd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbcA0Ddz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 22:33:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, jan.kiszka@siemens.com, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: Add cmdline reader command
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-cmdline-reader-command.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-cmdline-reader-command.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-cmdline-reader-command.patch

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
Subject: scripts/gdb: Add cmdline reader command

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

scripts-gdb-add-version-command.patch
scripts-gdb-add-cmdline-reader-command.patch

