Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B6936F8EF;
	Fri, 29 May 2026 04:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027635; cv=none; b=roVYRXfLk75bbpmwJkppzKqD83NsODGj1lZvdqe4zxgd2jpnXqhTw1VtXSTsrbXDypBo7Gqo7VpmqDLOpUWpo6uhxk1pfOMNXmU7DNe8FtPa4utn9g9W2C9Vp3GfzbIxeYwa+AGj2J1vWY1RTinEtexoivIyhGCVIS6w+d7Efis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027635; c=relaxed/simple;
	bh=nSgQbp7PL6uCFyAz2NJQ0VrcpxsG+0bNHbGJ7c09HP0=;
	h=Date:To:From:Subject:Message-Id; b=Z3pfghpZOMWT5oc5U9kfEmXu0OtCsklm/SsJ7yjCqR+GWPOzKVO9ejnbmmLt4i9q3fa3tT/XN7mUA2eejLLLmoiMVvFE8INwY8casdPNtRszYYzmxjiAmD9iGFzW5mVJ4xxBmBccsj0x1E8EdNi2mL8MF0OXDNHNKYnX4fg3PTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LmdPfoNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LmdPfoNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423B81F00893;
	Fri, 29 May 2026 04:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027633;
	bh=+oL9xshrH67n7gsQsKvjmDwhT4HBcS6cNrI0F1sgQJA=;
	h=Date:To:From:Subject;
	b=LmdPfoNCe8LzYmnf7ZQqVu2PxIt+2I8Og9YBB/add8YpJcR+FgVIkM8X68rQMd/Hu
	 77Rlk9d6BDfE6YV/T8vxkW3Q5wEv82mg34AgbCW9mOgDupe7HrGqw9PYDr3NwtFU5g
	 vUQpbBPZV4hq7VMji6YpL4pHfdzgKnmxBGml44vo=
Date: Thu, 28 May 2026 21:07:12 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,joao.m.martins@oracle.com,georgi.djakov@oss.qualcomm.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch removed from -mm tree
Message-Id: <20260529040713.423B81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: fix incorrect altmap passing in error path
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Liam R. Howlett <liam@infradead.org>
Reviewed-by: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
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

mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

