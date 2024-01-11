Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9C85810C
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W7Zc2w5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24337C433F1;
	Thu, 11 Jan 2024 20:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705005965;
	bh=VpRc4/EpAsCQ5BzfiKAtR075UB7lDG/LryU/bwf6LD0=;
	h=Date:To:From:Subject:From;
	b=W7Zc2w5GRowzpQzvsjmnjl/ny2W3++YNyGdrEpRRhCbOU6qSO/ifIQbZ2NPoWw6aL
	 G7vRMLY8yThGZj4b36l8HjSSinEy9g4pUuJHotNUJRc9qspEtR+ts9HM4sXm5igzd4
	 tyuqL4XuuJNJi73DAlF0dbQwJCqD5X12DWmfYO/k=
Date: Thu, 11 Jan 2024 12:46:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,lkp@intel.com,Liam.Howlett@oracle.com,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch added to mm-unstable branch
Message-Id: <20240111204605.24337C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: mark vmap_init_free_space() with __init tag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch

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
Subject: mm: vmalloc: mark vmap_init_free_space() with __init tag
Date: Thu, 11 Jan 2024 14:26:28 +0100

vmap_init_free_space() is called only once therefore tag it with __init. 
Apart of that it access the "vmlist" variable that is located in
".init.data" section.

Link: https://lkml.kernel.org/r/20240111132628.299644-1-urezki@gmail.com
Fixes: 86817057732 ("mm: vmalloc: remove global vmap_area_root rb-tree")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401112056.I41bELL4-lkp@intel.com/
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix
+++ a/mm/vmalloc.c
@@ -4508,7 +4508,7 @@ module_init(proc_vmalloc_init);
 
 #endif
 
-static void vmap_init_free_space(void)
+static void __init vmap_init_free_space(void)
 {
 	unsigned long vmap_start = 1;
 	const unsigned long vmap_end = ULONG_MAX;
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch
mm-vmalloc-remove-vmap_area_list-fix.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-based-on-cpus-in-a-system.patch
mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch

