Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D06122370A;
	Thu,  7 Aug 2025 22:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754606199; cv=none; b=ndiwxPli+Up2RdZg11vZgn1Efi4ozl9KQfBk0z0dzMZ7yJac11cc1zwwuVNCZsdO9AwPL0oVWUL07f+AQBJ+9W1a+kCLbVUiA9LKZC5R+moIhIdsrdZU1tYoY5oOyuS9SCwZhKzWy6caxpPt4SDSmAfrn8VtUpE2480ASjo44Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754606199; c=relaxed/simple;
	bh=gqDJBdGGnri81C9JYYvriLcCIss6kinKURJkmA8Lhbk=;
	h=Date:To:From:Subject:Message-Id; b=BFZ8zFMO3W7O2A4BWB/xNeCRnFZkAYsSJ7wdXYV6NE/UpuSlTOLGCrgzXP7DnBFGYPZn5YPwlRpJyia2J/RAsiYwqdwrnJptaBvhrAXqQV4q9l2jiyGn+nDpCqi763F0J81pgRXCSvCQ/IYfqGkddXYdID/ADYhF6PWZ7Zfgr1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iVLsbKUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iVLsbKUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8F5C4CEEB;
	Thu,  7 Aug 2025 22:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754606199;
	bh=gqDJBdGGnri81C9JYYvriLcCIss6kinKURJkmA8Lhbk=;
	h=Date:To:From:Subject:From;
	b=iVLsbKUrMYzEZYqJHeT2Wf6fh7sXO8PwZvrkXrw5I46ynSEkQNgOW93eCarv9d4F5
	 DQjG9JAkdAE3UOgcU7kAVPoB5aWqYb68rgtAQD9n/JUIwks4Kq/yl3Qm0TR5SI9GGv
	 74bGQpJXDQhdX8EAyciWDmLW5+23TMq+0aeROlBQ=
Date: Thu, 07 Aug 2025 15:36:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,souravpanda@google.com,rientjes@google.com,pasha.tatashin@soleen.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-fix-accounting-of-memmap-pages-for-early-sections.patch removed from -mm tree
Message-Id: <20250807223638.DF8F5C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix accounting of memmap pages for early sections
has been removed from the -mm tree.  Its filename was
     mm-fix-accounting-of-memmap-pages-for-early-sections.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: mm: fix accounting of memmap pages for early sections
Date: Mon, 4 Aug 2025 10:40:15 +0200

memmap pages can be allocated either from the memblock (boot) allocator
during early boot or from the buddy allocator.

When these memmap pages are removed via arch_remove_memory(), the
deallocation path depends on their source:

* For pages from the buddy allocator, depopulate_section_memmap() is
  called, which also decrements the count of nr_memmap_pages.

* For pages from the boot allocator, free_map_bootmem() is called. But
  it currently does not adjust the nr_memmap_boot_pages.

To fix this inconsistency, update free_map_bootmem() to also decrement the
nr_memmap_boot_pages count by invoking memmap_boot_pages_add(), mirroring
how free_vmemmap_page() handles this for boot-allocated pages.

This ensures correct tracking of memmap pages regardless of allocation
source.

Link: https://lkml.kernel.org/r/20250804084015.270570-1-sumanthk@linux.ibm.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/sparse.c~mm-fix-accounting-of-memmap-pages-for-early-sections
+++ a/mm/sparse.c
@@ -688,6 +688,7 @@ static void free_map_bootmem(struct page
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
+	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
 	vmemmap_free(start, end, NULL);
 }
 
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

mm-fix-accounting-of-memmap-pages.patch

