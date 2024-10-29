Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB953747F
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 01:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730163658; cv=none; b=H8STDmmUe3n+sAadRIFu156/vWOL8FSnAtqDBSr3AtdRaWRkV7pY5E/R+qJpQ8/b4G30TCR6Cv34ACuaac8Y8iCLCacqmqVmJwJ6l1A04cQpW7WF/K7sqUuUBY0GcHpyeagKksHbAfHXqOzsP9UV0o+xlFRFLz0+o0kYAB3rwJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730163658; c=relaxed/simple;
	bh=mTE3G5k11igEg52rxyrHsRjM++oWlLRlrmaXVrDHw1c=;
	h=Date:To:From:Subject:Message-Id; b=M4fSeiG9fqAHDtaaAIDlbHAvkAFwqqLxDZKVNEXQDN2TnXp35UO/gR5BEsqPWVmoIpkvDFyWjOiwvI8jOzPK7MKIN9UU4oZ+0H3wb1VZH4VFUBBdjSIondroC0XmxXEkOPcKZ96c1UfUNPa3DzQ/coQqgynXE7k3rcu7Sg81QXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wPPKenbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wPPKenbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EB7C4CEC3;
	Tue, 29 Oct 2024 01:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730163658;
	bh=mTE3G5k11igEg52rxyrHsRjM++oWlLRlrmaXVrDHw1c=;
	h=Date:To:From:Subject:From;
	b=wPPKenbNJjFrMU+7gyzGEr0hB/51mI8LnVuRLIhvfcLA2bKhWHGjytBCuxiloQr1O
	 5OPy771vEDdbY+GA/j1zmxo/dkGeZ1rogKqACfmDS/OiIVXA7YZbIt/+SMGBdoUisV
	 rkMG9DsUtOgRPPIgHbpuLP6jM87lQov7vDaHNLDE=
Date: Mon, 28 Oct 2024 18:00:57 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-aligned-address-in-copy_user_gigantic_page.patch added to mm-unstable branch
Message-Id: <20241029010058.62EB7C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use aligned address in copy_user_gigantic_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-aligned-address-in-copy_user_gigantic_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-aligned-address-in-copy_user_gigantic_page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use aligned address in copy_user_gigantic_page()
Date: Mon, 28 Oct 2024 22:56:56 +0800

In current kernel, hugetlb_wp() calls copy_user_large_folio() with the
fault address.  Where the fault address may be not aligned with the huge
page size.  Then, copy_user_large_folio() may call
copy_user_gigantic_page() with the address, while
copy_user_gigantic_page() requires the address to be huge page size
aligned.  So, this may cause memory corruption or information leak,
addtional, use more obvious naming 'addr_hint' instead of 'addr' for
copy_user_gigantic_page().

Link: https://lkml.kernel.org/r/20241028145656.932941-2-wangkefeng.wang@huawei.com
Fixes: 530dd9926dc1 ("mm: memory: improve copy_user_large_folio()")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++---
 mm/memory.c  |    5 +++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-use-aligned-address-in-copy_user_gigantic_page
+++ a/mm/hugetlb.c
@@ -5340,7 +5340,7 @@ again:
 					break;
 				}
 				ret = copy_user_large_folio(new_folio, pte_folio,
-						ALIGN_DOWN(addr, sz), dst_vma);
+							    addr, dst_vma);
 				folio_put(pte_folio);
 				if (ret) {
 					folio_put(new_folio);
@@ -6643,8 +6643,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			*foliop = NULL;
 			goto out;
 		}
-		ret = copy_user_large_folio(folio, *foliop,
-					    ALIGN_DOWN(dst_addr, size), dst_vma);
+		ret = copy_user_large_folio(folio, *foliop, dst_addr, dst_vma);
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
--- a/mm/memory.c~mm-use-aligned-address-in-copy_user_gigantic_page
+++ a/mm/memory.c
@@ -6841,13 +6841,14 @@ void folio_zero_user(struct folio *folio
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-				   unsigned long addr,
+				   unsigned long addr_hint,
 				   struct vm_area_struct *vma,
 				   unsigned int nr_pages)
 {
-	int i;
+	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(dst));
 	struct page *dst_page;
 	struct page *src_page;
+	int i;
 
 	for (i = 0; i < nr_pages; i++) {
 		dst_page = folio_page(dst, i);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-unused-hugepage-for-vma_alloc_folio.patch
tmpfs-dont-enable-large-folios-if-not-supported.patch
mm-huge_memory-move-file_thp_enabled-into-huge_memoryc.patch
mm-shmem-remove-__shmem_huge_global_enabled.patch
mm-use-aligned-address-in-clear_gigantic_page.patch
mm-use-aligned-address-in-copy_user_gigantic_page.patch

