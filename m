Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5A53B3C15
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 03:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791691156; cv=none; b=LBNOV4T2xGw3Zee/tOZBikpJmyX0JWVBUlShst0mUYF0nRjwqWozfzNYtwQqjd0mel8BrzlgBzDAM0Lm8HOVJ0i/fNaCsF/Do7HjQOSuIcLiEuxSubmxTGSrOWh5dw4agkTurw+z/f6a7k5cWYP84ZToOHJ+S+/QSf02yNZIYXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791691156; c=relaxed/simple;
	bh=H/RZ91r7M1MFQht+p5H7gakLpCfEpC/kpZhpjLEc/sM=;
	h=Date:To:From:Subject:Message-Id; b=JWQM7B08tRLglq0C+hTJYPnI79bw1VCgy/aIbegEFrS3xH/+kewiewKq7PbJz0f0GnhgQpFTgj1B41c9ajC10tTjF9TGNvoKoMZZm+Plc7XB5ysyfKe5ah5NjzfjX0VzzgKUTmtGur3V/NMzlUA0XnkinmLRWUqZ7KVEe6ycMLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lSB2gkZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lSB2gkZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDADC1F000FF;
	Sun, 11 Oct 2026 03:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791691154;
	bh=ZLfLSONXhsL8KVivW8skTw2tfMzyaFtyx7FaFDxhgrA=;
	h=Date:To:From:Subject;
	b=lSB2gkZnRTApf0C9XnjQyJXLSktZdueXZ2nHKGPScVfyGI1n/MJw3L7bG3tFJgY8K
	 HPNsIpJv3EaM0ijxt+IWlNvN6Cwgo0dGpjBe12q2DXl5pTRC1Kz4ATaaOHIpmOdEWE
	 RVFUP3lvJKKhSIhzAitzxYdbt4XNzwYnmbY5nx1Q=
Date: Sat, 10 Oct 2026 20:59:14 -0700
To: mm-commits@vger.kernel.org,kuan-ying.lee@canonical.com,kbingham@kernel.org,jan.kiszka@siemens.com,ue081723@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-radix-tree-lookup-pointer-handling.patch added to mm-nonmm-unstable branch
Message-Id: <20261011035914.CDADC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: fix radix tree lookup pointer handling
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-radix-tree-lookup-pointer-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-radix-tree-lookup-pointer-handling.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

scripts-gdb-fix-radix-tree-lookup-pointer-handling.patch
scripts-gdb-fix-stack-depot-out-of-bounds-diagnostic.patch

