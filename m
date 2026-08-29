Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E491E1A3D
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 22:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788042658; cv=none; b=hhw3ADp6mDES4kkO/jFs/31sonO4gjF5wape/ajZ3bukmG42Mu21o8auO260gUV5UdNuCIu/pnHKGGJBBRlJRar4bIHlKWZnXY82dy51mpm+gGvx/b32rx+wjiUR2hjfotcEtokSvaq+SxXEMwAlUN4SIb3IPVdlF9L4UToLySg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788042658; c=relaxed/simple;
	bh=Yb7ztxDbDU5OuIo3hV9OQflLmoD7SEldnN+EtTma54o=;
	h=Date:To:From:Subject:Message-Id; b=krIUfjM7Fyh2q28ol0fE3r8rspwarTsW2TzXrLvl1eEedAYpyZB3dtxcwjlHxdAPma0dZk7XpiyX8tjKZDToipRvWQMrhBzFUfV/Sm47OWSSMdz6v+5ROIruWw9qB7h07ft3r8KU4OmjBDYVxGnpNRgJSButsmoqzdEYiRBmLSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PPhUy+LC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PPhUy+LC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0459F1F000E9;
	Sat, 29 Aug 2026 22:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788042657;
	bh=I+bRkPU4UKG4T3baygDiDcRgIcGwH6Pr8Gxk2N6G+TE=;
	h=Date:To:From:Subject;
	b=PPhUy+LCpGl7enFXTvD5DwQnT/s+t+SccaVJRlzDT1sBFHBqpRhzicZxEZyCiVOqH
	 V86JdoEBbCg7a4CGcVsTNGeACRhAVBm6iIfqhP4EH0zZaV8Wb6TAOq5JZH2L7Xe6gs
	 9uVVCZmj+CYqUiAR00majOR/kBGUQ3tPhdloYuyo=
Date: Sat, 29 Aug 2026 15:30:56 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,thnkslprpt@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-simplify-error-handling-in-insert_pages.patch added to mm-new branch
Message-Id: <20260829223057.0459F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: simplify error handling in insert_pages()
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-simplify-error-handling-in-insert_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-simplify-error-handling-in-insert_pages.patch

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
From: Avi Weiss <thnkslprpt@gmail.com>
Subject: mm/memory: simplify error handling in insert_pages()
Date: Sat, 29 Aug 2026 20:11:12 +0300

Patch series "mm/memory: improve insert_pages() error handling", v3.

Improve insert_pages() error handling.

The first patch simplifies error handling by initializing the error status
to zero and assigning error codes at their respective failure sites.

The second patch returns -ENOMEM when walk_to_pmd() fails.  A NULL return
from walk_to_pmd() indicates failure to allocate an upper page-table
level, so -ENOMEM is more appropriate than -EFAULT and is consistent with
the subsequent pte_alloc() failure.


This patch (of 2):

Initialize error return status to zero and then set it as needed at each
point of failure.

Assign -ENOMEM explicitly when pte_alloc() fails as the pte_alloc() macro
returns a boolean.

Link: https://lore.kernel.org/cover.1788022178.git.thnkslprpt@gmail.com
Link: https://lore.kernel.org/dd3a672c858b38c7525541b19a919e120c4e5a0e.1788022178.git.thnkslprpt@gmail.com
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/memory.c~mm-memory-simplify-error-handling-in-insert_pages
+++ a/mm/memory.c
@@ -2565,20 +2565,22 @@ static int insert_pages(struct vm_area_s
 	unsigned long curr_page_idx = 0;
 	unsigned long remaining_pages_total = *num;
 	unsigned long pages_to_write_in_pmd;
-	int ret;
+	int err = 0;
 more:
-	ret = -EFAULT;
 	pmd = walk_to_pmd(mm, addr);
-	if (!pmd)
+	if (!pmd) {
+		err = -EFAULT;
 		goto out;
+	}
 
 	pages_to_write_in_pmd = min_t(unsigned long,
 		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));
 
 	/* Allocate the PTE if necessary; takes PMD lock once only. */
-	ret = -ENOMEM;
-	if (pte_alloc(mm, pmd))
+	if (pte_alloc(mm, pmd)) {
+		err = -ENOMEM;
 		goto out;
+	}
 
 	while (pages_to_write_in_pmd) {
 		int pte_idx = 0;
@@ -2586,15 +2588,14 @@ more:
 
 		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
 		if (!start_pte) {
-			ret = -EFAULT;
+			err = -EFAULT;
 			goto out;
 		}
 		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
-			int err = insert_page_in_batch_locked(vma, pte,
-				addr, pages[curr_page_idx], prot);
+			err = insert_page_in_batch_locked(vma, pte, addr,
+							  pages[curr_page_idx], prot);
 			if (unlikely(err)) {
 				pte_unmap_unlock(start_pte, pte_lock);
-				ret = err;
 				remaining_pages_total -= pte_idx;
 				goto out;
 			}
@@ -2607,10 +2608,9 @@ more:
 	}
 	if (remaining_pages_total)
 		goto more;
-	ret = 0;
 out:
 	*num = remaining_pages_total;
-	return ret;
+	return err;
 }
 
 /**
_

Patches currently in -mm which might be from thnkslprpt@gmail.com are

mm-memory-simplify-error-handling-in-insert_pages.patch
mm-memory-return-enomem-for-page-table-allocation-failure-in-insert_pages.patch

