Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896E21870
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738700; cv=none; b=CPnmy1n46ZwesoTxGbKjSXB2Urxm39I1Ynrel8zMg1CXmTCTiDTNJlYVnVmfAe+/GHH8f0JvSTE2N1qyObs14IqpKMncV4iadsAFznSSQbFCG0b8obMw/yrRqUCZ5MPMO/wHszWZlAJdaFZXwgspEYvr7eZHeit16rrN2aOvE+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738700; c=relaxed/simple;
	bh=YTlH+OcqqAEMgfiCyP0fn5xSpwQ5LH0ZXfmqN1gSmO4=;
	h=Date:To:From:Subject:Message-Id; b=YzEMb7I4VgF8CqdLU3P1fl2/eXqNFgOpHrei+GMJkLi5pxAzFlI0XV4IvoFCPTZ+BJoQfo0LdSatKv/iVO4Nc4/J1GMNyTdy5uGSYO4qRQ0ahUb5EvNRpCtJF9PYOgCFgdYoyjw8ifuIXTNvDdJJYi1JYSK8a5J65eJj10iNBZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W1Cr7Tla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W1Cr7Tla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DCBC43394;
	Sat, 24 Feb 2024 01:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708738700;
	bh=YTlH+OcqqAEMgfiCyP0fn5xSpwQ5LH0ZXfmqN1gSmO4=;
	h=Date:To:From:Subject:From;
	b=W1Cr7TlaG6rAzdo8tEIGvXrwbH8TSCsWKaxVekHEAXmiQEtB4OJKG04vLca/teR/j
	 AIxG0shOqEx0hCnayPA5b/mZBLrR9A/xen2esO8ciXFTxYuF6zov++nnYeFSh3ZuT5
	 KH/7qHEVRJHLgVxoWJU+3Ng7HJIqG7qi7BnLl0Q0=
Date: Fri, 23 Feb 2024 17:38:19 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,oleksiy.avramchenko@sony.com,nathan@kernel.org,lstoakes@gmail.com,lkp@intel.com,Liam.Howlett@oracle.com,hch@infradead.org,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix-2.patch removed from -mm tree
Message-Id: <20240224013820.54DCBC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fix a wrong value passed to __find_vmap_area()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix-2.patch

This patch was dropped because it was folded into mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: fix a wrong value passed to __find_vmap_area()
Date: Thu, 11 Jan 2024 13:11:04 +0100

There was a typo in the vmalloc_dump_obj() function.  Instead of passing a
real address which is "objp" an "addr" was used what is wrong and not
initialized.

Link: https://lkml.kernel.org/r/20240111121104.180993-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 86817057732a ("mm: vmalloc: remove global vmap_area_root rb-tree")
Closes: https://lore.kernel.org/oe-kbuild-all/202401111810.TKPIXLCs-lkp@intel.com/
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix-2
+++ a/mm/vmalloc.c
@@ -4342,7 +4342,7 @@ bool vmalloc_dump_obj(void *object)
 	vn = addr_to_node((unsigned long)objp);
 
 	if (spin_trylock(&vn->busy.lock)) {
-		va = __find_vmap_area(addr, &vn->busy.root);
+		va = __find_vmap_area((unsigned long)objp, &vn->busy.root);
 
 		if (va && va->vm) {
 			addr = (unsigned long)va->vm->addr;
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-vmap_area_list-fix.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-offload-free_vmap_area_lock-lock-fix.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-based-on-cpus-in-a-system.patch
mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch
mm-vmalloc-improve-description-of-vmap-node-layer.patch
mm-vmalloc-refactor-vmalloc_dump_obj-function.patch

