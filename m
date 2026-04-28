Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C8F370D55
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 13:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777384142; cv=none; b=gCSXr+MqkHzhfgIRYeLL/GVmwQS5uXF8v3IFXQbyck1jGSX1CrD+TAmXKSw3KGuNgAHElh3XHGfwNyHIJIcw9NJIlycHuG/h/55qivTDzXunbnEavNfVG9DIUF+UnipqxqCKCo/OfMImajwUCduXohSbPgULZrHTMaFf8Iy83sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777384142; c=relaxed/simple;
	bh=gg6lkjcJjsz27U5zggoQjBHb0GUDpZInG68yvaPjLx8=;
	h=Date:To:From:Subject:Message-Id; b=f9Gn6IpSa/JnbomwSiyjb40RRTcucjonP2WU8+/uN2Ri/oHrLoNUx9h0F/XoWuzHgMLg3CReDMVAiOkBmSvfP5Cdx2563givnP84i0o3vEees7oF93oe/W/aUDgEH8EqeKCE7mhErT7lhyEtLu6p8u2yEc24K3xhQTFVAeyGz+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WsnbdgOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WsnbdgOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29544C2BCAF;
	Tue, 28 Apr 2026 13:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777384142;
	bh=gg6lkjcJjsz27U5zggoQjBHb0GUDpZInG68yvaPjLx8=;
	h=Date:To:From:Subject:From;
	b=WsnbdgOdzJeGhK1+0fyWZMpaSXkKX+tUWY84sDC8APtvqRLpRdPiM2FEATSOWpdZb
	 TjEVmLl335L7WdNYDj6MHrfTEA7rmtyBmaM0sY/d7oUdpRKTV36bJQnUVd5J7zqM6F
	 ZBELmtoB9YMMvoXC1CvRPKvV57H1PhE5fPh4x9ko=
Date: Tue, 28 Apr 2026 06:49:01 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch added to mm-new branch
Message-Id: <20260428134902.29544C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: fix incorrect altmap passing in error path
has been added to the -mm mm-new branch.  Its filename is
     mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/memory_hotplug: fix incorrect altmap passing in error path
Date: Tue, 28 Apr 2026 16:18:51 +0800

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

Link: https://lore.kernel.org/20260428081855.1249045-3-songmuchun@bytedance.com
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
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path
+++ a/mm/memory_hotplug.c
@@ -1470,7 +1470,7 @@ static int create_altmaps_and_memory_blo
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
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

