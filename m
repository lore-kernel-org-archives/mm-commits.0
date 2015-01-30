From: akpm@linux-foundation.org
Subject: + scripts-gdb-convert-cpulist-to-generator-function.patch added
 to -mm tree
Date: Fri, 30 Jan 2015 15:37:07 -0800
Message-ID: <54cc15a3.DohqOlK0Uoa706vM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763283AbbA3XhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:37:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: convert CpuList to generator function
has been added to the -mm tree.  Its filename is
     scripts-gdb-convert-cpulist-to-generator-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-convert-cpulist-to-generator-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-convert-cpulist-to-generator-function.patch

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
Subject: scripts/gdb: convert CpuList to generator function

Yet another code simplification.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py    |   71 ++++++++++++++-------------------
 scripts/gdb/linux/modules.py |    2 
 2 files changed, 33 insertions(+), 40 deletions(-)

diff -puN scripts/gdb/linux/cpus.py~scripts-gdb-convert-cpulist-to-generator-function scripts/gdb/linux/cpus.py
--- a/scripts/gdb/linux/cpus.py~scripts-gdb-convert-cpulist-to-generator-function
+++ a/scripts/gdb/linux/cpus.py
@@ -61,50 +61,43 @@ def cpu_mask_invalidate(event):
         gdb.events.new_objfile.disconnect(cpu_mask_invalidate)
 
 
-class CpuList():
-    def __init__(self, mask_name):
-        global cpu_mask
-        self.mask = None
-        if mask_name in cpu_mask:
-            self.mask = cpu_mask[mask_name]
-        if self.mask is None:
-            self.mask = gdb.parse_and_eval(mask_name + ".bits")
-            if hasattr(gdb, 'events'):
-                cpu_mask[mask_name] = self.mask
-                gdb.events.stop.connect(cpu_mask_invalidate)
-                if hasattr(gdb.events, 'new_objfile'):
-                    gdb.events.new_objfile.connect(cpu_mask_invalidate)
-        self.bits_per_entry = self.mask[0].type.sizeof * 8
-        self.num_entries = self.mask.type.sizeof * 8 / self.bits_per_entry
-        self.entry = -1
-        self.bits = 0
-
-    def __iter__(self):
-        return self
-
-    def __next__(self):
-        while self.bits == 0:
-            self.entry += 1
-            if self.entry == self.num_entries:
-                raise StopIteration
-            self.bits = self.mask[self.entry]
-            if self.bits != 0:
-                self.bit = 0
+def cpu_list(mask_name):
+    global cpu_mask
+    mask = None
+    if mask_name in cpu_mask:
+        mask = cpu_mask[mask_name]
+    if mask is None:
+        mask = gdb.parse_and_eval(mask_name + ".bits")
+        if hasattr(gdb, 'events'):
+            cpu_mask[mask_name] = mask
+            gdb.events.stop.connect(cpu_mask_invalidate)
+            if hasattr(gdb.events, 'new_objfile'):
+                gdb.events.new_objfile.connect(cpu_mask_invalidate)
+    bits_per_entry = mask[0].type.sizeof * 8
+    num_entries = mask.type.sizeof * 8 / bits_per_entry
+    entry = -1
+    bits = 0
+
+    while True:
+        while bits == 0:
+            entry += 1
+            if entry == num_entries:
+                return
+            bits = mask[entry]
+            if bits != 0:
+                bit = 0
                 break
 
-        while self.bits & 1 == 0:
-            self.bits >>= 1
-            self.bit += 1
+        while bits & 1 == 0:
+            bits >>= 1
+            bit += 1
 
-        cpu = self.entry * self.bits_per_entry + self.bit
+        cpu = entry * bits_per_entry + bit
 
-        self.bits >>= 1
-        self.bit += 1
+        bits >>= 1
+        bit += 1
 
-        return cpu
-
-    def next(self):
-        return self.__next__()
+        yield cpu
 
 
 class PerCpu(gdb.Function):
diff -puN scripts/gdb/linux/modules.py~scripts-gdb-convert-cpulist-to-generator-function scripts/gdb/linux/modules.py
--- a/scripts/gdb/linux/modules.py~scripts-gdb-convert-cpulist-to-generator-function
+++ a/scripts/gdb/linux/modules.py
@@ -75,7 +75,7 @@ class LxLsmod(gdb.Command):
         for module in module_list():
             ref = 0
             module_refptr = module['refptr']
-            for cpu in cpus.CpuList("cpu_possible_mask"):
+            for cpu in cpus.cpu_list("cpu_possible_mask"):
                 refptr = cpus.per_cpu(module_refptr, cpu)
                 ref += refptr['incs']
                 ref -= refptr['decs']
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

