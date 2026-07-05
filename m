Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED4E86341
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 02:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783217413; cv=none; b=UOfF8QJ252OqNHCmD7TBMDAIq/ehUzcKMr+m+GA2j3BfyRcKRXhRgl5CT5Tpxs9tZdlKTSiW1XhtvBT3SNqmgewmrBMEZBpN46X1zpxVo1mVF/E0v/6gac2zU45ihZ8btGI/OkwDWa9ckkE8gS9R3OD014c9Ra3RPwVzenlg2GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783217413; c=relaxed/simple;
	bh=1WJT9FKng6P4q4b7haRziieew0RX/S8UeNblL3Kdx3I=;
	h=Date:To:From:Subject:Message-Id; b=d+WuWNHZZUFxZ0YphOf1qD5ZICgxmFVWkIWyQEAiX267UQSMpE9iOvZew/NovkHyveTymq2iH/McQkNVyxGULVHwo2rBL3zRsaG4pynSZ1siz4LkMHaFXykdD3qbkkPhlaK+2dNbmhKXS1dycIql/g24Z1yvICn0TmuSf2j8eww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S2QRlUIF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S2QRlUIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642E31F000E9;
	Sun,  5 Jul 2026 02:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783217412;
	bh=JIgqE6DVrHyE6okfopmyUJPkiRRy/DbSN4XQRbe/Voo=;
	h=Date:To:From:Subject;
	b=S2QRlUIFgyBsKSeZIbimgHdNvjS7RG35urHsBI4H9CEK/edEgxqoATxmo95pjcX//
	 4ntu+x62TtCZLmKJbGtw3D15zLija2tNLiZaiAx3JgCkKIjBq5zS/4U32owEbDkR71
	 o5Jeocs1Avgu4FRSL8NoqIp924ZpPXjo4bAt6lBI=
Date: Sat, 04 Jul 2026 19:10:12 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,catalin.marinas@arm.com,bigeasy@linutronix.de,arnd@arndb.de,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch removed from -mm tree
Message-Id: <20260705021012.642E31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: radix-tree: fix kmemleak false positives on tree head reassignment
has been removed from the -mm tree.  Its filename was
     radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: radix-tree: fix kmemleak false positives on tree head reassignment
Date: Thu, 02 Jul 2026 05:58:34 -0700

Kmemleak periodically reports transient false positives for radix tree
nodes allocated through the IDR, for example:

  unreferenced object 0xffff0004d6ac4200 (size 576):
    comm "tcpeventd", pid 6412
    backtrace (crc 335d668a):
      kmem_cache_alloc_noprof
      radix_tree_node_alloc
      radix_tree_extend
      idr_get_free
      idr_alloc_cyclic
      map_create
      __sys_bpf

radix_tree_extend() (grow) and radix_tree_shrink() (shrink) repoint
root->xa_head to a new node.  If a kmemleak scan has already walked past
root->xa_head, the new head is not reachable from any scanned pointer
until the following scan, so kmemleak reports it as leaked even though it
is live.

This is the same race fixed for the XArray API in commit a1a029bcea59
("XArray: fix kmemleak false positive in xas_shrink()").  The IDR uses the
radix tree API directly and hits it on both the grow and the shrink path,
so mark the new head as a transient leak in both.

Link: https://lore.kernel.org/20260702-radix-tree-v1-1-a87c125b0f96@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/lib/radix-tree.c~radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment
+++ a/lib/radix-tree.c
@@ -455,6 +455,8 @@ static int radix_tree_extend(struct radi
 		node->slots[0] = (void __rcu *)entry;
 		entry = node_to_entry(node);
 		rcu_assign_pointer(root->xa_head, entry);
+		/* new head may be missed by an in-progress kmemleak scan */
+		kmemleak_transient_leak(node);
 		shift += RADIX_TREE_MAP_SHIFT;
 	} while (shift <= maxshift);
 out:
@@ -495,8 +497,11 @@ static inline bool radix_tree_shrink(str
 		if (!node->shift && is_idr(root))
 			break;
 
-		if (radix_tree_is_internal_node(child))
+		if (radix_tree_is_internal_node(child)) {
 			entry_to_node(child)->parent = NULL;
+			/* new head may be missed by an in-progress kmemleak scan */
+			kmemleak_transient_leak(entry_to_node(child));
+		}
 
 		/*
 		 * We don't need rcu_assign_pointer(), since we are simply
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-fix-checksum-computation-for-per-cpu-objects.patch
mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch
mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-add-hwpoison-panic-destructive-test.patch
mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch

