Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AE55CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956997; cv=none; b=mQ0Kkbpd9Dj/cFUU1YjZGHMIYAh11JgCwTf0XmMWSDuxdxc9lhhH1KyTGOMnbXwu+FWjA22ZpRZm41N07JRLhRjTYIwSzg7IPjn7FegqTdqYk3+DVhbsDYP0uYS3tfOST2n53NRbkj07/cqGN1gjxQO4IHbXRn9+zsQ2HTH2Ens=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956997; c=relaxed/simple;
	bh=M6wvL6eQeJK7JH2/+WD1U011LtOD6Mdf7l9Pvgff8M0=;
	h=Date:To:From:Subject:Message-Id; b=e1G+7SLWT1SMMymPpN+Wu0bOlwoizdB2uDmHaTVaEFHXrZwniUVxMYCN3q6iNkcfWGDcEBrSwRA30H4VIki2qiUvBAnyGNL0Uw4OMK+PuHFDn4tVZtL2LgFvCVXQSQnViqZDteaA2C0eAJ0F2C7R/Qt9t7i9Yvt+G7Pxo0/EP14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vPiRLLb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vPiRLLb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A88C113CC;
	Mon,  6 May 2024 00:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956997;
	bh=M6wvL6eQeJK7JH2/+WD1U011LtOD6Mdf7l9Pvgff8M0=;
	h=Date:To:From:Subject:From;
	b=vPiRLLb0Ui7iZkjDcPVSDXV0xr5tAEbi8nbzDJ47WR1vjkUm8Qv4UcD5bI44RbuO0
	 /upiB4cqx/g8+T5FeLpm51BMCFwvSbEFPTo5rokCE6NUyNwaYWo3OKSx+8jBOOZXKX
	 hKhtEVSjMxD73/333LACusV5ZpuVLBrZ7hmm/43E=
Date: Sun, 05 May 2024 17:56:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch removed from -mm tree
Message-Id: <20240506005636.F1A88C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: always inline anon/file rmap duplication of a single PTE
has been removed from the -mm tree.  Its filename was
     mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: always inline anon/file rmap duplication of a single PTE
Date: Tue, 9 Apr 2024 21:22:45 +0200

As we grow the code, the compiler might make stupid decisions and
unnecessarily degrade fork() performance.  Let's make sure to always
inline functions that operate on a single PTE so the compiler will always
optimize out the loop and avoid a function call.

This is a preparation for maintining a total mapcount for large folios.

Link: https://lkml.kernel.org/r/20240409192301.907377-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte
+++ a/include/linux/rmap.h
@@ -347,8 +347,12 @@ static inline void folio_dup_file_rmap_p
 {
 	__folio_dup_file_rmap(folio, page, nr_pages, RMAP_LEVEL_PTE);
 }
-#define folio_dup_file_rmap_pte(folio, page) \
-	folio_dup_file_rmap_ptes(folio, page, 1)
+
+static __always_inline void folio_dup_file_rmap_pte(struct folio *folio,
+		struct page *page)
+{
+	__folio_dup_file_rmap(folio, page, 1, RMAP_LEVEL_PTE);
+}
 
 /**
  * folio_dup_file_rmap_pmd - duplicate a PMD mapping of a page range of a folio
@@ -448,8 +452,13 @@ static inline int folio_try_dup_anon_rma
 	return __folio_try_dup_anon_rmap(folio, page, nr_pages, src_vma,
 					 RMAP_LEVEL_PTE);
 }
-#define folio_try_dup_anon_rmap_pte(folio, page, vma) \
-	folio_try_dup_anon_rmap_ptes(folio, page, 1, vma)
+
+static __always_inline int folio_try_dup_anon_rmap_pte(struct folio *folio,
+		struct page *page, struct vm_area_struct *src_vma)
+{
+	return __folio_try_dup_anon_rmap(folio, page, 1, src_vma,
+					 RMAP_LEVEL_PTE);
+}
 
 /**
  * folio_try_dup_anon_rmap_pmd - try duplicating a PMD mapping of a page range
_

Patches currently in -mm which might be from david@redhat.com are


