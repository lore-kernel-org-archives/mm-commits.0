Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF74832E141
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 04:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791519275; cv=none; b=jHon7N99mId7XwlpPhAEBb1vbZkfaJG5oAYsxhwpTafkEhfYglVilbamHKCNzdsnGDv3wsVLX5v791dLLf3iSwz5982nw9xEd6qPGkNw6VDkFseC2LCTYlf35/Neqg/b0EIxttj3OGhiVvVwwlXhvp3kh8pEq8jS2teqkprXCO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791519275; c=relaxed/simple;
	bh=HmtdntnnHCIEsn0CW/jR477mCWsxyGyXbS/EIfgc4RY=;
	h=Date:To:From:Subject:Message-Id; b=fz1JlzIPcmh9ZZpL2X5uCAIPO3lJaj56ed+dqlQ7VPeOQKW9yDaknELKbVmmoJbV5a8gtWcCvMiXbjUB2ficTU2AGxGEdkNsAlQTSG81Obr4MmRUt1JnodQyAVqIlsfToZ27TMiA+XJmSbSw0eOx+HxFE2MOKbX4o4vyEihdYcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CORJ2UW9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CORJ2UW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A05A1F000FF;
	Fri,  9 Oct 2026 04:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791519271;
	bh=1vvdwlaeG3GdTIgaThEkP8x9PBJAJd/soUmiGTNqqZ8=;
	h=Date:To:From:Subject;
	b=CORJ2UW9E8tlVR/EtIYhmbnkalT0Ag37l0X/XfPEXYGTdhfKkQL4bcAIMSKe1mwxn
	 8djN8+JltpdtKel8nAYS+87Eyjbb4s/KGrZZQXe3vvamQeN3t2Bh2Tk3u4H9LWZLpv
	 /TYF6o+WrNP0VwNosBbWKw2ww6zogT7kpualRNBg=
Date: Thu, 08 Oct 2026 21:14:30 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,lkp@intel.com,gourry@gourry.net,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch removed from -mm tree
Message-Id: <20261009041431.0A05A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory_hotplug-factor-out-node_is_memoryless-fix
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-factor-out-node_is_memoryless.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-factor-out-node_is_memoryless-fix
Date: Fri Sep  4 06:54:43 PM PDT 2026

move node_is_memoryless() inside CONFIG_MEMORY_HOTREMOVE

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609050628.ywCLhOj5-lkp@intel.com/
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Oscar Salvador <osalvador@suse.de>
---

 mm/memory_hotplug.c |   61 +++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-factor-out-node_is_memoryless-fix
+++ a/mm/memory_hotplug.c
@@ -1491,36 +1491,6 @@ out:
 	return ret;
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
-/* Caller must hold the memory hotplug lock for this check. */
-static bool node_is_memoryless(int nid)
-{
-	/*
-	 * A node still spanning pages (especially ZONE_DEVICE) is not
-	 * memoryless.  A node spans memory after move_pfn_range_to_zone(),
-	 * e.g. once a memory block has been onlined.
-	 */
-	if (node_spanned_pages(nid))
-		return false;
-	/*
-	 * Offline memory blocks may not be spanned by the node yet, but they
-	 * link to it in sysfs and can be onlined later, so the node is not
-	 * memoryless while any remain.
-	 */
-	return !for_each_memory_block(&nid, check_no_memblock_for_node_cb);
-}
-
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -1815,6 +1785,37 @@ bool mhp_range_allowed(u64 start, u64 si
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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
mm-selftests-add-shmem-into-memory-failure-test-fix.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch
mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
selftests-mm-build-page-frag-test-with-the-kernel.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

