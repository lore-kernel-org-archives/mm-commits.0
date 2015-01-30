From: akpm@linux-foundation.org
Subject: +
 scripts-gdb-add-internal-helper-and-convenience-function-to-retrieve-thread_info.patch added to -mm tree
Date: Fri, 30 Jan 2015 15:36:45 -0800
Message-ID: <54cc158d.ScOuOEuaa/nXyzZQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759829AbbA3Xgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:36:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, fenghua.yu@intel.com, jason.wessel@windriver.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add internal helper and convenience function to retrieve thread_info
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-internal-helper-and-convenience-function-to-retrieve-thread_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-internal-helper-and-convenience-function-to-retrieve-thread_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-internal-helper-and-convenience-function-to-retrieve-thread_info.patch

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

