Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD3D32C7A
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 06:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fyJmCGCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359C0C43390;
	Wed, 10 Jan 2024 06:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704867817;
	bh=HC9SmIQOHb9zUtA3bF1M6Vmw/4G8+xbPv6bUmdToiW8=;
	h=Date:To:From:Subject:From;
	b=fyJmCGCQkwr0770cc6B46ySZOYeR3LQLCJ1ytS/27oP9YGyptfE2IQYUequMD8Vi1
	 +H5xXt56ak1/ElfJiwfnRfseoAaObnSiI7tziABEqgY6ypVZgzDdXa1b6TmE/1ABwj
	 TYe32zvXzj5nm1SR6gQRVyoE2rVxK++C6z46sdp8=
Date: Tue, 09 Jan 2024 22:23:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch added to mm-unstable branch
Message-Id: <20240110062337.359C0C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: add a shrinker to drain vmap pools
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-based-on-cpus-in-a-system.patch
mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch

