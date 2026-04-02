Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BE0355803
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 18:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775154313; cv=none; b=MWsg37taBMpuUCZapKt4YrgI7EcUfbDA+xp3UJvR4yvZa3ROmv4HzAUp3jPFdhTyV87B2WQFe4agL3Lz3ur+y8zJVfnsghiE2Q3yin2Kz9VQ+ZLSqoDv4AUZlmV3oPB4AEemixIRjwPG5h7Uh3tSiLFD2sW82KothlZxWwskXMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775154313; c=relaxed/simple;
	bh=04nPVQ4LN2NBiz8VUDgTii+4QXZIGCnC175uB+OQN/4=;
	h=Date:To:From:Subject:Message-Id; b=dSnugLRVgvzE4XXPJb3yuwvQ5YuM5eX7kvsqnIOm+QJrE6xMMgavAlxq7jiaH4E4zsSnyItQrh5b2W/uB+3/lS0BI9GhYsmbFMO5OLYUEbYAOCkl6JUB6Dj2dDU6qAGqTTJDGJLkTqex4yxiiseEHgQ6vkOWCqOLezGGuunZ/lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k/St+6tH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k/St+6tH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F61C116C6;
	Thu,  2 Apr 2026 18:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775154312;
	bh=04nPVQ4LN2NBiz8VUDgTii+4QXZIGCnC175uB+OQN/4=;
	h=Date:To:From:Subject:From;
	b=k/St+6tH8MIsmCesPFVunZgXDqQIRbzw9Wof0o+komHkJTpPRBCaGs20F2W59HeQf
	 P0tjEErLVTfGy1ahdD2Le5rHSwK7LSLxJ+vpy8QVcFyVF0QUA+1uyd/+4yzNH4zg35
	 tpGeu9h6XVnCR9wbFry1STQ3bPSZ88aoSsMelM/w=
Date: Thu, 02 Apr 2026 11:25:12 -0700
To: mm-commits@vger.kernel.org,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mprotect-special-case-small-folios-when-applying-write-permissions.patch removed from -mm tree
Message-Id: <20260402182512.B2F61C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mprotect: special-case small folios when applying write permissions
has been removed from the -mm tree.  Its filename was
     mm-mprotect-special-case-small-folios-when-applying-write-permissions.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Pedro Falcato <pfalcato@suse.de>
Subject: mm/mprotect: special-case small folios when applying write permissions
Date: Tue, 24 Mar 2026 15:43:42 +0000

The common order-0 case is important enough to want its own branch, and
avoids the hairy, large loop logic that the CPU does not seem to handle
particularly well.

While at it, encourage the compiler to inline batch PTE logic and resolve
constant branches by adding __always_inline strategically.

Link: https://lkml.kernel.org/r/20260324154342.156640-3-pfalcato@suse.de
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Tested-by: Luke Yang <luyang@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jiri Hladky <jhladky@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-special-case-small-folios-when-applying-write-permissions
+++ a/mm/mprotect.c
@@ -103,7 +103,7 @@ bool can_change_pte_writable(struct vm_a
 	return can_change_shared_pte_writable(vma, pte);
 }
 
-static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
+static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 				    pte_t pte, int max_nr_ptes, fpb_t flags)
 {
 	/* No underlying folio, so cannot batch */
@@ -117,9 +117,9 @@ static int mprotect_folio_pte_batch(stru
 }
 
 /* Set nr_ptes number of ptes, starting from idx */
-static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
-		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
-		int idx, bool set_write, struct mmu_gather *tlb)
+static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
+		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
 {
 	/*
 	 * Advance the position in the batch by idx; note that if idx > 0,
@@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch
  * pte of the batch. Therefore, we must individually check all pages and
  * retrieve sub-batches.
  */
-static void commit_anon_folio_batch(struct vm_area_struct *vma,
+static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
 		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
@@ -177,6 +177,13 @@ static void commit_anon_folio_batch(stru
 	int sub_batch_idx = 0;
 	int len;
 
+	/* Optimize for the common order-0 case. */
+	if (likely(nr_ptes == 1)) {
+		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, 1,
+				       0, PageAnonExclusive(first_page), tlb);
+		return;
+	}
+
 	while (nr_ptes) {
 		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
 		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
_

Patches currently in -mm which might be from pfalcato@suse.de are


