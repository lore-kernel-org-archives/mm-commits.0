Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A0DC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011073; cv=none; b=YDxxJVTTIooT5c6FPmefpH3XpZbBrOAuk3Kfpwn64iJlRlfvijN7dRTNZEfBmbyN5AzwfLsVMUDVCX8iCbTeCrL+i+E1ml0OTUXswaxTyucUIuWRw2/PNLS0ccWfTaix1ZNOX1sWoWsXykxIedcg9w+VRCuZYTKuShmO6/efZE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011073; c=relaxed/simple;
	bh=aJ1MLluCyQMfDwqGiKI9O/qCrct2Mc3t/TV4Fq/lpr4=;
	h=Date:To:From:Subject:Message-Id; b=jFtlBx9wTp7CJYyZMZZUoJsPqUbT2nCiaCXdvPNwm48iBem3z5IqCeobLoSEu1/qNU3fdOjcQ8TRZ0S6wCxrmI406PHTldSNAmjZ2CJCSosERUN8jR7r9evGWnPVk4fwI09BND6RShCsdawHifT3vAJleai1B2z/t2PW0NMFRlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DD47V7cA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DD47V7cA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA146C4CEE4;
	Mon, 12 May 2025 00:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011073;
	bh=aJ1MLluCyQMfDwqGiKI9O/qCrct2Mc3t/TV4Fq/lpr4=;
	h=Date:To:From:Subject:From;
	b=DD47V7cAHwrPD+/aXmh6ydDnsqo34K7FRWXDEn2xKqWaEjbWnLbQEofNVxdRTeAYu
	 Nh3jz0D22mxOsM3awCXwU4+VnYiuz5dhaoh7NSwdZ2KpJbOGIuc6Mgh6y9G+4zHJ39
	 S5OsGd25UqoJW1ii5HdPZUWgidh7uxeLy+Eooe3s=
Date: Sun, 11 May 2025 17:51:12 -0700
To: mm-commits@vger.kernel.org,hch@infradead.org,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch removed from -mm tree
Message-Id: <20250512005112.EA146C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: use for_each_vmap_node() in purge-vmap-area
has been removed from the -mm tree.  Its filename was
     vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: vmalloc: use for_each_vmap_node() in purge-vmap-area
Date: Tue, 8 Apr 2025 17:15:49 +0200

Update a __purge_vmap_area_lazy() to use introduced helper.  This is last
place in vmalloc code.  Also this patch introduces an extra function which
is node_to_id() that converts a vmap_node pointer to an index in array.

__purge_vmap_area_lazy() requires that extra function.

Link: https://lkml.kernel.org/r/20250408151549.77937-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~vmalloc-use-for_each_vmap_node-in-purge-vmap-area
+++ a/mm/vmalloc.c
@@ -923,6 +923,19 @@ id_to_node(unsigned int id)
 	return &vmap_nodes[id % nr_vmap_nodes];
 }
 
+static inline unsigned int
+node_to_id(struct vmap_node *node)
+{
+	/* Pointer arithmetic. */
+	unsigned int id = node - vmap_nodes;
+
+	if (likely(id < nr_vmap_nodes))
+		return id;
+
+	WARN_ONCE(1, "An address 0x%p is out-of-bounds.\n", node);
+	return 0;
+}
+
 /*
  * We use the value 0 to represent "no node", that is why
  * an encoded value will be the node-id incremented by 1.
@@ -2259,9 +2272,7 @@ static bool __purge_vmap_area_lazy(unsig
 	 */
 	purge_nodes = CPU_MASK_NONE;
 
-	for (i = 0; i < nr_vmap_nodes; i++) {
-		vn = &vmap_nodes[i];
-
+	for_each_vmap_node(vn) {
 		INIT_LIST_HEAD(&vn->purge_list);
 		vn->skip_populate = full_pool_decay;
 		decay_va_pool_node(vn, full_pool_decay);
@@ -2280,7 +2291,7 @@ static bool __purge_vmap_area_lazy(unsig
 		end = max(end, list_last_entry(&vn->purge_list,
 			struct vmap_area, list)->va_end);
 
-		cpumask_set_cpu(i, &purge_nodes);
+		cpumask_set_cpu(node_to_id(vn), &purge_nodes);
 	}
 
 	nr_purge_nodes = cpumask_weight(&purge_nodes);
_

Patches currently in -mm which might be from urezki@gmail.com are

maintainers-add-myself-as-vmalloc-co-maintainer.patch

