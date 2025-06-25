Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874934204E;
	Wed, 25 Jun 2025 21:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750886613; cv=none; b=c83F4lrWItcG1BQcSo2bbv2NMH0hx950hC/Vp9TJvfWmJ5RyECcvr7Hsqgr7vEFr1zniol9fDHKfKSjjttLCTSZXyiJwA0zhbJ6Fw7zFO8rsoQH84Z9i1XgWpvUE+aCwTJrUaegSUoMg0L6m1ub2KRIhVgq+zwXoO4UN67YLfLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750886613; c=relaxed/simple;
	bh=+aaVODyFRxiNAinyW918MpkifFSTASvLDdyv7jW/DZM=;
	h=Date:To:From:Subject:Message-Id; b=eWmPGYe2Y+GfDGvKq2N9wlB3Geb2oET9IRIL2hI0AIZl3WNPCKrV3z56h2xNijJPew5GrFfHAycjM7Hp2cwM2x0tRxz/gmtvg9j6psTDw09h3c8w8aXxKLaqqsIMjyZkGjjsa6TkRD3gecVlYP1Nm/CbfecHRMMZ6MQFJAIxC74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lBTGyGpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lBTGyGpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA9BC4CEEA;
	Wed, 25 Jun 2025 21:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750886613;
	bh=+aaVODyFRxiNAinyW918MpkifFSTASvLDdyv7jW/DZM=;
	h=Date:To:From:Subject:From;
	b=lBTGyGpyQLxKIw7hM6GYN11ucWv+/OcDq8Obupx47NI7jgMvLXw2VVEsKzbCVdSXP
	 z3CykTb0OtQIgg55vkEBJgVzTC3viuMmVs/TyLnJKz8B0LhiXtnmG7QCEETzucY2Jp
	 rU6qPFXq0O4hzIf45eb5otsl/Mvp7huNTJWlrfw4=
Date: Wed, 25 Jun 2025 14:23:32 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,sdonthineni@nvidia.com,kbingham@kernel.org,jan.kiszka@siemens.com,florian.fainelli@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-interruptspy-after-maple-tree-conversion.patch added to mm-hotfixes-unstable branch
Message-Id: <20250625212332.DAA9BC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: fix interrupts.py after maple tree conversion
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-fix-interruptspy-after-maple-tree-conversion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-interruptspy-after-maple-tree-conversion.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Florian Fainelli <florian.fainelli@broadcom.com>
Subject: scripts/gdb: fix interrupts.py after maple tree conversion
Date: Tue, 24 Jun 2025 19:10:20 -0700

In commit 721255b9826b ("genirq: Use a maple tree for interrupt descriptor
management"), the irq_desc_tree was replaced with a sparse_irqs tree using
a maple tree structure.  Since the script looked for the irq_desc_tree
symbol which is no longer available, no interrupts would be printed and
the script output would not be useful anymore.

In addition to looking up the correct symbol (sparse_irqs), a new module
(mapletree.py) is added whose mtree_load() implementation is largely
copied after the C version and uses the same variable and intermediate
function names wherever possible to ensure that both the C and Python
version be updated in the future.

This restores the scripts' output to match that of /proc/interrupts.

Link: https://lkml.kernel.org/r/20250625021020.1056930-1-florian.fainelli@broadcom.com
Fixes: 721255b9826b ("genirq: Use a maple tree for interrupt descriptor management")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Shanker Donthineni <sdonthineni@nvidia.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    7 
 scripts/gdb/linux/interrupts.py   |   12 -
 scripts/gdb/linux/mapletree.py    |  252 ++++++++++++++++++++++++++++
 scripts/gdb/linux/xarray.py       |   28 +++
 4 files changed, 293 insertions(+), 6 deletions(-)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-fix-interruptspy-after-maple-tree-conversion
+++ a/scripts/gdb/linux/constants.py.in
@@ -20,6 +20,7 @@
 #include <linux/of_fdt.h>
 #include <linux/page_ext.h>
 #include <linux/radix-tree.h>
+#include <linux/maple_tree.h>
 #include <linux/slab.h>
 #include <linux/threads.h>
 #include <linux/vmalloc.h>
@@ -93,6 +94,12 @@ LX_GDBPARSED(RADIX_TREE_MAP_SIZE)
 LX_GDBPARSED(RADIX_TREE_MAP_SHIFT)
 LX_GDBPARSED(RADIX_TREE_MAP_MASK)
 
+/* linux/maple_tree.h */
+LX_VALUE(MAPLE_NODE_SLOTS)
+LX_VALUE(MAPLE_RANGE64_SLOTS)
+LX_VALUE(MAPLE_ARANGE64_SLOTS)
+LX_GDBPARSED(MAPLE_NODE_MASK)
+
 /* linux/vmalloc.h */
 LX_VALUE(VM_IOREMAP)
 LX_VALUE(VM_ALLOC)
--- a/scripts/gdb/linux/interrupts.py~scripts-gdb-fix-interruptspy-after-maple-tree-conversion
+++ a/scripts/gdb/linux/interrupts.py
@@ -7,7 +7,7 @@ import gdb
 from linux import constants
 from linux import cpus
 from linux import utils
-from linux import radixtree
+from linux import mapletree
 
 irq_desc_type = utils.CachedType("struct irq_desc")
 
@@ -23,12 +23,12 @@ def irqd_is_level(desc):
 def show_irq_desc(prec, irq):
     text = ""
 
-    desc = radixtree.lookup(gdb.parse_and_eval("&irq_desc_tree"), irq)
+    desc = mapletree.mtree_load(gdb.parse_and_eval("&sparse_irqs"), irq)
     if desc is None:
         return text
 
-    desc = desc.cast(irq_desc_type.get_type())
-    if desc is None:
+    desc = desc.cast(irq_desc_type.get_type().pointer())
+    if desc == 0:
         return text
 
     if irq_settings_is_hidden(desc):
@@ -221,8 +221,8 @@ class LxInterruptList(gdb.Command):
             gdb.write("CPU%-8d" % cpu)
         gdb.write("\n")
 
-        if utils.gdb_eval_or_none("&irq_desc_tree") is None:
-            return
+        if utils.gdb_eval_or_none("&sparse_irqs") is None:
+            raise gdb.GdbError("Unable to find the sparse IRQ tree, is CONFIG_SPARSE_IRQ enabled?")
 
         for irq in range(nr_irqs):
             gdb.write(show_irq_desc(prec, irq))
diff --git a/scripts/gdb/linux/mapletree.py a/scripts/gdb/linux/mapletree.py
new file mode 100644
--- /dev/null
+++ a/scripts/gdb/linux/mapletree.py
@@ -0,0 +1,252 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+#  Maple tree helpers
+#
+# Copyright (c) 2025 Broadcom
+#
+# Authors:
+#  Florian Fainelli <florian.fainelli@broadcom.com>
+
+import gdb
+
+from linux import utils
+from linux import constants
+from linux import xarray
+
+maple_tree_root_type = utils.CachedType("struct maple_tree")
+maple_node_type = utils.CachedType("struct maple_node")
+maple_enode_type = utils.CachedType("void")
+
+maple_dense = 0
+maple_leaf_64 = 1
+maple_range_64 = 2
+maple_arange_64 = 3
+
+class Mas(object):
+    ma_active = 0
+    ma_start = 1
+    ma_root = 2
+    ma_none = 3
+    ma_pause = 4
+    ma_overflow = 5
+    ma_underflow = 6
+    ma_error = 7
+
+    def __init__(self, mt, first, end):
+        if mt.type == maple_tree_root_type.get_type().pointer():
+            self.tree = mt.dereference()
+        elif mt.type != maple_tree_root_type.get_type():
+            raise gdb.GdbError("must be {} not {}"
+                               .format(maple_tree_root_type.get_type().pointer(), mt.type))
+        self.tree = mt
+        self.index = first
+        self.last = end
+        self.node = None
+        self.status = self.ma_start
+        self.min = 0
+        self.max = -1
+
+    def is_start(self):
+        # mas_is_start()
+        return self.status == self.ma_start
+
+    def is_ptr(self):
+        # mas_is_ptr()
+        return self.status == self.ma_root
+
+    def is_none(self):
+        # mas_is_none()
+        return self.status == self.ma_none
+
+    def root(self):
+        # mas_root()
+        return self.tree['ma_root'].cast(maple_enode_type.get_type().pointer())
+
+    def start(self):
+        # mas_start()
+        if self.is_start() is False:
+            return None
+
+        self.min = 0
+        self.max = ~0
+
+        while True:
+            self.depth = 0
+            root = self.root()
+            if xarray.xa_is_node(root):
+                self.depth = 0
+                self.status = self.ma_active
+                self.node = mte_safe_root(root)
+                self.offset = 0
+                if mte_dead_node(self.node) is True:
+                    continue
+
+                return None
+
+            self.node = None
+            # Empty tree
+            if root is None:
+                self.status = self.ma_none
+                self.offset = constants.LX_MAPLE_NODE_SLOTS
+                return None
+
+            # Single entry tree
+            self.status = self.ma_root
+            self.offset = constants.LX_MAPLE_NODE_SLOTS
+
+            if self.index != 0:
+                return None
+
+            return root
+
+        return None
+
+    def reset(self):
+        # mas_reset()
+        self.status = self.ma_start
+        self.node = None
+
+def mte_safe_root(node):
+    if node.type != maple_enode_type.get_type().pointer():
+        raise gdb.GdbError("{} must be {} not {}"
+                           .format(mte_safe_root.__name__, maple_enode_type.get_type().pointer(), node.type))
+    ulong_type = utils.get_ulong_type()
+    indirect_ptr = node.cast(ulong_type) & ~0x2
+    val = indirect_ptr.cast(maple_enode_type.get_type().pointer())
+    return val
+
+def mte_node_type(entry):
+    ulong_type = utils.get_ulong_type()
+    val = None
+    if entry.type == maple_enode_type.get_type().pointer():
+        val = entry.cast(ulong_type)
+    elif entry.type == ulong_type:
+        val = entry
+    else:
+        raise gdb.GdbError("{} must be {} not {}"
+                           .format(mte_node_type.__name__, maple_enode_type.get_type().pointer(), entry.type))
+    return (val >> 0x3) & 0xf
+
+def ma_dead_node(node):
+    if node.type != maple_node_type.get_type().pointer():
+        raise gdb.GdbError("{} must be {} not {}"
+                           .format(ma_dead_node.__name__, maple_node_type.get_type().pointer(), node.type))
+    ulong_type = utils.get_ulong_type()
+    parent = node['parent']
+    indirect_ptr = node['parent'].cast(ulong_type) & ~constants.LX_MAPLE_NODE_MASK
+    return indirect_ptr == node
+
+def mte_to_node(enode):
+    ulong_type = utils.get_ulong_type()
+    if enode.type == maple_enode_type.get_type().pointer():
+        indirect_ptr = enode.cast(ulong_type)
+    elif enode.type == ulong_type:
+        indirect_ptr = enode
+    else:
+        raise gdb.GdbError("{} must be {} not {}"
+                           .format(mte_to_node.__name__, maple_enode_type.get_type().pointer(), enode.type))
+    indirect_ptr = indirect_ptr & ~constants.LX_MAPLE_NODE_MASK
+    return indirect_ptr.cast(maple_node_type.get_type().pointer())
+
+def mte_dead_node(enode):
+    if enode.type != maple_enode_type.get_type().pointer():
+        raise gdb.GdbError("{} must be {} not {}"
+                           .format(mte_dead_node.__name__, maple_enode_type.get_type().pointer(), enode.type))
+    node = mte_to_node(enode)
+    return ma_dead_node(node)
+
+def ma_is_leaf(tp):
+    result = tp < maple_range_64
+    return tp < maple_range_64
+
+def mt_pivots(t):
+    if t == maple_dense:
+        return 0
+    elif t == maple_leaf_64 or t == maple_range_64:
+        return constants.LX_MAPLE_RANGE64_SLOTS - 1
+    elif t == maple_arange_64:
+        return constants.LX_MAPLE_ARANGE64_SLOTS - 1
+
+def ma_pivots(node, t):
+    if node.type != maple_node_type.get_type().pointer():
+        raise gdb.GdbError("{}: must be {} not {}"
+                           .format(ma_pivots.__name__, maple_node_type.get_type().pointer(), node.type))
+    if t == maple_arange_64:
+        return node['ma64']['pivot']
+    elif t == maple_leaf_64 or t == maple_range_64:
+        return node['mr64']['pivot']
+    else:
+        return None
+
+def ma_slots(node, tp):
+    if node.type != maple_node_type.get_type().pointer():
+        raise gdb.GdbError("{}: must be {} not {}"
+                           .format(ma_slots.__name__, maple_node_type.get_type().pointer(), node.type))
+    if tp == maple_arange_64:
+        return node['ma64']['slot']
+    elif tp == maple_range_64 or tp == maple_leaf_64:
+        return node['mr64']['slot']
+    elif tp == maple_dense:
+        return node['slot']
+    else:
+        return None
+
+def mt_slot(mt, slots, offset):
+    ulong_type = utils.get_ulong_type()
+    return slots[offset].cast(ulong_type)
+
+def mtree_lookup_walk(mas):
+    ulong_type = utils.get_ulong_type()
+    n = mas.node
+
+    while True:
+        node = mte_to_node(n)
+        tp = mte_node_type(n)
+        pivots = ma_pivots(node, tp)
+        end = mt_pivots(tp)
+        offset = 0
+        while True:
+            if pivots[offset] >= mas.index:
+                break
+            if offset >= end:
+                break
+            offset += 1
+
+        slots = ma_slots(node, tp)
+        n = mt_slot(mas.tree, slots, offset)
+        if ma_dead_node(node) is True:
+            mas.reset()
+            return None
+            break
+
+        if ma_is_leaf(tp) is True:
+            break
+
+    return n
+
+def mtree_load(mt, index):
+    ulong_type = utils.get_ulong_type()
+    # MT_STATE(...)
+    mas = Mas(mt, index, index)
+    entry = None
+
+    while True:
+        entry = mas.start()
+        if mas.is_none():
+            return None
+
+        if mas.is_ptr():
+            if index != 0:
+                entry = None
+            return entry
+
+        entry = mtree_lookup_walk(mas)
+        if entry is None and mas.is_start():
+            continue
+        else:
+            break
+
+    if xarray.xa_is_zero(entry):
+        return None
+
+    return entry
diff --git a/scripts/gdb/linux/xarray.py a/scripts/gdb/linux/xarray.py
new file mode 100644
--- /dev/null
+++ a/scripts/gdb/linux/xarray.py
@@ -0,0 +1,28 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+#  Xarray helpers
+#
+# Copyright (c) 2025 Broadcom
+#
+# Authors:
+#  Florian Fainelli <florian.fainelli@broadcom.com>
+
+import gdb
+
+from linux import utils
+from linux import constants
+
+def xa_is_internal(entry):
+    ulong_type = utils.get_ulong_type()
+    return ((entry.cast(ulong_type) & 3) == 2)
+
+def xa_mk_internal(v):
+    return ((v << 2) | 2)
+
+def xa_is_zero(entry):
+    ulong_type = utils.get_ulong_type()
+    return entry.cast(ulong_type) == xa_mk_internal(257)
+
+def xa_is_node(entry):
+    ulong_type = utils.get_ulong_type()
+    return xa_is_internal(entry) and (entry.cast(ulong_type) > 4096)
_

Patches currently in -mm which might be from florian.fainelli@broadcom.com are

scripts-gdb-fix-dentry_name-lookup.patch
scripts-gdb-fix-interrupts-display-after-mcp-on-x86.patch
scripts-gdb-fix-interruptspy-after-maple-tree-conversion.patch
scripts-gdb-de-reference-per-cpu-mce-interrupts.patch

