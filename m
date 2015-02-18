From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-get_gdbserver_type-helper.patch removed
 from -mm tree
Date: Wed, 18 Feb 2015 11:44:19 -0800
Message-ID: <54e4eb93.aUGV49+Mxv3EMkYc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbbBRToU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add get_gdbserver_type helper
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-get_gdbserver_type-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add get_gdbserver_type helper

This helper probes the type of the gdb server.  Supported are QEMU and
KGDB so far.  Knowledge about the gdb server is required e.g.  to retrieve
the current CPU or current task.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN scripts/gdb/linux/utils.py~scripts-gdb-add-get_gdbserver_type-helper scripts/gdb/linux/utils.py
--- a/scripts/gdb/linux/utils.py~scripts-gdb-add-get_gdbserver_type-helper
+++ a/scripts/gdb/linux/utils.py
@@ -119,3 +119,38 @@ def is_target_arch(arch):
         if target_arch is None:
             target_arch = gdb.execute("show architecture", to_string=True)
         return arch in target_arch
+
+
+GDBSERVER_QEMU = 0
+GDBSERVER_KGDB = 1
+gdbserver_type = None
+
+
+def get_gdbserver_type():
+    def exit_handler(event):
+        global gdbserver_type
+        gdbserver_type = None
+        gdb.events.exited.disconnect(exit_handler)
+
+    def probe_qemu():
+        try:
+            return gdb.execute("monitor info version", to_string=True) != ""
+        except:
+            return False
+
+    def probe_kgdb():
+        try:
+            thread_info = gdb.execute("info thread 2", to_string=True)
+            return "shadowCPU0" in thread_info
+        except:
+            return False
+
+    global gdbserver_type
+    if gdbserver_type is None:
+        if probe_qemu():
+            gdbserver_type = GDBSERVER_QEMU
+        elif probe_kgdb():
+            gdbserver_type = GDBSERVER_KGDB
+        if not gdbserver_type is None and hasattr(gdb, 'events'):
+            gdb.events.exited.connect(exit_handler)
+    return gdbserver_type
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

