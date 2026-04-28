Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD2743E4AC
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 13:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382014; cv=none; b=bVB4ld+xOg9Py8x+uRF3GHUk0Em0el9gXZh7sOvLooIiENtlzoorgLifvk0Ze59OVvlGnmqaRw4zQVBIaOQlrNfjvXRM4otlnFq9RBk8YAoIkln8FcDtIXFPdlwPBqXF1Ju3u8YHKCTPpzxExc+PgKtaRfrqaGPj0kDKsv7s6Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382014; c=relaxed/simple;
	bh=fDYouqA6GD/1eeHm8Z2dOkYWWFdiYGeyM279P3YlKYs=;
	h=Date:To:From:Subject:Message-Id; b=MNuN9oRCQFsJP+pid1fWiQ8Ix+ZKVrBR4h/lpiRUuRqtrDW6IY2pIfi1aWooQlZiuK18yPvWZeHvLLeHt5ZmO9V4Rt4msVRMuBpas37WhN01Ml9y2d/6tkzUTt1rhNPjtyofUp6Bkr/5RvnMePh3y3KKNKJX7Y659uVXXfdkuf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G7Tcy7mw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G7Tcy7mw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA5EC2BCAF;
	Tue, 28 Apr 2026 13:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777382014;
	bh=fDYouqA6GD/1eeHm8Z2dOkYWWFdiYGeyM279P3YlKYs=;
	h=Date:To:From:Subject:From;
	b=G7Tcy7mwFnn0VtqAOHcHS5as1mJj1bWhJqfVaALguh9bVXgPSWPw617JZAZpnbCqL
	 jTqQfHMMpHNLn/9qGk09bNqRfQ2CbEOUhB3dTEkC0Ggyw99sK3gYy9XUNQvalNPY/H
	 u+cRzM/3leT0E9m+2MW32A57aU8LiqVeaH4A2uKs=
Date: Tue, 28 Apr 2026 06:13:33 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch removed from -mm tree
Message-Id: <20260428131334.1FA5EC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: fix incorrect altmap passing in error path
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/memory_hotplug: fix incorrect altmap passing in error path
Date: Sun, 26 Apr 2026 17:26:36 +0800

In create_altmaps_and_memory_blocks(), when arch_add_memory() succeeds
with memmap_on_memory enabled, the vmemmap pages are allocated from
params.altmap.  If create_memory_block_devices() subsequently fails, the
error path calls arch_remove_memory() with a NULL altmap instead of
params.altmap.

This is a bug that could lead to memory corruption.  Since altmap is NULL,
vmemmap_free() falls back to freeing the vmemmap pages into the system
buddy allocator via free_pages() instead of the altmap. 
arch_remove_memory() then immediately destroys the physical linear mapping
for this memory.  This injects unowned pages into the buddy allocator,
causing machine checks or memory corruption if the system later attempts
to allocate and use those freed pages.

Fix this by passing params.altmap to arch_remove_memory() in the error
path.

Link: https://lore.kernel.org/20260426092640.375967-3-songmuchun@bytedance.com
Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path
+++ a/mm/memory_hotplug.c
@@ -1469,7 +1469,7 @@ static int create_altmaps_and_memory_blo
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, NULL);
+			arch_remove_memory(cur_start, memblock_size, params.altmap);
 			kfree(params.altmap);
 			goto out;
 		}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-fix-memory-block-reference-leak-on-remove.patch
drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch
drivers-base-memory-fix-locking-for-poison-accounting-lookup.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

