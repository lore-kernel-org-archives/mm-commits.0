From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-task-iteration-class.patch removed from
 -mm tree
Date: Wed, 18 Feb 2015 11:44:09 -0800
Message-ID: <54e4eb89.Xl3r7U2yVqUwPU4j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbbBRToK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add task iteration class
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-task-iteration-class.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

