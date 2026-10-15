Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4043C1D7E;
	Thu, 15 Oct 2026 22:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105108; cv=none; b=UDzijJGepjs/3zHp4V12lHMn1x+Hp5266fCcmG1YftOlP0ZSb3ct5OWU4VuDSwFGjb2boBL92lAo1obWjYtbeoVXjXfbfr8TSlJHeKw5kY3rl2bZqgwJwPhqeeIhVG+Xk6qFOsBNg8aBVWk4GqqPvYNyxxrz3tIgspxp8NGNNBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105108; c=relaxed/simple;
	bh=EIaQgIW4QydUnq6CIeZ1VkvwGLvOYvjFXUqC0+p4IL4=;
	h=Date:To:From:Subject:Message-Id; b=iPAEm9DBKjyoYJfjAXuR1qWE6q9UOKylKXjz5ouussWGSAjfmSBSOlfS6gizpTX0aVTNvYFY/tZuhiBtQt8E7p7zvQgjLUyz8uTiytnqUktDsdc4srAgjhKQlTE4TRJtEj6pDPMHW20vvtmkkCwgrrUyKRzgtues/RYzA47HqgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bO0osEm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bO0osEm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80221F000C5;
	Thu, 15 Oct 2026 22:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792105105;
	bh=fIUmyFopoiCqG44yakq2RwP8Z1dK81ex56CWXEwtKGI=;
	h=Date:To:From:Subject;
	b=bO0osEm5YRj0QhBlo7gUJwmBRZKHG5uL8fZ1zgLodGTfqE3touiJ/A/y9zgoigi13
	 Uh418kx1FCIReIfNcXd/0OQ1tyCjEwhZ9RzJse5socP8GWibE3Jij8MY01suSPvePp
	 lrXc26hjJFZb2SC5XpoA/u2fwLcOTncMbVN6gHkc=
Date: Thu, 15 Oct 2026 15:58:25 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,mason@kernel.org,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,kas@kernel.org,jannh@google.com,david@kernel.org,agl@us.ibm.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-endless-write-fault-on-a-leftover-uffd-bit.patch added to mm-hotfixes-unstable branch
Message-Id: <20261015225825.D80221F000C5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix endless write fault on a leftover uffd bit
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-endless-write-fault-on-a-leftover-uffd-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-endless-write-fault-on-a-leftover-uffd-bit.patch

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
Subject: mm/hugetlb: fix endless write fault on a leftover uffd bit
Date: Thu, 15 Oct 2026 18:07:12 +0200

hugetlb_fault() resolves the uffd bit on a write fault only if the VMA is
registered for userfaultfd write protection, and hugetlb_wp() bails out
for any entry with the uffd bit set assuming hugetlb_fault() has already
resolved it.

When a read-only hugetlb entry with the uffd bit set is mapped in a VMA
that is not registered for uffd-wp, a write fault to it never makes
progress. If the access comes from the kernel, e.g. read(2) from
/dev/zero into such page, the task spins in the page fault handler,
ignores SIGKILL and keeps holding the locks taken by the system call.

Such entries should not exist, but an unprivileged user can create them,
for example with MADV_DONTNEED of a page protected with UFFDIO_RWPROTECT
or with UFFDIO_COPY in MODE_WP racing with UFFDIO_UNREGISTER.

Clear the uffd bit when the VMA is not registered for uffd-wp and let the
fault proceed to hugetlb_wp(), like do_wp_page() does for regular pages.

Note that a FOLL_FORCE write to a page protected with UFFDIO_RWPROTECT in
a private VMA that was made PROT_NONE now drops the RWP protection of
that page.

Original fix generated by an LLM and sent in private by Josef.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-6-42796911043b@kernel.org
Fixes: 60d5b473d61b ("mm/hugetlb: fix uffd wr-protection for CoW optimization path")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
Cc: <stable@vger.kernel.org>
[rppt: massage commit message]
[ david: convert comment into a TODO ]
---

 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-endless-write-fault-on-a-leftover-uffd-bit
+++ a/mm/hugetlb.c
@@ -6195,15 +6195,19 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		goto out_ptl;
 
 	/* Handle userfault-wp first, before trying to lock more pages */
-	if (userfaultfd_wp(vma) && huge_pte_uffd(huge_ptep_get(mm, vmf.address, vmf.pte)) &&
+	if (huge_pte_uffd(huge_ptep_get(mm, vmf.address, vmf.pte)) &&
 	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(vmf.orig_pte)) {
-		if (!userfaultfd_wp_async(vma)) {
+		if (userfaultfd_wp(vma) && !userfaultfd_wp_async(vma)) {
 			spin_unlock(vmf.ptl);
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			return handle_userfault(&vmf, VM_UFFD_WP);
 		}
 
+		/*
+		 * TODO: fix all cases where uffd PTE bits remain in VMAs that
+		 * are no longer registered with uffd.
+		 */
 		vmf.orig_pte = huge_pte_clear_uffd(vmf.orig_pte);
 		set_huge_pte_at(mm, vmf.address, vmf.pte, vmf.orig_pte,
 				huge_page_size(hstate_vma(vma)));
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-vma-dont-leak-the-commit-charge-on-mmap-failure.patch
mm-hugetlb-fix-use-after-free-of-a-new-anon-folio.patch
mm-hugetlb-unmap-the-page-where-the-other-vma-maps-it.patch
mm-hugetlb-dont-clear-the-resv_map-of-a-vma-whose-lock-is-held.patch
mm-hugetlb-fix-endless-write-fault-on-a-leftover-uffd-bit.patch
mm-hugetlb-dont-leave-a-uffd-wp-marker-when-zapping-an-rwp-entry.patch

