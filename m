From: akpm@linux-foundation.org
Subject: + revert-scripts-gdb-add-a-radix-tree-parser.patch added to -mm
 tree
Date: Mon, 11 Jul 2016 12:51:53 -0700
Message-ID: <5783f8d9.tHUmaGziDgfOf0g5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbcGKTvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 15:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran@ksquared.org.ukkieran@ksquared.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "scripts/gdb: add a Radix Tree Parser"
has been added to the -mm tree.  Its filename is
     revert-scripts-gdb-add-a-radix-tree-parser.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-scripts-gdb-add-a-radix-tree-parser.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-scripts-gdb-add-a-radix-tree-parser.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kieran Bingham <kieran@ksquared.org.uk>
Subject: Revert "scripts/gdb: add a Radix Tree Parser"

This reverts commit e127a73d41ac ("scripts/gdb: add a Radix Tree Parser")

The python implementation of radix-tree was merged at the same time as the
radix-tree system was heavily reworked from commit e9256efcc8e3
("radix-tree: introduce radix_tree_empty") to 3bcadd6fa6c4 ("radix-tree:
free up the bottom bit of exceptional entries for reuse") and no longer
functions, but also prevents other gdb scripts from loading.

This functionality has not yet hit a release, so simply remove it for now

Link: http://lkml.kernel.org/r/1467127337-11135-6-git-send-email-kieran@bingham.xyz
Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    7 --
 scripts/gdb/linux/radixtree.py    |   97 ----------------------------
 scripts/gdb/vmlinux-gdb.py        |    1 
 3 files changed, 105 deletions(-)

diff -puN scripts/gdb/linux/constants.py.in~revert-scripts-gdb-add-a-radix-tree-parser scripts/gdb/linux/constants.py.in
--- a/scripts/gdb/linux/constants.py.in~revert-scripts-gdb-add-a-radix-tree-parser
+++ a/scripts/gdb/linux/constants.py.in
@@ -14,7 +14,6 @@
 
 #include <linux/fs.h>
 #include <linux/mount.h>
-#include <linux/radix-tree.h>
 
 /* We need to stringify expanded macros so that they can be parsed */
 
@@ -51,9 +50,3 @@ LX_VALUE(MNT_NOEXEC)
 LX_VALUE(MNT_NOATIME)
 LX_VALUE(MNT_NODIRATIME)
 LX_VALUE(MNT_RELATIME)
-
-/* linux/radix-tree.h */
-LX_VALUE(RADIX_TREE_INDIRECT_PTR)
-LX_GDBPARSED(RADIX_TREE_HEIGHT_MASK)
-LX_GDBPARSED(RADIX_TREE_MAP_SHIFT)
-LX_GDBPARSED(RADIX_TREE_MAP_MASK)
diff -puN scripts/gdb/linux/radixtree.py~revert-scripts-gdb-add-a-radix-tree-parser /dev/null
--- a/scripts/gdb/linux/radixtree.py
+++ /dev/null
@@ -1,97 +0,0 @@
-#
-# gdb helper commands and functions for Linux kernel debugging
-#
-#  Radix Tree Parser
-#
-# Copyright (c) 2016 Linaro Ltd
-#
-# Authors:
-#  Kieran Bingham <kieran.bingham@linaro.org>
-#
-# This work is licensed under the terms of the GNU GPL version 2.
-#
-
-import gdb
-
-from linux import utils
-from linux import constants
-
-radix_tree_root_type = utils.CachedType("struct radix_tree_root")
-radix_tree_node_type = utils.CachedType("struct radix_tree_node")
-
-
-def is_indirect_ptr(node):
-    long_type = utils.get_long_type()
-    return (node.cast(long_type) & constants.LX_RADIX_TREE_INDIRECT_PTR)
-
-
-def indirect_to_ptr(node):
-    long_type = utils.get_long_type()
-    node_type = node.type
-    indirect_ptr = node.cast(long_type) & ~constants.LX_RADIX_TREE_INDIRECT_PTR
-    return indirect_ptr.cast(node_type)
-
-
-def maxindex(height):
-    height = height & constants.LX_RADIX_TREE_HEIGHT_MASK
-    return gdb.parse_and_eval("height_to_maxindex["+str(height)+"]")
-
-
-def lookup(root, index):
-    if root.type == radix_tree_root_type.get_type().pointer():
-        root = root.dereference()
-    elif root.type != radix_tree_root_type.get_type():
-        raise gdb.GdbError("Must be struct radix_tree_root not {}"
-                           .format(root.type))
-
-    node = root['rnode']
-    if node is 0:
-        return None
-
-    if not (is_indirect_ptr(node)):
-        if (index > 0):
-            return None
-        return node
-
-    node = indirect_to_ptr(node)
-
-    height = node['path'] & constants.LX_RADIX_TREE_HEIGHT_MASK
-    if (index > maxindex(height)):
-        return None
-
-    shift = (height-1) * constants.LX_RADIX_TREE_MAP_SHIFT
-
-    while True:
-        new_index = (index >> shift) & constants.LX_RADIX_TREE_MAP_MASK
-        slot = node['slots'][new_index]
-
-        node = slot.cast(node.type.pointer()).dereference()
-        if node is 0:
-            return None
-
-        shift -= constants.LX_RADIX_TREE_MAP_SHIFT
-        height -= 1
-
-        if (height <= 0):
-            break
-
-    return node
-
-
-class LxRadixTree(gdb.Function):
-    """ Lookup and return a node from a RadixTree.
-
-$lx_radix_tree_lookup(root_node [, index]): Return the node at the given index.
-If index is omitted, the root node is dereferenced and returned."""
-
-    def __init__(self):
-        super(LxRadixTree, self).__init__("lx_radix_tree_lookup")
-
-    def invoke(self, root, index=0):
-        result = lookup(root, index)
-        if result is None:
-            raise gdb.GdbError("No entry in tree at index {}".format(index))
-
-        return result
