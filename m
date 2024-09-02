Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6754A0F;
	Mon,  2 Sep 2024 00:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238778; cv=none; b=bJ/Z/gs+OfSDe0D6EzyGAxrOKuh7TdG6veXklrBeCd9TAsYMEL70PD/y4QU2LeIoB1BcVMIHySfU6UrL0IP9jAZPpl66G4gPKr4VUDZWkR9qzP4Vtf+Qp8HU/pXlJEq7TFEKEXlBM6BYlMJmNkdd0M0Ysq0ngPHCWqG0DWMnhYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238778; c=relaxed/simple;
	bh=nExsIZU5E9kONaUw+9NKvM2hVVn26gqYAgyR5ssWLq8=;
	h=Date:To:From:Subject:Message-Id; b=owdRqIKJ3V7w5UmoTsXRimKbHdusjZCFRA1PLDE5sTQfjqCwOpHycyT/V9hNRgyAOSqzmGcpHJCxy/di/6p3Q62L6WtkR3ObEOpN9HdFn2v6AydyTmwm6t3qMoXgnusK4msgW1VmFj73TPl43NmoGEYYZHcykWWfz9dz/5/t5oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RqLCfvWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RqLCfvWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D119C4CEC3;
	Mon,  2 Sep 2024 00:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238778;
	bh=nExsIZU5E9kONaUw+9NKvM2hVVn26gqYAgyR5ssWLq8=;
	h=Date:To:From:Subject:From;
	b=RqLCfvWtWgH4C/Tdv0Qo+ZDX7MxysQMWuhKPnv4SQs46LIDKZhPFO3tSyrGFNdemY
	 JFTlsD+/lWAvkDbF9vkoOnow0eV4am7JTQOKflOyWn4ymPly4mjYHYWt7xuPF9xjmz
	 uoB/szCwHPVxc+0bLVVfUFDbEQfLngvNIpXnQ1wY=
Date: Sun, 01 Sep 2024 17:59:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,kent.overstreet@linux.dev,kees@kernel.org,iamjoonsoo.kim@lge.com,cl@linux.com,42.hyeyoo@gmail.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-slub-add-check-for-s-flags-in-the-alloc_tagging_slab_free_hook.patch removed from -mm tree
Message-Id: <20240902005938.5D119C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/slub: add check for s->flags in the alloc_tagging_slab_free_hook
has been removed from the -mm tree.  Its filename was
     mm-slub-add-check-for-s-flags-in-the-alloc_tagging_slab_free_hook.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/slub: add check for s->flags in the alloc_tagging_slab_free_hook
Date: Fri, 16 Aug 2024 09:33:36 +0800

When enable CONFIG_MEMCG & CONFIG_KFENCE & CONFIG_KMEMLEAK, the following
warning always occurs,This is because the following call stack occurred:
mem_pool_alloc
    kmem_cache_alloc_noprof
        slab_alloc_node
            kfence_alloc

Once the kfence allocation is successful,slab->obj_exts will not be empty,
because it has already been assigned a value in kfence_init_pool.

Since in the prepare_slab_obj_exts_hook function,we perform a check for
s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE),the alloc_tag_add function
will not be called as a result.Therefore,ref->ct remains NULL.

However,when we call mem_pool_free,since obj_ext is not empty, it
eventually leads to the alloc_tag_sub scenario being invoked.  This is
where the warning occurs.

So we should add corresponding checks in the alloc_tagging_slab_free_hook.
For __GFP_NO_OBJ_EXT case,I didn't see the specific case where it's using
kfence,so I won't add the corresponding check in
alloc_tagging_slab_free_hook for now.

[    3.734349] ------------[ cut here ]------------
[    3.734807] alloc_tag was not set
[    3.735129] WARNING: CPU: 4 PID: 40 at ./include/linux/alloc_tag.h:130 kmem_cache_free+0x444/0x574
[    3.735866] Modules linked in: autofs4
[    3.736211] CPU: 4 UID: 0 PID: 40 Comm: ksoftirqd/4 Tainted: G        W          6.11.0-rc3-dirty #1
[    3.736969] Tainted: [W]=WARN
[    3.737258] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
[    3.737875] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    3.738501] pc : kmem_cache_free+0x444/0x574
[    3.738951] lr : kmem_cache_free+0x444/0x574
[    3.739361] sp : ffff80008357bb60
[    3.739693] x29: ffff80008357bb70 x28: 0000000000000000 x27: 0000000000000000
[    3.740338] x26: ffff80008207f000 x25: ffff000b2eb2fd60 x24: ffff0000c0005700
[    3.740982] x23: ffff8000804229e4 x22: ffff800082080000 x21: ffff800081756000
[    3.741630] x20: fffffd7ff8253360 x19: 00000000000000a8 x18: ffffffffffffffff
[    3.742274] x17: ffff800ab327f000 x16: ffff800083398000 x15: ffff800081756df0
[    3.742919] x14: 0000000000000000 x13: 205d344320202020 x12: 5b5d373038343337
[    3.743560] x11: ffff80008357b650 x10: 000000000000005d x9 : 00000000ffffffd0
[    3.744231] x8 : 7f7f7f7f7f7f7f7f x7 : ffff80008237bad0 x6 : c0000000ffff7fff
[    3.744907] x5 : ffff80008237ba78 x4 : ffff8000820bbad0 x3 : 0000000000000001
[    3.745580] x2 : 68d66547c09f7800 x1 : 68d66547c09f7800 x0 : 0000000000000000
[    3.746255] Call trace:
[    3.746530]  kmem_cache_free+0x444/0x574
[    3.746931]  mem_pool_free+0x44/0xf4
[    3.747306]  free_object_rcu+0xc8/0xdc
[    3.747693]  rcu_do_batch+0x234/0x8a4
[    3.748075]  rcu_core+0x230/0x3e4
[    3.748424]  rcu_core_si+0x14/0x1c
[    3.748780]  handle_softirqs+0x134/0x378
[    3.749189]  run_ksoftirqd+0x70/0x9c
[    3.749560]  smpboot_thread_fn+0x148/0x22c
[    3.749978]  kthread+0x10c/0x118
[    3.750323]  ret_from_fork+0x10/0x20
[    3.750696] ---[ end trace 0000000000000000 ]---

Link: https://lkml.kernel.org/r/20240816013336.17505-1-hao.ge@linux.dev
Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/slub.c~mm-slub-add-check-for-s-flags-in-the-alloc_tagging_slab_free_hook
+++ a/mm/slub.c
@@ -2116,6 +2116,10 @@ alloc_tagging_slab_free_hook(struct kmem
 	if (!mem_alloc_profiling_enabled())
 		return;
 
+	/* slab->obj_exts might not be NULL if it was created for MEMCG accounting. */
+	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
+		return;
+
 	obj_exts = slab_obj_exts(slab);
 	if (!obj_exts)
 		return;
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-cma-change-the-addition-of-totalcma_pages-in-the-cma_init_reserved_mem.patch

