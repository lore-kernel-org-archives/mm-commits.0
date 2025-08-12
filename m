Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CB52356DA
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 06:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754978485; cv=none; b=m3qQBZckRc0Bxcv+TqB0Q6fUojigG67w1jmzWGMv2BzZf2kc8wFmoDDvIdWqSA1zthwn7ZZYTqx1CcJ+Pi7xidvVizFx2hlNT7s2aQkFj9+KpetmtVM3SmxWVSYsRkIrln1uslN02cyRmZuqRG9imcCZJ3RUqd2yAsu3dBNjdS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754978485; c=relaxed/simple;
	bh=S4pGazGBLvVXjjNTIqr1/ZLtc6jveiGfk905Xpbcu9M=;
	h=Date:To:From:Subject:Message-Id; b=ilxTXPEGKPWYm6g8Ys9Ku629W13+55PNjQpQf3ATGz14a88JGG5LuSUHbGJfEdevlru/1LoDI+zmFLSIR8FZvhxH52U1F3WX2FENzmDuCNRPahnR9w5qJhIA4JdztVVBvzmNV3dGtXwNfs0F5QqRTsDXkptGi99YBYV1FR3ICYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1z8CScop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1z8CScop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9344C4CEF0;
	Tue, 12 Aug 2025 06:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754978484;
	bh=S4pGazGBLvVXjjNTIqr1/ZLtc6jveiGfk905Xpbcu9M=;
	h=Date:To:From:Subject:From;
	b=1z8CScop7r5NJw9+ce2U+89qMkIcgVK7gxYPyk1ItP2VlFgoVgrlPOqqlL5DsIabu
	 kLwIZPsJHKqbGm0MjCtFucaWwfMHC4ZIPn4pMq4jqaOsjqIypopig/mHfn+dQffYRy
	 M+lj7o0DUwnY2A36mK6KTLObdWSrPEBvlbd1b1Qw=
Date: Mon, 11 Aug 2025 23:01:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangyicong@hisilicon.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,quic_zhenhuah@quicinc.com,peterx@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,joey.gouly@arm.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-pass-page-directly-instead-of-using-folio_page.patch removed from -mm tree
Message-Id: <20250812060124.C9344C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pass page directly instead of using folio_page
has been removed from the -mm tree.  Its filename was
     mm-pass-page-directly-instead-of-using-folio_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: pass page directly instead of using folio_page
Date: Wed, 6 Aug 2025 20:26:11 +0530

In commit_anon_folio_batch(), we iterate over all pages pointed to by the
PTE batch.  Therefore we need to know the first page of the batch;
currently we derive that via folio_page(folio, 0), but, that takes us to
the first (head) page of the folio instead - our PTE batch may lie in the
middle of the folio, leading to incorrectness.

Bite the bullet and throw away the micro-optimization of reusing the folio
in favour of code simplicity.  Derive the page and the folio in
change_pte_range, and pass the page too to commit_anon_folio_batch to fix
the aforementioned issue.

Link: https://lkml.kernel.org/r/20250806145611.3962-1-dev.jain@arm.com
Fixes: cac1db8c3aad ("mm: optimize mprotect() by PTE batching")
Reported-by: syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Debugged-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/mm/mprotect.c~mm-pass-page-directly-instead-of-using-folio_page
+++ a/mm/mprotect.c
@@ -120,9 +120,8 @@ static int mprotect_folio_pte_batch(stru
 
 static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
 			   pte_t oldpte, pte_t *pte, int target_node,
-			   struct folio **foliop)
+			   struct folio *folio)
 {
-	struct folio *folio = NULL;
 	bool ret = true;
 	bool toptier;
 	int nid;
@@ -131,7 +130,6 @@ static bool prot_numa_skip(struct vm_are
 	if (pte_protnone(oldpte))
 		goto skip;
 
-	folio = vm_normal_folio(vma, addr, oldpte);
 	if (!folio)
 		goto skip;
 
@@ -173,7 +171,6 @@ static bool prot_numa_skip(struct vm_are
 		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
 
 skip:
-	*foliop = folio;
 	return ret;
 }
 
@@ -231,10 +228,9 @@ static int page_anon_exclusive_sub_batch
  * retrieve sub-batches.
  */
 static void commit_anon_folio_batch(struct vm_area_struct *vma,
-		struct folio *folio, unsigned long addr, pte_t *ptep,
+		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
-	struct page *first_page = folio_page(folio, 0);
 	bool expected_anon_exclusive;
 	int sub_batch_idx = 0;
 	int len;
@@ -251,7 +247,7 @@ static void commit_anon_folio_batch(stru
 }
 
 static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
-		struct folio *folio, unsigned long addr, pte_t *ptep,
+		struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
 	bool set_write;
@@ -270,7 +266,7 @@ static void set_write_prot_commit_flush_
 				       /* idx = */ 0, set_write, tlb);
 		return;
 	}
-	commit_anon_folio_batch(vma, folio, addr, ptep, oldpte, ptent, nr_ptes, tlb);
+	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
 }
 
 static long change_pte_range(struct mmu_gather *tlb,
@@ -305,15 +301,19 @@ static long change_pte_range(struct mmu_
 			const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | FPB_RESPECT_WRITE;
 			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
 			struct folio *folio = NULL;
+			struct page *page;
 			pte_t ptent;
 
+			page = vm_normal_page(vma, addr, oldpte);
+			if (page)
+				folio = page_folio(page);
 			/*
 			 * Avoid trapping faults against the zero or KSM
 			 * pages. See similar comment in change_huge_pmd.
 			 */
 			if (prot_numa) {
 				int ret = prot_numa_skip(vma, addr, oldpte, pte,
-							 target_node, &folio);
+							 target_node, folio);
 				if (ret) {
 
 					/* determine batch to skip */
@@ -323,9 +323,6 @@ static long change_pte_range(struct mmu_
 				}
 			}
 
-			if (!folio)
-				folio = vm_normal_folio(vma, addr, oldpte);
-
 			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
 
 			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
@@ -351,7 +348,7 @@ static long change_pte_range(struct mmu_
 			 */
 			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
 			     !pte_write(ptent))
-				set_write_prot_commit_flush_ptes(vma, folio,
+				set_write_prot_commit_flush_ptes(vma, folio, page,
 				addr, pte, oldpte, ptent, nr_ptes, tlb);
 			else
 				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
_

Patches currently in -mm which might be from dev.jain@arm.com are


