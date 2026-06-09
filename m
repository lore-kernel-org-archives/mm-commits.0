Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228C72F6188;
	Tue,  9 Jun 2026 01:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968156; cv=none; b=e0H4CiOc4nC6loGlLRAYwaKO+qmIBSUKx/YO/Y3fPtQHmlj6kMS5/VKFg1Xlm1Jto5HtCsKdAw9ZzmL/kfKDpGKnb6p015fau5AjVsL+oJleHuCfkcnGTXwNmAu9s3CsTFz8//MUKOHMFRtQPRFBmT0lqn5XECYBBhwly2fIWuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968156; c=relaxed/simple;
	bh=BxkIzcFktqZXGj1ro6gCyhWt5mGd3CyEZcAw8xGeD0M=;
	h=Date:To:From:Subject:Message-Id; b=UrAKOuXp7S1YwNUIw6mVqHGJuSco+Q6Nbfc1+Bgh25onYu+bxKo/0E961fQZN7WYkm8fMzxlmt9rhqy0t0mv2yJVyTkI4trYT5F21SXFzALwvKPJpCLQPUeOwI5LmqZ/b+y6zAH05MXWOGEJmmgtHwKXjnY41Ul6zAUojrziFNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ziQMSZ5W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ziQMSZ5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94F31F00893;
	Tue,  9 Jun 2026 01:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968155;
	bh=MMfwCnAREdwb+cnYQp+Ya9WougO8T3seWaQhwmlD+O4=;
	h=Date:To:From:Subject;
	b=ziQMSZ5W5COmmDjzcIY8ihEPJS4TSwzKQRHREEvT171hVFUzfQGenfvpwLSveLARV
	 cOzMuXlU1mPaDU6fjQ6l2xsq9bcJPNoyhv5aIETt8Qy0i+LPKIj5ciuNfsQ1AFN+67
	 tOKHZq7qxH1Spj0KRJLpZY9VDr/7xDS6VGfcotCs=
Date: Mon, 08 Jun 2026 18:22:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,dev.jain@arm.com,david@kernel.org,balbirs@nvidia.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-fix-make_uffd_wp_huge_pte-prot-update-race.patch removed from -mm tree
Message-Id: <20260609012234.E94F31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: fix make_uffd_wp_huge_pte() prot-update race
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-fix-make_uffd_wp_huge_pte-prot-update-race.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: fs/proc/task_mmu: fix make_uffd_wp_huge_pte() prot-update race
Date: Fri, 29 May 2026 18:23:25 +0100

Patch series "userfaultfd/pagemap: pre-existing fixes".

These are pre-existing bug fixes that were carried at the front of the
userfaultfd RWP working-set-tracking series up to v5 [1].  Per review
feedback that fixes should not sit in the middle of a feature series, they
are split out and sent on their own; the RWP series is reposted rebased on
top of this.

All six were flagged by the Sashiko AI review of the RWP series and carry
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>.  They are
independent of RWP, apply to mm-new directly, and carry Cc: stable@.

  1: fs/proc/task_mmu: a missing huge_ptep_modify_prot_start() in
     make_uffd_wp_huge_pte() can lose hardware Dirty/Accessed updates
     when PAGEMAP_SCAN write-protects a hugetlb PTE.

  2: fs/proc/task_mmu: pagemap_scan_hugetlb_entry() compares the range
     against HPAGE_SIZE rather than the hstate page size, so it never
     write-protects gigantic hugetlb pages.

  3: fs/proc/task_mmu: PAGEMAP_SCAN with PM_SCAN_WP_MATCHING over an
     unpopulated hugetlb range self-deadlocks -- pagemap_scan_pte_hole()
     calls uffd_wp_range() while walk_hugetlb_range() holds the hugetlb
     vma lock for read, and hugetlb_change_protection() then takes it
     for write. Install the marker inline instead.

  4: mm/huge_memory: change_non_present_huge_pmd() drops pmd_swp_uffd_wp
     on a device-private PMD permission downgrade, silently losing the
     uffd-wp marker.

  5: userfaultfd: must_wait() applies pte_write() to a locklessly read
     PTE without checking pte_present(), so swap/migration entries
     decode random offset bits and a thread can stay parked on a stale
     fault.

  6: userfaultfd: __VMA_UFFD_FLAGS feeds VMA_UFFD_MINOR_BIT (41) to
     mk_vma_flags() unconditionally, an out-of-bounds write into the
     single-word vma_flags_t on 32-bit. Build the mask from config-gated
     per-mode masks so an unavailable bit is never materialised.


This patch (of 6):

make_uffd_wp_huge_pte() arms the UFFD_WP bit on a present HugeTLB PTE by
calling huge_ptep_modify_prot_commit() with a ptent snapshot that was
fetched without the corresponding huge_ptep_modify_prot_start().  The
start helper is what atomically clears the entry so the kernel-owned
snapshot stays consistent until the commit; without it, the hardware may
set Dirty or Accessed in the live PTE between the original read and the
commit, and huge_ptep_modify_prot_commit() (whose generic implementation
just calls set_huge_pte_at()) then writes the stale snapshot back over the
live hardware bits, losing the update.

The non-hugetlb sibling make_uffd_wp_pte() does this correctly via
ptep_modify_prot_start() / ptep_modify_prot_commit().  Mirror that pattern
for the present-PTE branch.  The migration case stays as-is -- migration
entries are non-present, so there's no hardware update to race against.

Link: https://lore.kernel.org/20260529172331.356655-1-kas@kernel.org
Link: https://lore.kernel.org/20260529172331.356655-2-kas@kernel.org
Link: https://lore.kernel.org/all/20260526130509.2748441-1-kirill@shutemov.name/ [1]
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-make_uffd_wp_huge_pte-prot-update-race
+++ a/fs/proc/task_mmu.c
@@ -2610,12 +2610,16 @@ static void make_uffd_wp_huge_pte(struct
 	if (softleaf_is_hwpoison(entry) || softleaf_is_marker(entry))
 		return;
 
-	if (softleaf_is_migration(entry))
+	if (softleaf_is_migration(entry)) {
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
 				pte_swp_mkuffd_wp(ptent), psize);
-	else
-		huge_ptep_modify_prot_commit(vma, addr, ptep, ptent,
-					     huge_pte_mkuffd_wp(ptent));
+	} else {
+		pte_t old_pte, new_pte;
+
+		old_pte = huge_ptep_modify_prot_start(vma, addr, ptep);
+		new_pte = huge_pte_mkuffd_wp(old_pte);
+		huge_ptep_modify_prot_commit(vma, addr, ptep, old_pte, new_pte);
+	}
 }
 #endif /* CONFIG_HUGETLB_PAGE */
 
_

Patches currently in -mm which might be from kas@kernel.org are


