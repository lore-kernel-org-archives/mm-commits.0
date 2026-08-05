Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740CF3BBFCE
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896605; cv=none; b=Jp0yUwUBbKGe+91JHzB5zctzrW5UZzQmvdsajas6WExr5tS3VpeX+Z+eVn+QTjz4738x4Pi19kIhRKd/kNUDpq/gzkQcc5QvGrs+gPZtmaYMF5Cp38+JljGTy0cJT9TyjZt4WW3ugXerKPEEfzKV19LsfkjnV+bHcMZFsrMo1zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896605; c=relaxed/simple;
	bh=DeQoETAc5Z8vaMD3Luf3OxjFkr49BRlRVlUebfrXy5M=;
	h=Date:To:From:Subject:Message-Id; b=RjNanwtXib7IH6LV7fZmjOVbJi5khZY/lRbuqBh4vWse0lBdWdlRElPITrUJkiIa/OIqlGSCu+P05gOxPW9QbnmyCad61IMbttzVBLTc7+G5Fut5YNZ3ChY5izu7sYKHH717rd3rsElhzLWHf0oK/OtNn8rVwjSo3TfHf638XUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RmCwirrA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RmCwirrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2001F000E9;
	Wed,  5 Aug 2026 02:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896604;
	bh=PeS2galX78skqFC9Fr3+MtZYAnZ4euFfQv3yIB9UZsg=;
	h=Date:To:From:Subject;
	b=RmCwirrA382ag1PIVfdFqqOHF79E1XD+khG6neHesC3WbTG2dyLaA11cI3xEPZ+gM
	 8qgEMxJKemZ7FNXKGWcgZzF2iXz7FrFox2iNysoGJBtddKDwKarLHnzYsgOepgbt54
	 ewsiLnNfmLps7TBFBeZvt+mNIrF8AnFqmyPvocu8=
Date: Tue, 04 Aug 2026 19:23:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-entirely-remove-lru_add_drain-in-do_swap_page.patch removed from -mm tree
Message-Id: <20260805022324.3D2001F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: entirely remove lru_add_drain in do_swap_page
has been removed from the -mm tree.  Its filename was
     mm-entirely-remove-lru_add_drain-in-do_swap_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm: entirely remove lru_add_drain in do_swap_page
Date: Thu, 2 Jul 2026 07:59:54 +0800

We are doing a lot of redundant lru_add_drain() calls in do_swap_page(),
especially for synchronous I/O devices.  For example, the test program
below currently ends up draining lru_cache 100% of the time:

int main(int argc, char *argv[])
{
        int i;
 #define SIZE 100*1024*1024
	while(1) {
		volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

		for (int i = 0; i < SIZE/sizeof(int); i++)
			p[i] =  i%64;
		madvise((void *)p, SIZE, MADV_PAGEOUT);
		for (int i = 0; i < SIZE/sizeof(int); i++)
			p[i] =  i%64;
		munmap(p, SIZE);
	}
	return 0;
}

Folio reuse now relies primarily on the exclusive hint, making lru_cache
draining to drop the refcount in lru_cache largely irrelevant.  For a
kernel build with a minimal configuration running in a 1 GB memcg, this
patch skips more than 43,000 redundant local LRU drains.

Link: https://lore.kernel.org/20260701235955.36126-4-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/mm/memory.c~mm-entirely-remove-lru_add_drain-in-do_swap_page
+++ a/mm/memory.c
@@ -4894,16 +4894,6 @@ vm_fault_t do_swap_page(struct vm_fault
 	} else if (folio != swapcache)
 		page = folio_page(folio, 0);
 
-	/*
-	 * If we want to map a page that's in the swapcache writable, we
-	 * have to detect via the refcount if we're really the exclusive
-	 * owner. Try removing the extra reference from the local LRU
-	 * caches if required.
-	 */
-	if ((vmf->flags & FAULT_FLAG_WRITE) &&
-	    !folio_test_ksm(folio) && !folio_test_lru(folio))
-		lru_add_drain();
-
 	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch
arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

