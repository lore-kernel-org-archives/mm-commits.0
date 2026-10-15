Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECFC12B94;
	Thu, 15 Oct 2026 22:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105103; cv=none; b=ghrj/CwggoBKhkLOsTeGfTbRclxku9xqV+/Mg7s67HFJob8cGX65Wqc8xr2PWqPcpFPnwDAz3ZP9tTZFh+odmYFBu08jUrhPCwuWHeBFyg0pkHhez94yNRC/mlBgRF5DUt8O5ryqcp7nEdL1GzVRh0gFnaASJ/B6fEJmTB000HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105103; c=relaxed/simple;
	bh=xMvsp90UJwTUYDhCjJSiRL+WMN9gqEoHfUq3NvWcByQ=;
	h=Date:To:From:Subject:Message-Id; b=DLLp3lPQTSK6kXZ0DURqbELetGsxMtWi2l3XjDxvp36SW+ZCEzWUX5KxV8H9Xu0sJfkuCOnYf0TSCdJaAicz0KE1ZLAjpK5b37k8XVHgpVRlhCw0NmK29phDAh6gv38k+NxZ5+1Q0JE9WjpjC2y5IkLHzhfrrbupyQWAM8du4nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v9JNu2tB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v9JNu2tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1412E1F000C4;
	Thu, 15 Oct 2026 22:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792105102;
	bh=Sj4SAiwLNwzXHg3cKe/KjjP/RKz44lapV26i93FGZf0=;
	h=Date:To:From:Subject;
	b=v9JNu2tBpnZpPEJoeQ/QOqDWO4dd7BlXghcMzTU78CxMJEMuBIwu58Qjy86JNSrvD
	 e2IPxqJwdg3jOyan5tt7AQi3FmklQ1lhqk1UhDJDoCMrzPT5Fm92ciju90YG7prtZ7
	 qt8udG0vpkREQ/u++iqb8sbrX9aqODBXmgZAqLW4=
Date: Thu, 15 Oct 2026 15:58:21 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,mason@kernel.org,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,kas@kernel.org,jannh@google.com,david@kernel.org,agl@us.ibm.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-unmap-the-page-where-the-other-vma-maps-it.patch added to mm-hotfixes-unstable branch
Message-Id: <20261015225822.1412E1F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: unmap the page where the other VMA maps it
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-unmap-the-page-where-the-other-vma-maps-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-unmap-the-page-where-the-other-vma-maps-it.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/hugetlb: unmap the page where the other VMA maps it
Date: Thu, 15 Oct 2026 18:07:10 +0200

If the owner of a MAP_PRIVATE hugetlb mapping fails to allocate a page
for CoW, unmap_ref_private() unmaps the old page from all other private
VMAs that have no reservation of their own.  It finds them by the offset
in the file, but then zaps each of them at the address of the faulting
VMA.  Nothing says that another VMA maps the offset at that address: a
child can have moved its copy of the VMA with mremap(), and a second
mapping of the file is wherever mmap() has put it.

So __unmap_hugepage_range() walks the page tables of the other mm at an
address outside of iter_vma, where i_mmap_rwsem of this file protects
nothing and where anything can be mapped, and the page stays mapped where
it really is.

All of the following was seen on v7.3-rc6+ (g6c377d19d4a5) in KVM guests,
as a user without any privilege.  It takes a pool of 2 MiB pages with no
free page that is not reserved, so that the allocation fails: the user
can take or reserve what is free itself.

 - The child moves its VMA away.  The page is never unmapped, the
   mapcount stays 2, and the owner goes round retry_avoidcopy in
   hugetlb_wp() until the child is gone or a page becomes free.  SIGKILL
   to the owner does not end it.  5 of 5 runs.

 - The owner's mm has a second private mapping of the offset, made with
   MAP_NORESERVE.  The owner zaps its own entry and reads zeroes where
   its data was.  5 of 5 runs.

 - The child moves its VMA away and maps a 1 GiB hugetlb page at the old
   address, so this one takes a pool with a 1 GiB page as well.
   huge_pte_offset() for the 2 MiB size steps through the PUD
   leaf, so the "PMD table" is the 1 GiB page itself and its "page table
   lock" is folio->private of that page, which holds 2.  Kernels with
   lock debugging oops in __unmap_hugepage_range(), 7 of 7 runs.  Others
   spin on that word for ever with preemption disabled, 5 of 5 runs:

     watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [u_det3:130]
     RIP: 0010:queued_spin_lock_slowpath+0x8a/0x290
     RAX: 0000000000000002 RBX: ffffea0001000028
     Call Trace:
      __unmap_hugepage_range+0x154/0x6d0
      unmap_hugepage_range+0xc1/0x140
      hugetlb_wp+0x55c/0x700
      hugetlb_fault+0x5f3/0x8f0

   RCU stalls follow, and killing all tasks of the user changes nothing.
   Four such owners, whose children share a single 1 GiB page, took down
   the whole guest with its four CPUs, 2 of 2 runs: one reported soft
   lockups on all four, the other gave no sign of life any more.

   i_mmap_rwsem stays write locked.  With a MAP_PRIVATE mapping of a
   hugetlbfs file that belongs to another user, and that the attacker
   can only read, the next mmap() of that file by its owner sleeps
   uninterruptibly in __mmap_region(), 4 of 4 runs.

Compute the address from the offset for each VMA.  The tree walk returns
only VMAs that cover pgoff, and vm_start, vm_end and vm_pgoff of a hugetlb
VMA are aligned to the huge page size, as pgoff is, so the whole range
lies inside iter_vma.  Its page tables can not go away there, since the
VMA is unlinked from the file under i_mmap_rwsem first.

With the right address the page is unmapped from all VMAs but the
owner's, so the retry in hugetlb_wp() finds a mapcount of 1 and reuses the
page.

A child that has moved its copy of the VMA now loses the page, and gets
SIGBUS when it faults on a missing page of that VMA.  That is what the
comment above the function has always promised to those who do not own
the reservation, and what already happens to a child that has left the
VMA in place.

The address has been wrong from the start, and the second case needs
only mmap() and fork().  mremap() of hugetlb VMAs, which the other cases
use, came with commit 550a7d60bd5e ("mm, hugepages: add mremap() support
for hugepage backed vma") in v5.16.

Original fix generated by an LLM and sent in private by Josef.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-4-42796911043b@kernel.org
Fixes: 04f2cbe35699 ("hugetlb: guarantee that COW faults for a process that called mmap(MAP_PRIVATE) on hugetlbfs will succeed")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
[ david: switch to vma_filebacked_address, add VM_WARN_ON_ONCE, refine comments]
---

 mm/hugetlb.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-unmap-the-page-where-the-other-vma-maps-it
+++ a/mm/hugetlb.c
@@ -5451,6 +5451,8 @@ static void unmap_ref_private(struct mm_
 	struct address_space *mapping;
 	pgoff_t pgoff;
 
+	VM_WARN_ON_ONCE(!folio_test_anon(folio));
+
 	/*
 	 * vm_pgoff is in PAGE_SIZE units, hence the different calculation
 	 * from page cache lookup which is in HPAGE_SIZE units.
@@ -5485,10 +5487,17 @@ static void unmap_ref_private(struct mm_
 		 * could insert a zeroed page instead of the data existing
 		 * from the time of fork. This would look like data corruption
 		 */
-		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
-			unmap_hugepage_range(iter_vma, address,
-					     address + huge_page_size(h),
-					     folio, 0);
+		if (is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
+			continue;
+
+		/*
+		 * The address in other VMAs can differ. Even though our old
+		 * folio is anon, we always operate on the underlying hugetlb
+		 * file.
+		 */
+		address = vma_filebacked_address(iter_vma, pgoff, 1);
+		unmap_hugepage_range(iter_vma, address,
+				     address + huge_page_size(h), folio, 0);
 	}
 	i_mmap_unlock_write(mapping);
 }
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-vma-dont-leak-the-commit-charge-on-mmap-failure.patch
mm-hugetlb-fix-use-after-free-of-a-new-anon-folio.patch
mm-hugetlb-unmap-the-page-where-the-other-vma-maps-it.patch
mm-hugetlb-dont-clear-the-resv_map-of-a-vma-whose-lock-is-held.patch
mm-hugetlb-fix-endless-write-fault-on-a-leftover-uffd-bit.patch
mm-hugetlb-dont-leave-a-uffd-wp-marker-when-zapping-an-rwp-entry.patch

