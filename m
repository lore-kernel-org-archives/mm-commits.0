From: akpm@linux-foundation.org
Subject: + scripts-gdb-add-get_gdbserver_type-helper.patch added to -mm
 tree
Date: Fri, 30 Jan 2015 15:36:47 -0800
Message-ID: <54cc158f.o1pbUC9FWCI0QSQM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759829AbbA3Xgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:36:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add get_gdbserver_type helper
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-get_gdbserver_type-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-get_gdbserver_type-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-get_gdbserver_type-helper.patch

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

