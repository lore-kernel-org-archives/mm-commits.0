Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96CA4FD28D;
	Thu, 15 Oct 2026 22:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105113; cv=none; b=YGxtehGcn0Tp1morLdo90d1wORL6lDEmb0Hb9bMJMEWtEbcA388Ts4eXPM/KCIV9k9pH5AFem88UQp/ChGyju8yfAuPHLZE4kfdYbwiw+QIasDgdoTpLEHc9SAu5qpsBd3PT9I5ImXu52IPb4exw/m8qlZpF9IBwXcMUjkIsNtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105113; c=relaxed/simple;
	bh=Q7GKQ7KXDhCNAUMjGmmevZsV1ieJnVYq36yzbBfn6Ks=;
	h=Date:To:From:Subject:Message-Id; b=AKcBEehNBjlpGJlrkX5aC9lIxNyClWhmsAcR/8mN0+123vwhKKp1FyrWI7ZqeRDXuD9xVqVBMCITGithRySmReJZkK/ZboZN5kuDtVoa8qGQkp0uPB3H8DY9irQApjL8ottcc/zOvR8MPd3IdDXyGFVKIPmXIusEYTdJop9fTdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nrNNTYo9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nrNNTYo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6922D1F000C6;
	Thu, 15 Oct 2026 22:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792105111;
	bh=j2XK3fCtru7aUZZ2lxt1iKD1fnh+jY46ppB0dpQVDi4=;
	h=Date:To:From:Subject;
	b=nrNNTYo9Zs0D75PeTp6XwQR6fzNKP6MNzXTJWZOsf/gSS1+03utzsESXtcUjfRp0o
	 UnMy0CCvsLOBgGD1p8Wrwf2uDPX2ugpZdvHHhsXogLhPybCVS6vzmfccTlwMNSlJAS
	 XAu8wIjQeSgudYsOXjVxby0QtwCa3HPB3pZReocc=
Date: Thu, 15 Oct 2026 15:58:31 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,mason@kernel.org,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,kas@kernel.org,jannh@google.com,david@kernel.org,agl@us.ibm.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-dont-leave-a-uffd-wp-marker-when-zapping-an-rwp-entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20261015225831.6922D1F000C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: don't leave a uffd-wp marker when zapping an RWP entry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-dont-leave-a-uffd-wp-marker-when-zapping-an-rwp-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-dont-leave-a-uffd-wp-marker-when-zapping-an-rwp-entry.patch

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
Subject: mm/hugetlb: don't leave a uffd-wp marker when zapping an RWP entry
Date: Thu, 15 Oct 2026 18:07:15 +0200

An entry that is protected with UFFDIO_RWPROTECT is PAGE_NONE with the
uffd bit set, the bit that userfaultfd write protection uses too.  When
__unmap_hugepage_range() zaps an entry with that bit it leaves a
PTE_MARKER_UFFD_WP behind, whatever the VMA is registered for.

In a VMA registered with UFFDIO_REGISTER_MODE_RWP that marker means
nothing.  The next fault has hugetlb_no_page() turn it into a present,
read-only entry with the uffd bit.  That is not an RWP entry, since it is
not PAGE_NONE, and the VMA has no VM_UFFD_WP (the two modes can not be
registered together).  An earlier fix solved some side effects, now just
stop the zap from wrongly installing a marker.

Leave a marker only if the VMA is registered for write protection, both
for present and for non-present entries.  The zap of ordinary page
tables has the same test, in cond_install_uffd_wp_ptes(), and
hugetlb_change_protection() says that "uffd_rwp does not install markers".

After a zap the range of an RWP VMA is simply empty, as it is for
anonymous memory and shmem.  Nothing changes for VMAs with VM_UFFD_WP.  In
a VMA that is not registered at all a leftover uffd bit or marker is now
dropped by the zap and no longer kept alive.

Original fix generated by an LLM and sent in private by Josef.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-9-42796911043b@kernel.org
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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
[ david: a bit of description overhaul+simplification ]
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-dont-leave-a-uffd-wp-marker-when-zapping-an-rwp-entry
+++ a/mm/hugetlb.c
@@ -5278,7 +5278,7 @@ void __unmap_hugepage_range(struct mmu_g
 			 * drop the uffd-wp bit in this zap, then replace the
 			 * pte with a marker.
 			 */
-			if (pte_swp_uffd_any(pte) &&
+			if (userfaultfd_wp(vma) && pte_swp_uffd_any(pte) &&
 			    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 				set_huge_pte_at(mm, address, ptep,
 						make_pte_marker(PTE_MARKER_UFFD_WP),
@@ -5314,7 +5314,7 @@ void __unmap_hugepage_range(struct mmu_g
 		if (huge_pte_dirty(pte))
 			folio_mark_dirty(folio);
 		/* Leave a uffd-wp pte marker if needed */
-		if (huge_pte_uffd(pte) &&
+		if (userfaultfd_wp(vma) && huge_pte_uffd(pte) &&
 		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 			set_huge_pte_at(mm, address, ptep,
 					make_pte_marker(PTE_MARKER_UFFD_WP),
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-vma-dont-leak-the-commit-charge-on-mmap-failure.patch
mm-hugetlb-fix-use-after-free-of-a-new-anon-folio.patch
mm-hugetlb-unmap-the-page-where-the-other-vma-maps-it.patch
mm-hugetlb-dont-clear-the-resv_map-of-a-vma-whose-lock-is-held.patch
mm-hugetlb-fix-endless-write-fault-on-a-leftover-uffd-bit.patch
mm-hugetlb-dont-leave-a-uffd-wp-marker-when-zapping-an-rwp-entry.patch

