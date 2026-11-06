Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793942354;
	b=toF34xCwhfSL0qHhOg8msQdKdIrsUSi8sRyPkL9fM8nMLKH3HQpYFj/+TrmMGdDOQuW0
	 4CwKy32XvuSVCitnqvEixldT3ogkHk2RQ7Yr55cuLdFBOyyMTIiwgDAwqIBfbA+FmRrwO
	 3Td0Ed9Zf/BEnO/Q9FoBeOJlBlkohF8Sezs99cPkR1zoI0F1oJdD+KDsaWCNWZPJ0aFXA
	 cjAwFNtbaF3N7qcEWMcC4ISbC5prfs6qle3eSKamY30WTi/JqFDLcXc/D1yGPM+UOC0Jd
	 o33Upsb7JkkvMtu7R8Blx8C7KxOWEyd3+iXwdNJd47vS+kqmHkThlzIG2OVlhunMi3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793942354;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nXXC+tjsY1SdNmnYJ6WgbJiCyu7W3eFSoZriTkmcOzk=;
	b=IKVk/v3IAo6pz72BYKnnHIzF0rMvZzP5sRK385zc8sc1u/quD+dQOF++yQDhz6HnDKGO
	 S2R8JqZVTCH48bCkmljak4Jq7s5PsgRDaYAnLqDeG/KQl7AUbAq3DKOHp7MMdLHoPAJpq
	 GBkeUnIChGjkSTTFFxfmHFEXhi7CKcTeRVq6o3pY4Gzy18BjIHOFncD5fVYakVNSag3BB
	 NScP0y4eKGFNlymjFmrGvYNJ5kmIU18l3yAQz2DYwHpOVyhLczHQUhc+Gx8kbv23CHAHj
	 Xntp8KF9wZIk0uxuzkLF4nIvysMgSptO4Y7tHIj7NlCanfwN6rLXcaH9PPnIOSirC0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=npIXRMJ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27627606A326;
	Fri,  6 Nov 2026 05:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=npIXRMJ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912241F0089F;
	Fri,  6 Nov 2026 05:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793942353;
	bh=nXXC+tjsY1SdNmnYJ6WgbJiCyu7W3eFSoZriTkmcOzk=;
	h=Date:To:From:Subject;
	b=npIXRMJ60hTIZXJX39Ukrhi4a7IlE/zuRO3JegPJAydlKJaVbDHvhoifzWy2NlW30
	 dvI3G21Nd7WWD+d4773HQdYpgsfQdP2LLsstrZavMkSCngeNMcn7+8q+QhW3v0hiqc
	 b2QFNu+vv+Ol0haRRY1nVf6LzudrX2PhLHMRiLIk=
Date: Thu, 05 Nov 2026 21:19:13 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	stable@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,
	ritesh.list@gmail.com,peterx@redhat.com,nico.pache@linux.dev,
	maddy@linux.ibm.com,loic.molinari@collabora.com,ljs@kernel.org,
	liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jgg@ziepe.ca,
	dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,azpijr@gmail.com,alex@shazbot.org,khorenko@virtuozzo.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-duplicate-a-pmd-mapping-as-one-in-folio_dup_file_rmap_pmd.patch added to mm-new branch
Message-Id: <20261106051913.912241F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/rmap: duplicate a PMD mapping as one in folio_dup_file_rmap_pmd()
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-duplicate-a-pmd-mapping-as-one-in-folio_dup_file_rmap_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-duplicate-a-pmd-mapping-as-one-in-folio_dup_file_rmap_pmd.patch

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
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: mm/rmap: duplicate a PMD mapping as one in folio_dup_file_rmap_pmd()
Date: Wed, 04 Nov 2026 21:40:55 +0100

Patch series "mm/huge_memory: copy PMDs at fork like the PTE path does",
v5.

copy_huge_pmd() decides what to copy at fork by its own rules, apart
from copy_present_ptes(): a lockless check for special PMDs, and a skip
of every file THP. Following David's review of v3, this series makes it
decide the way the PTE path does, under the page table lock, with
vm_normal_page_pmd(). That fixes the two bugs v1-v3 were about. The
patches:

1. folio_dup_file_rmap_pmd() duplicated a PMD mapping as HPAGE_PMD_NR
   PTE mappings. It had no caller until patch 2.
2. File THPs are copied at fork instead of being refaulted by the
   child, as their PTEs would be.
3. The special-PMD read moves under the lock. That closes the race with
   a driver zap (vfio-pci, panthor) and the missing page table deposit
   on ppc64 hash that Sashiko found in v1.
4. A selftest for 1 and 2.

Stable
======

The race (since v6.12) and the ppc64 hash NULL deref (since v7.1) are
fixed in patch 3, which only works on top of the copy rework in patch
2, and patch 2 is the first caller of the helper patch 1 fixes. So
patches 1-3 carry Cc: stable, as David suggested on v4. They will not
apply to 6.12 as they are, I will do the backports.

A related refcount bug in copy_huge_pud() for device DAX is fixed in
a separate series, as it does not depend on this one:
https://patch.msgid.link/20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com

Testing
=======

v5 on v7.4-rc1, x86_64 with 4 NUMA nodes, the series with
CONFIG_DEBUG_VM, KASAN and lockdep:

- fork_file_thp (patch 4) skips on v7.4-rc1, where fork leaves file
  THPs to a refault, and fails in both cases without patch 1, where
  ShmemPmdMapped drops when the child exits and the kernel reports
  "Bad page cache";
- with the series it passes, also under migrate_pages() of the parent
  and under reclaim in a small memcg, where some runs skip; with other
  processes churning PMD-mapped shmem it passes or skips, never fails;
- cow, guard-regions, uffd-unit-tests, uffd-wp-mremap,
  split_huge_page_test, mremap_test, soft-dirty, pagemap_ioctl,
  migration, madv_populate, transhuge-stress and khugepaged pass as on
  v7.4-rc1.

The runs below are from v4, on v7.3-rc7 in a KVM guest with 4 vCPUs,
x86_64. Patches 1-3 changed since only by the device private CoW check.

Race with a driver zap. The guest's QXL device is bound to vfio-pci in
no-IOMMU mode, BAR0 of 64 MB mapped with PMDs. The reproducer below
forks while a second thread clears PCI_COMMAND_MEMORY through the vfio
config region after a random delay of up to 1 ms; the child waits for
the write to finish and reads one byte of each 2 MB of the BAR. A child
that reads anything without SIGBUS kept a stale mapping. I have not hit
it without help, so a test-only debugfs knob adds an mdelay(2) between
copy_pmd_range()'s lockless pmd_is_huge() and the PMD locks:

  +-----------------------+-------+-------+----------------+
  | kernel                | delay | forks | stale children |
  +-----------------------+-------+-------+----------------+
  | 7.3-rc7               | none  | 20900 | 0              |
  | 7.3-rc7               | 2 ms  | 150   | 128            |
  | 7.3-rc7 + this series | none  | 3000  | 0              |
  | 7.3-rc7 + this series | 2 ms  | 400   | 0              |
  +-----------------------+-------+-------+----------------+

ppc64 hash is not tested on hardware. On x86 a test-only hack makes
arch_needs_pgtable_deposit() true and mremap move the table, as on
ppc64 hash. Without the series the first child of the reproducer oopses
at exit in pgtable_trans_huge_withdraw(); with it the reproducer and
the mm selftests pass.

Cost
====

fork() now copies file THPs instead of leaving them to a refault, which
costs fork() a reference, an rmap update and a counter per huge PMD and
saves the child a fault per huge PMD it touches. fork() of a process
with 4 GB of shmem THPs mapped MAP_PRIVATE and an anon_vma on the VMA,
medians of 2000 forks:

  +-----------------------+------------+-------------------------+
  | kernel                | fork()     | fork(), child reads all |
  +-----------------------+------------+-------------------------+
  | 7.3-rc7               | 86-129 us  | 2380-2620 us            |
  | 7.3-rc7 + this series | 230-355 us | 820-930 us              |
  +-----------------------+------------+-------------------------+

Notes
=====

- drm_gem_shmem and mshv_vtl map special PMDs with
  vmf_insert_pfn_pmd() as well.
- copy_huge_pud() still differs from the PMD tail in that it does not
  mark a shared PUD clean in the child or handle uffd bits.
- A reproducer is at the Link:


This patch (of 4):

folio_dup_file_rmap_pmd() passes PGTABLE_LEVEL_PTE to
__folio_dup_file_rmap() for HPAGE_PMD_NR pages, so it adds HPAGE_PMD_NR
PTE mappings to the folio instead of one PMD mapping.

The helper has no caller yet, the next patch adds the first one. Pass
PGTABLE_LEVEL_PMD, as folio_try_dup_anon_rmap_pmd() does.

Link: https://lore.kernel.org/20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com
Link: https://lore.kernel.org/20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-1-c56d0d26f970@virtuozzo.com
Fixes: d8ef5e311d7b ("mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()")
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Loïc Molinari <loic.molinari@collabora.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <stable@vger.kernel.org>
---

 include/linux/rmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/rmap.h~mm-rmap-duplicate-a-pmd-mapping-as-one-in-folio_dup_file_rmap_pmd
+++ a/include/linux/rmap.h
@@ -558,7 +558,7 @@ static inline void folio_dup_file_rmap_p
 		struct page *page, struct vm_area_struct *dst_vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 #endif
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are

mm-rmap-duplicate-a-pmd-mapping-as-one-in-folio_dup_file_rmap_pmd.patch
mm-huge_memory-copy-file-thps-at-fork-like-copy_present_ptes-does.patch
mm-huge_memory-read-a-special-pmd-under-the-lock-in-copy_huge_pmd.patch
selftests-mm-test-fork-of-pmd-mapped-shmem-thps.patch

