Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6351A5810E
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jgwD2dZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE631C433F1;
	Thu, 11 Jan 2024 20:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705006153;
	bh=TjLg+QlIR+vdl/7i48LJiC0Z3rz1dbDUqaEJ2mHuv1c=;
	h=Date:To:From:Subject:From;
	b=jgwD2dZfdHyelm2CgdNwGNljVvMlphH9tp5AoW829905G3sieD7NJto5H1ecgybyc
	 XtFgZMZuqu/HAdv+/jWB/aewYs4jhpGT228pNxv33ZIeRTHD+QzfZx8yTpSLaGiROK
	 KoviOYA6HWMrKitOZAULuZDvqkje36m+Fdp5OXis=
Date: Thu, 11 Jan 2024 12:49:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,oleksiy.avramchenko@sony.com,nathan@kernel.org,lstoakes@gmail.com,lkp@intel.com,Liam.Howlett@oracle.com,hch@infradead.org,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix-2.patch added to mm-unstable branch
Message-Id: <20240111204913.CE631C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fix a wrong value passed to __find_vmap_area()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix-2.patch

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
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix-2.patch
mm-vmalloc-remove-vmap_area_list-fix.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-based-on-cpus-in-a-system.patch
mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch

