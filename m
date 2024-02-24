Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FD51870
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738699; cv=none; b=r5L7hKvJ7+bUDTdwd8ZgMgaQMjiPg+seg03k+5eH9eYF/cCBY6d4Yc4Jcp9ab6ZPcCPm4gHHg0Ehatl9rA4gfFFU4ZLVzEWXkZfWDS29WV3m9YtQnHeKrsRQsRxEXiiJfyITcA+gGzfosI+p6psCGp11oBb4yfZKEI85+b/0yD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738699; c=relaxed/simple;
	bh=liOfG2O4D4zW3hqtxC+Zwxn+ziioerjsyiAgyzuATjY=;
	h=Date:To:From:Subject:Message-Id; b=YcyCJrCOKmhaQum6nBbH2Lfhn7LR7nxKLUlJy7Vlvl8w7cPtkNm9mitG1yN7RHbHORS/3+ekbv1QDK6LYzTHvqrcEt2RIhGcSfYY/PiofwLxxIq6c1vq6ugpZyagAHLSwzmwBqf9u1qlLzVPDjwtJ+jJP9aIUYFbm8/HKp2aHiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TNhN7yk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TNhN7yk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A98C433C7;
	Sat, 24 Feb 2024 01:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708738699;
	bh=liOfG2O4D4zW3hqtxC+Zwxn+ziioerjsyiAgyzuATjY=;
	h=Date:To:From:Subject:From;
	b=TNhN7yk+ztEY6zxi5DKByGMoQHsRre+QH+5yPr9bs99mvxuaxOw1mp6R7kFqE+rcF
	 rREo9hQhiEXQLi5CHStLO9ziban8leXb1lb1IHFOcyUoAKkR0N5pczyhdxMXvETYLS
	 NlpvBnnpUgTUkBGaH4OEFRGjwJ5eDcz9HldB5JY8=
Date: Fri, 23 Feb 2024 17:38:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,lkp@intel.com,Liam.Howlett@oracle.com,hch@lst.de,david@fromorbit.com,bhe@redhat.com,anshuman.khandual@arm.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch removed from -mm tree
Message-Id: <20240224013819.02A98C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: mark vmap_init_free_space() with __init tag
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch

This patch was dropped because it was folded into mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: mark vmap_init_free_space() with __init tag
Date: Thu, 11 Jan 2024 14:26:28 +0100

vmap_init_free_space() is called only once therefore tag it with __init. 
Apart of that it access the "vmlist" variable that is located in
".init.data" section.

Link: https://lkml.kernel.org/r/20240111132628.299644-1-urezki@gmail.com
Fixes: 86817057732a ("mm: vmalloc: remove global vmap_area_root rb-tree")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401112056.I41bELL4-lkp@intel.com/
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
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

