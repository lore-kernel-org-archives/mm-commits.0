Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA88B365A00
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388634; cv=none; b=O0a3ai1+s1X0M0kIS7tt8lOXpSOKpoT93XArhKjGd/cACbNUGPjGKDqsLBRuFzJ5P5lfuRQri+aS/0CwBxHu3owk9q9x5ibR2vfzfWeRLW28i0I3iofB+b1K6+J+h87f0sDO+mGNQxFF3cFIx6FdN8z3E60H2bFXEFlNs6oCwZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388634; c=relaxed/simple;
	bh=wGiDb4HOK121168Zf4VVSetL1pWNP/p5Ady+Byw4icU=;
	h=Date:To:From:Subject:Message-Id; b=Z2nqY01IkN0K4PYmG+KSe1QJSeIMbOtozgCABSDUPdvsejiVZw6X/AtmcNGT2A8l0wMkpxZkRpJrUECgmpVp3oKY8euOVWGrjP41WGhlIZdvKgOabdFLCOdQHnR5y8xibSKY+XLVDOa9jALvHfyvlXyvfthsHXMs6gf6umtmDaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fqWGPbHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fqWGPbHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9339BC19424;
	Tue, 24 Mar 2026 21:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388634;
	bh=wGiDb4HOK121168Zf4VVSetL1pWNP/p5Ady+Byw4icU=;
	h=Date:To:From:Subject:From;
	b=fqWGPbHmxZiHGqpYaz7H8VLj0NUEYutdZ1tnA8PvmY7v/eEfyVEKJiMnpi55FY1K8
	 ZOl0Dyd0UvDZ9i2X+nxPVnkx+ojnQelxstFd6n2C/xZbW5DLMr42hYvn5tGmQIttGC
	 XeO2OcoWbulFmMMVk0+Oc7Yzpmdn83EHoWrlS8mM=
Date: Tue, 24 Mar 2026 14:43:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-mm-align-vmemmap-to-maximal-folio-size.patch removed from -mm tree
Message-Id: <20260324214354.9339BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv/mm: align vmemmap to maximal folio size
has been removed from the -mm tree.  Its filename was
     riscv-mm-align-vmemmap-to-maximal-folio-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: riscv/mm: align vmemmap to maximal folio size
Date: Fri, 27 Feb 2026 19:42:43 +0000

The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
struct pages of the head page to be naturally aligned with regard to the
folio size.

Align vmemmap to the newly introduced MAX_FOLIO_VMEMMAP_ALIGN.

Link: https://lkml.kernel.org/r/20260227194302.274384-6-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Hildenbrand (arm) <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/init.c   |    3 ++-
 include/linux/mmzone.h |   11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/arch/riscv/mm/init.c~riscv-mm-align-vmemmap-to-maximal-folio-size
+++ a/arch/riscv/mm/init.c
@@ -63,7 +63,8 @@ phys_addr_t phys_ram_base __ro_after_ini
 EXPORT_SYMBOL(phys_ram_base);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-#define VMEMMAP_ADDR_ALIGN	(1ULL << SECTION_SIZE_BITS)
+#define VMEMMAP_ADDR_ALIGN	max(1ULL << SECTION_SIZE_BITS, \
+				    MAX_FOLIO_VMEMMAP_ALIGN)
 
 unsigned long vmemmap_start_pfn __ro_after_init;
 EXPORT_SYMBOL(vmemmap_start_pfn);
--- a/include/linux/mmzone.h~riscv-mm-align-vmemmap-to-maximal-folio-size
+++ a/include/linux/mmzone.h
@@ -92,6 +92,17 @@
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
 
+/*
+ * HugeTLB Vmemmap Optimization (HVO) requires struct pages of the head page to
+ * be naturally aligned with regard to the folio size.
+ *
+ * HVO which is only active if the size of struct page is a power of 2.
+ */
+#define MAX_FOLIO_VMEMMAP_ALIGN \
+	(IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) && \
+	 is_power_of_2(sizeof(struct page)) ? \
+	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
+
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
_

Patches currently in -mm which might be from kas@kernel.org are


