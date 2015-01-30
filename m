From: akpm@linux-foundation.org
Subject: + scripts-gdb-convert-modulelist-to-generator-function.patch
 added to -mm tree
Date: Fri, 30 Jan 2015 15:37:05 -0800
Message-ID: <54cc15a1.7HZ16mapzkZmpiR0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763285AbbA3XhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:37:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: convert ModuleList to generator function
has been added to the -mm tree.  Its filename is
     scripts-gdb-convert-modulelist-to-generator-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-convert-modulelist-to-generator-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-convert-modulelist-to-generator-function.patch

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
Subject: scripts/gdb: convert ModuleList to generator function

Analogously to the task list, convert the module list to a generator
function.  It noticeably simplifies the code.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/modules.py |   35 +++++++++++----------------------
 scripts/gdb/linux/symbols.py |    2 -
 2 files changed, 13 insertions(+), 24 deletions(-)

diff -puN scripts/gdb/linux/modules.py~scripts-gdb-convert-modulelist-to-generator-function scripts/gdb/linux/modules.py
--- a/scripts/gdb/linux/modules.py~scripts-gdb-convert-modulelist-to-generator-function
+++ a/scripts/gdb/linux/modules.py
@@ -19,31 +19,20 @@ from linux import cpus, utils
 module_type = utils.CachedType("struct module")
 
 
-class ModuleList:
-    def __init__(self):
-        global module_type
-        self.module_ptr_type = module_type.get_type().pointer()
-        modules = gdb.parse_and_eval("modules")
-        self.curr_entry = modules['next']
-        self.end_of_list = modules.address
-
-    def __iter__(self):
-        return self
-
-    def __next__(self):
-        entry = self.curr_entry
-        if entry != self.end_of_list:
-            self.curr_entry = entry['next']
-            return utils.container_of(entry, self.module_ptr_type, "list")
-        else:
-            raise StopIteration
-
-    def next(self):
-        return self.__next__()
+def module_list():
+    global module_type
+    module_ptr_type = module_type.get_type().pointer()
+    modules = gdb.parse_and_eval("modules")
+    entry = modules['next']
+    end_of_list = modules.address
+
+    while entry != end_of_list:
+        yield utils.container_of(entry, module_ptr_type, "list")
+        entry = entry['next']
 
 
 def find_module_by_name(name):
-    for module in ModuleList():
+    for module in module_list():
         if module['name'].string() == name:
             return module
     return None
@@ -83,7 +72,7 @@ class LxLsmod(gdb.Command):
             "Address{0}    Module                  Size  Used by\n".format(
                 "        " if utils.get_long_type().sizeof == 8 else ""))
 
-        for module in ModuleList():
+        for module in module_list():
             ref = 0
             module_refptr = module['refptr']
             for cpu in cpus.CpuList("cpu_possible_mask"):
diff -puN scripts/gdb/linux/symbols.py~scripts-gdb-convert-modulelist-to-generator-function scripts/gdb/linux/symbols.py
--- a/scripts/gdb/linux/symbols.py~scripts-gdb-convert-modulelist-to-generator-function
+++ a/scripts/gdb/linux/symbols.py
@@ -133,7 +133,7 @@ lx-symbols command."""
         gdb.execute("symbol-file vmlinux")
 
         self.loaded_modules = []
-        module_list = modules.ModuleList()
+        module_list = modules.module_list()
         if not module_list:
             gdb.write("no modules found\n")
         else:
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

