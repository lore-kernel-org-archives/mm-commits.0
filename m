Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793321556;
	b=QQ1ubUQiVSp50PTwlGB6UKYrRReTYGogcfvPgROjdadv90g7ZkdFpw+TK/0IgfyfvElb
	 b5gpZGH27eWmBb+QP7Oxpu/pG3ow19Xy/H7spx+gjrQio3Taf8kY6okL/ABETTiPkpljr
	 FGgF0hLcKK+OGRZ+Lh3XllXaJgb/f0j79LGfadmKX+WczaXFllLfpp5PQFJll1PZTMmfH
	 MhyYTluZ8HbPXk8L5JNsG4sPaaYDbUyv1NvRkDCHe9oMu7x99O0z+8ER5AE1kz9WcKap9
	 k85jw9A09guIBf0s1Spwn0rsp//uBGSgi/u19oFByxzXyzesvTv6J5H1/0lZ3C+Mvcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793321556;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=o5JIL7TSMUa/zrnOoI4rDx588PbOTUBxMNuXq1pyiLw=;
	b=b/IlAGmpSFTPgI1IZNbCING1HZImYG5WNySmmyf3PUj6Imyk4myxMGDlLsR10Y++/KjQ
	 hhj/LUQsNlzVloavzzk4IWfOXSRYf8gfniwyHDS7QwSBr0Vwcj/5+/TegCGShuQ5/Ak+6
	 MO8ns5kOaqAqUnfbj/G5hLeqy6/LI0LBFBuU65/sD9VM/hxkWfBkAzA6apks2FDuMs1Kz
	 1aLihyO2/IrgG63quckArNNSxNXC5WGnI56KSvlJ4IgwJMWlBlZnoqJhRTvpTtOarqxQo
	 eo8bLwLeqReyedMXejvYElooWfjC7wQMWKo/ZuAPBWX3Yjkx6JPhJt1tYPq1bNIXhLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AoMqYWaf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C93606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 00:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AoMqYWaf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4918B1F000C1;
	Fri, 30 Oct 2026 00:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793321555;
	bh=o5JIL7TSMUa/zrnOoI4rDx588PbOTUBxMNuXq1pyiLw=;
	h=Date:To:From:Subject;
	b=AoMqYWaflZpAh3bMM3bj8Bp2h6aO6L/w78UBUgiIrBSrBiIzESDz6cwL6X4P27sUg
	 dH7JGOXX8iN2fB5NUn8jiiZOUZXGWp5OhNetsUsk9n+TjSqW8Y5bf8fe00OR76xbxw
	 rCgeIG/3O68vrAEriPAW2SrRxO1oFdGs88qlFNPs=
Date: Thu, 29 Oct 2026 17:52:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sshegde@linux.ibm.com,skhan@linuxfoundation.org,rppt@kernel.org,
	ritesh.list@gmail.com,rdunlap@infradead.org,qi.zheng@linux.dev,
	osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,
	maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,
	david@kernel.org,corbet@lwn.net,chleroy@kernel.org,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch added to mm-new branch
Message-Id: <20261030005235.4918B1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb_vmemmap: remove hugetlb_vmemmap_optimize_bootmem_folios()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch

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
Subject: mm/hugetlb_vmemmap: remove hugetlb_vmemmap_optimize_bootmem_folios()
Date: Mon, 19 Oct 2026 17:08:30 +0800

With vmemmap_wrprotect_hvo() removed, the bootmem wrapper no longer
performs any bootmem-specific work.

Call hugetlb_vmemmap_optimize_folios() directly for bootmem folios and
remove the redundant wrapper.

Link: https://lore.kernel.org/20261019090830.1917657-5-songmuchun@bytedance.com
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

 mm/hugetlb.c         |    2 +-
 mm/hugetlb_vmemmap.c |   29 ++++-------------------------
 mm/hugetlb_vmemmap.h |    6 ------
 3 files changed, 5 insertions(+), 32 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios
+++ a/mm/hugetlb.c
@@ -3290,7 +3290,7 @@ static void __init prep_and_add_bootmem_
 	struct folio *folio, *tmp_f;
 
 	/* Send list for bulk vmemmap optimization processing */
-	hugetlb_vmemmap_optimize_bootmem_folios(h, folio_list);
+	hugetlb_vmemmap_optimize_folios(h, folio_list);
 
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
 		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios
+++ a/mm/hugetlb_vmemmap.c
@@ -590,19 +590,16 @@ static int hugetlb_vmemmap_split_folio(c
 	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
 }
 
-static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
-					      struct list_head *folio_list,
-					      bool boot)
+void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
 {
 	struct folio *folio;
-	int nr_to_optimize;
+	unsigned long nr_to_optimize = 0;
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	if (list_empty(folio_list))
 		return;
 
-	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
@@ -610,7 +607,7 @@ static void __hugetlb_vmemmap_optimize_f
 		 * Bootmem gigantic folios may already be marked optimized when
 		 * their vmemmap layout was prepared earlier, so skip them here.
 		 */
-		if (boot && folio_test_hugetlb_vmemmap_optimized(folio))
+		if (folio_test_hugetlb_vmemmap_optimized(folio))
 			continue;
 
 		nr_to_optimize++;
@@ -628,14 +625,7 @@ static void __hugetlb_vmemmap_optimize_f
 	}
 
 	if (!nr_to_optimize)
-		/*
-		 * All pre-HVO folios, nothing left to do. It's ok if
-		 * there is a mix of pre-HVO and not yet HVO-ed folios
-		 * here, as __hugetlb_vmemmap_optimize_folio() will
-		 * skip any folios that already have the optimized flag
-		 * set, see vmemmap_should_optimize_folio().
-		 */
-		goto out;
+		return;
 
 	flush_tlb_all();
 
@@ -660,21 +650,10 @@ static void __hugetlb_vmemmap_optimize_f
 		}
 	}
 
-out:
 	flush_tlb_all();
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
-{
-	__hugetlb_vmemmap_optimize_folios(h, folio_list, false);
-}
-
-void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list)
-{
-	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
-}
-
 void __init hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
 	if (!READ_ONCE(vmemmap_optimize_enabled))
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios
+++ a/mm/hugetlb_vmemmap.h
@@ -24,7 +24,6 @@ long hugetlb_vmemmap_restore_folios(cons
 					struct list_head *non_hvo_folios);
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
-void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
@@ -66,11 +65,6 @@ static inline void hugetlb_vmemmap_optim
 {
 }
 
-static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
-						struct list_head *folio_list)
-{
-}
-
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
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

