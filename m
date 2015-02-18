From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-add-internal-helper-and-convenience-function-to-retrieve-thread_info.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:16 -0800
Message-ID: <54e4eb90.mtWTnkyTY9TgHFTA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbbBRToR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, fenghua.yu@intel.com, jason.wessel@windriver.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add internal helper and convenience function to retrieve thread_info
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-internal-helper-and-convenience-function-to-retrieve-thread_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add internal helper and convenience function to retrieve thread_info

Add the internal helper get_thread_info that calculates the thread_info
from a given task variable.  Also export this service as a convenience
function.

Note: ia64 version is untested.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/tasks.py |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN scripts/gdb/linux/tasks.py~scripts-gdb-add-internal-helper-and-convenience-function-to-retrieve-thread_info scripts/gdb/linux/tasks.py
--- a/scripts/gdb/linux/tasks.py~scripts-gdb-add-internal-helper-and-convenience-function-to-retrieve-thread_info
+++ a/scripts/gdb/linux/tasks.py
@@ -71,3 +71,38 @@ return that task_struct variable which P
 
 
 LxTaskByPidFunc()
+
+
+thread_info_type = utils.CachedType("struct thread_info")
+
+ia64_task_size = None
+
+
+def get_thread_info(task):
+    global thread_info_type
+    thread_info_ptr_type = thread_info_type.get_type().pointer()
+    if utils.is_target_arch("ia64"):
+        global ia64_task_size
+        if ia64_task_size is None:
+            ia64_task_size = gdb.parse_and_eval("sizeof(struct task_struct)")
+        thread_info_addr = task.address + ia64_task_size
+        thread_info = thread_info_addr.cast(thread_info_ptr_type)
+    else:
+        thread_info = task['stack'].cast(thread_info_ptr_type)
+    return thread_info.dereference()
+
+
+class LxThreadInfoFunc (gdb.Function):
+    """Calculate Linux thread_info from task variable.
+
+$lx_thread_info(TASK): Given TASK, return the corresponding thread_info
+variable."""
+
+    def __init__(self):
+        super(LxThreadInfoFunc, self).__init__("lx_thread_info")
+
+    def invoke(self, task):
+        return get_thread_info(task)
+
+
+LxThreadInfoFunc()
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

