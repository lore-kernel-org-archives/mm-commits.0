From: akpm@linux-foundation.org
Subject: +
 scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module.patch added to -mm tree
Date: Fri, 30 Jan 2015 15:36:31 -0800
Message-ID: <54cc157f./2f8+1XUed24o7gz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbbA3Xgc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:36:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add internal helper and convenience function to look up a module
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module.patch

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

