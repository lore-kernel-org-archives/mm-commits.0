From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-add-helper-and-convenience-function-to-look-up-tasks.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:11 -0800
Message-ID: <54e4eb8b.58HBvadiv+b9hLfZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbbBRToM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add helper and convenience function to look up tasks
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-helper-and-convenience-function-to-look-up-tasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add helper and convenience function to look up tasks

Add the helper task_by_pid that can look up a task by its PID.  Also
export it as a convenience function.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/tasks.py |   27 +++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 +
 2 files changed, 28 insertions(+)

diff -puN scripts/gdb/linux/tasks.py~scripts-gdb-add-helper-and-convenience-function-to-look-up-tasks scripts/gdb/linux/tasks.py
--- a/scripts/gdb/linux/tasks.py~scripts-gdb-add-helper-and-convenience-function-to-look-up-tasks
+++ a/scripts/gdb/linux/tasks.py
@@ -44,3 +44,30 @@ class TaskList:
                 utils.container_of(t['thread_group']['next'],
                                    self.task_ptr_type, "thread_group")
         return t
+
+
+def get_task_by_pid(pid):
+    for task in TaskList():
+        if int(task['pid']) == pid:
+            return task
+    return None
+
+
+class LxTaskByPidFunc(gdb.Function):
+    """Find Linux task by PID and return the task_struct variable.
+
+$lx_task_by_pid(PID): Given PID, iterate over all tasks of the target and
+return that task_struct variable which PID matches."""
+
+    def __init__(self):
+        super(LxTaskByPidFunc, self).__init__("lx_task_by_pid")
+
+    def invoke(self, pid):
+        task = get_task_by_pid(pid)
+        if task:
+            return task.dereference()
+        else:
+            raise gdb.GdbError("No task of PID " + str(pid))
+
+
+LxTaskByPidFunc()
diff -puN scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-helper-and-convenience-function-to-look-up-tasks scripts/gdb/vmlinux-gdb.py
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-helper-and-convenience-function-to-look-up-tasks
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -26,3 +26,4 @@ else:
     import linux.symbols
     import linux.modules
     import linux.dmesg
+    import linux.tasks
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

