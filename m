Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37512AF1D;
	Mon, 18 May 2026 18:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779130745; cv=none; b=jeLaZCZMaAp8XHq7GlgKtUbIuRNGE4N52I0TlvVGURlykWezb8tEq6wgE+t8uj0MmLE+rp9AVNeYDibhyq3Nr7Dyw6rYDFXS7Ar3o9IZToH5ie9cdO8OaLBCPQ08fxRXFIRoBecblzVuX2Q7/c0ABCb/9UTPaHDlaqzuaiqSMk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779130745; c=relaxed/simple;
	bh=9GjBhUIVMI9u+1q7jcMpsTP6grTif6Rv8ZVNygxyv4A=;
	h=Date:To:From:Subject:Message-Id; b=GPWfScbrI56+/MO5mm6BK4hwPuww+zV/ByHTbRGCM/mDSMgvl1RhkGRfxQyF5ZPqkesRtnlWHTtO+sJMcls14izVIa9WdLSpOqOF1eK0Hm2JxV2GmB3vNn5x2rKf+kqYCXXVDeMMkferHZPyk9cQmHHAlOOvuOAFIGVNY5hBGwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xfUm2AkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xfUm2AkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684BCC2BCB7;
	Mon, 18 May 2026 18:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779130744;
	bh=9GjBhUIVMI9u+1q7jcMpsTP6grTif6Rv8ZVNygxyv4A=;
	h=Date:To:From:Subject:From;
	b=xfUm2AkNe63fwlSJyZChvckHKRyjGO0T9Vphb49UnzKQwJWAlw4EU1QsmFhXd77KY
	 dfvWmVrhmJ3XpFc028W3C6eFm+il7cX+D0/IDuNzwrsAhmlpDmQ4QEnaQFDcbFfB8l
	 FBzYvjXZlo97yhhI1qRWZKen+6zFdvxftelJrv/M=
Date: Mon, 18 May 2026 11:59:03 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,riel@surriel.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,harry@kernel.org,david@kernel.org,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-initialize-nr_pages-to-1-at-loop-start-in-try_to_unmap_one.patch added to mm-hotfixes-unstable branch
Message-Id: <20260518185904.684BCC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-rmap-initialize-nr_pages-to-1-at-loop-start-in-try_to_unmap_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-initialize-nr_pages-to-1-at-loop-start-in-try_to_unmap_one.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
Date: Mon, 18 May 2026 12:06:56 +0530

Initialize nr_pages to 1 at the start of each loop iteration, like
folio_referenced_one() does.

Without this, nr_pages computed by a previous folio_unmap_pte_batch() call
can be reused on a later iteration that does not run
folio_unmap_pte_batch() again.

mmap a 64K large folio with MAP_ANONYMOUS | MAP_DROPPABLE, then call
madvise(MADV_FREE), then make the last page device-exclusive via
HMM_DMIRROR_EXCLUSIVE.

Trigger node reclaim through sysfs.  Now, in try_to_unmap_one(), we will
first clear the first 15 out of 16 entries mapping the lazyfree folio. 
This will set nr_pages to 15.  In the next pvmw walk, this nr_pages gets
reused on a device-exclusive pte, thus potentially corrupting folio
refcount/mapcount.

At the moment, I have a userspace program which can make the kernel spit
out a trace, but the blow up is in folio_referenced_one(), because there
are existing bugs in the interaction between device-private and rmap
(which too I am investigating).  I did a one liner kernel change to avoid
going into folio_referenced_one(), and the kernel blows up at
folio_remove_rmap_ptes in try_to_unmap_one which is what I wanted.

Note that the bug is there not since file folio batching but lazyfree
folio batching, since device-exclusive only works for anonymous folios.

Userspace visible effect is simply kernel crashing somewhere due to
refcount/mapcount corruption.

Link: https://lore.kernel.org/20260518063656.3721056-1-dev.jain@arm.com
Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/rmap.c~mm-rmap-initialize-nr_pages-to-1-at-loop-start-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -2030,6 +2030,8 @@ static bool try_to_unmap_one(struct foli
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
+		nr_pages = 1;
+
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
 		 */
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-rmap-initialize-nr_pages-to-1-at-loop-start-in-try_to_unmap_one.patch
selftests-mm-simplify-byte-pattern-checking-in-mremap_test.patch
mm-khugepaged-generalize-alloc_charge_folio.patch

