From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-convert-modules-usage-to-lists-functions.patch removed from -mm tree
Date: Fri, 27 May 2016 11:44:02 -0700
Message-ID: <57489572.qRRFY0EEKBoynD+9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbcE0SoD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:44:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: convert modules usage to lists functions
has been removed from the -mm tree.  Its filename was
     scripts-gdb-convert-modules-usage-to-lists-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kieran Bingham <kieran.bingham@linaro.org>
Subject: scripts/gdb: convert modules usage to lists functions

Simplify the module list functions with the new list_for_each_entry
abstractions

Link: http://lkml.kernel.org/r/ad0101c9391088608166fcec26af179868973d86.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/modules.py |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff -puN scripts/gdb/linux/modules.py~scripts-gdb-convert-modules-usage-to-lists-functions scripts/gdb/linux/modules.py
--- a/scripts/gdb/linux/modules.py~scripts-gdb-convert-modules-usage-to-lists-functions
+++ a/scripts/gdb/linux/modules.py
@@ -13,7 +13,7 @@
 
 import gdb
 
-from linux import cpus, utils
+from linux import cpus, utils, lists
 
 
 module_type = utils.CachedType("struct module")
@@ -23,12 +23,9 @@ def module_list():
     global module_type
     module_ptr_type = module_type.get_type().pointer()
     modules = gdb.parse_and_eval("modules")
-    entry = modules['next']
-    end_of_list = modules.address
 
-    while entry != end_of_list:
-        yield utils.container_of(entry, module_ptr_type, "list")
-        entry = entry['next']
+    for module in lists.list_for_each_entry(modules, module_ptr_type, "list"):
+        yield module
 
 
 def find_module_by_name(name):
@@ -80,17 +77,15 @@ class LxLsmod(gdb.Command):
                 size=str(layout['size']),
                 ref=str(module['refcnt']['counter'] - 1)))
 
-            source_list = module['source_list']
             t = self._module_use_type.get_type().pointer()
-            entry = source_list['next']
             first = True
-            while entry != source_list.address:
-                use = utils.container_of(entry, t, "source_list")
+            sources = module['source_list']
+            for use in lists.list_for_each_entry(sources, t, "source_list"):
                 gdb.write("{separator}{name}".format(
                     separator=" " if first else ",",
                     name=use['source']['name'].string()))
                 first = False
-                entry = entry['next']
+
             gdb.write("\n")
 
 
_

Patches currently in -mm which might be from kieran.bingham@linaro.org are


