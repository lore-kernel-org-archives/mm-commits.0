From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-use-a-generator-instead-of-iterator-for-task-list.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:39 -0800
Message-ID: <54e4eba7.V7Bok8T4SG3hzEdd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbbBRTok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.wagner@bmw-carit.de, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jan.kiszka@siemens.com, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: use a generator instead of iterator for task list
has been removed from the -mm tree.  Its filename was
     scripts-gdb-use-a-generator-instead-of-iterator-for-task-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: scripts/gdb: use a generator instead of iterator for task list

The iterator does not return any task_struct from the thread_group list
because the first condition in the 'if not t or ...' will only be the
first time None.

Instead of keeping track of the state ourself in the next() function, we
fall back using Python's generator.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/tasks.py |   50 ++++++++++++++---------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff -puN scripts/gdb/linux/tasks.py~scripts-gdb-use-a-generator-instead-of-iterator-for-task-list scripts/gdb/linux/tasks.py
--- a/scripts/gdb/linux/tasks.py~scripts-gdb-use-a-generator-instead-of-iterator-for-task-list
+++ a/scripts/gdb/linux/tasks.py
@@ -18,38 +18,28 @@ from linux import utils
 
 task_type = utils.CachedType("struct task_struct")
 
-
-class TaskList:
-    def __init__(self):
-        global task_type
-        self.task_ptr_type = task_type.get_type().pointer()
-        self.init_task = gdb.parse_and_eval("init_task")
-        self.curr_group = self.init_task.address
-        self.curr_task = None
-
-    def __iter__(self):
-        return self
-
-    def __next__(self):
-        t = self.curr_task
-        if not t or t == self.curr_group:
-            self.curr_group = \
-                utils.container_of(self.curr_group['tasks']['next'],
-                                   self.task_ptr_type, "tasks")
-            if self.curr_group == self.init_task.address:
-                raise StopIteration
-            t = self.curr_task = self.curr_group
-        else:
-            self.curr_task = \
-                utils.container_of(t['thread_group']['next'],
-                                   self.task_ptr_type, "thread_group")
-        return t
-
-    def next(self):
-        return self.__next__()
+def task_lists():
+    global task_type
+    task_ptr_type = task_type.get_type().pointer()
+    init_task = gdb.parse_and_eval("init_task").address
+    t = g = init_task
+
+    while True:
+        while True:
+            yield t
+
+            t = utils.container_of(t['thread_group']['next'],
+                                   task_ptr_type, "thread_group")
+            if t == g:
+                break
+
+        t = g = utils.container_of(g['tasks']['next'],
+                                   task_ptr_type, "tasks")
+        if t == init_task:
+            return
 
 def get_task_by_pid(pid):
-    for task in TaskList():
+    for task in task_lists():
         if int(task['pid']) == pid:
             return task
     return None
_

Patches currently in -mm which might be from daniel.wagner@bmw-carit.de are

origin.patch

