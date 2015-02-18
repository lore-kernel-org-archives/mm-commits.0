From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-convert-cpulist-to-generator-function.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:44 -0800
Message-ID: <54e4ebac.ce/RLAFc5EDIT11c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbbBRTop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: convert CpuList to generator function
has been removed from the -mm tree.  Its filename was
     scripts-gdb-convert-cpulist-to-generator-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
