Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD182DF13B;
	Thu, 14 May 2026 00:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778719241; cv=none; b=bjljLrcFioblP+TMFkFD7uq09LnIcE6RzmpFjiQRd9GiYCpuCrBJmQnuibL3hdGGPKTYdY9OYlWXAtB+hLb+M15QG0k5LQ+YGdxQpPoVvNzCpkv22oHWhzHORjJyySNsar/jboDCrYaXe1ffKyIJfwQP0gNzO/t3WsLAWL/Uibw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778719241; c=relaxed/simple;
	bh=enMeri4ZgBUuSEv4ae3VQT2Qs8Bq+/pwXBTYa+imw+Q=;
	h=Date:To:From:Subject:Message-Id; b=GU4tMOkov6bQLO/H7kSsejL6XiWB1nngE7Pxor0oBoRb9G1QgHbngUg4o7ihphKwI+n7BaOBbYfC/ntSXgeq7Gy7nKC2120bTrB/d2/4RCHef5UTXRVOsfUXbMDnqRyuQlW1fP+zY2ykORGwVr/EINwBm71v0z3B11An62PQ0Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rqY98pnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rqY98pnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A549AC19425;
	Thu, 14 May 2026 00:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778719241;
	bh=enMeri4ZgBUuSEv4ae3VQT2Qs8Bq+/pwXBTYa+imw+Q=;
	h=Date:To:From:Subject:From;
	b=rqY98pntx/Qqq1Hhovh2+llUWj3/w0KxHON1hw6JK+pepIR874qvO4VupnQJ46OLO
	 VkPK2IIoLP/pIyN83LCAN3UXposDjMs7WIJivVqQ3EvoheNe+gWMMYXSlGRbaC9yRm
	 RZYZcmU+ipPhAWHnzBkXrsAwX+VUAPOojIo7x5bA=
Date: Wed, 13 May 2026 17:40:41 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,huang.ying.caritas@gmail.com,gregkh@linuxfoundation.org,david@kernel.org,dakr@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory_hotplug-fix-memory-block-reference-leak-on-remove.patch removed from -mm tree
Message-Id: <20260514004041.A549AC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: fix memory block reference leak on remove
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-memory-block-reference-leak-on-remove.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/memory_hotplug: fix memory block reference leak on remove
Date: Tue, 28 Apr 2026 16:52:17 +0800

Patch series "mm: Fix memory block leaks and locking", v2.

This series fixes two memory block device reference leaks and one locking
issue around the per-memory_block hwpoison counter.


This patch (of 2):

remove_memory_blocks_and_altmaps() looks up each memory block with
find_memory_block(), which acquires a reference to the memory block
device.

That reference is never dropped on this path, resulting in a leaked device
reference when removing memory blocks and their altmaps.  Drop the
reference after retrieving mem->altmap and clearing mem->altmap, before
removing the memory block device.

Link: https://lore.kernel.org/20260428085219.1316047-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20260428085219.1316047-2-songmuchun@bytedance.com
Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-memory-block-reference-leak-on-remove
+++ a/mm/memory_hotplug.c
@@ -1422,6 +1422,8 @@ static void remove_memory_blocks_and_alt
 
 		altmap = mem->altmap;
 		mem->altmap = NULL;
+		/* drop the ref. we got via find_memory_block() */
+		put_device(&mem->dev);
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

