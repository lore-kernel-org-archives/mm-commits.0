Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6377143B6CD
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 06:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453166; cv=none; b=lFWUHzgNj2fwyAx61jwM4HBFaUkd6mG2a3JUUG6qs0ETrCHEV12gqcSoNbNdWjC/8GC2O57KUmVQ23lxKlj2SoDyH9l8O1Wn/x5fFXcr3y08UEIRyd4wfrxlFjqxGpo96yoz9cm6UrYRUyajsJNuBCqdTCBePF9Qfh3pkVNJ07s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453166; c=relaxed/simple;
	bh=32tbI3Ij5tfdk6rjcaD4Nc9M6T86WCEMaVkFJok6t4w=;
	h=Date:To:From:Subject:Message-Id; b=rJD2rqb/TmqiXaHOuVTfFREVcMFn6a5jB7ruWf+coIxsQnNpxjxQ4xJ0LAHWF0iK/lwgPOFvAFJJ83TBgwFCapcjGtEi2bk5D2G738PMbjaCFoYdPsmwa/8OIIBTRzW2lb9vYoukBGzt/XxNOIKkpJtwJ+3dnyG/UFnD3IScUoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1eD3WyAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1eD3WyAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF6C1F000FF;
	Tue, 15 Sep 2026 06:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789453165;
	bh=+E7LE8TiifM0Nm43WBf8r3URYmzBSVj1mOGX/fztUUo=;
	h=Date:To:From:Subject;
	b=1eD3WyAN9a4Zwp2RqHzAI26ZTIye+4x94LsYRgxyGd/pSt6bYHvRFRYa2OR7duQZF
	 NGzlUcNfyTwMfLQtgCm9nQV396aAgLX+RZo99jMcPluBpFjUANnn8csHTYpb6Pdhfh
	 snhvia67QwT+GzfvEftg993JouQohu/6RHP4hJTw=
Date: Mon, 14 Sep 2026 23:19:24 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-extract-vmap_insert_free_area-helper.patch removed from -mm tree
Message-Id: <20260915061925.0CF6C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: extract vmap_insert_free_area helper
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-extract-vmap_insert_free_area-helper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: extract vmap_insert_free_area helper
Date: Mon, 14 Sep 2026 11:34:01 +0800

The allocation and insertion of a free vmap_area is duplicated between the
loop body and the tail of vmap_init_free_space.  Factor it into a small
helper so the main function only deals with computing the free gaps
between busy regions.

Link: https://lore.kernel.org/20260914-vmalloc_study-v1-2-526f68559706@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/vmalloc.c |   41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-vmap_insert_free_area-helper
+++ a/mm/vmalloc.c
@@ -5439,11 +5439,23 @@ module_init(proc_vmalloc_init);
 
 #endif
 
+static void __init vmap_insert_free_area(unsigned long start, unsigned long end)
+{
+	struct vmap_area *free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
+
+	if (!WARN_ON_ONCE(!free)) {
+		free->va_start = start;
+		free->va_end = end;
+		insert_vmap_area_augment(free, NULL,
+					 &free_vmap_area_root,
+					 &free_vmap_area_list);
+	}
+}
+
 static void __init vmap_init_free_space(void)
 {
 	unsigned long vmap_start = 1;
 	const unsigned long vmap_end = ULONG_MAX;
-	struct vmap_area *free;
 	struct vm_struct *busy;
 
 	/*
@@ -5453,32 +5465,15 @@ static void __init vmap_init_free_space(
 	 *  |<--------------------------------->|
 	 */
 	for (busy = vmlist; busy; busy = busy->next) {
-		if ((unsigned long) busy->addr - vmap_start > 0) {
-			free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
-			if (!WARN_ON_ONCE(!free)) {
-				free->va_start = vmap_start;
-				free->va_end = (unsigned long) busy->addr;
-
-				insert_vmap_area_augment(free, NULL,
-					&free_vmap_area_root,
-						&free_vmap_area_list);
-			}
-		}
+		if ((unsigned long)busy->addr - vmap_start > 0)
+			vmap_insert_free_area(vmap_start,
+					      (unsigned long)busy->addr);
 
 		vmap_start = (unsigned long) busy->addr + busy->size;
 	}
 
-	if (vmap_end - vmap_start > 0) {
-		free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
-		if (!WARN_ON_ONCE(!free)) {
-			free->va_start = vmap_start;
-			free->va_end = vmap_end;
-
-			insert_vmap_area_augment(free, NULL,
-				&free_vmap_area_root,
-					&free_vmap_area_list);
-		}
-	}
+	if (vmap_end - vmap_start > 0)
+		vmap_insert_free_area(vmap_start, vmap_end);
 }
 
 static void vmap_init_nodes(void)
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch
tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch
mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch
mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch
mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch

