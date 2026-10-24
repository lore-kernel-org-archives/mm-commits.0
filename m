Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832250;
	b=0l3e3rZXkZSYfHDsEnLHJRhHUi1aWG89+Bzvn/MRDVScETpwK8OV1fWUfaEqL41OqnNd
	 TiwAYCzDdPz6evahTSBv1Px6cnis1GJCR1raDQ43d5mJV0IYofyQdzFk9b8rUqm29lcz/
	 gbbHPjFEsb8KTuyF8F0G1yu8atrMSEUFkyJc+N422/d0kqbjsAXCKdfuefx9hygsl0VPv
	 4j7L5yUj88cjOPpLvNMX3Og4/Xaao/shReUU/oOO8hg11f7LaAI7rcqe3j3Pl4k9jRYat
	 Fv+t1BORAPlCbZlCKfPIFEa6cEbM1bpVCkV2YJdZBZbcd7BPggy+zw8C1kLBnPbT8eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832250;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=c62GIyb0zH8DVvKA4a462Yi/RXSvLI77Xr1xKoFKZbE=;
	b=ghEGPaG1DMwrj01Wp6FkBri3RAht75FdOFqth0YAs94/brZDdiJIoGImlJ/eRfBps2uY
	 CVJrIdAawRsjMml2Ww33Zh6N5dYgarTZ5oKlKMcty0Bmjvqqv6BY1yRwkwevQzImFdgb2
	 IUgEImrOV5tbZWWCXz3L5Dhye4r7Tly8wH+u6UXBsNPF2zdCITYwfCgnyl+pwxsS8nDwM
	 SON+nhtu8MDnrlFmFUBunJkAn7BfppIFYDP2iwvaukK60T+BGdV+j8gw3xe7B/vuDfruu
	 cXST+PPAsu63aIrtjg1Ktt/F4BWkVQuaBYD00T1rGxMy1BmFfBvk5KJPlws8OLvki4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YwkNRBiT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC1A606A31B;
	Sat, 24 Oct 2026 08:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YwkNRBiT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37D91F01825;
	Sat, 24 Oct 2026 08:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832249;
	bh=c62GIyb0zH8DVvKA4a462Yi/RXSvLI77Xr1xKoFKZbE=;
	h=Date:To:From:Subject;
	b=YwkNRBiTsnMBTQXhdOgHguhuCT3L1IkIKjC9Tcz6953zXfZKbDGjtGBR6nCRPmgf2
	 eInlW0u1Wk7DxNijAYeRxgohD9ARYw/M798MzRC5dJ7FwmXoAARnyZhzGlrxdDijKX
	 zQeM2dz4ji34wbBKopRHnuFrF7hTHK2AfLeUNlmQ=
Date: Sat, 24 Oct 2026 01:57:29 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mgorman@techsingularity.net,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,josef@toxicpanda.com,jannh@google.com,agl@us.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-tolerate-uffd-bits-set-without-uffd-for-prot_none-ptes.patch removed from -mm tree
Message-Id: <20261024085729.C37D91F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: tolerate uffd bits set without uffd for PROT_NONE PTEs
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-tolerate-uffd-bits-set-without-uffd-for-prot_none-ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/hugetlb: tolerate uffd bits set without uffd for PROT_NONE PTEs
Date: Thu, 15 Oct 2026 18:07:13 +0200

The whole uffd handling when a VMA is unregistered from UFFD is shaky:
there are still some scenarios where we might have stale uffd PTE bits
in VMAs no longer registered for UFFD, which confuses other code.

Let's just tolerate that for now and simply clear the PTE bit. Add a
TODO to really clean up any uffd leftovers when unregistering a VMA from
userfaultfd.

The handling is now more similar to what we have in handle_pte_fault().

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-7-42796911043b@kernel.org
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-tolerate-uffd-bits-set-without-uffd-for-prot_none-ptes
+++ a/mm/hugetlb.c
@@ -6169,16 +6169,20 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * NUMA hinting), so let normal hugetlb fault handling proceed.
 	 */
 	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
-	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
+	    huge_pte_uffd(vmf.orig_pte)) {
 		spinlock_t *ptl;
 		pte_t pte;
 
 		/* Sync: drop hugetlb locks before blocking in handle_userfault() */
-		if (!userfaultfd_rwp_async(vma))
+		if (userfaultfd_rwp(vma) && !userfaultfd_rwp_async(vma))
 			return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
 
 		ptl = huge_pte_lock(h, mm, vmf.pte);
 		pte = huge_ptep_get(mm, vmf.address, vmf.pte);
+		/*
+		 * TODO: fix all cases where uffd PTE bits remain in VMAs that
+		 * are no longer registered with uffd.
+		 */
 		if (pte_protnone(pte) && huge_pte_uffd(pte)) {
 			unsigned int shift = huge_page_shift(h);
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

