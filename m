Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023392;
	b=E2dlTS7FwWidCAz4Gt4TSoyiKFaPOMAhEEfyz6dYwc0KWsGl7eTDemCN6JOAVlydOw+t
	 O7n8gUqN+By4S4tqSxFXISoqMRqrbZcYvJ/5o4ruADymgXsW/DD9HiTbfEAPpHdZmGCzK
	 H5TujzVRFC2/dtnFdIpIi6fFoY0LXJWee7J0eGHy6R801zBMIG5OdCWD1W1cnxB92HObh
	 pMj4I2eJiqqZrxoNVtFfCVnGbNb6Srv7yc2G72z6G++/si/PEwi3fjwvP2RfM87Pa9Cld
	 exkcTsuaJe15T7gWcMbTJeSnIgygdYJSZy732o09TNoJ0/Wuws0m4u0ZQ7Gq0y3rMJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023392;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=auX4CTXTe9SOpKJlAsAXmEoCeOOEKvlw+57SQ2978po=;
	b=klhA4THeMnwSkVNMHaiCmiy+r16jWX3uzz/QU12Jxh+VxNmfhn/R/MSCR8G4EMkd229R
	 3IxE+fyTwGcjdXcEc1qnyHwFm3hbTRJEDIvokVf4b+NrWIAYY4D8Z+n7Xdg/NHGqXJ45C
	 4WLawgbdzUFAVdV2riU/qqLRD9gOJyYfs8KtoFFOT8UzC9gECV5oXKvz7Ynds4jIs7wxD
	 csI3Ku7XnuEn850NwOibOU0+nhjGwr4LjE1vTjKGeHF/L/5SSn4676zAlz+6YfgmmoICI
	 BiYEz+xL7Y4otjbf+xUKRNhsn4hAN+lBG5mmglOhAW9z6cMeIrNgNaPuwZB8LItAOMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PAJUKj51;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11646606A330
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PAJUKj51
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F381F0089F;
	Sat,  7 Nov 2026 03:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023391;
	bh=auX4CTXTe9SOpKJlAsAXmEoCeOOEKvlw+57SQ2978po=;
	h=Date:To:From:Subject;
	b=PAJUKj517cjrnC9M54SdBHJChdPRXQRBVfBirZ8ZuOrSvjHduwmU0KlEZUQZoP0qL
	 Ot6oNbZxIOwHAzRQmHcpEjuquvV6pXOOXOl6wtUmimWZg5w9bNSyHE3xHKKkxH/t4t
	 HMLsQwKsEripxyC7g8bWDAJAPFwRY26esJBlxAno=
Date: Fri, 06 Nov 2026 19:49:51 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch removed from -mm tree
Message-Id: <20261107034951.86F381F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: rename vmemmap_remap_pte() to vmemmap_optimize_pte()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: rename vmemmap_remap_pte() to vmemmap_optimize_pte()
Date: Wed, 04 Nov 2026 10:35:04 +0800

Both optimization and restoration update vmemmap PTEs by remapping them,
so "remap" does not identify the callback's role.  Use "optimize" for the
optimization callback to match "restore" and make the two directions
explicit and consistent.

No functional change intended.

Link: https://lore.kernel.org/20261104023510.260766-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20261103224659.2865b9ff27d09994949edd78@linux-foundation.org
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 mm/hugetlb_vmemmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte
+++ a/mm/hugetlb_vmemmap.c
@@ -213,8 +213,8 @@ static struct page *vmemmap_dup_page_fro
 	return dst;
 }
 
-static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
-			      struct vmemmap_remap_walk *walk)
+static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
+		struct vmemmap_remap_walk *walk)
 {
 	struct page *page = pte_page(ptep_get(pte));
 	pte_t entry;
@@ -302,7 +302,7 @@ static int vmemmap_remap_free(unsigned l
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_remap_pte,
+		.remap_pte	= vmemmap_optimize_pte,
 		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch

