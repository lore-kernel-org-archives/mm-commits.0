Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CE637B3F1
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 16:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774369394; cv=none; b=AQNETZzvfxEi8NYX3DbAKKoPpb41XzH4+ekCI9g6id8RjboedLNcW7QXOFLHSN1FF6yi9jW8FF3Q4UNBv4RLdUIQ/hc2liKXxJLMCVOF98w6WAzAUnV/ucLBOE539NVs3/ZO23GtzrfHlpjtCra3Ba7ok86bzDL7hjsIm/l0hY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774369394; c=relaxed/simple;
	bh=iCX3jW4Qp3htDGyNQ9qYTdu559yqtstbajKzdG9NBps=;
	h=Date:To:From:Subject:Message-Id; b=O0gjfIs/pP1tYY8XdFcJKZGp7m7pYu9kC3kX7bcZG4Z/ONauk9cDudGMgMZWhtP2JyUST24Dp18QeR3QiavxGWMHjv0koFxPu8O4FcCSkAZ5/J60gf51mvQFOVUUgk5r0+/Eh1hYK2jofhhHdBPv/LI2X0oiYax4Yz79xkpfn1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gMzmtAkD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gMzmtAkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18E3C19424;
	Tue, 24 Mar 2026 16:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774369393;
	bh=iCX3jW4Qp3htDGyNQ9qYTdu559yqtstbajKzdG9NBps=;
	h=Date:To:From:Subject:From;
	b=gMzmtAkDUaYukXd0beZmb3cx357WmZuK5MsOY5yNUfSvQ9JQf37cUY1a9bB3mmFan
	 F8azWfQfMSYblo2hsmS7ah8Q8IpAd++jeXmMmfmVUPEwiX9QMU+stCnFgdY7+VKvQB
	 NnOlpLPlsazoEdKNcEqyF6ATPdvL/qCgOBC11ro4=
Date: Tue, 24 Mar 2026 09:23:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,jhladky@redhat.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-special-case-small-folios-when-applying-write-permissions.patch added to mm-new branch
Message-Id: <20260324162313.B18E3C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mprotect: special-case small folios when applying write permissions
has been added to the -mm mm-new branch.  Its filename is
     mm-mprotect-special-case-small-folios-when-applying-write-permissions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-special-case-small-folios-when-applying-write-permissions.patch

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

mm-mprotect-move-softleaf-code-out-of-the-main-function.patch
mm-mprotect-special-case-small-folios-when-applying-write-permissions.patch

