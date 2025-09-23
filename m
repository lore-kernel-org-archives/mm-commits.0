Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055C11A7264
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 21:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758663036; cv=none; b=FwmuNm7IHkhDGfzJW7QBqy4IEEfJwciOdvv/Yh4lNluMHJu0pKx8pBOLSqmsKdq1VEm8I/eF4XJ5aCUJJ1RxdSkifPEyVKeXmKCVPTtOSpNqB1bfRMMwdW+4RhBKSw9KJzMTklX9XuOMyq0BDxh6zWGvw+q8BKIWjS1vz3ImpsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758663036; c=relaxed/simple;
	bh=nCV6ZQ9cfeGp3x3kQzZ+vUMftZGBqdKMC6Fb2c2lV9Q=;
	h=Date:To:From:Subject:Message-Id; b=gOhTWBgdjG1uUgeW1/GMizDBm8hxikn1m4JeLa/ZmcB+x85fVWeoNtRg08DsyvyfojAztjO2RPEmiTmhsSxkwSc6HmCJPktemax/fFxzgnP0Cx0XND/HIxoel6jxyelJSpyOlJd3+CKHoLdb8t9D/tfdHtRtnSWt34atUhKZWEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l2sc4Afi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l2sc4Afi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B52C4CEF7;
	Tue, 23 Sep 2025 21:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758663035;
	bh=nCV6ZQ9cfeGp3x3kQzZ+vUMftZGBqdKMC6Fb2c2lV9Q=;
	h=Date:To:From:Subject:From;
	b=l2sc4Afi0vTTnEf8buc7+BYq6TBLWwdrEt/Dp3FGl62CnlkIlQ0k31k8bu9flEhPc
	 JwlIeX6z8lsqs5QMOd+CbsGcw36fENNiMmLITZFf/SB2kg+AVq/dkB1M1rg4x2eFxq
	 tCjGP3Ub2dEgPHuLy4bstRDM9wtk+oUJcf75zFGo=
Date: Tue, 23 Sep 2025 14:30:35 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,kas@kernel.org,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix.patch added to mm-unstable branch
Message-Id: <20250923213035.B7B52C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix
Date: Tue Sep 23 02:27:40 PM PDT 2025

s/CROSSSED/CROSSED/

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/page_vma_mapped.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/rmap.h~mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix
+++ a/include/linux/rmap.h
@@ -925,7 +925,7 @@ struct page *make_device_exclusive(struc
 /* Result flags */
 
 /* The page is mapped across page table boundary */
-#define PVMW_PGTABLE_CROSSSED	(1 << 16)
+#define PVMW_PGTABLE_CROSSED	(1 << 16)
 
 struct page_vma_mapped_walk {
 	unsigned long pfn;
--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix
+++ a/mm/page_vma_mapped.c
@@ -309,7 +309,7 @@ next_pte:
 				}
 				pte_unmap(pvmw->pte);
 				pvmw->pte = NULL;
-				pvmw->flags |= PVMW_PGTABLE_CROSSSED;
+				pvmw->flags |= PVMW_PGTABLE_CROSSED;
 				goto restart;
 			}
 			pvmw->pte++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one-fix.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch

