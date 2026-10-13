Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04472D7DD7;
	Tue, 13 Oct 2026 04:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865915; cv=none; b=MEndAi7DHwj4GBGyojz5+RabaAwO+R6I9OBe0mpLqdn2WpKjdyB7dTCmcxGfRLhe9gUDjCpgTSwSrkUHcVoCP8epIe06TgJJF3KK8nDgfW9lRFI9l69pIHfY5Zv8tGPremrHPMiT4yYv1fRtLnOSO8KdNbxSIuBAWXH2qVYfeGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865915; c=relaxed/simple;
	bh=ns6ef2NSBFmlJnaNVR0S74xT5Oojfn+O0Tybs2j7Brw=;
	h=Date:To:From:Subject:Message-Id; b=Tta1OaPtN82v1WPZifdEIdRer+2/Gs1pwuI46cY9JM5iAvwBKzKMx3jksn18THhgYfMzxaOZiTYtsFdiZOsJXljbXLveWKUqLDKe0LrDn0fJ0k9K0aHHbgA4yj/t8ouGpHztSKmD7hA1E/C8kjiotvtXs0Qak6EgTDCyqk0flH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VhYSQlml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VhYSQlml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775E31F00893;
	Tue, 13 Oct 2026 04:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865914;
	bh=76ZQtbxO0VIM+bPanI+GsfDotLqkwS1YfhEQIPi5ic8=;
	h=Date:To:From:Subject;
	b=VhYSQlmlS3DhT6GdoQmW8X0KKnZfOnUa5eQX9rbQuMJ+SRck8Z33VfGDYfDwtKocM
	 21Um0DzESeNyn/oymvOQ0Y0bWiTiPnl/GZnNLHwkqcBKL8VTYH3IcuqMlx6VJgEq7R
	 8ZKR2uxF6x6bQnR2IW7WQkmOC1sp6Y3nlzbGfZUw=
Date: Mon, 12 Oct 2026 21:31:54 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,pfalcato@suse.de,peterx@redhat.com,ljs@kernel.org,liam@infradead.org,jgg@ziepe.ca,jannh@google.com,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch removed from -mm tree
Message-Id: <20261013043154.775E31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/task_mmu: handle special PMDs in clear_refs and pagemap
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: proc/task_mmu: handle special PMDs in clear_refs and pagemap
Date: Sat, 12 Sep 2026 08:28:22 -0400

mshv_vtl_low can install a special PMD from a PFN supplied in the mmap file
offset.  That PFN need not have a memmap entry.  Reading /proc/PID/pagemap
or writing /proc/PID/clear_refs for such a mapping oopses the kernel.

With a test driver mapping the PFN at the 1 TiB mark:

  echo 1 > /proc/self/clear_refs

  BUG: unable to handle page fault for address: fffffb5b80000008
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  RIP: 0010:clear_refs_pte_range+0xb1/0x1e0
  Call Trace:
   walk_pgd_range+0x50a/0xad0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_mm_unsafe+0x193/0x230
   clear_refs_write+0x18e/0x3f0

  pread(pagemap_fd, buf, 512 * 8, addr / PAGE_SIZE * 8)

  BUG: unable to handle page fault for address: fffff57840000008
  RIP: 0010:pagemap_pmd_range+0x3cf/0x6b0
  Call Trace:
   walk_pgd_range+0x50a/0xad0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_mm_unsafe+0x193/0x230
   pagemap_read+0x1dc/0x350

clear_refs_pte_range() passes the PMD to pmd_folio(), while
pagemap_pmd_range_thp() uses pmd_page() followed by page_folio().

Both paths assume the PFN has a struct page and dereference bad address.

Use vm_normal_folio_pmd() and vm_normal_page_pmd() so clear_refs skips
folio operations and pagemap skips folio-derived flags for special PMDs.
This matches the PTE paths, which already use vm_normal_folio() and
vm_normal_page().

User-facing notes:
 - Pagemap still reports PM_PRESENT and the PFN to a CAP_SYS_ADMIN reader.

 - For a special PMD backed by a valid memmap entry and for the huge
   zero PMD, PM_FILE changes from set to clear.

 - PM_MMAP_EXCLUSIVE is already clear in both cases.

 - The output for an anonymous THP is unchanged.

Tested in QEMU with the test driver on broken and fixed kernels.  Both proc
operations oops before the fix and return 0 after it.

This is technically reachable via mshv_vtl_low, so I tagged it stable.

Link: https://lore.kernel.org/20260912122822.3348978-1-gourry@gourry.net
Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
Signed-off-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260912034833.2952750-1-gourry%40gourry.net
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org> # v6.19+
---

 fs/proc/task_mmu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap
+++ a/fs/proc/task_mmu.c
@@ -1704,7 +1704,9 @@ static int clear_refs_pte_range(pmd_t *p
 		if (!pmd_present(*pmd))
 			goto out;
 
-		folio = pmd_folio(*pmd);
+		folio = vm_normal_folio_pmd(vma, addr, *pmd);
+		if (!folio)
+			goto out;
 
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
@@ -2024,7 +2026,7 @@ static int pagemap_pmd_range_thp(pmd_t *
 		goto populate_pagemap;
 
 	if (pmd_present(pmd)) {
-		page = pmd_page(pmd);
+		page = vm_normal_page_pmd(vma, addr, pmd);
 
 		flags |= PM_PRESENT;
 		if (pmd_soft_dirty(pmd))
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch

