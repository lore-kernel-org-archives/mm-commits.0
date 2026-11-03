Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672156;
	b=fOnJQp8LhN92hmvrp+0GeFGLJT9p2+MkgTJMzmPVplv9T0QBcfi3IA8S84ZPIftwU6CR
	 MJcOPw/3NIZC8oo7lJRSu4C/RHdI4RFP30BbXm/jY1A8gYfnpv2lHSrh5eZKvthWpRCuZ
	 1io2ZSuSPgDvP7ROt7/NKQyQkOD2j9H3AQgq5DYyfNjkkrl4cruR9/FHPcyVu8XX1eu7X
	 kHWfYhzGFk3sOuQ5CZQbGfaPkAwLqjIyzfTG5kq3BqyNOFHmjTBaAwaTjR4eQkrdWA1an
	 ve1qzu9EKjnnukPjccfbTIgg2Z5r6XRcnBNYJnM/LhU1RLCJy8a6ObXP7dP/auacskA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672156;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=BGYyPx1YuZJJaW3M9cOvIiHYHFUtkIs96uyQ7c9gMvU=;
	b=TXY8ltSDfbjmd+jrz1L9NJSfwqf3MmK9Cfb/RFnNMTC2DvmgRodGFxnjURUxiat0EZW4
	 3Za0FJfwZx8jH9tnqYskd2vHJuTbVFc4fU7cU6WGTZ4qJnBPOaVUFvwCfwGmTDB9Oi8LQ
	 xKXUN+r7tbnCvgNwO62XkFnUuaHsdtzSy/HOFzB4WZJ/nNrHoEJtmve6PcfPPIvcSB6Mi
	 SmBLXda1WHRlnJVieA74dDrfEAGOs4YMlVMYTTKGX3FWpCudka7LKhBGj8BTDKMZpb6G9
	 NPrkZVn9foTAu1O5zj95Hz1Z5oRcV8eef2zbAmzoA4SK1ZNSwASVY/wGMqekNnyFu6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gT2Ltihi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86793606A329;
	Tue,  3 Nov 2026 02:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gT2Ltihi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D0F1F000C1;
	Tue,  3 Nov 2026 02:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672156;
	bh=BGYyPx1YuZJJaW3M9cOvIiHYHFUtkIs96uyQ7c9gMvU=;
	h=Date:To:From:Subject;
	b=gT2LtihiLJ/u1bUj3ncZsKb9jYLhkwDJl3ltQuXRpnjGmLJ1soA/SwVo03V+hSYnh
	 NimekzUdA2lYw/OhsvOgLnYLnkKSzA3hpyDIR5kLmLk2kCTdHu5CRtJAvFs1W9QieS
	 Jlxyl6BeBkYM5XNdbV4MNWz8UjJ+hLkPYxTw66KI=
Date: Mon, 02 Nov 2026 18:15:55 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,pankaj.gupta@amd.com,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,kas@kernel.org,david@kernel.org,rppt@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-cma-accept-memory-of-multi-range-cma-areas.patch removed from -mm tree
Message-Id: <20261103021556.51D0F1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/cma: accept memory of multi-range CMA areas
has been removed from the -mm tree.  Its filename was
     mm-cma-accept-memory-of-multi-range-cma-areas.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/cma: accept memory of multi-range CMA areas
Date: Thu, 29 Oct 2026 12:18:37 +0200

Patch series "mm/cma: accept memory of CMA areas reserved with
memblock_reserve()", v1.

Pages of allocated CMA areas are released to the buddy allocator with
__free_pages(), which does not check for unaccepted memory.

This usually works because memblock accepts the memory it allocates.

However, multi-range CMA areas, used by hugetlb_cma, and fixed CMA areas
requested with cma=<size>@<base> are reserved with memblock_reserve() and
their memory is never accepted.

On TDX and SEV-SNP guests the first access to such a page is fatal.

To ease the backporting, each case is addressed by a separate patch:
- patch 1 accepts the memory of multi-range CMA areas
- patch 2 does the same for the fixed CMA areas

The second patch won't apply cleanly to 6.6 and 6.12, but I believe the
stable team LLMs will take care of that :)


This patch (of 2):

On systems with unaccepted memory, memblock allocations accept the
allocated range, but when cma_declare_contiguous_multi() uses open coded
allocation of multiple ranges, it reserves them with memblock_reserve()
and they are never accepted.

These pages are released to the buddy allocator by cma_activate_area()
with __free_pages() that does not check for unaccepted memory, so the
first access to such a page in a TDX or SEV-SNP guest is fatal.

Accept the memory of each range when it is reserved.

Link: https://lore.kernel.org/20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org
Link: https://lore.kernel.org/20261029-cma-multi-v1-1-2cbced8b5cb7@kernel.org
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Tested-by: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/cma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/cma.c~mm-cma-accept-memory-of-multi-range-cma-areas
+++ a/mm/cma.c
@@ -678,6 +678,8 @@ int __init cma_declare_contiguous_multi(
 			break;
 		}
 
+		accept_memory(mlp->base, size);
+
 		pr_debug("created region %d: %016llx - %016llx\n",
 		    nr, (u64)mlp->base, (u64)mlp->base + size);
 		cmrp = &cma->ranges[nr++];
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-clear-uffd-state-in-child-ptes-if-uffd-is-released-during-fork.patch
mm-vma-undo-userfaultfd-unmap-preparation-when-unmapping-fails.patch
hibernation-make-swsusp_page-helpers-static.patch
hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch
hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch
hibernation-kfence-explicitly-map-unmap-kfence-pages.patch
hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch

