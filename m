Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB5253E1D
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970514; cv=none; b=N6jwvJjNQ0NtgHKYLkOQuksYA8M3ygKmyjeAwr8x1WqKAqp2aGX5MfRcVgBjvtZr7MuLEfc/2xoavrJ/3sM9lbxJxYqN7/KwPc4Su/tFvhcP5MnqeSwHn0w+ARPgT9n/hJaUESDWG0F567g/KWCslASw2kzcEuAesVg5GYD6Np8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970514; c=relaxed/simple;
	bh=vDWQVbOB3vxJVu257Ui4DAzgDAvY/KkbrNFtXTupxRs=;
	h=Date:To:From:Subject:Message-Id; b=Bs3sB28et+viY+DgfMz2K5F4W6JbQ0Mw8FGbE2a3xhMF3BIkusVSdC3cHpO4XO0Duj1KXxjk6HiugJPHXlRw6zNOugb/HqRDbOiKZRT8ZVKGJGRZEouYMLWCYmUB1WkoMfwcQnhDZCywnjUspYgEm8IrlFs8cd28lGBYMjLbeQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kWToRqMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kWToRqMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AA2C433F1;
	Tue, 23 Jan 2024 00:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970514;
	bh=vDWQVbOB3vxJVu257Ui4DAzgDAvY/KkbrNFtXTupxRs=;
	h=Date:To:From:Subject:From;
	b=kWToRqMXoVo9dlNf4Bzm4E085uO4WlkrSe7k3CeIDqC66c1s2fGuJHy5Ky41AtmYl
	 2g73m3DlAYDZSobyii+0FFHIL7ZuF4IDroAl6cNW/JPv9itEKHv/yXW6/n0oNmL/8y
	 zD73/omtVDgirjU04xHwJZU+EuIuU5PRNsKl6Ep8=
Date: Mon, 22 Jan 2024 16:41:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-ignore-writable-bit-in-folio_pte_batch.patch added to mm-unstable branch
Message-Id: <20240123004153.E8AA2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: ignore writable bit in folio_pte_batch()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-ignore-writable-bit-in-folio_pte_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-ignore-writable-bit-in-folio_pte_batch.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: ignore writable bit in folio_pte_batch()
Date: Mon, 22 Jan 2024 20:42:00 +0100

...  and conditionally return to the caller if any pte except the first
one is writable.  fork() has to make sure to properly write-protect in
case any PTE is writable.  Other users (e.g., page unmaping) won't care.

Link: https://lkml.kernel.org/r/20240122194200.381241-12-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-memory-ignore-writable-bit-in-folio_pte_batch
+++ a/mm/memory.c
@@ -955,7 +955,7 @@ static __always_inline void __copy_prese
 
 static inline pte_t __pte_batch_clear_ignored(pte_t pte)
 {
-	return pte_clear_soft_dirty(pte_mkclean(pte_mkold(pte)));
+	return pte_wrprotect(pte_clear_soft_dirty(pte_mkclean(pte_mkold(pte))));
 }
 
 /*
@@ -963,20 +963,29 @@ static inline pte_t __pte_batch_clear_ig
  * pages of the same folio.
  *
  * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN.
- * the accessed bit, dirty bit and soft-dirty bit.
+ * the accessed bit, dirty bit, soft-dirty bit and writable bit.
+ . If "any_writable" is set, it will indicate if any other PTE besides the
+ * first (given) PTE is writable.
  */
 static inline int folio_pte_batch(struct folio *folio, unsigned long addr,
-		pte_t *start_ptep, pte_t pte, int max_nr)
+		pte_t *start_ptep, pte_t pte, int max_nr, bool *any_writable)
 {
 	unsigned long folio_end_pfn = folio_pfn(folio) + folio_nr_pages(folio);
 	const pte_t *end_ptep = start_ptep + max_nr;
 	pte_t expected_pte = __pte_batch_clear_ignored(pte_next_pfn(pte));
 	pte_t *ptep = start_ptep + 1;
+	bool writable;
+
+	if (any_writable)
+		*any_writable = false;
 
 	VM_WARN_ON_FOLIO(!pte_present(pte), folio);
 
 	while (ptep != end_ptep) {
-		pte = __pte_batch_clear_ignored(ptep_get(ptep));
+		pte = ptep_get(ptep);
+		if (any_writable)
+			writable = !!pte_write(pte);
+		pte = __pte_batch_clear_ignored(pte);
 
 		if (!pte_same(pte, expected_pte))
 			break;
@@ -989,6 +998,9 @@ static inline int folio_pte_batch(struct
 		if (pte_pfn(pte) == folio_end_pfn)
 			break;
 
+		if (any_writable)
+			*any_writable |= writable;
+
 		expected_pte = pte_next_pfn(expected_pte);
 		ptep++;
 	}
@@ -1010,6 +1022,7 @@ copy_present_ptes(struct vm_area_struct
 {
 	struct page *page;
 	struct folio *folio;
+	bool any_writable;
 	int err, nr;
 
 	page = vm_normal_page(src_vma, addr, pte);
@@ -1024,7 +1037,8 @@ copy_present_ptes(struct vm_area_struct
 	 * by keeping the batching logic separate.
 	 */
 	if (unlikely(!*prealloc && folio_test_large(folio) && max_nr != 1)) {
-		nr = folio_pte_batch(folio, addr, src_pte, pte, max_nr);
+		nr = folio_pte_batch(folio, addr, src_pte, pte, max_nr,
+				     &any_writable);
 		if (folio_test_anon(folio)) {
 			folio_ref_add(folio, nr);
 			if (unlikely(folio_try_dup_anon_rmap_ptes(folio, page,
@@ -1039,6 +1053,8 @@ copy_present_ptes(struct vm_area_struct
 			folio_dup_file_rmap_ptes(folio, page, nr);
 			rss[mm_counter_file(page)] += nr;
 		}
+		if (any_writable)
+			pte = pte_mkwrite(pte, src_vma);
 		__copy_present_ptes(dst_vma, src_vma, dst_pte, src_pte, pte,
 				    addr, nr);
 		return nr;
_

Patches currently in -mm which might be from david@redhat.com are

uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages.patch
arm-pgtable-define-pfn_pte_shift-on-arm-and-arm64.patch
nios2-pgtable-define-pfn_pte_shift.patch
powerpc-pgtable-define-pfn_pte_shift.patch
risc-pgtable-define-pfn_pte_shift.patch
s390-pgtable-define-pfn_pte_shift.patch
sparc-pgtable-define-pfn_pte_shift.patch
mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch
mm-memory-pass-pte-to-copy_present_pte.patch
mm-memory-optimize-fork-with-pte-mapped-thp.patch
mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch
mm-memory-ignore-writable-bit-in-folio_pte_batch.patch

