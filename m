Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672120;
	b=i9rLIUsAA37y0darn2CJ0HmrEkpWXQtVAbmzi+bk15TIXd9LhH32K1+r08Ti/iGtiAqG
	 g7UUTX21TQujH5seuYEwlG9sbuxr8yOLX0uzDWGjBXHlby8o/yRnJrW04K8PmELs8DNuy
	 nndQv1/ckwiC0WnXhZck+DAnLU78PvIApJ3Mnx+WEWD4A0IE0j/b+pFESWdnFOlyZYnnx
	 zMVsJR6rWyYpKwEAXgDSh0uzjWVPyV1+BrUUAgokR34W86KPir0QVZA3xKlXmHwqMBikJ
	 9Daoc0dr2n+SMuF7isOJ0wQAzhSkvLtiuqRn8v+QRWMTy5zbzvoluxU+XtnbUjtQVvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672120;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=FnwpCVjwydqlOHCUe4nN3SvfJ8VJHqAKOvkEjUan0cw=;
	b=FlDfVMiadvmrk9vQsDcBsaTeLHhCBPUua5gbefRTt8/O2Jm6boNVorYt1cq+7wa4jU6r
	 kbimv4L+K0uzON0H4BNLq2VaL1r0e2mtpd+qL2IYjhOaEV/Y2l73VyKy/Vxbbg3ZiHArL
	 XkoVkeVo3royLiKqLmkpz7TQMuDz4WfKWhNj29aYPLlgy4T0Emxe30kelSYiJAYVJ6hBm
	 jjx52ZTqSOxzQNImG4f9iJI34t1pVo56HXmIhS0S7pX8LjFEeih169uHWfd8CIt6dX3gH
	 T+PDmmkir7ArB+9DOTO00VrDCjGt68D7KVYmzXD0NhY+zS6cz51elRgRoX+4Y15+FOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="d0qGcd/o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5484606A332;
	Tue,  3 Nov 2026 02:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=d0qGcd/o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CC21F000C1;
	Tue,  3 Nov 2026 02:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672119;
	bh=FnwpCVjwydqlOHCUe4nN3SvfJ8VJHqAKOvkEjUan0cw=;
	h=Date:To:From:Subject;
	b=d0qGcd/ofpymRWcPis2xAdBhz7WvtI9O2hsMstCPOt3Orc1V5yFmqSfUJbcKsbZzw
	 eU877UnRfiFT+AxEQlPo5a9kIgyAtbjKSwv/a+Pa1Afc0e3fmksKb0TAx/woFd+YTN
	 MoMbLmUK9HGSfJHnUpAgLFwSKiKYBwosOeZWAwME=
Date: Mon, 02 Nov 2026 18:15:18 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kylebot@openai.com,
	kas@kernel.org,huang.ying.caritas@gmail.com,hanchuanhua@oppo.com,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,david@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch removed from -mm tree
Message-Id: <20261103021519.40CC21F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: fix address wraparound when scanning large folio PTEs
has been removed from the -mm tree.  Its filename was
     mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: fix address wraparound when scanning large folio PTEs
Date: Wed, 14 Oct 2026 20:34:28 +0200

numa_rebuild_large_mapping() and do_swap_page() can be tricked into
generating an address wraparound, crashing the kernel. All that's required
is to map a tail page of a large folio close enough to the start/end of
the address space to e.g., make

	unsigned long addr_start = addr - (nr << PAGE_SHIFT);

to wrap around.

Let's fix it by providing a better helper, folio_scan_range(), that
takes care of staying within VMA and page table boundaries while
handling possible wraparounds.

There are some nasty details, like not being able to use pmd_addr_end()
in this context. Add some helpful comments for these cases.

Link: https://lore.kernel.org/20261014-folio_pte_scan_range-v2-1-00cf9bbaa364@kernel.org
Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ying Huang <huang.ying.caritas@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: <stable@vger.kernel.org>
---

 mm/memory.c |   50 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 14 deletions(-)

--- a/mm/memory.c~mm-fix-address-wraparound-when-scanning-large-folio-ptes
+++ a/mm/memory.c
@@ -4934,6 +4934,34 @@ static void check_swap_exclusive(struct
 }
 
 /*
+ * Get the address range in which a folio might be mapped, assuming its pages
+ * are mapped consecutively and the folio page at the given idx is mapped at
+ * the given address.
+ */
+static void folio_pte_range(const struct folio *folio,
+		const struct vm_area_struct *vma, unsigned long addr,
+		unsigned long idx, unsigned long *start, unsigned long *end)
+{
+	/* Stay within the page table and VMA boundaries. */
+	const unsigned long pmd_start = addr & PMD_MASK;
+	const unsigned long pmd_end = pmd_start + PMD_SIZE;
+	const unsigned long lower = max(pmd_start, vma->vm_start);
+	/*
+	 * We cannot use pmd_addr_end(), as it does not clamp reliably. To
+	 * avoid wraparounds, compute using the inclusive end.
+	 */
+	const unsigned long upper = min(pmd_end - 1, vma->vm_end - 1) + 1;
+	const unsigned long offset = idx << PAGE_SHIFT;
+
+	/*
+	 * Avoid start/end addresses wrapping by not adding/subtracting more
+	 * than the lower/upper limits would allow.
+	 */
+	*start = addr - min(addr - lower, offset);
+	*end = addr + min(upper - addr, folio_size(folio) - offset);
+}
+
+/*
  * We enter with either the VMA lock or the mmap_lock held (see
  * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
  * We return with pte unmapped and unlocked.
@@ -5121,16 +5149,15 @@ vm_fault_t do_swap_page(struct vm_fault
 	address = vmf->address;
 	ptep = vmf->pte;
 	if (folio_test_large(folio) && folio_test_swapcache(folio)) {
-		int nr = folio_nr_pages(folio);
-		unsigned long idx = folio_page_idx(folio, page);
-		unsigned long folio_start = address - idx * PAGE_SIZE;
-		unsigned long folio_end = folio_start + nr * PAGE_SIZE;
+		const int nr = folio_nr_pages(folio);
+		const unsigned long idx = folio_page_idx(folio, page);
+		unsigned long folio_start, folio_end;
 		pte_t *folio_ptep;
 		pte_t folio_pte;
 
-		if (unlikely(folio_start < max(address & PMD_MASK, vma->vm_start)))
-			goto check_folio;
-		if (unlikely(folio_end > pmd_addr_end(address, vma->vm_end)))
+		folio_pte_range(folio, vma, address, idx, &folio_start,
+				&folio_end);
+		if (unlikely((folio_end - folio_start) >> PAGE_SHIFT != nr))
 			goto check_folio;
 
 		folio_ptep = vmf->pte - idx;
@@ -6280,16 +6307,11 @@ static void numa_rebuild_large_mapping(s
 				       struct folio *folio, pte_t fault_pte,
 				       bool ignore_writable, bool pte_write_upgrade)
 {
-	int nr = pte_pfn(fault_pte) - folio_pfn(folio);
+	const unsigned long idx = pte_pfn(fault_pte) - folio_pfn(folio);
 	unsigned long start, end, addr = vmf->address;
-	unsigned long addr_start = addr - (nr << PAGE_SHIFT);
-	unsigned long pt_start = ALIGN_DOWN(addr, PMD_SIZE);
 	pte_t *start_ptep;
 
-	/* Stay within the VMA and within the page table. */
-	start = max3(addr_start, pt_start, vma->vm_start);
-	end = min3(addr_start + folio_size(folio), pt_start + PMD_SIZE,
-		   vma->vm_end);
+	folio_pte_range(folio, vma, addr, idx, &start, &end);
 	start_ptep = vmf->pte - ((addr - start) >> PAGE_SHIFT);
 
 	/* Restore all PTEs' mapping of the large folio */
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch

