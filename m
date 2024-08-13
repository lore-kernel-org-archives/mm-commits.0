Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C94515A8
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 02:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723516066; cv=none; b=Tvcy0/7Ji3jxCfYdBbfV8eLU7ieQzAWGh+vCHSTYk9WJ+g01Pl36xscAFtn+w0X8j45kUae1kbszwuZ22uhNIocvGTIZev0CT4nSFAJl5K2gd+YbJZVWuGHr8LGRYwDB1fkJxS4j0SbnLhwYKvH8FR3eeOV3+iiYIyWv07uePJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723516066; c=relaxed/simple;
	bh=/tTyZBLYguGdpfUszEsQIfock1ctfBPxeAdUFKa0NBE=;
	h=Date:To:From:Subject:Message-Id; b=nE23VcTHE5bqtgkMX/GugeQFBT3cUMpeNOXmC3Ra79ibR+fJNZ5D1+wetyJyaHX/PZFfve2MVAa98eeC35YFCNVWYzipcyC+wK4fWJpK5TqQSKgBzahYHm20dyo0SjM70IFC6M7CgBokDk4iiwMNORiRLFOo+dp/IYHhBsARgjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DIL1wEsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DIL1wEsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1832C4AF11;
	Tue, 13 Aug 2024 02:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723516065;
	bh=/tTyZBLYguGdpfUszEsQIfock1ctfBPxeAdUFKa0NBE=;
	h=Date:To:From:Subject:From;
	b=DIL1wEsUj92mo1p7BFqqb9k5G15c0NHEhwVDMhMi/0/httE4jusp0c/eOwr2gg9Uu
	 UK16vQBtnUHGQOJx4mO8RqgrFtf47yl4OdSQIUj/Z4TcQVxxsfVOhkt5lAvmfQUjdt
	 gH/O9UChe8W9Ev53XP+zZRuf74y+ptfA3aUN026g=
Date: Mon, 12 Aug 2024 19:27:45 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mgorman@techsingularity.net,kirill@shutemov.name,jthoughton@google.com,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mprotect-push-mmu-notifier-to-puds.patch removed from -mm tree
Message-Id: <20240813022745.A1832C4AF11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mprotect: push mmu notifier to PUDs
has been removed from the -mm tree.  Its filename was
     mm-mprotect-push-mmu-notifier-to-puds.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/mprotect: push mmu notifier to PUDs
Date: Wed, 7 Aug 2024 15:48:06 -0400

mprotect() does mmu notifiers in PMD levels.  It's there since 2014 of
commit a5338093bfb4 ("mm: move mmu notifier call from change_protection to
change_pmd_range").

At that time, the issue was that NUMA balancing can be applied on a huge
range of VM memory, even if nothing was populated.  The notification can
be avoided in this case if no valid pmd detected, which includes either
THP or a PTE pgtable page.

Now to pave way for PUD handling, this isn't enough.  We need to generate
mmu notifications even on PUD entries properly.  mprotect() is currently
broken on PUD (e.g., one can easily trigger kernel error with dax 1G
mappings already), this is the start to fix it.

To fix that, this patch proposes to push such notifications to the PUD
layers.

There is risk on regressing the problem Rik wanted to resolve before, but
I think it shouldn't really happen, and I still chose this solution
because of a few reasons:

  1) Consider a large VM that should definitely contain more than GBs
     of memory, it's highly likely that PUDs are also none.  In this case
     there will have no regression.

  2) KVM has evolved a lot over the years to get rid of rmap walks,
     which might be the major cause of the previous soft-lockup.  At least
     TDP MMU already got rid of rmap as long as not nested (which should
     be the major use case, IIUC), then the TDP MMU pgtable walker will
     simply see empty VM pgtable (e.g.  EPT on x86), the invalidation of a
     full empty region in most cases could be pretty fast now, comparing
     to 2014.

  3) KVM has explicit code paths now to even give way for mmu
     notifiers just like this one, e.g.  in commit d02c357e5bfa ("KVM:
     x86/mmu: Retry fault before acquiring mmu_lock if mapping is
     changing").  It'll also avoid contentions that may also contribute to
     a soft-lockup.

  4) Stick with PMD layer simply don't work when PUD is there...  We
     need one way or another to fix PUD mappings on mprotect().

Pushing it to PUD should be the safest approach as of now, e.g.  there's
yet no sign of huge P4D coming on any known archs.

Link: https://lkml.kernel.org/r/20240807194812.819412-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-push-mmu-notifier-to-puds
+++ a/mm/mprotect.c
@@ -363,9 +363,6 @@ static inline long change_pmd_range(stru
 	unsigned long next;
 	long pages = 0;
 	unsigned long nr_huge_updates = 0;
-	struct mmu_notifier_range range;
-
-	range.start = 0;
 
 	pmd = pmd_offset(pud, addr);
 	do {
@@ -383,14 +380,6 @@ again:
 		if (pmd_none(*pmd))
 			goto next;
 
-		/* invoke the mmu notifier if the pmd is populated */
-		if (!range.start) {
-			mmu_notifier_range_init(&range,
-				MMU_NOTIFY_PROTECTION_VMA, 0,
-				vma->vm_mm, addr, end);
-			mmu_notifier_invalidate_range_start(&range);
-		}
-
 		_pmd = pmdp_get_lockless(pmd);
 		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd) || pmd_devmap(_pmd)) {
 			if ((next - addr != HPAGE_PMD_SIZE) ||
@@ -431,9 +420,6 @@ next:
 		cond_resched();
 	} while (pmd++, addr = next, addr != end);
 
-	if (range.start)
-		mmu_notifier_invalidate_range_end(&range);
-
 	if (nr_huge_updates)
 		count_vm_numa_events(NUMA_HUGE_PTE_UPDATES, nr_huge_updates);
 	return pages;
@@ -443,22 +429,36 @@ static inline long change_pud_range(stru
 		struct vm_area_struct *vma, p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
+	struct mmu_notifier_range range;
 	pud_t *pud;
 	unsigned long next;
 	long pages = 0, ret;
 
+	range.start = 0;
+
 	pud = pud_offset(p4d, addr);
 	do {
 		next = pud_addr_end(addr, end);
 		ret = change_prepare(vma, pud, pmd, addr, cp_flags);
-		if (ret)
-			return ret;
+		if (ret) {
+			pages = ret;
+			break;
+		}
 		if (pud_none_or_clear_bad(pud))
 			continue;
+		if (!range.start) {
+			mmu_notifier_range_init(&range,
+						MMU_NOTIFY_PROTECTION_VMA, 0,
+						vma->vm_mm, addr, end);
+			mmu_notifier_invalidate_range_start(&range);
+		}
 		pages += change_pmd_range(tlb, vma, pud, addr, next, newprot,
 					  cp_flags);
 	} while (pud++, addr = next, addr != end);
 
+	if (range.start)
+		mmu_notifier_invalidate_range_end(&range);
+
 	return pages;
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-powerpc-add-missing-pud-helpers.patch
mm-x86-make-pud_leaf-only-care-about-pse-bit.patch
mm-x86-arch_check_zapped_pud.patch
mm-x86-add-missing-pud-helpers.patch
mm-mprotect-fix-dax-pud-handlings.patch

