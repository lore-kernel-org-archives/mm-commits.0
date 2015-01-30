From: akpm@linux-foundation.org
Subject: + scripts-gdb-add-task-iteration-class.patch added to -mm tree
Date: Fri, 30 Jan 2015 15:36:39 -0800
Message-ID: <54cc1587.MqK/HFBw0x0Nj/47%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759829AbbA3Xgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:36:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add task iteration class
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-task-iteration-class.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-task-iteration-class.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-task-iteration-class.patch

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
Subject: scripts/gdb: add task iteration class

This class allows to iterate over all tasks of the target.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/tasks.py |   46 +++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff -puN /dev/null scripts/gdb/linux/tasks.py
--- /dev/null
+++ a/scripts/gdb/linux/tasks.py
@@ -0,0 +1,46 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  task & thread tools
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
+from linux import utils
+
+
+task_type = utils.CachedType("struct task_struct")
+
+
+class TaskList:
+    def __init__(self):
+        global task_type
+        self.task_ptr_type = task_type.get_type().pointer()
+        self.init_task = gdb.parse_and_eval("init_task")
+        self.curr_group = self.init_task.address
+        self.curr_task = None
+
+    def __iter__(self):
+        return self
+
+    def next(self):
+        t = self.curr_task
+        if not t or t == self.curr_group:
+            self.curr_group = \
+                utils.container_of(self.curr_group['tasks']['next'],
+                                   self.task_ptr_type, "tasks")
+            if self.curr_group == self.init_task.address:
+                raise StopIteration
+            t = self.curr_task = self.curr_group
+        else:
+            self.curr_task = \
+                utils.container_of(t['thread_group']['next'],
+                                   self.task_ptr_type, "thread_group")
+        return t
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

