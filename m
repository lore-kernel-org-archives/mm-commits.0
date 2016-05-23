From: akpm@linux-foundation.org
Subject: [patch 59/84] scripts/gdb: add a Radix Tree Parser
Date: Mon, 23 May 2016 16:25:07 -0700
Message-ID: <57439153.VVtcO+gKbsMUohUM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbcEWXZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kieran.bingham@linaro.org, jan.kiszka@siemens.com

From: Kieran Bingham <kieran.bingham@linaro.org>
Subject: scripts/gdb: add a Radix Tree Parser

Linux makes use of the Radix Tree data structure to store pointers indexed
by integer values. This structure is utilised across many structures in
the kernel including the IRQ descriptor tables, and several filesystems.

This module provides a method to lookup values from a structure given
its head node.

Usage:

The function lx_radix_tree_lookup, must be given a symbol of type
struct radix_tree_root, and an index into that tree.

The object returned is a generic integer value, and must be cast
correctly to the type based on the storage in the data structure.

For example, to print the irq descriptor in the sparse irq_desc_tree at
index 18, try the following:

 (gdb) print (struct irq_desc)$lx_radix_tree_lookup(irq_desc_tree, 18)

Link: http://lkml.kernel.org/r/d2028c55e50cf95a9b7f8ca0d11885174b0cc709.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    7 ++
 scripts/gdb/linux/radixtree.py    |   97 ++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py        |    1 
 3 files changed, 105 insertions(+)

diff -puN scripts/gdb/linux/constants.py.in~scripts-gdb-add-a-radix-tree-parser scripts/gdb/linux/constants.py.in
--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-add-a-radix-tree-parser
+++ a/scripts/gdb/linux/constants.py.in
@@ -14,6 +14,7 @@
 
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/radix-tree.h>
 
 /* We need to stringify expanded macros so that they can be parsed */
 
@@ -50,3 +51,9 @@ LX_VALUE(MNT_NOEXEC)
 LX_VALUE(MNT_NOATIME)
 LX_VALUE(MNT_NODIRATIME)
 LX_VALUE(MNT_RELATIME)
+
+/* linux/radix-tree.h */
+LX_VALUE(RADIX_TREE_INDIRECT_PTR)
+LX_GDBPARSED(RADIX_TREE_HEIGHT_MASK)
+LX_GDBPARSED(RADIX_TREE_MAP_SHIFT)
+LX_GDBPARSED(RADIX_TREE_MAP_MASK)
diff -puN /dev/null scripts/gdb/linux/radixtree.py
--- /dev/null
+++ a/scripts/gdb/linux/radixtree.py
@@ -0,0 +1,97 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  Radix Tree Parser
+#
+# Copyright (c) 2016 Linaro Ltd
+#
+# Authors:
+#  Kieran Bingham <kieran.bingham@linaro.org>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import gdb
+
+from linux import utils
+from linux import constants
+
+radix_tree_root_type = utils.CachedType("struct radix_tree_root")
+radix_tree_node_type = utils.CachedType("struct radix_tree_node")
+
+
+def is_indirect_ptr(node):
+    long_type = utils.get_long_type()
+    return (node.cast(long_type) & constants.LX_RADIX_TREE_INDIRECT_PTR)
+
+
+def indirect_to_ptr(node):
+    long_type = utils.get_long_type()
+    node_type = node.type
+    indirect_ptr = node.cast(long_type) & ~constants.LX_RADIX_TREE_INDIRECT_PTR
+    return indirect_ptr.cast(node_type)
+
+
+def maxindex(height):
+    height = height & constants.LX_RADIX_TREE_HEIGHT_MASK
+    return gdb.parse_and_eval("height_to_maxindex["+str(height)+"]")
+
+
+def lookup(root, index):
+    if root.type == radix_tree_root_type.get_type().pointer():
+        root = root.dereference()
+    elif root.type != radix_tree_root_type.get_type():
+        raise gdb.GdbError("Must be struct radix_tree_root not {}"
+                           .format(root.type))
+
+    node = root['rnode']
+    if node is 0:
+        return None
+
+    if not (is_indirect_ptr(node)):
+        if (index > 0):
+            return None
+        return node
+
+    node = indirect_to_ptr(node)
+
+    height = node['path'] & constants.LX_RADIX_TREE_HEIGHT_MASK
+    if (index > maxindex(height)):
+        return None
+
+    shift = (height-1) * constants.LX_RADIX_TREE_MAP_SHIFT
+
+    while True:
+        new_index = (index >> shift) & constants.LX_RADIX_TREE_MAP_MASK
+        slot = node['slots'][new_index]
+
+        node = slot.cast(node.type.pointer()).dereference()
+        if node is 0:
+            return None
+
+        shift -= constants.LX_RADIX_TREE_MAP_SHIFT
+        height -= 1
+
+        if (height <= 0):
+            break
+
+    return node
+
+
+class LxRadixTree(gdb.Function):
+    """ Lookup and return a node from a RadixTree.
+
+$lx_radix_tree_lookup(root_node [, index]): Return the node at the given index.
+If index is omitted, the root node is dereferenced and returned."""
+
+    def __init__(self):
+        super(LxRadixTree, self).__init__("lx_radix_tree_lookup")
+
+    def invoke(self, root, index=0):
+        result = lookup(root, index)
+        if result is None:
+            raise gdb.GdbError("No entry in tree at index {}".format(index))
+
+        return result
+
+LxRadixTree()
diff -puN scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-a-radix-tree-parser scripts/gdb/vmlinux-gdb.py
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-a-radix-tree-parser
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -31,3 +31,4 @@ else:
     import linux.lists
     import linux.proc
     import linux.constants
+    import linux.radixtree
_
