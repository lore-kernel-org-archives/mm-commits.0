Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023612;
	b=SD4yG0ylEAeAda5PGytRGhyf/bdYWtDwhrK5qaqjIoFw7GirfzaeR4YNPLTdb0v8NHH/
	 3IQTyFgMAO1tSaFoDr3L/VsSfw1wbTWpGb831l8yJ03gXzcVkFqmrbg8Uvvhzzv00WgrO
	 3RKbMc6QicdhHFKJrNCzjWIMr5b+a4odd/D9GEMk9JI3gaOiMgbk3LzZGkoa0xjPkGTxM
	 osycAlIe7by8sw2cPJUENeY/RMz/UVL4yMWAofJeTqGQghfvJBMSsQ5Q/69IMw1HRU7Hz
	 R2LElIVSX8YzEZZRuq9cxJTBce3GcpcekKxfc+zkjcifyiZG1xpGaePIi6PvhTCCtlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023612;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=5KKjel5lPbIjooWZMc1qxp/DL4KD4h9GdDTyx0CGaas=;
	b=jgkOKbfRy5Svz1j6t7+4thEd0ZNeaghxBJpWoaW6WhO4qW7ElPZIHRFWT/HSpAzKbWXt
	 tymWZchfa1ziV8m5xP1pvMGSEtfeLj/JHf7bPlQQtCK9vbOyLbg41uT56UT73aZEHdtWW
	 rtrPp6a5pepo+40KONimB6VCswX8K5+i4LbtsId7E7NhpBPrS0UragRuMNCW9VFy80Rqj
	 8aCuGGVOwYL74Z3VZnmtmEIK4r7enNHu1cAzolBiLIrpWLyRfJA3SzeijR3zgado7DI1N
	 uyxbhTyqi5xMn4pCVD41LcZZ96KVdUi3DxSFQNcbQiDXlrfVZ9C12ON3gyr/m/ETgYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lPTrfqGW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8F4606A32C
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lPTrfqGW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C1C1F0089F;
	Sat,  7 Nov 2026 03:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023612;
	bh=5KKjel5lPbIjooWZMc1qxp/DL4KD4h9GdDTyx0CGaas=;
	h=Date:To:From:Subject;
	b=lPTrfqGWIJ26evXd22gOMVzMcFoZZyPKTtMvakRUGNbpNfJRE2gefMxSMUNYlx4RH
	 wB3KyK7bqOr3SJvz2sOeGADBhuc0bAJGc82+dmC+ECLnDTQi54PhMo0iDEaTdBVEIt
	 wl/Z1GCYESEUK8Lg84VCDuL5ZMu5sgwGBhI+hIEE=
Date: Fri, 06 Nov 2026 19:53:31 -0800
To: mm-commits@vger.kernel.org,zhangyili01@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-fix-oom-during-head-page-allocation.patch added to mm-unstable branch
Message-Id: <20261107035332.57C1C1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: hugetlb_vmemmap: fix OOM during head page allocation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-fix-oom-during-head-page-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-fix-oom-during-head-page-allocation.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Yili Zhang <zhangyili01@baidu.com>
Subject: mm: hugetlb_vmemmap: fix OOM during head page allocation
Date: Sat, 07 Nov 2026 10:27:44 +0800

Patch series "mm: Decouple folio-based vmemmap optimization from HugeTLB",
v4.

Section-based vmemmap optimization is implemented in sparse-vmemmap.c,
while folio-based optimization currently lives in hugetlb_vmemmap.c.
The latter is tightly coupled to HugeTLB-specific state even though the
underlying page-table remapping operates on one folio at a time.

To make these interfaces easier to maintain, the folio-based remapping
mechanics first need a boundary that is independent of HugeTLB-specific
state and raw address ranges. This will allow the mechanics to be moved
into a common vmemmap optimization layer alongside the section-based
interface.

This series establishes that boundary through three folio-oriented
operations, each with a distinct role:

  - vmemmap_optimize_folio() optimizes the vmemmap backing of a folio;
  - vmemmap_restore_folio() restores the vmemmap backing of a folio; and
  - vmemmap_pteify_folio() converts the vmemmap backing of a folio to
    PTE mappings.

Together, these operations encapsulate the address-range calculation and
remapping mechanics for a folio. HugeTLB wrappers retain policy decisions
such as eligibility, optimized state, batching and TLB flush handling.

Patch 1 is a standalone prerequisite fix for best-effort HVO head-page
allocation. Patches 2-9 generalize the underlying vmemmap remapping
infrastructure by removing HugeTLB-specific assumptions and simplifying
remap control and resource handling. Patches 10-13 then establish
folio-oriented operations for optimization, restoration and PTE
conversion.

The implementation remains in hugetlb_vmemmap.c for now. A follow-up can
move the folio-based operations into the common vmemmap optimization layer
once the interface boundary is in place.


This patch (of 13):

The head page used during HugeTLB vmemmap optimization is allocated with
a bare GFP_KERNEL mask. When boot-time hugepage allocation drains free
memory, parallel optimization workers can enter OOM handling before
userspace exists, leaving the kernel with no killable process and causing
a panic.

hugetlb_pages_alloc_boot_node() invokes HVO on the folios accumulated so
far when available memory reaches zero, allowing the released vmemmap pages
to support further hugepage allocations. If allocating the HVO head page
returns -ENOMEM, the bulk HVO path frees any vmemmap pages it has already
accumulated and retries, while callers can continue with an unoptimized
folio if the retry still fails. Therefore, neither an allocation warning
nor OOM handling helps this best-effort allocation. Use GFP_KERNEL |
__GFP_NOWARN | __GFP_RETRY_MAYFAIL to allow reclaim retries while avoiding
both.

Link: https://lore.kernel.org/20261107022756.77731-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20261107022756.77731-2-songmuchun@bytedance.com
Fixes: c0b495b91a47 ("mm/hugetlb: refactor code around vmemmap_walk")
Signed-off-by: Yili Zhang <zhangyili01@baidu.com>
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb_vmemmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-fix-oom-during-head-page-allocation
+++ a/mm/hugetlb_vmemmap.c
@@ -501,6 +501,7 @@ static int __hugetlb_vmemmap_optimize_fo
 {
 	unsigned long vmemmap_start, vmemmap_end;
 	struct page *vmemmap_head, *vmemmap_tail;
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL;
 	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -527,7 +528,7 @@ static int __hugetlb_vmemmap_optimize_fo
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
+	vmemmap_head = alloc_pages_node(nid, gfp_mask, 0);
 	if (!vmemmap_head) {
 		ret = -ENOMEM;
 		goto out;
_

Patches currently in -mm which might be from zhangyili01@baidu.com are

mm-hugetlb_vmemmap-fix-oom-during-head-page-allocation.patch

