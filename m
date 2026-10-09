Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DCF3FD132
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525430; cv=none; b=AM4sPSM8weJv7Igr8w6nfoH5aV4OmMr2Kp0Y6RrUXmD6N2Aya/qNIZmASMgBX8hSCwVnpLiEhoigSzn5aJtxd+PSDX38kjyTnX3+O0oqnOv1exeCW/7/zNdxugGWT7OjsHb0p+mwWy1lUMOt6i0Cwli0bpoaMaPYgzV1xLO3o3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525430; c=relaxed/simple;
	bh=Pq8HmAv6+j5vZscyN0O2UBHsCLq3Dzl3x7JcYCwFEOY=;
	h=Date:To:From:Subject:Message-Id; b=m5wOjUt2hx6KRAxX9+NQozCoZHXCLH0qXMt9PKRTW2STGCGuOTtUA3nN1viyAB4TircP0dbD7eytUqZcyTib75mRLG7RxYgmWVG8LTK/liMZrel+FHARqrhiRCooVn8whgeL0wE26fgvHG0oAOL3ZGJ9h5t82TpaUdRMiqfu47w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pqcmoJwd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pqcmoJwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980811F00893;
	Fri,  9 Oct 2026 05:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525429;
	bh=JLecL0wk2u6nGtslYxpIpOIIc/dJLpj/wFS2YEuAczg=;
	h=Date:To:From:Subject;
	b=pqcmoJwdFrUazHu9bletpJau9ZjSEycBR6n1p91ME79LURUzC8/9hIlNsGnaKvOv0
	 tV6eW9xodIJaINjifBurDAxObqtHGTr7RMT5ZqF3cCiC4Qka93KtT/yfqLAwBdCwAP
	 o7E//t9VuXsFrcoDOvsuWXN3JwxwJpJ7QpBVvjAM=
Date: Thu, 08 Oct 2026 22:57:09 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,mcgrof@kernel.org,jikos@kernel.org,bentiss@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-execmem-handle-potential-allocation-errors-in-the-maple-tree.patch removed from -mm tree
Message-Id: <20261009055709.980811F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/execmem: handle potential allocation errors in the maple tree
has been removed from the -mm tree.  Its filename was
     mm-execmem-handle-potential-allocation-errors-in-the-maple-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/execmem: handle potential allocation errors in the maple tree
Date: Thu, 03 Sep 2026 18:49:59 +0300

execmem_cache_clean() and execmem_cache_alloc_locked() ignore potential
allocation failures in mas_store_gfp().

While in practice they are unlikely to happen, it's better to handle those
errors and ensure the integrity of the ROX cache.

Preallocate the maple tree nodes for the stores that must not fail and
order the maple tree updates so that there won't be any failures once a
tree has been modified.

Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-2-11beb2a3d249@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: copilot:claude-opus-5
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
---

 mm/execmem.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/mm/execmem.c~mm-execmem-handle-potential-allocation-errors-in-the-maple-tree
+++ a/mm/execmem.c
@@ -149,7 +149,15 @@ static void execmem_cache_clean(struct w
 		if (vm && get_vm_area_size(vm) == size &&
 		    IS_ALIGNED(size, PMD_SIZE) &&
 		    IS_ALIGNED(mas.index, PMD_SIZE)) {
-			mas_store_gfp(&mas, NULL, GFP_KERNEL);
+			/*
+			 * Preallocate to ensure mas_store does not fail
+			 * If there is no memory for the tree update, bail out,
+			 * next execmem_free() might be more lucky
+			 */
+			if (mas_preallocate(&mas, NULL, GFP_KERNEL))
+				break;
+
+			mas_store_prealloc(&mas, NULL);
 			vfree(area);
 		}
 	}
@@ -219,30 +227,34 @@ static void *execmem_cache_alloc_locked(
 	addr = mas_free.index;
 	last = mas_free.last;
 
+	mas_set_range(&mas_free, addr, addr + size - 1);
+	if (mas_preallocate(&mas_free, NULL, GFP_KERNEL))
+		return NULL;
+
 	/* insert allocated size to busy_areas at range [addr, addr + size) */
 	mas_set_range(&mas_busy, addr, addr + size - 1);
 	err = mas_store_gfp(&mas_busy, (void *)addr, GFP_KERNEL);
 	if (err)
-		return NULL;
+		goto err_destroy_mas_free;
 
-	mas_store_gfp(&mas_free, NULL, GFP_KERNEL);
+	mas_store_prealloc(&mas_free, NULL);
 	if (area_size > size) {
-		void *ptr = (void *)(addr + size);
-
 		/*
 		 * re-insert remaining free size to free_areas at range
 		 * [addr + size, last]
+		 * the range matches an existing entry, so this cannot allocate
 		 */
+		ptr = (void *)(addr + size);
 		mas_set_range(&mas_free, addr + size, last);
-		err = mas_store_gfp(&mas_free, ptr, GFP_KERNEL);
-		if (err) {
-			mas_store_gfp(&mas_busy, NULL, GFP_KERNEL);
-			return NULL;
-		}
+		mas_store_gfp(&mas_free, ptr, GFP_KERNEL);
 	}
 	ptr = (void *)addr;
 
 	return ptr;
+
+err_destroy_mas_free:
+	mas_destroy(&mas_free);
+	return NULL;
 }
 
 static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
_

Patches currently in -mm which might be from rppt@kernel.org are

docs-mm-describe-set_memory-and-set_direct_map-apis.patch
docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch
arch-mm-promote-debug_wx-to-check_wx.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

