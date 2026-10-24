Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828043;
	b=bKxNGX9+Eu8dcM28OMqyLkWpCRvrFrh5ggxtRrSRMKwfpXUCtWcZ4Aj6uGL2fpTCUOKo
	 d+bzKLqfMu/s1Yp0TovtoV4sQ6sGcvYuT5AQ4gOekKHlH2Uog3WdQSC4JgToICkvFf50v
	 x5Ty2Tw2tHFPXSnCNCJdftW7oAzOgq66Kehpt4V4PfapsB76f/hWfxzPqeFA39msMVmLQ
	 YXjuvAZLo9ZEeXhzV8AxCsQTEE2gi7+Yaw5kr3q2zS+6n0JXmZWygWG3Yhio0FWCDilKL
	 VDfPCQNyfILcn2gKG/u8HZ6kgtUgDHR3ybW+tFRd0KwziCVrCtSJzs4injXTO4e4P0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828043;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=TixrSsr7XAv+7yfqTIR+qacZrhX8MDBC4j9eFs8DAMk=;
	b=tNEloiYeua1JU0zg1sIft4xFM7g8C7ZisYV4p/WWwbCszlOuo7g8ADztHSoJbIR4RtUU
	 vTFIncrjuCQr0kUDJE8Xuptexvlipqlx8dihQSdiKfie5s8Nhp1WEONMH5YZa56EV2a/j
	 BYq2z6kQa9pR7hiXZ9JJgPRMn4k2RxYDzlSnKbRNkC20g6XA7+59vzWWCg+wOPiY9f9J1
	 nzDx/fmPRgU+sHJuoTZD5JD3Yim3L2lDL+c7roya5XvMi5rQuATPvkTYrXrKsvx+r4MyE
	 0yzA3pHOINZXMTg8+L0aKVwb/bWQ8yZi5fB2d7epZWj6z2KOOGbz0U6k8aW3/n1M6iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eSHayHn2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25244606A321
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 07:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eSHayHn2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EB71F01829;
	Sat, 24 Oct 2026 07:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828043;
	bh=TixrSsr7XAv+7yfqTIR+qacZrhX8MDBC4j9eFs8DAMk=;
	h=Date:To:From:Subject;
	b=eSHayHn2OEvTcI5WDzYProA9z8cOO1RSxEkVpX0qwtBLG6Tg/gZ9eQpGG2MY/4tuT
	 WQp2DWzTHkiSL4NqDtA7YaRjg4OZadmC3H5NdBPc+77OdNZKje6qfrK2w/Ie4PETiZ
	 YXuQqEeoWLelO6Vn4c5UH5rvua5l/rVd8vs21huU=
Date: Sat, 24 Oct 2026 00:47:22 -0700
To: mm-commits@vger.kernel.org,kuan-ying.lee@canonical.com,kbingham@kernel.org,jan.kiszka@siemens.com,ue081723@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-radix-tree-lookup-pointer-handling.patch removed from -mm tree
Message-Id: <20261024074722.E4EB71F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: scripts/gdb: fix radix tree lookup pointer handling
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-radix-tree-lookup-pointer-handling.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ting-Han Hou <ue081723@gmail.com>
Subject: scripts/gdb: fix radix tree lookup pointer handling
Date: Sun, 11 Oct 2026 10:30:43 +0800

Patch series "scripts/gdb: fix radix tree lookup and stack depot
diagnostic", v2.

Two scripts/gdb fixes.

Patch 1 fixes $lx_radix_tree_lookup(), which dereferenced slot contents
as if they were node pointers. v2 also handles the XArray sibling,
retry and zero entries that Sashiko pointed out: they carry the
internal tag but are not node pointers, and the v1 patch raised a GDB
MemoryError on them. Large folios in the page cache make sibling
entries common, so this was worth fixing rather than documenting.

Patch 2 is unchanged from v1 apart from being resent with git
send-email, since the earlier copy was word-wrapped by the mail
client. Sorry about that.

Both patches are tested against standalone GCC-built fixtures that use
the kernel struct layouts (details below the --- line of each patch),
not against a running kernel.


This patch (of 2):

lookup() casts each slot to a pointer to a node pointer and then
dereferences it. Since the slot already contains an entry pointer,
this reads the entry's contents as another pointer instead of
returning the entry itself. Internal entries also keep their tag
bits when descending, so multi-level trees are read from the wrong
address and $lx_radix_tree_lookup() fails with a memory error.

Sibling, retry and zero entries carry the same internal tag but are
small integers rather than node pointers, so the tag alone must not
decide whether to descend. A page cache populated with large folios
has a sibling entry in every slot but the first of each folio.

Walk the tree the way xas_load() does: descend only through entries
that xa_is_node() would accept, follow sibling entries to the
canonical slot of a multi-index entry, and treat retry and zero
entries like empty slots since they hold no data. Remove the explicit
shift counter, as traversal now follows the entry type.

Link: https://lore.kernel.org/20261011023044.1722-1-ue081723@gmail.com
Link: https://lore.kernel.org/20261011023044.1722-2-ue081723@gmail.com
Fixes: b7235d6bb516 ("scripts/gdb: add a Radix Tree Parser")
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
---

 scripts/gdb/linux/radixtree.py |   68 ++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 27 deletions(-)

--- a/scripts/gdb/linux/radixtree.py~scripts-gdb-fix-radix-tree-lookup-pointer-handling
+++ a/scripts/gdb/linux/radixtree.py
@@ -27,6 +27,24 @@ def entry_to_node(node):
     indirect_ptr = node.cast(long_type) & ~constants.LX_RADIX_TREE_INTERNAL_NODE
     return indirect_ptr.cast(radix_tree_node_type.get_type().pointer())
 
+def is_node(entry):
+    # Like xa_is_node(): internal entries below 4096 are sibling, retry
+    # or zero entries rather than pointers to a struct xa_node.
+    ulong_type = utils.get_ulong_type()
+    return is_internal_node(entry) and entry.cast(ulong_type) > 4096
+
+def is_sibling(entry):
+    # Like xa_is_sibling(): a multi-index entry occupies several slots,
+    # and all but the first hold a sibling entry that encodes the offset
+    # of the first one.
+    ulong_type = utils.get_ulong_type()
+    return is_internal_node(entry) and entry.cast(ulong_type) < \
+        xa_mk_internal(constants.LX_RADIX_TREE_MAP_SIZE - 1)
+
+def sibling_offset(entry):
+    ulong_type = utils.get_ulong_type()
+    return int(entry.cast(ulong_type)) >> 2
+
 def node_maxindex(node):
     return (constants.LX_RADIX_TREE_MAP_SIZE << node['shift']) - 1
 
@@ -40,39 +58,35 @@ def resolve_root(root):
 
 def lookup(root, index):
     root = resolve_root(root)
-    node = root['xa_head']
-    if node == 0:
-        return None
+    entry = root['xa_head']
 
-    if not (is_internal_node(node)):
-        if (index > 0):
+    if is_node(entry):
+        node = entry_to_node(entry)
+        if index > node_maxindex(node):
             return None
-        return node
-
-    node = entry_to_node(node)
-    maxindex = node_maxindex(node)
 
-    if (index > maxindex):
+        # Walk down the tree like xas_load() does.
+        while True:
+            offset = (index >> node['shift']) & constants.LX_RADIX_TREE_MAP_MASK
+            entry = node['slots'][offset]
+
+            while is_sibling(entry):
+                entry = node['slots'][sibling_offset(entry)]
+                if node['shift'] and is_node(entry):
+                    # xas_descend() turns this into a retry entry.
+                    return None
+
+            if not is_node(entry) or node['shift'] == 0:
+                break
+            node = entry_to_node(entry)
+    elif index > 0:
         return None
 
-    shift = node['shift'] + constants.LX_RADIX_TREE_MAP_SHIFT
-
-    while True:
-        offset = (index >> node['shift']) & constants.LX_RADIX_TREE_MAP_MASK
-        slot = node['slots'][offset]
-
-        if slot == 0:
-            return None
-
-        node = slot.cast(node.type.pointer()).dereference()
-        if node == 0:
-            return None
-
-        shift -= constants.LX_RADIX_TREE_MAP_SHIFT
-        if (shift <= 0):
-            break
+    # Empty slots and retry or zero entries hold no data.
+    if entry == 0 or is_internal_node(entry):
+        return None
 
-    return node
+    return entry
 
 def descend(parent, index):
     offset = (index >> int(parent["shift"])) & constants.LX_RADIX_TREE_MAP_MASK
_

Patches currently in -mm which might be from ue081723@gmail.com are

scripts-gdb-fix-stack-depot-out-of-bounds-diagnostic.patch

