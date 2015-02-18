From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-convert-modulelist-to-generator-function.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:42 -0800
Message-ID: <54e4ebaa.3kE1NWgqATlzsSFg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbbBRTon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: convert ModuleList to generator function
has been removed from the -mm tree.  Its filename was
     scripts-gdb-convert-modulelist-to-generator-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

