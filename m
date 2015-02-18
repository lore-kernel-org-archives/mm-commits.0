From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:01 -0800
Message-ID: <54e4eb81.ZzicBP8Z1nfvs4SJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbBRToC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add internal helper and convenience function to look up a module
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add internal helper and convenience function to look up a module

Add the internal helper get_module_by_name to obtain the module structure
corresponding to the given name.  Also export this service as a
convenience function.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/modules.py |   28 ++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py   |    1 +
 2 files changed, 29 insertions(+)

diff -puN scripts/gdb/linux/modules.py~scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module scripts/gdb/linux/modules.py
--- a/scripts/gdb/linux/modules.py~scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module
+++ a/scripts/gdb/linux/modules.py
@@ -37,3 +37,31 @@ class ModuleList:
             return utils.container_of(entry, self.module_ptr_type, "list")
         else:
             raise StopIteration
+
+
+def find_module_by_name(name):
+    for module in ModuleList():
+        if module['name'].string() == name:
+            return module
+    return None
+
+
+class LxModule(gdb.Function):
+    """Find module by name and return the module variable.
+
+$lx_module("MODULE"): Given the name MODULE, iterate over all loaded modules
+of the target and return that module variable which MODULE matches."""
+
+    def __init__(self):
+        super(LxModule, self).__init__("lx_module")
+
+    def invoke(self, mod_name):
+        mod_name = mod_name.string()
+        module = find_module_by_name(mod_name)
+        if module:
+            return module.dereference()
+        else:
+            raise gdb.GdbError("Unable to find MODULE " + mod_name)
+
+
+LxModule()
diff -puN scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module scripts/gdb/vmlinux-gdb.py
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -24,3 +24,4 @@ except:
 else:
     import linux.utils
     import linux.symbols
+    import linux.modules
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

