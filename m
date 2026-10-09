Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D473B3FB7F1
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525397; cv=none; b=RLRr00pYB02KkJ6udf/iG5Z6ywFhnJmtMH6YdccM/lwcTyZvTmNKDBqwHeeLFAOofRPW5b6fgR/rsxwVO1+BAqf2PoKQ7F7PGthTRqo98MLanqG2TCTOCh2ekmITTfRmJUE224IgImy0IgDOq16Ci/vCiOXSM/ize6FyE0i7b6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525397; c=relaxed/simple;
	bh=zR09xpH8hvCvnUTzOoR8xYvlByaEi3P0y4QWMLwVkDI=;
	h=Date:To:From:Subject:Message-Id; b=LqgEe7WEnLOBpvfemMd/tvLG4O0tD4fo2bujCLbI0bz6jH/ZDub2DMFub39p3lT3lW6nYEgYJt0m2cQrEDrfIg954EVHbp1pdegJ3UZnoaKtCmKa+8/u4zxPMOttfn6ZtIShecG9rh22Agr4YAQACE1x/liH0tLzop4cuHAgX+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=paMw/I81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="paMw/I81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7991F00893;
	Fri,  9 Oct 2026 05:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525395;
	bh=/Ot/FpHucuiWB74IOR6d3nuIQJz9mCiCwQMy5v5OuoY=;
	h=Date:To:From:Subject;
	b=paMw/I81j8Gy1sFhznjDaMPT1s5FgdhinZSk3nUUv4yBH2Fb3Kw8/bKNi5XPmh/Zz
	 lFFc0BzVScTJm+EQIRYjAC73uCgoDX2uct4ZZ1XoF1/inwGKjjA465qAEuChMBdGMl
	 Ww7GgWz8Yiqojs07alh6uu0eFHtutyNV0ei7UHkg=
Date: Thu, 08 Oct 2026 22:56:35 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-factor-out-node_is_memoryless.patch removed from -mm tree
Message-Id: <20261009055635.AA7991F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: factor out node_is_memoryless()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-factor-out-node_is_memoryless.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/memory_hotplug: factor out node_is_memoryless()
Date: Wed, 2 Sep 2026 15:55:07 -0400

A memoryless node neither spans present pages (populated or ZONE_DEVICE)
nor has an offline-but-added memory block still linked to it in sysfs.

try_offline_node() presently open-codes this memoryless check.

Pull that into a node_is_memoryless() helper and pull the existing
check_no_memblock_for_node_cb() helper ahead of the add/online path so
it's clearer what is happening here.

No functional change.

[akpm@linux-foundation.org: move node_is_memoryless() inside CONFIG_MEMORY_HOTREMOVE]
Link: https://lore.kernel.org/20260902195507.88655-1-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
---

 mm/memory_hotplug.c |   61 ++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-factor-out-node_is_memoryless
+++ a/mm/memory_hotplug.c
@@ -1785,6 +1785,37 @@ bool mhp_range_allowed(u64 start, u64 si
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+
+static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
+{
+	int nid = *(int *)arg;
+
+	/*
+	 * If a memory block belongs to multiple nodes, the stored nid is not
+	 * reliable. However, such blocks are always online (e.g., cannot get
+	 * offlined) and, therefore, are still spanned by the node.
+	 */
+	return mem->nid == nid ? -EEXIST : 0;
+}
+
+/* Caller must hold the memory hotplug lock for this check. */
+static bool node_is_memoryless(int nid)
+{
+	/*
+	 * A node still spanning pages (especially ZONE_DEVICE) is not
+	 * memoryless.  A node spans memory after move_pfn_range_to_zone(),
+	 * e.g. once a memory block has been onlined.
+	 */
+	if (node_spanned_pages(nid))
+		return false;
+	/*
+	 * Offline memory blocks may not be spanned by the node yet, but they
+	 * link to it in sysfs and can be onlined later, so the node is not
+	 * memoryless while any remain.
+	 */
+	return !for_each_memory_block(&nid, check_no_memblock_for_node_cb);
+}
+
 /*
  * Scan pfn range [start,end) to find movable/migratable pages (LRU and
  * hugetlb folio, movable_ops pages). Will skip over most unmovable
@@ -2214,18 +2245,6 @@ static int check_cpu_on_node(int nid)
 	return 0;
 }
 
-static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
-{
-	int nid = *(int *)arg;
-
-	/*
-	 * If a memory block belongs to multiple nodes, the stored nid is not
-	 * reliable. However, such blocks are always online (e.g., cannot get
-	 * offlined) and, therefore, are still spanned by the node.
-	 */
-	return mem->nid == nid ? -EEXIST : 0;
-}
-
 /**
  * try_offline_node
  * @nid: the node ID
@@ -2237,23 +2256,7 @@ static int check_no_memblock_for_node_cb
  */
 void try_offline_node(int nid)
 {
-	int rc;
-
-	/*
-	 * If the node still spans pages (especially ZONE_DEVICE), don't
-	 * offline it. A node spans memory after move_pfn_range_to_zone(),
-	 * e.g., after the memory block was onlined.
-	 */
-	if (node_spanned_pages(nid))
-		return;
-
-	/*
-	 * Especially offline memory blocks might not be spanned by the
-	 * node. They will get spanned by the node once they get onlined.
-	 * However, they link to the node in sysfs and can get onlined later.
-	 */
-	rc = for_each_memory_block(&nid, check_no_memblock_for_node_cb);
-	if (rc)
+	if (!node_is_memoryless(nid))
 		return;
 
 	if (check_cpu_on_node(nid))
_

Patches currently in -mm which might be from gourry@gourry.net are

proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch
mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch
mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch

