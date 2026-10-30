Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793321553;
	b=bEF9OO8wtu+gFsr/Mg7b/59t/8xDRDdYvm6B2Mp2E9rrCiTey7eGLu8fp9XZOyHxPdnS
	 oM5kYcfwrmAIBHKyja4bvS3cdUHTimAET7jC+K91mjDIEBr/Cw9SwvUADZ7SQrWPplqnE
	 +xCGux4eQnBUUZyjvWkqW1wm2CHXJgNgIFa39zTGprJg6rBOC1OHM46vhMFPMwUXXlWPG
	 GEgsB91iFLtH755Z/1suU2nujZNG0WNoMsOqlA94cvZBakWYkib0HRrliXMB7OOv8Xz7/
	 v6Dkkb1GOrb0wK/z1PwcJS+EgM2qMyfqHCda1frXXVXF4kqvhyu2s8SsxK+A7VHMh/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793321553;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=QzpJVH5efsWddVJg1ls+u7459Hzmdm65CNNYgrQE6jg=;
	b=Dww6dmKVG7ZjHSdXkNEAdYUXBs7vq8fCHxJkJpYulBKOI2+J2tV6rr8LWc/WQowZWWXL
	 vrAWsAL5R24lVFmuMdwSp4e3InVK4qEEEepPdN19as+YZUn+ycIJLQKRdIsBtVXjIzLxE
	 ICCNT/O/K+CqYPzob4FFaa2goWqPfwGpcQPAF5ZbSn+JBs3qxxLnaqxw8bYtvTjBqLbE5
	 p4oIPwwrDBGGTVzaK8psLNmSN9VMBvIBuJLNsqZuipE4vv/LPx2HQDr1NRX/tidUOJ6Ib
	 yGvtMFSJ7j/VdhRS5t6JEgascGOnDEkXzz11ogF9pnpYXHkvHqtSeJB/OWE6Fl/gZGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GXpmYN2w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51BB606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 00:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GXpmYN2w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7224F1F000C1;
	Fri, 30 Oct 2026 00:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793321552;
	bh=QzpJVH5efsWddVJg1ls+u7459Hzmdm65CNNYgrQE6jg=;
	h=Date:To:From:Subject;
	b=GXpmYN2wmr3LpveaFMOYPoUo9he+X1tOvo8YaBv8EQo06RmqEBx/PCkgxkXZCT7uq
	 QFb/4McgiHz/Fwbmr2ZahSoct31Z9wN6fvjThst766Bcp/XxVw+Y6lxqojbKA3Rf/R
	 ZE4pYQKFydGg73L9TauiAU2q3UPcKnGkzNWCyJ7I=
Date: Thu, 29 Oct 2026 17:52:32 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sshegde@linux.ibm.com,skhan@linuxfoundation.org,rppt@kernel.org,
	ritesh.list@gmail.com,rdunlap@infradead.org,qi.zheng@linux.dev,
	osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,
	maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,
	david@kernel.org,corbet@lwn.net,chleroy@kernel.org,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch added to mm-new branch
Message-Id: <20261030005232.7224F1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb_vmemmap: remove vmemmap_wrprotect_hvo()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/hugetlb_vmemmap: remove vmemmap_wrprotect_hvo()
Date: Mon, 19 Oct 2026 17:08:29 +0800

Shared vmemmap tail pages are now mapped read-only during initial
population, so already optimized HugeTLB bootmem folios no longer need a
separate write-protection pass.

Remove vmemmap_wrprotect_hvo() and skip these folios during boot-time
optimization.

Link: https://lore.kernel.org/20261019090830.1917657-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
---

 include/linux/mm.h   |    2 --
 mm/hugetlb_vmemmap.c |   16 +++++-----------
 mm/sparse-vmemmap.c  |   23 -----------------------
 3 files changed, 5 insertions(+), 36 deletions(-)

--- a/include/linux/mm.h~mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo
+++ a/include/linux/mm.h
@@ -5363,8 +5363,6 @@ int vmemmap_populate_hugepages(unsigned
 			       int node, struct vmem_altmap *altmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap);
-void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
-			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
 #ifdef CONFIG_MEMORY_HOTPLUG
 void vmemmap_free(unsigned long start, unsigned long end,
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo
+++ a/mm/hugetlb_vmemmap.c
@@ -605,19 +605,13 @@ static void __hugetlb_vmemmap_optimize_f
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
-		unsigned long spfn, epfn;
 
-		if (boot && folio_test_hugetlb_vmemmap_optimized(folio)) {
-			/*
-			 * Already optimized by pre-HVO, just map the
-			 * mirrored tail page structs RO.
-			 */
-			spfn = (unsigned long)&folio->page;
-			epfn = spfn + hugetlb_vmemmap_size(h);
-			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
-					HUGETLB_VMEMMAP_RESERVE_SIZE);
+		/*
+		 * Bootmem gigantic folios may already be marked optimized when
+		 * their vmemmap layout was prepared earlier, so skip them here.
+		 */
+		if (boot && folio_test_hugetlb_vmemmap_optimized(folio))
 			continue;
-		}
 
 		nr_to_optimize++;
 
--- a/mm/sparse-vmemmap.c~mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo
+++ a/mm/sparse-vmemmap.c
@@ -386,29 +386,6 @@ int __meminit vmemmap_populate_basepages
 	return 0;
 }
 
-/*
- * Write protect the mirrored tail page structs for HVO. This will be
- * called from the hugetlb code when gathering and initializing the
- * memblock allocated gigantic pages. The write protect can't be
- * done earlier, since it can't be guaranteed that the reserved
- * page structures will not be written to during initialization,
- * even if CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled.
- *
- * The PTEs are known to exist, and nothing else should be touching
- * these pages. The caller is responsible for any TLB flushing.
- */
-void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
-				    int node, unsigned long headsize)
-{
-	unsigned long maddr;
-	pte_t *pte;
-
-	for (maddr = addr + headsize; maddr < end; maddr += PAGE_SIZE) {
-		pte = virt_to_kpte(maddr);
-		ptep_set_wrprotect(&init_mm, maddr, pte);
-	}
-}
-
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 				      unsigned long addr, unsigned long next)
 {
_

Patches currently in -mm which might be from muchun.song@linux.dev are

riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch

