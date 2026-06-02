Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B323B83EF
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439018; cv=none; b=U7aIavY/9d/Na59Lgw8ChoNmwn9k3zE0KEbfhgz+0IEFqExdSJAQ7Fmmnv1QzzYCpXBjQ856dVXpimmu58kPqH+x30J//7miOBWeDacumybY9CcKkzTBn+uaRU+ws52TmbbO/beQ9yYEQx2+hEREyPOYlWN5N2/ZiRDyKGl5Q4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439018; c=relaxed/simple;
	bh=ZseIiK7o8riIX8PNGv0NYiO6TYl4ysftlrsP+J6ZaFs=;
	h=Date:To:From:Subject:Message-Id; b=urhGdOvmREQjT2P4vXpZ5ZvJAmMEoH6TIWjQ+OFoZcimhcB82Nn58K7IHy/dCoYwZBEhDfdj8fU1s9FjevheOGwZHJ2Rfn46U0kT9UAvVuApA2jls+DqfcO2HO0tNXeDQ1aXfwP8cS2bGuC3LT8CDtnk0WLVg1rXEHqgvQzakwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FKYZf7Cc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FKYZf7Cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCF31F00898;
	Tue,  2 Jun 2026 22:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439017;
	bh=h+9DwZ+bvjjAhxLgtKZxFu/Gj3cOQIT5WujtxQJ42rg=;
	h=Date:To:From:Subject;
	b=FKYZf7CcR5qkHzr8SYfNqTSEDtI+UnJNs8sY5/z+fjN/xF37eT2mpvQagwXWBRG4x
	 Xm3naRat3J6O5CO+kcTY7Grk3V6cFjfObiCfjcVhnbeziWjTPITBzAM+O2qfey3IK7
	 mLVrChMGjWtgrK4A3hj+SVNJLrVVZ+AIx8LU1wAU=
Date: Tue, 02 Jun 2026 15:23:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch removed from -mm tree
Message-Id: <20260602222337.4BCF31F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/bootmem_info: remove call to kmemleak_free_part_phys()
has been removed from the -mm tree.  Its filename was
     mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/bootmem_info: remove call to kmemleak_free_part_phys()
Date: Mon, 11 May 2026 16:05:32 +0200

The call to kmemleak_free_part_phys() was added in 2022 in
commit dd0ff4d12dd2 ("bootmem: remove the vmemmap pages from kmemleak in
put_page_bootmem").

In 2025, commit b2aad24b5333 ("mm/memmap: prevent double scanning of memmap
by kmemleak") started to use MEMBLOCK_ALLOC_NOLEAKTRACE when allocating
the memmap to skip the kmemleak_alloc_phys() in the buddy.

So remove the call to kmemleak_free_part_phys(). If this would still
be required for other purposes, either free_reserved_page() should take
care of it, or selected users.

Link: https://lore.kernel.org/20260511-bootmem_info_prep-v1-4-3fb0be6fc688@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem_info.h |    1 -
 mm/bootmem_info.c            |    1 -
 2 files changed, 2 deletions(-)

--- a/include/linux/bootmem_info.h~mm-bootmem_info-remove-call-to-kmemleak_free_part_phys
+++ a/include/linux/bootmem_info.h
@@ -82,7 +82,6 @@ static inline void get_page_bootmem(unsi
 
 static inline void free_bootmem_page(struct page *page)
 {
-	kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 	free_reserved_page(page);
 }
 #endif
--- a/mm/bootmem_info.c~mm-bootmem_info-remove-call-to-kmemleak_free_part_phys
+++ a/mm/bootmem_info.c
@@ -32,7 +32,6 @@ void put_page_bootmem(struct page *page)
 
 	if (page_ref_dec_return(page) == 1) {
 		set_page_private(page, 0);
-		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 		free_reserved_page(page);
 	}
 }
_

Patches currently in -mm which might be from david@kernel.org are


