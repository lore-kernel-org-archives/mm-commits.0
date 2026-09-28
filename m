Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2B925333F
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 22:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790636018; cv=none; b=eM375wu42lAe2tgjtbni2Ev2jyuNL2oHcT+L5dEMu+Bg42ErRVwF8NRW8LyWje98IVVI1b+41K+1z3d+exLDgr2XPEAArt5qfZ8lRVQ3D50xrCbOkqtiZi4d8zdlGGxxL163K/zA3cLnEnPskmPYPAtrLy+3t1i5RNlT/biOweE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790636018; c=relaxed/simple;
	bh=pYtiEoiRdHPdnT8F0gfFhiN1MbHaBOdb2+Nqxn38BEs=;
	h=Date:To:From:Subject:Message-Id; b=bV9tMBXXtWveYQN0TMSZXT5a6ng1fmcwxAjGMMniW9mgTgQK9OURk3syw1Bf5iWCD4E4xzCYXOy/MkWeLHDGu0RfTisjYRH4cB/FQxUkMJSlCWu5YKa1Spa+jFlWl6jW2yEhnyEwU2rrqaBWafJU2sK4VW3eJLKDCtXY4ISZ4sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GIe0UyxH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GIe0UyxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5ED1F000FF;
	Mon, 28 Sep 2026 22:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790636016;
	bh=C5GtKXjD65FkQIcjUjbJqB04Em9QhJZNYTVhEXSiF2w=;
	h=Date:To:From:Subject;
	b=GIe0UyxH+j0JgZ1t9DlNpPCSyn8QqlRMZlGTf5mgsR1VyuFIiWna3yChzGJm5tCUJ
	 7Y+d8A8hlml0iQbTfJeXHaLODCNQGUOF+r+34Gi2ni7mOYzz4eG988Q7Ts42rtsZP9
	 nWN21Y6emAafd9QOeER9NPgTfwgNz42sFgWLxrVw=
Date: Mon, 28 Sep 2026 15:53:35 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch added to mm-new branch
Message-Id: <20260928225336.1E5ED1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: fix vmalloc_dump_obj cross-zone VA lookup
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: fix vmalloc_dump_obj cross-zone VA lookup
Date: Mon, 28 Sep 2026 16:15:55 +0800

vmalloc_dump_obj() searches only one vmap node (addr_to_node(addr)), but a
vmalloc allocation may span multiple vmap zones.  The VA is stored in only
one node's rb-tree (addr_to_node(va_start)), so an object pointer in a
different zone than va_start maps to a different node and the search
misses.  This affects any allocation larger than vmap_zone_size (64 KiB)
on multi-CPU systems.

Extract find_vmap_area_lock() from find_vmap_area() to share the
cross-node iteration logic.  The helper supports both spin_lock and
spin_trylock, the latter for atomic dump contexts (OOM, KASAN, RCU).

Link: https://lore.kernel.org/20260928-vmalloc_dump_obj-v4-2-6f288a431edc@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
---

 mm/vmalloc.c |  108 +++++++++++++++++++++++++++++--------------------
 1 file changed, 66 insertions(+), 42 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup
+++ a/mm/vmalloc.c
@@ -2516,67 +2516,94 @@ static void free_unmap_vmap_area(struct
 	free_vmap_area_noflush(va);
 }
 
-struct vmap_area *find_vmap_area(unsigned long addr)
+static inline int next_vmap_node_id(int i)
+{
+	return (i + nr_vmap_nodes - 1) % nr_vmap_nodes;
+}
+
+enum vmap_lock_mode {
+	VMAP_LOCK,
+	VMAP_TRYLOCK,
+};
+
+/*
+ * Search for a vmap_area at @addr across all vmap nodes.  An
+ * addr_to_node_id(addr) converts an address to a node index where
+ * a VA is located. If VA spans several zones and passed addr is not
+ * the same as va->va_start, what is not common, we may need to scan
+ * extra nodes. See an example:
+ *
+ *      <----va---->
+ * -|-----|-----|-----|-----|-
+ *     1     2     0     1
+ *
+ * VA resides in node 1 whereas it spans 1, 2 an 0. If passed addr
+ * is within 2 or 0 nodes we should do extra work.
+ *
+ * Returns the VA with @locked_vn->busy.lock held; the caller must
+ * release it. If @mode is VMAP_TRYLOCK, nodes that cannot be locked
+ * are skipped.
+ */
+static struct vmap_area *
+find_vmap_area_lock(unsigned long addr, struct vmap_node **locked_vn,
+		enum vmap_lock_mode mode)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
 	int i, j;
 
+	*locked_vn = NULL;
+
 	if (unlikely(!vmap_initialized))
 		return NULL;
 
-	/*
-	 * An addr_to_node_id(addr) converts an address to a node index
-	 * where a VA is located. If VA spans several zones and passed
-	 * addr is not the same as va->va_start, what is not common, we
-	 * may need to scan extra nodes. See an example:
-	 *
-	 *      <----va---->
-	 * -|-----|-----|-----|-----|-
-	 *     1     2     0     1
-	 *
-	 * VA resides in node 1 whereas it spans 1, 2 an 0. If passed
-	 * addr is within 2 or 0 nodes we should do extra work.
-	 */
 	i = j = addr_to_node_id(addr);
 	do {
 		vn = &vmap_nodes[i];
 
-		spin_lock(&vn->busy.lock);
-		va = __find_vmap_area(addr, &vn->busy.root);
-		spin_unlock(&vn->busy.lock);
+		if (mode == VMAP_LOCK) {
+			spin_lock(&vn->busy.lock);
+		} else {
+			if (!spin_trylock(&vn->busy.lock))
+				continue;
+		}
 
-		if (va)
+		va = __find_vmap_area(addr, &vn->busy.root);
+		if (va) {
+			*locked_vn = vn;
 			return va;
-	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
+		}
+
+		spin_unlock(&vn->busy.lock);
+	} while ((i = next_vmap_node_id(i)) != j);
 
 	return NULL;
 }
 
-static struct vmap_area *find_unlink_vmap_area(unsigned long addr)
+struct vmap_area *find_vmap_area(unsigned long addr)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
-	int i, j;
 
-	/*
-	 * Check the comment in the find_vmap_area() about the loop.
-	 */
-	i = j = addr_to_node_id(addr);
-	do {
-		vn = &vmap_nodes[i];
-
-		spin_lock(&vn->busy.lock);
-		va = __find_vmap_area(addr, &vn->busy.root);
-		if (va)
-			unlink_va(va, &vn->busy.root);
+	va = find_vmap_area_lock(addr, &vn, VMAP_LOCK);
+	if (va)
 		spin_unlock(&vn->busy.lock);
 
-		if (va)
-			return va;
-	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
+	return va;
+}
 
-	return NULL;
+static struct vmap_area *find_unlink_vmap_area(unsigned long addr)
+{
+	struct vmap_node *vn;
+	struct vmap_area *va;
+
+	va = find_vmap_area_lock(addr, &vn, VMAP_LOCK);
+	if (va) {
+		unlink_va(va, &vn->busy.root);
+		spin_unlock(&vn->busy.lock);
+	}
+
+	return va;
 }
 
 /*** Per cpu kva allocator ***/
@@ -5282,14 +5309,11 @@ bool vmalloc_dump_obj(void *object)
 	unsigned long nr_pages;
 
 	addr = PAGE_ALIGN_DOWN((unsigned long) object);
-	vn = addr_to_node(addr);
-
-	if (!spin_trylock(&vn->busy.lock))
-		return false;
 
-	va = __find_vmap_area(addr, &vn->busy.root);
+	va = find_vmap_area_lock(addr, &vn, VMAP_TRYLOCK);
 	if (!va || !va->vm) {
-		spin_unlock(&vn->busy.lock);
+		if (va)
+			spin_unlock(&vn->busy.lock);
 		return false;
 	}
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch
mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch
mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch
mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch
mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch
mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch
mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch
mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch

