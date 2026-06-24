Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C0D3E2AD1
	for <mm-commits@vger.kernel.org>; Wed, 24 Jun 2026 20:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782333600; cv=none; b=PsxbtAZH7jKRXHfTgmXxhcVWOTUQjnIxHXVEZBSADIBvn8zmjvvnyc0na+MPbr1ab2FeNJsjlKEJDycZQKmnJGTECP1m74Q30YzzJJNXL6LTXC/bQq3ajiQcgXMWx18hHlJ2PHPhmXU3HjLaDwKQbXYqzL/i9mcRWT4kM05P3O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782333600; c=relaxed/simple;
	bh=EapGSS34toVs13FF/79sU+EamTCZmshvDuj+H1KwhkQ=;
	h=Date:To:From:Subject:Message-Id; b=F7vyxm2NHwdCkLxrbS74HYnvhdzwEJsjkuiHOkebRIjqwEYY/gaYaLl+0Tf9ABJ+WCTGpOvVwnB1EpmXTaGA6mUA3cMBbjbhoSGubA+5sZNjil7hdxihuBKNNRYLeAVZ3SfwTiylXF953eMGhEc7FosmJN1O2gz4OSQ7QrC2fyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AzC/J/AF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AzC/J/AF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34141F00A3A;
	Wed, 24 Jun 2026 20:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782333593;
	bh=sRIHXJ4uqGWX9FsWF1ypdHuJnM2Q0hHirMvgSHOEktw=;
	h=Date:To:From:Subject;
	b=AzC/J/AFpxDnjI4h5vSJemC7CEbLW2NVqk6xDx8EBaF0KWLDYqiqdO6YwCLPbwe7G
	 Ux9WFtoeebbNTZu0Y0Iw17mQ0W1mnkrlEApOSVfxXFXPDXoMdbfZ2+zZvwrkgSq/4P
	 5mzLgdOuon5OfMO4V7ZGLnnXjLiIzBXwDrIDweCo=
Date: Wed, 24 Jun 2026 13:39:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,pfalcato@suse.de,nphamcs@gmail.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-drop-sub-from-batching-context.patch added to mm-new branch
Message-Id: <20260624203953.B34141F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mprotect: drop 'sub' from batching context
has been added to the -mm mm-new branch.  Its filename is
     mm-mprotect-drop-sub-from-batching-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-drop-sub-from-batching-context.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm/mprotect: drop 'sub' from batching context
Date: Tue, 23 Jun 2026 12:57:22 +0000

Shorten the name of page_anon_exclusive_sub_batch by dropping the
"sub-batch" context - the function itself doesn't need this context. 
Similarly, drop "sub" from sub_batch_idx, it is unnecessary and the usage
is clear enough.

Link: https://lore.kernel.org/20260623125723.2503832-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-drop-sub-from-batching-context
+++ a/mm/mprotect.c
@@ -143,7 +143,7 @@ static __always_inline void prot_commit_
  * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
  * that the ptes point to consecutive pages of the same anon large folio.
  */
-static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
+static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
 		struct page *first_page, bool expected_anon_exclusive)
 {
 	int idx;
@@ -174,16 +174,16 @@ static __always_inline void commit_anon_
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
 	bool expected_anon_exclusive;
-	int sub_batch_idx = 0;
+	int batch_idx = 0;
 	int len;
 
 	while (nr_ptes) {
-		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
-		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
+		expected_anon_exclusive = PageAnonExclusive(first_page + batch_idx);
+		len = page_anon_exclusive_batch(batch_idx, nr_ptes,
 					first_page, expected_anon_exclusive);
 		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
-				       sub_batch_idx, expected_anon_exclusive, tlb);
-		sub_batch_idx += len;
+				       batch_idx, expected_anon_exclusive, tlb);
+		batch_idx += len;
 		nr_ptes -= len;
 	}
 }
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch
mm-mprotect-drop-sub-from-batching-context.patch

