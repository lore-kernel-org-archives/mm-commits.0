Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195C31D6DB4
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119278; cv=none; b=D5S9ZBeBvdmHgGwNHU3OZrPVUOWVrlP2ae2O0lzc91fQnvunjByd49BuiQC+Aj2LsSMHfWfErasCuMe70D24GEX/T6sJpyqmP/0v1YKFfaI5+P6HOQE+ZfjRlBmjqDAjAHTFzC/KZOwDfC3hMIT0EBRtEPlQda/hNfGsaBZZiVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119278; c=relaxed/simple;
	bh=F0CoPDQ5m8A5uVPLIlI4UWtku1xTQTV5yw/TQ6t1IQ8=;
	h=Date:To:From:Subject:Message-Id; b=oxSTu+cezB+m4wpLS9zkDpjH2vJjKVBBwCbVWu2NLt7vLxv09E+wV/bWhuELJdqHbmwQetjfh4sFUptfJ+D95psbE8YH9TJPPYkajkxL+Uct3rgyMwmCYCBZbiFdkbP9RUISph9dQJ4m4E8Afm6Zcnunj2hAG9CcPtifZrp/6Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VOON81SP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VOON81SP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E1FC4CEE4;
	Tue, 13 May 2025 06:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119278;
	bh=F0CoPDQ5m8A5uVPLIlI4UWtku1xTQTV5yw/TQ6t1IQ8=;
	h=Date:To:From:Subject:From;
	b=VOON81SPSUz4YXMF1ggHrnmuniQO8rn9KTYuWWd7x0jgvmf9DWW/F7XEkyV4TyMyZ
	 XwyOUXzYQAjr0eNvJQ8wrEPOu1zM3pE6Stzctj/NxfMiOyPIrwAgM81evfUoNvUzbd
	 aDhzIVbg5Gdtqu81Bv6u2Y0ACEfaCN6nvU+gG5Ac=
Date: Mon, 12 May 2025 23:54:37 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,lorenzo.stoakes@oracle.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-for_each_valid_pfn-and-use-it-from-reserve_bootmem_region.patch removed from -mm tree
Message-Id: <20250513065437.E1E1FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce for_each_valid_pfn() and use it from reserve_bootmem_region()
has been removed from the -mm tree.  Its filename was
     mm-introduce-for_each_valid_pfn-and-use-it-from-reserve_bootmem_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Woodhouse <dwmw@amazon.co.uk>
Subject: mm: introduce for_each_valid_pfn() and use it from reserve_bootmem_region()
Date: Wed, 23 Apr 2025 14:33:37 +0100

Patch series "mm: Introduce for_each_valid_pfn()", v4.

There are cases where a naïve loop over a PFN range, calling pfn_valid()
on each one, is horribly inefficient.  Ruihan Li reported the case where
memmap_init() iterates all the way from zero to a potentially large value
of ARCH_PFN_OFFSET, and we at Amazon found the reserve_bootmem_region()
one as it affects hypervisor live update.  Others are more cosmetic.

By introducing a for_each_valid_pfn() helper it can optimise away a lot of
pointless calls to pfn_valid(), skipping immediately to the next valid PFN
and also skipping *all* checks within a valid (sub)region according to the
granularity of the memory model in use.


This patch (of 7)

Especially since commit 9092d4f7a1f8 ("memblock: update initialization of
reserved pages"), the reserve_bootmem_region() function can spend a
significant amount of time iterating over every 4KiB PFN in a range,
calling pfn_valid() on each one, and ultimately doing absolutely nothing.

On a platform used for virtualization, with large NOMAP regions that
eventually get used for guest RAM, this leads to a significant increase in
steal time experienced during kexec for a live update.

Introduce for_each_valid_pfn() and use it from reserve_bootmem_region(). 
This implementation is precisely the same naïve loop that the functio
used to have, but subsequent commits will provide optimised versions for
FLATMEM and SPARSEMEM, and this version will remain for those
architectures which provide their own pfn_valid() implementation,
until/unless they also provide a matching for_each_valid_pfn().

Link: https://lkml.kernel.org/r/20250423133821.789413-1-dwmw2@infradead.org
Link: https://lkml.kernel.org/r/20250423133821.789413-2-dwmw2@infradead.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Will Deacon <will@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 ++++++++++
 mm/mm_init.c           |   23 ++++++++++-------------
 2 files changed, 20 insertions(+), 13 deletions(-)

--- a/include/linux/mmzone.h~mm-introduce-for_each_valid_pfn-and-use-it-from-reserve_bootmem_region
+++ a/include/linux/mmzone.h
@@ -2177,6 +2177,16 @@ void sparse_init(void);
 #define subsection_map_init(_pfn, _nr_pages) do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
+/*
+ * Fallback case for when the architecture provides its own pfn_valid() but
+ * not a corresponding for_each_valid_pfn().
+ */
+#ifndef for_each_valid_pfn
+#define for_each_valid_pfn(_pfn, _start_pfn, _end_pfn)			\
+	for ((_pfn) = (_start_pfn); (_pfn) < (_end_pfn); (_pfn)++)	\
+		if (pfn_valid(_pfn))
+#endif
+
 #endif /* !__GENERATING_BOUNDS.H */
 #endif /* !__ASSEMBLY__ */
 #endif /* _LINUX_MMZONE_H */
--- a/mm/mm_init.c~mm-introduce-for_each_valid_pfn-and-use-it-from-reserve_bootmem_region
+++ a/mm/mm_init.c
@@ -783,22 +783,19 @@ void __meminit init_deferred_page(unsign
 void __meminit reserve_bootmem_region(phys_addr_t start,
 				      phys_addr_t end, int nid)
 {
-	unsigned long start_pfn = PFN_DOWN(start);
-	unsigned long end_pfn = PFN_UP(end);
+	unsigned long pfn;
 
-	for (; start_pfn < end_pfn; start_pfn++) {
-		if (pfn_valid(start_pfn)) {
-			struct page *page = pfn_to_page(start_pfn);
+	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
+		struct page *page = pfn_to_page(pfn);
 
-			__init_deferred_page(start_pfn, nid);
+		__init_deferred_page(pfn, nid);
 
-			/*
-			 * no need for atomic set_bit because the struct
-			 * page is not visible yet so nobody should
-			 * access it yet.
-			 */
-			__SetPageReserved(page);
-		}
+		/*
+		 * no need for atomic set_bit because the struct
+		 * page is not visible yet so nobody should
+		 * access it yet.
+		 */
+		__SetPageReserved(page);
 	}
 }
 
_

Patches currently in -mm which might be from dwmw@amazon.co.uk are


