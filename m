From: akpm@linux-foundation.org
Subject: +
 scripts-gdb-add-automatic-symbol-reloading-on-module-insertion.patch added
 to -mm tree
Date: Fri, 30 Jan 2015 15:36:29 -0800
Message-ID: <54cc157d.80BMOjt/wYFZipOL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbbA3Xga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:36:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add automatic symbol reloading on module insertion
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-automatic-symbol-reloading-on-module-insertion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-automatic-symbol-reloading-on-module-insertion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-automatic-symbol-reloading-on-module-insertion.patch

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
Subject: scripts/gdb: add automatic symbol reloading on module insertion

This installs a silent breakpoint on the do_init_module function.  The
breakpoint handler will try to load symbols from the module files found
during lx-symbols execution.  This way, breakpoints can be set to module
initialization functions, and there is no need to explicitly call
lx-symbols after (re-)loading a module.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |   39 +++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff -puN scripts/gdb/linux/symbols.py~scripts-gdb-add-automatic-symbol-reloading-on-module-insertion scripts/gdb/linux/symbols.py
--- a/scripts/gdb/linux/symbols.py~scripts-gdb-add-automatic-symbol-reloading-on-module-insertion
+++ a/scripts/gdb/linux/symbols.py
@@ -19,6 +19,30 @@ import string
 from linux import modules, utils
 
 
+if hasattr(gdb, 'Breakpoint'):
+    class LoadModuleBreakpoint(gdb.Breakpoint):
+        def __init__(self, spec, gdb_command):
+            super(LoadModuleBreakpoint, self).__init__(spec, internal=True)
+            self.silent = True
+            self.gdb_command = gdb_command
+
+        def stop(self):
+            module = gdb.parse_and_eval("mod")
+            module_name = module['name'].string()
+            cmd = self.gdb_command
+
+            # enforce update if object file is not found
+            cmd.module_files_updated = False
+
+            if module_name in cmd.loaded_modules:
+                gdb.write("refreshing all symbols to reload module "
+                          "'{0}'\n".format(module_name))
+                cmd.load_all_symbols()
+            else:
+                cmd.load_module_symbols(module)
+            return False
+
+
 class LxSymbols(gdb.Command):
     """(Re-)load symbols of Linux kernel and currently loaded modules.
 
@@ -30,6 +54,8 @@ lx-symbols command."""
     module_paths = []
     module_files = []
     module_files_updated = False
+    loaded_modules = []
+    breakpoint = None
 
     def __init__(self):
         super(LxSymbols, self).__init__("lx-symbols", gdb.COMMAND_FILES,
@@ -87,6 +113,8 @@ lx-symbols command."""
                 addr=module_addr,
                 sections=self._section_arguments(module))
             gdb.execute(cmdline, to_string=True)
+            if not module_name in self.loaded_modules:
+                self.loaded_modules.append(module_name)
         else:
             gdb.write("no module object found for '{0}'\n".format(module_name))
 
@@ -104,6 +132,7 @@ lx-symbols command."""
         gdb.execute("symbol-file", to_string=True)
         gdb.execute("symbol-file vmlinux")
 
+        self.loaded_modules = []
         module_list = modules.ModuleList()
         if not module_list:
             gdb.write("no modules found\n")
@@ -123,5 +152,15 @@ lx-symbols command."""
 
         self.load_all_symbols()
 
+        if hasattr(gdb, 'Breakpoint'):
+            if not self.breakpoint is None:
+                self.breakpoint.delete()
+                self.breakpoint = None
+            self.breakpoint = LoadModuleBreakpoint(
+                "kernel/module.c:do_init_module", self)
+        else:
+            gdb.write("Note: symbol update on module loading not supported "
+                      "with this gdb version\n")
+
 
 LxSymbols()
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

