Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832301;
	b=w3BkzJpm6APIel6IPn9BBZkLjGVyv4lhiLY80JnzeORE8ZmLx79ki9+8a8xF+NZvQTOm
	 yMkSZH39RZ0VQlgc8P6NnXVSw5rxpoHIDZfXMsYUCKKPTZNax4tWS8i2M0pKu+2vgh3MX
	 LzgRJsEyy5wJqcuRi1Ocsmkg+doW6coLBHb36wupfk/vTJnYsM/kH2HG6xB85vWyR6RW2
	 dgikAI/M0HNQ0P9Z1s1rj9hNulD/8pd2rrhU2tDnqmRJ9iHTC0G+FRPIcSBuqaL7YlDgi
	 +ZBHND2/gOZnA5WRTGpp1mNF28QbN/nmPitZ6XoTU/Dnbpn+By+FoFjvarG08bMa3Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832301;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=eVgRLJu/xuz/mNb1CtLTy9oaf+5r/Eea8C6PDyPmZS0=;
	b=pSsSa9/U7yqriDF37/IHERQhTNrQe0Nmy+LBRJYA3T8WmzVzqdf+iipj84qLRFAbcpZp
	 3AiPvnWNkP1BbP0jzt1yrKCNSRF2LpSYRPLq9gxnzuZdrGRbcRj7WjcxuG63kOG/71Hll
	 OwVQ4aLElDq/Nll6Rh8bGZO/j6I01lLxdoznAcPo9xa+CgBmTuSDtnkoIbXKWi8LVSSMq
	 7Kt26iR/LUhhJeowiVqAcKgmGmdQvVLFD1DG+zpwnYTIbeH/hRO2VSBk2a/DIJ1b6nQw6
	 6HfZECbCsJBOwShspLQtr9Au9WlKUmaPVMNXqVD51luL1woWyVLdGQReD2lwBK05M8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Y7PDB/oW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CF6606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y7PDB/oW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E751F01825;
	Sat, 24 Oct 2026 08:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832300;
	bh=eVgRLJu/xuz/mNb1CtLTy9oaf+5r/Eea8C6PDyPmZS0=;
	h=Date:To:From:Subject;
	b=Y7PDB/oW7AxVltpKryjvg8OfkUU3y3ZyDymos4GW81nodEHtLmmF/MIWnR/lDkJZ9
	 Nso6bv3LvD+zjSs/QRyZHMoUa/86oeE70sBM50wrYtwPfVufrTMV5PHom+WEj8XUGI
	 LpqLq384uDFZfnM9g4N+5mP/h4T+0VBjJ0BnwIAQ=
Date: Sat, 24 Oct 2026 01:58:20 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch removed from -mm tree
Message-Id: <20261024085820.91E751F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vmalloc: fix vmalloc_dump_obj cross-zone VA lookup
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2503,67 +2503,94 @@ static void free_unmap_vmap_area(struct
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
@@ -5269,14 +5296,11 @@ bool vmalloc_dump_obj(void *object)
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


