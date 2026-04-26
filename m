Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C0F37BE7D;
	Sun, 26 Apr 2026 19:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777233287; cv=none; b=T6I9XOvL5Q5n1Q8MeWmZnlBYvtH4uKTBpg8dA0CaLGkD1k5F5lbH8rruxFnJq+j2JeVVq6E2XC5p8+264rxfNRYzr51WGJnhBkZUBGWhGLWMMRzf/Efngd7x/JCtPVp06JNcPx45kp2H/MlcCtW7ZwgrNFkq6VNJbL3dyivNdys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777233287; c=relaxed/simple;
	bh=3/bt0Nrq1HoyOJ+6zLl4F3BQRUYkONWlF2cbteo/YIU=;
	h=Date:To:From:Subject:Message-Id; b=lZXGl6xtnEDONAxsC4Z3dsvUJOqt2OzAFYPT+ZfdVZg/pPxOu1B0fExL7ZjbPrXHZKMJG+LGu5KhxdIQ84yfOgrTz6zsj7OOqqmnV3QRgmr6tNtls1bLiT/CRUJ1JKOVG3caL0nibD6IEOd3VXuYNDOmb+WpmHSe1DSI5ILLBjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U5zreVdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U5zreVdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D613DC2BCAF;
	Sun, 26 Apr 2026 19:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777233286;
	bh=3/bt0Nrq1HoyOJ+6zLl4F3BQRUYkONWlF2cbteo/YIU=;
	h=Date:To:From:Subject:From;
	b=U5zreVdcjSlrvgOBwUDnXJf/MhRQQ2/pbrOFCFLyfgIJwHBOzV58FkNteTa7wJGGu
	 cjP6ZNE2XMzk3FBe/AwL8yzqLoqj4TkQFQgd3VC1tUU7XH2ba1OoaMw4ndCYl6YKrT
	 oQe8W2aD40qNIC58UpoZXyuurGf0ngb5Lq1xGc6M=
Date: Sun, 26 Apr 2026 12:54:46 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,joao.m.martins@oracle.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch added to mm-new branch
Message-Id: <20260426195446.D613DC2BCAF@smtp.kernel.org>
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
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

