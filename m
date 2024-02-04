Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B768C9473
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031240; cv=none; b=Xy9QapL4B7Qn9Zl/4HhzxWxJHXlA40OI6E/qhX2cCSN6rfzIEZ1+mgEXLM/stShtbnHGga55Wh4oQ4mAvmDOZhh6sMauDxjfwWg0Mdj6iVsNqbJ6fnCQPd7LukHYOceYP9T/8e5+QQ0u7i1ttIDnHgq7zDX/Dan94n+kKUqE8i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031240; c=relaxed/simple;
	bh=D5YvcfP8LwvizFGDoL7pfdWmXYTesuaIBkkplNMwJvE=;
	h=Date:To:From:Subject:Message-Id; b=bpYqQIVcgPZLBtCj36QEMvXvi77JQoGPth7+ZtluD9O8Yq1zQbcFaMnNZoSRDF8GWoeooJ9s1hjVh3P3D1h1pIT1bVEgb85fBp9xYkvVnfF1TBCZlgvQPGWf8zjhySw0kMpO525n9BPgQb3YP3Y0fPJ/nxdtu3sAvBMVSnH+VWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qFhf0a3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qFhf0a3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB37C433A6;
	Sun,  4 Feb 2024 07:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031240;
	bh=D5YvcfP8LwvizFGDoL7pfdWmXYTesuaIBkkplNMwJvE=;
	h=Date:To:From:Subject:From;
	b=qFhf0a3xmlfNdmQZG9m/+1BMiZuhzo26Qid/1oy+dD0KATNApya61uH+5RDBMBNuD
	 0EnZ/W2hF0IFAyTnBrnvmNJAPyIdv0iGP0rnmZYG3n3pSqmz0Lex99rG8f15TOHVZm
	 AZ48lEA2pirKejzF3pQi6zyAoOhh4gx+oPlsGovs=
Date: Sat, 03 Feb 2024 23:20:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-offload-free_vmap_area_lock-lock-fix.patch added to mm-unstable branch
Message-Id: <20240204072040.2CB37C433A6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: add a scan area of VA only once
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-offload-free_vmap_area_lock-lock-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-offload-free_vmap_area_lock-lock-fix.patch

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
Subject: mm: vmalloc: add a scan area of VA only once
Date: Fri, 2 Feb 2024 20:06:28 +0100

Invoke a kmemleak_scan_area() function only for newly allocated objects to
add a scan area within that object.  There is no reason to add a same scan
area(pointer to beginning or inside the object) several times.  If a VA is
obtained from the cache its scan area has already been associated.

Link: https://lkml.kernel.org/r/20240202190628.47806-1-urezki@gmail.com
Fixes: 7db166b4aa0d ("mm: vmalloc: offload free_vmap_area_lock lock")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kazuhito Hagio <k-hagio-ab@nec.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-offload-free_vmap_area_lock-lock-fix
+++ a/mm/vmalloc.c
@@ -1834,13 +1834,13 @@ static struct vmap_area *alloc_vmap_area
 		va = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);
 		if (unlikely(!va))
 			return ERR_PTR(-ENOMEM);
-	}
 
-	/*
-	 * Only scan the relevant parts containing pointers to other objects
-	 * to avoid false negatives.
-	 */
-	kmemleak_scan_area(&va->rb_node, SIZE_MAX, gfp_mask);
+		/*
+		 * Only scan the relevant parts containing pointers to other objects
+		 * to avoid false negatives.
+		 */
+		kmemleak_scan_area(&va->rb_node, SIZE_MAX, gfp_mask);
+	}
 
 retry:
 	if (addr == vend) {
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix-2.patch
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

