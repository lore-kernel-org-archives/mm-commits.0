From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-class-to-iterate-over-cpu-masks.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:27 -0800
Message-ID: <54e4eb9b.NiMKdoFXJ2p2SSAM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbbBRTo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add class to iterate over CPU masks
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-class-to-iterate-over-cpu-masks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add class to iterate over CPU masks

Will be used first to count module references.  It is optimized to read
the mask only once per stop.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |   54 ++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff -puN scripts/gdb/linux/cpus.py~scripts-gdb-add-class-to-iterate-over-cpu-masks scripts/gdb/linux/cpus.py
--- a/scripts/gdb/linux/cpus.py~scripts-gdb-add-class-to-iterate-over-cpu-masks
+++ a/scripts/gdb/linux/cpus.py
@@ -50,6 +50,60 @@ def per_cpu(var_ptr, cpu):
     return pointer.cast(var_ptr.type).dereference()
 
 
+cpu_mask = {}
+
+
+def cpu_mask_invalidate(event):
+    global cpu_mask
+    cpu_mask = {}
+    gdb.events.stop.disconnect(cpu_mask_invalidate)
+    if hasattr(gdb.events, 'new_objfile'):
+        gdb.events.new_objfile.disconnect(cpu_mask_invalidate)
+
+
+class CpuList():
+    def __init__(self, mask_name):
+        global cpu_mask
+        self.mask = None
+        if mask_name in cpu_mask:
+            self.mask = cpu_mask[mask_name]
+        if self.mask is None:
+            self.mask = gdb.parse_and_eval(mask_name + ".bits")
+            if hasattr(gdb, 'events'):
+                cpu_mask[mask_name] = self.mask
+                gdb.events.stop.connect(cpu_mask_invalidate)
+                if hasattr(gdb.events, 'new_objfile'):
+                    gdb.events.new_objfile.connect(cpu_mask_invalidate)
+        self.bits_per_entry = self.mask[0].type.sizeof * 8
+        self.num_entries = self.mask.type.sizeof * 8 / self.bits_per_entry
+        self.entry = -1
+        self.bits = 0
+
+    def __iter__(self):
+        return self
+
+    def next(self):
+        while self.bits == 0:
+            self.entry += 1
+            if self.entry == self.num_entries:
+                raise StopIteration
+            self.bits = self.mask[self.entry]
+            if self.bits != 0:
+                self.bit = 0
+                break
+
+        while self.bits & 1 == 0:
+            self.bits >>= 1
+            self.bit += 1
+
+        cpu = self.entry * self.bits_per_entry + self.bit
+
+        self.bits >>= 1
+        self.bit += 1
+
+        return cpu
+
+
 class PerCpu(gdb.Function):
     """Return per-cpu variable.
 
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

