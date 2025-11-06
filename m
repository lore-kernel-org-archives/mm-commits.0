Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016CC335BA5
	for <mm-commits@vger.kernel.org>; Thu,  6 Nov 2025 23:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762471473; cv=none; b=V01yRnuADyTL5B3csCFN248j2/DVnMLqRy0Muh7jVYvp6AQKciU0B6iKAok1eoWZ9OXagQdIhG35umCovpOqhVOrNuLUybpyh9B/48ufIHrudfhimeGHRxIt3EiauTUNCHM1jEzrVwFrkwWGfOjRH2CJ7RI0FQePPztU0/oGKuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762471473; c=relaxed/simple;
	bh=eNwl7shZhX9zWjqtsqH7Qy8dEzNV4Riz1CAjXGE/q4w=;
	h=Date:To:From:Subject:Message-Id; b=jTsLE17Ygf4fhhYB6tJ0+703wYXF7RUaPAkmzgfUktZeOkI5dktmP48MoSZ4Bd2JMoH0e7O1oi76nwl8nxs6x6+selQttsAKHLPpZEDZfAMtvnii9yk/JRtKiWANfYl+4+ZwzU/kQLIPJfa4qms43SIsNKHMtGMwYIEls1I05iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VWy8f1GE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VWy8f1GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C65FC113D0;
	Thu,  6 Nov 2025 23:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762471472;
	bh=eNwl7shZhX9zWjqtsqH7Qy8dEzNV4Riz1CAjXGE/q4w=;
	h=Date:To:From:Subject:From;
	b=VWy8f1GEdKY+QS7sZ1L9bwgZJ2RLm6C3rlYJOc+9jql+9rDNA4J7yJSSb+pUeur00
	 /fzqygtg5iL2gpB2+H787P5BbXMi4dc68AxDIHLn4RFmN2wSdGufa+iAZbF3tvJ71J
	 GbetBDKkM4kiRI8CQrARA4d90rvHTZtfsQAvlo3Q=
Date: Thu, 06 Nov 2025 15:24:31 -0800
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,hca@linux.ibm.com,gor@linux.ibm.com,daniel@iogearbox.net,ast@kernel.org,andrii@kernel.org,agordeev@linux.ibm.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-radix-tree-add-lx-radix-tree-command.patch added to mm-nonmm-unstable branch
Message-Id: <20251106232432.6C65FC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb/radix-tree: add lx-radix-tree-command
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-radix-tree-add-lx-radix-tree-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-radix-tree-add-lx-radix-tree-command.patch

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
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: scripts/gdb/radix-tree: add lx-radix-tree-command
Date: Thu, 6 Nov 2025 13:43:41 +0100

Patch series "scripts/gdb/symbols: make BPF debug info available to GDB",
v2.

This series greatly simplifies debugging BPF progs when using QEMU gdbstub
by providing symbol names, sizes, and line numbers to GDB.

Patch 1 adds radix tree iteration, which is necessary for parsing
prog_idr.  Patch 2 is the actual implementation; its description contains
some details on how to use this.


This patch (of 2):

Add a function and a command to iterate over radix tree contents. 
Duplicate the C implementation in Python, but drop support for tagging.

Link: https://lkml.kernel.org/r/20251106124600.86736-1-iii@linux.ibm.com
Link: https://lkml.kernel.org/r/20251106124600.86736-2-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/radixtree.py |  139 +++++++++++++++++++++++++++++--
 1 file changed, 132 insertions(+), 7 deletions(-)

--- a/scripts/gdb/linux/radixtree.py~scripts-gdb-radix-tree-add-lx-radix-tree-command
+++ a/scripts/gdb/linux/radixtree.py
@@ -30,13 +30,16 @@ def entry_to_node(node):
 def node_maxindex(node):
     return (constants.LX_RADIX_TREE_MAP_SIZE << node['shift']) - 1
 
-def lookup(root, index):
+def resolve_root(root):
+    if root.type == radix_tree_root_type.get_type():
+        return root
     if root.type == radix_tree_root_type.get_type().pointer():
-        node = root.dereference()
-    elif root.type != radix_tree_root_type.get_type():
-        raise gdb.GdbError("must be {} not {}"
-                           .format(radix_tree_root_type.get_type(), root.type))
+        return root.dereference()
+    raise gdb.GdbError("must be {} not {}"
+                       .format(radix_tree_root_type.get_type(), root.type))
 
+def lookup(root, index):
+    root = resolve_root(root)
     node = root['xa_head']
     if node == 0:
         return None
@@ -71,14 +74,120 @@ def lookup(root, index):
 
     return node
 
-class LxRadixTree(gdb.Function):
+def descend(parent, index):
+    offset = (index >> int(parent["shift"])) & constants.LX_RADIX_TREE_MAP_MASK
+    return offset, parent["slots"][offset]
+
+def load_root(root):
+    node = root["xa_head"]
+    nodep = node
+
+    if is_internal_node(node):
+        node = entry_to_node(node)
+        maxindex = node_maxindex(node)
+        return int(node["shift"]) + constants.LX_RADIX_TREE_MAP_SHIFT, \
+               nodep, maxindex
+
+    return 0, nodep, 0
+
+class RadixTreeIter:
+    def __init__(self, start):
+        self.index = 0
+        self.next_index = start
+        self.node = None
+
+def xa_mk_internal(v):
+    return (v << 2) | 2
+
+LX_XA_RETRY_ENTRY = xa_mk_internal(256)
+LX_RADIX_TREE_RETRY = LX_XA_RETRY_ENTRY
+
+def next_chunk(root, iter):
+    mask = (1 << (utils.get_ulong_type().sizeof * 8)) - 1
+
+    index = iter.next_index
+    if index == 0 and iter.index != 0:
+        return None
+
+    restart = True
+    while restart:
+        restart = False
+
+        _, child, maxindex = load_root(root)
+        if index > maxindex:
+            return None
+        if not child:
+            return None
+
+        if not is_internal_node(child):
+            iter.index = index
+            iter.next_index = (maxindex + 1) & mask
+            iter.node = None
+            return root["xa_head"].address
+
+        while True:
+            node = entry_to_node(child)
+            offset, child = descend(node, index)
+
+            if not child:
+                while True:
+                    offset += 1
+                    if offset >= constants.LX_RADIX_TREE_MAP_SIZE:
+                        break
+                    slot = node["slots"][offset]
+                    if slot:
+                        break
+                index &= ~node_maxindex(node)
+                index = (index + (offset << int(node["shift"]))) & mask
+                if index == 0:
+                    return None
+                if offset == constants.LX_RADIX_TREE_MAP_SIZE:
+                    restart = True
+                    break
+                child = node["slots"][offset]
+
+            if not child:
+                restart = True
+                break
+            if child == LX_XA_RETRY_ENTRY:
+                break
+            if not node["shift"] or not is_internal_node(child):
+                break
+
+    iter.index = (index & ~node_maxindex(node)) | offset
+    iter.next_index = ((index | node_maxindex(node)) + 1) & mask
+    iter.node = node
+
+    return node["slots"][offset].address
+
+def next_slot(slot, iter):
+    mask = (1 << (utils.get_ulong_type().sizeof * 8)) - 1
+    for _ in range(iter.next_index - iter.index - 1):
+        slot += 1
+        iter.index = (iter.index + 1) & mask
+        if slot.dereference():
+            return slot
+    return None
+
+def for_each_slot(root, start=0):
+    iter = RadixTreeIter(start)
+    slot = None
+    while True:
+        if not slot:
+            slot = next_chunk(root, iter)
+            if not slot:
+                break
+        yield iter.index, slot
+        slot = next_slot(slot, iter)
+
+class LxRadixTreeLookup(gdb.Function):
     """ Lookup and return a node from a RadixTree.
 
 $lx_radix_tree_lookup(root_node [, index]): Return the node at the given index.
 If index is omitted, the root node is dereference and returned."""
 
     def __init__(self):
-        super(LxRadixTree, self).__init__("lx_radix_tree_lookup")
+        super(LxRadixTreeLookup, self).__init__("lx_radix_tree_lookup")
 
     def invoke(self, root, index=0):
         result = lookup(root, index)
@@ -87,4 +196,20 @@ If index is omitted, the root node is de
 
         return result
 
+class LxRadixTree(gdb.Command):
+    """Show all values stored in a RadixTree."""
+
+    def __init__(self):
+        super(LxRadixTree, self).__init__("lx-radix-tree", gdb.COMMAND_DATA,
+                                          gdb.COMPLETE_NONE)
+
+    def invoke(self, argument, from_tty):
+        args = gdb.string_to_argv(argument)
+        if len(args) != 1:
+            raise gdb.GdbError("Usage: lx-radix-tree ROOT")
+        root = gdb.parse_and_eval(args[0])
+        for index, slot in for_each_slot(root):
+            gdb.write("[{}] = {}\n".format(index, slot.dereference()))
+
 LxRadixTree()
+LxRadixTreeLookup()
_

Patches currently in -mm which might be from iii@linux.ibm.com are

scripts-gdb-radix-tree-add-lx-radix-tree-command.patch
scripts-gdb-symbols-make-bpf-debug-info-available-to-gdb.patch

