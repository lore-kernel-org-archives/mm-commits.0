From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-lx-lsmod-command.patch removed from -mm
 tree
Date: Wed, 18 Feb 2015 11:44:29 -0800
Message-ID: <54e4eb9d.vr/dtTm42aR42hlu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbbBRToa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add lx-lsmod command
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-lx-lsmod-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add lx-lsmod command

This adds a lsmod-like command to list all currently loaded modules of the
target.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/modules.py |   46 ++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff -puN scripts/gdb/linux/modules.py~scripts-gdb-add-lx-lsmod-command scripts/gdb/linux/modules.py
--- a/scripts/gdb/linux/modules.py~scripts-gdb-add-lx-lsmod-command
+++ a/scripts/gdb/linux/modules.py
@@ -13,7 +13,7 @@
 
 import gdb
 
-from linux import utils
+from linux import cpus, utils
 
 
 module_type = utils.CachedType("struct module")
@@ -65,3 +65,47 @@ of the target and return that module var
 
 
 LxModule()
+
+
+class LxLsmod(gdb.Command):
+    """List currently loaded modules."""
+
+    _module_use_type = utils.CachedType("struct module_use")
+
+    def __init__(self):
+        super(LxLsmod, self).__init__("lx-lsmod", gdb.COMMAND_DATA)
+
+    def invoke(self, arg, from_tty):
+        gdb.write(
+            "Address{0}    Module                  Size  Used by\n".format(
+                "        " if utils.get_long_type().sizeof == 8 else ""))
+
+        for module in ModuleList():
+            ref = 0
+            module_refptr = module['refptr']
+            for cpu in cpus.CpuList("cpu_possible_mask"):
+                refptr = cpus.per_cpu(module_refptr, cpu)
+                ref += refptr['incs']
+                ref -= refptr['decs']
+
+            gdb.write("{address} {name:<19} {size:>8}  {ref}".format(
+                address=str(module['module_core']).split()[0],
+                name=module['name'].string(),
+                size=module['core_size'],
+                ref=ref))
+
+            source_list = module['source_list']
+            t = self._module_use_type.get_type().pointer()
+            entry = source_list['next']
+            first = True
+            while entry != source_list.address:
+                use = utils.container_of(entry, t, "source_list")
+                gdb.write("{separator}{name}".format(
+                    separator=" " if first else ",",
+                    name=use['source']['name'].string()))
+                first = False
+                entry = entry['next']
+            gdb.write("\n")
+
+
+LxLsmod()
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

