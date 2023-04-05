Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7575C7619A
	for <mm-commits@archiver.kernel.org>; Wed,  5 Apr 2023 22:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbjDEWC3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 18:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjDEWC3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 18:02:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80AF7692
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 15:02:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50000641A5
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 22:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EDAC4339C;
        Wed,  5 Apr 2023 22:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680732146;
        bh=OM2tTAKsz7oo6GiMKK9ifzbnilvbeyRruEyNG0MATFY=;
        h=Date:To:From:Subject:From;
        b=yRcASETDGagwoPLxc/Op3VgOj+sU2GUvFkq4IRg0ia3YyG4aOWuq6bLott4s08hwD
         4/KvbnXGfk2HLPaP3WlBexZOd2cGfqad5CkszobIG6qJu8gebWbBU2BqxqSa5uWJoX
         UTLUGM9MubQFubkDF+kcTUHVZiftMQtBDHmBjCT8=
Date:   Wed, 05 Apr 2023 15:02:25 -0700
To:     mm-commits@vger.kernel.org, jan.kiszka@siemens.com,
        f.fainelli@gmail.com, kieran.bingham@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-add-a-radix-tree-parser.patch added to mm-nonmm-unstable branch
Message-Id: <20230405220226.A2EDAC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add a Radix Tree Parser
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-add-a-radix-tree-parser.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-add-a-radix-tree-parser.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kieran Bingham <kieran.bingham@linaro.org>
Subject: scripts/gdb: add a Radix Tree Parser
Date: Tue, 4 Apr 2023 14:40:49 -0700

Linux makes use of the Radix Tree data structure to store pointers indexed
by integer values.  This structure is utilised across many structures in
the kernel including the IRQ descriptor tables, and several filesystems.

This module provides a method to lookup values from a structure given its
head node.

Usage:

The function lx_radix_tree_lookup, must be given a symbol of type struct
radix_tree_root, and an index into that tree.

The object returned is a generic integer value, and must be cast correctly
to the type based on the storage in the data structure.

For example, to print the irq descriptor in the sparse irq_desc_tree at
index 18, try the following:

(gdb) print (struct irq_desc)$lx_radix_tree_lookup(irq_desc_tree, 18)

This script previously existed under commit
e127a73d41ac471d7e3ba950cf128f42d6ee3448 ("scripts/gdb: add a Radix Tree
Parser") and was later reverted with
b447e02548a3304c47b78b5e2d75a4312a8f17e1i (Revert "scripts/gdb: add a
Radix Tree Parser").

This version expects the XArray based radix tree implementation and has
been verified using QEMU/x86 on Linux 6.3-rc5.

[f.fainelli@gmail.com: revive and update for xarray implementation]
Link: https://lkml.kernel.org/r/20230404214049.1016811-1-f.fainelli@gmail.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/constants.py.in |    8 ++
 scripts/gdb/linux/radixtree.py    |   87 ++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py        |    1 
 3 files changed, 96 insertions(+)

--- a/scripts/gdb/linux/constants.py.in~scripts-gdb-add-a-radix-tree-parser
+++ a/scripts/gdb/linux/constants.py.in
@@ -17,6 +17,7 @@
 #include <linux/hrtimer.h>
 #include <linux/mount.h>
 #include <linux/of_fdt.h>
+#include <linux/radix-tree.h>
 #include <linux/threads.h>
 
 /* We need to stringify expanded macros so that they can be parsed */
@@ -68,6 +69,13 @@ LX_VALUE(NR_CPUS)
 /* linux/of_fdt.h> */
 LX_VALUE(OF_DT_HEADER)
 
+/* linux/radix-tree.h */
+LX_GDBPARSED(RADIX_TREE_ENTRY_MASK)
+LX_GDBPARSED(RADIX_TREE_INTERNAL_NODE)
+LX_GDBPARSED(RADIX_TREE_MAP_SIZE)
+LX_GDBPARSED(RADIX_TREE_MAP_SHIFT)
+LX_GDBPARSED(RADIX_TREE_MAP_MASK)
+
 /* Kernel Configs */
 LX_CONFIG(CONFIG_GENERIC_CLOCKEVENTS)
 LX_CONFIG(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)
--- /dev/null
+++ a/scripts/gdb/linux/radixtree.py
@@ -0,0 +1,87 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+#  Radix Tree Parser
+#
+# Copyright (c) 2016 Linaro Ltd
+# Copyright (c) 2023 Broadcom
+#
+# Authors:
+#  Kieran Bingham <kieran.bingham@linaro.org>
+#  Florian Fainelli <f.fainelli@gmail.com>
+
+import gdb
+
+from linux import utils
+from linux import constants
+
+radix_tree_root_type = utils.CachedType("struct xarray")
+radix_tree_node_type = utils.CachedType("struct xa_node")
+
+def is_internal_node(node):
+    long_type = utils.get_long_type()
+    return ((node.cast(long_type) & constants.LX_RADIX_TREE_ENTRY_MASK) == constants.LX_RADIX_TREE_INTERNAL_NODE)
+
+def entry_to_node(node):
+    long_type = utils.get_long_type()
+    node_type = node.type
+    indirect_ptr = node.cast(long_type) & ~constants.LX_RADIX_TREE_INTERNAL_NODE
+    return indirect_ptr.cast(radix_tree_node_type.get_type().pointer())
+
+def node_maxindex(node):
+    return (constants.LX_RADIX_TREE_MAP_SIZE << node['shift']) - 1
+
+def lookup(root, index):
+    if root.type == radix_tree_root_type.get_type().pointer():
+        node = root.dereference()
+    elif root.type != radix_tree_root_type.get_type():
+        raise gdb.GdbError("must be {} not {}"
+                           .format(radix_tree_root_type.get_type(), root.type))
+
+    node = root['xa_head']
+    if node == 0:
+        return None
+
+    if not (is_internal_node(node)):
+        if (index > 0):
+            return None
+        return node
+
+    node = entry_to_node(node)
+    maxindex = node_maxindex(node)
+
+    if (index > maxindex):
+        return None
+
+    shift = node['shift'] + constants.LX_RADIX_TREE_MAP_SHIFT
+
+    while True:
+        offset = (index >> node['shift']) & constants.LX_RADIX_TREE_MAP_MASK
+        slot = node['slots'][offset]
+
+        node = slot.cast(node.type.pointer()).dereference()
+        if node == 0:
+            return None
+
+        shift -= constants.LX_RADIX_TREE_MAP_SHIFT
+        if (shift <= 0):
+            break
+
+    return node
+
+class LxRadixTree(gdb.Function):
+    """ Lookup and return a node from a RadixTree.
+
+$lx_radix_tree_lookup(root_node [, index]): Return the node at the given index.
+If index is omitted, the root node is dereference and returned."""
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
--- a/scripts/gdb/vmlinux-gdb.py~scripts-gdb-add-a-radix-tree-parser
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -38,3 +38,4 @@ else:
     import linux.genpd
     import linux.device
     import linux.mm
+    import linux.radixtree
_

Patches currently in -mm which might be from kieran.bingham@linaro.org are

scripts-gdb-add-a-radix-tree-parser.patch

