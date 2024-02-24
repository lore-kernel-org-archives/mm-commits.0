Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E0263AC
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739381; cv=none; b=SubzqlJLx0sJ5o78u6aiD8Wms4Z5hRPI2g3IY186UE/bpA9eMJsRyRK8R6xvWSXm/qOUUEfx97chjnwcKnEHsNQwZDyOEiavxuwHtCSdafGZnTVP+1HK7oGwlGSBB45+GcpZ1WPw/gl9Ewtp6vft3JSSNalcZNXxOM9/rJhncwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739381; c=relaxed/simple;
	bh=UxvOuCtt3BDvKgXo7IaH7tJXd8GoiECAgq+SNpy8XGE=;
	h=Date:To:From:Subject:Message-Id; b=Ll6tBxvP8aNUZULK7cShu3ylqwW4rK+Htb2iKSMHoiqPPMHII+ys+e2ccoHhXNZSwZDlgwWREIhfvStFTysHHgVrMd0Ur7+H6VGLAuDSQ+1i0dpdas+Dil6t478GIvP1++7VI+cuWjuv6eWFazIKysyV2ZfDZlDmKy9HFV/a2Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BR38LEaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BR38LEaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875EFC433F1;
	Sat, 24 Feb 2024 01:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739381;
	bh=UxvOuCtt3BDvKgXo7IaH7tJXd8GoiECAgq+SNpy8XGE=;
	h=Date:To:From:Subject:From;
	b=BR38LEaA2D5fndMj3VaJAGfZIg+Hc979cjbCKCTePp8F7NqC/iMsy9dZ9Ye10Gd92
	 qigmPst1KOh6uXWO+mpU7qnj3YxcTB6QV0qWwj03Vv16XNZ97ii14RiwPIVzhzpr2T
	 m+wRMK2oDTq+NqojRIRdu158mNx7rlIi/XNYhtRU=
Date: Fri, 23 Feb 2024 17:49:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch removed from -mm tree
Message-Id: <20240224014941.875EFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: add a shrinker to drain vmap pools
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: add a shrinker to drain vmap pools
Date: Tue, 2 Jan 2024 19:46:33 +0100

The added shrinker is used to return back current cached VAs into a global
vmap space, when a system enters into a low memory mode.

Link: https://lkml.kernel.org/r/20240102184633.748113-12-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Kazuhito Hagio <k-hagio-ab@nec.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-add-a-shrinker-to-drain-vmap-pools
+++ a/mm/vmalloc.c
@@ -4917,8 +4917,37 @@ static void vmap_init_nodes(void)
 	}
 }
 
+static unsigned long
+vmap_node_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
+{
+	unsigned long count;
+	struct vmap_node *vn;
+	int i, j;
+
+	for (count = 0, i = 0; i < nr_vmap_nodes; i++) {
+		vn = &vmap_nodes[i];
+
+		for (j = 0; j < MAX_VA_SIZE_PAGES; j++)
+			count += READ_ONCE(vn->pool[j].len);
+	}
+
+	return count ? count : SHRINK_EMPTY;
+}
+
+static unsigned long
+vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
+{
+	int i;
+
+	for (i = 0; i < nr_vmap_nodes; i++)
+		decay_va_pool_node(&vmap_nodes[i], true);
+
+	return SHRINK_STOP;
+}
+
 void __init vmalloc_init(void)
 {
+	struct shrinker *vmap_node_shrinker;
 	struct vmap_area *va;
 	struct vmap_node *vn;
 	struct vm_struct *tmp;
@@ -4966,4 +4995,14 @@ void __init vmalloc_init(void)
 	 */
 	vmap_init_free_space();
 	vmap_initialized = true;
+
+	vmap_node_shrinker = shrinker_alloc(0, "vmap-node");
+	if (!vmap_node_shrinker) {
+		pr_err("Failed to allocate vmap-node shrinker!\n");
+		return;
+	}
+
+	vmap_node_shrinker->count_objects = vmap_node_shrink_count;
+	vmap_node_shrinker->scan_objects = vmap_node_shrink_scan;
+	shrinker_register(vmap_node_shrinker);
 }
_

Patches currently in -mm which might be from urezki@gmail.com are


