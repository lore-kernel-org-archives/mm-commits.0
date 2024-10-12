Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C4513D897
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 22:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728771724; cv=none; b=Gz+vMdiZWW9YWL8p52srMOU8HcRZxkxqk5DZd4fD1OksayeK6XD2O+fAbSgO+zttiVvUt9OR5aTUd6rBclBImA+jZWPnOCeKz1+BEZEKztYPjNvq75XmM1VQ4mh5/rSD/qLBtfJTALYBQw1WjWGSaKSZGWvHGsJ7J1iG6dTkAnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728771724; c=relaxed/simple;
	bh=fjilsVe1a80tPGSkZ0rRLQBzDDXbagw4rDtkt3pi2j4=;
	h=Date:To:From:Subject:Message-Id; b=E2AvW6sSOxh96i0U7bZOAv7oFztrI1DCpcd04HKvNNsHcOEw1obd8MjRDVaUMqYBIYxKk1MYnvtPe5z3GDAeOWQt83azuC5oaQMhm5F7GdQ+Up+zIqvE9xpbsK2/f8kgljYutc6cqkRMjPA6hDJ/nLi7rcEmUGVx7UAMJ9OJIRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EDvZocM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EDvZocM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DF8C4CEC6;
	Sat, 12 Oct 2024 22:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728771723;
	bh=fjilsVe1a80tPGSkZ0rRLQBzDDXbagw4rDtkt3pi2j4=;
	h=Date:To:From:Subject:From;
	b=EDvZocM2kMn55kW7s3tf75SGqOw57rqOPcaDd7n/t6HRaDJfXjNN3C4Qmt9DC5eg8
	 XEH1WNaLntw3Q03DSaFIKGHgAcfgTrC/Ca9EUOdr3PxaADzXjhyr1uBBeYeOYeqi2I
	 fkUb45Mdiy2Tz1IJFm6YEKVaGFkXKoIV6dt4MXO8=
Date: Sat, 12 Oct 2024 15:22:03 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,keescook@chromium.org,jhubbard@nvidia.com,glider@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1.patch added to mm-unstable branch
Message-Id: <20241012222203.C2DF8C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: avoid zeroing user movable page twice with init_on_alloc=1
has been added to the -mm mm-unstable branch.  Its filename is
     mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm: avoid zeroing user movable page twice with init_on_alloc=1
Date: Fri, 11 Oct 2024 11:03:04 -0400

Commit 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and
init_on_free=1 boot options") forces allocated page to be zeroed in
post_alloc_hook() when init_on_alloc=1.

For order-0 folios, if arch does not define
vma_alloc_zeroed_movable_folio(), the default implementation again zeros
the page return from the buddy allocator.  So the page is zeroed twice. 
Fix it by passing __GFP_ZERO instead to avoid double page zeroing.  At the
moment, s390,arm64,x86,alpha,m68k are not impacted since they define their
own vma_alloc_zeroed_movable_folio().

For >0 order folios (mTHP and PMD THP), folio_zero_user() is called to
zero the folio again.  Fix it by calling folio_zero_user() only if
init_on_alloc is set.  All arch are impacted.

Add alloc_zeroed() helper to encapsulate the init_on_alloc check.

Link: https://lkml.kernel.org/r/20241011150304.709590-1-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    8 +-------
 mm/huge_memory.c        |    3 ++-
 mm/internal.h           |    6 ++++++
 mm/memory.c             |    3 ++-
 4 files changed, 11 insertions(+), 9 deletions(-)

--- a/include/linux/highmem.h~mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1
+++ a/include/linux/highmem.h
@@ -224,13 +224,7 @@ static inline
 struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
-	struct folio *folio;
-
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
-	if (folio)
-		clear_user_highpage(&folio->page, vaddr);
-
-	return folio;
+	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr);
 }
 #endif
 
--- a/mm/huge_memory.c~mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1
+++ a/mm/huge_memory.c
@@ -1176,7 +1176,8 @@ static struct folio *vma_alloc_anon_foli
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-	folio_zero_user(folio, addr);
+	if (!alloc_zeroed())
+		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * folio_zero_user writes become visible before the set_pmd_at()
--- a/mm/internal.h~mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1
+++ a/mm/internal.h
@@ -1233,6 +1233,12 @@ void touch_pud(struct vm_area_struct *vm
 void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	       pmd_t *pmd, bool write);
 
+static inline bool alloc_zeroed(void)
+{
+	return static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
+			&init_on_alloc);
+}
+
 enum {
 	/* mark page accessed */
 	FOLL_TOUCH = 1 << 16,
--- a/mm/memory.c~mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1
+++ a/mm/memory.c
@@ -4719,7 +4719,8 @@ static struct folio *alloc_anon_folio(st
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
-			folio_zero_user(folio, vmf->address);
+			if (!alloc_zeroed())
+				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
 next:
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1.patch

