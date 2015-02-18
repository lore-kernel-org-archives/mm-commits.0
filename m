From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-lx-symbols-command.patch removed from
 -mm tree
Date: Wed, 18 Feb 2015 11:43:55 -0800
Message-ID: <54e4eb7b.DtLWAjliuIyBNePL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbbBRTn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add lx-symbols command
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-lx-symbols-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add lx-symbols command

This is probably the most useful helper when debugging kernel modules:
lx-symbols first reloads vmlinux.  Then it searches recursively for *.ko
files in the specified paths and the current directory.  Finally it walks
the kernel's module list, issuing the necessary add-symbol-file command
for each loaded module so that gdb knows which module symbol corresponds
to which address.  It also looks up variable sections (bss, data, rodata)
and appends their address to the add-symbole-file command line.  This
allows to access global module variables just like any other variable.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |  127 +++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py   |    1 
 2 files changed, 128 insertions(+)

diff -puN /dev/null scripts/gdb/linux/symbols.py
--- /dev/null
+++ a/scripts/gdb/linux/symbols.py
@@ -0,0 +1,127 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  load kernel and module symbols
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
+import os
+import re
+import string
+
+from linux import modules, utils
+
+
+class LxSymbols(gdb.Command):
+    """(Re-)load symbols of Linux kernel and currently loaded modules.
+
+The kernel (vmlinux) is taken from the current working directly. Modules (.ko)
+are scanned recursively, starting in the same directory. Optionally, the module
+search path can be extended by a space separated list of paths passed to the
+lx-symbols command."""
+
+    module_paths = []
+    module_files = []
+    module_files_updated = False
+
+    def __init__(self):
+        super(LxSymbols, self).__init__("lx-symbols", gdb.COMMAND_FILES,
+                                        gdb.COMPLETE_FILENAME)
+
+    def _update_module_files(self):
+        self.module_files = []
+        for path in self.module_paths:
+            gdb.write("scanning for modules in {0}\n".format(path))
+            for root, dirs, files in os.walk(path):
+                for name in files:
+                    if name.endswith(".ko"):
+                        self.module_files.append(root + "/" + name)
+        self.module_files_updated = True
+
+    def _get_module_file(self, module_name):
+        module_pattern = ".*/{0}\.ko$".format(
+            string.replace(module_name, "_", r"[_\-]"))
+        for name in self.module_files:
+            if re.match(module_pattern, name) and os.path.exists(name):
+                return name
+        return None
+
+    def _section_arguments(self, module):
+        try:
+            sect_attrs = module['sect_attrs'].dereference()
+        except gdb.error:
+            return ""
+        attrs = sect_attrs['attrs']
+        section_name_to_address = {
+            attrs[n]['name'].string() : attrs[n]['address']
+            for n in range(sect_attrs['nsections'])}
+        args = []
+        for section_name in [".data", ".data..read_mostly", ".rodata", ".bss"]:
+            address = section_name_to_address.get(section_name)
+            if address:
+                args.append(" -s {name} {addr}".format(
+                    name=section_name, addr=str(address)))
+        return "".join(args)
+
+    def load_module_symbols(self, module):
+        module_name = module['name'].string()
+        module_addr = str(module['module_core']).split()[0]
+
+        module_file = self._get_module_file(module_name)
+        if not module_file and not self.module_files_updated:
+            self._update_module_files()
+            module_file = self._get_module_file(module_name)
+
+        if module_file:
+            gdb.write("loading @{addr}: {filename}\n".format(
+                addr=module_addr, filename=module_file))
+            cmdline = "add-symbol-file {filename} {addr}{sections}".format(
+                filename=module_file,
+                addr=module_addr,
+                sections=self._section_arguments(module))
+            gdb.execute(cmdline, to_string=True)
+        else:
+            gdb.write("no module object found for '{0}'\n".format(module_name))
+
+    def load_all_symbols(self):
+        gdb.write("loading vmlinux\n")
+
+        # Dropping symbols will disable all breakpoints. So save their states
+        # and restore them afterward.
+        saved_states = []
+        if hasattr(gdb, 'breakpoints') and not gdb.breakpoints() is None:
+            for bp in gdb.breakpoints():
+                saved_states.append({'breakpoint': bp, 'enabled': bp.enabled})
+
+        # drop all current symbols and reload vmlinux
+        gdb.execute("symbol-file", to_string=True)
+        gdb.execute("symbol-file vmlinux")
+
+        module_list = modules.ModuleList()
+        if not module_list:
+            gdb.write("no modules found\n")
+        else:
+            [self.load_module_symbols(module) for module in module_list]
+
+        for saved_state in saved_states:
+            saved_state['breakpoint'].enabled = saved_state['enabled']
+
+    def invoke(self, arg, from_tty):
+        self.module_paths = arg.split()
+        self.module_paths.append(os.getcwd())
+
+        # enforce update
+        self.module_files = []
+        self.module_files_updated = False
+
+        self.load_all_symbols()
+
+
+LxSymbols()
diff -puN scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-lx-symbols-command scripts/gdb/vmlinux-gdb.py
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-lx-symbols-command
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -23,3 +23,4 @@ except:
               "work.\n")
 else:
     import linux.utils
+    import linux.symbols
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

