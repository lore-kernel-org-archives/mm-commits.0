Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6227080C
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747009611; cv=none; b=cR341ZjZ8P+nNRmdaRsvt94DZNC8kGARiErL+WO8bIwWE9i+QWgEZewTet3tb6a462iTm7fqGwL1ZCiPm9Ei5lLiYV7oYOIGsbkgfJVnC2jH06hWd4ROgt9nBi0LYmzfY7BO6aqgqKRFdjyOveYfePOZHX4/a81j5sKMRU1LibQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747009611; c=relaxed/simple;
	bh=HLnRsmugMujPhYKQUXtnn2sQ5dHgOjtGqSp/XL++89M=;
	h=Date:To:From:Subject:Message-Id; b=snPujrAD+bmwfdvpf87KMUhJlTQxlJL2pewhUBuKmv+yIzuwVkpV975fjjTu4F81/gNdATYOsI2DGmAyk1MSnT2eY2l1DFwpLhyZYzsW84Kyf98f2CbOJxRvA3J6G3okPnrqAXfO9J/DAWkhIzc+QRa0aRJJikhxag2ydPN9wi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ezpETmNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ezpETmNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D73C4CEE4;
	Mon, 12 May 2025 00:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747009610;
	bh=HLnRsmugMujPhYKQUXtnn2sQ5dHgOjtGqSp/XL++89M=;
	h=Date:To:From:Subject:From;
	b=ezpETmNJQkaC5p69IOi/ZExxoYBUdd1dXm42MiVZW4FVCKCbovOMb4pXCheH9xOWL
	 SVP+SVqQsNZx+bmnSxxdZ+7PPsD0lzi3W+0N+2NE6ixDUqf3EQoK4/IMg7uPsUkNJn
	 d0sz62gUhBELk14svh9FtmBiRkf537Xocut8/2pE=
Date: Sun, 11 May 2025 17:26:49 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,riel@surriel.com,peterz@infradead.org,mingo@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kernel-fork-only-call-untrack_pfn_clear-on-vmas-duplicated-for-fork.patch removed from -mm tree
Message-Id: <20250512002650.95D73C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/fork: only call untrack_pfn_clear() on VMAs duplicated for fork()
has been removed from the -mm tree.  Its filename was
     kernel-fork-only-call-untrack_pfn_clear-on-vmas-duplicated-for-fork.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: kernel/fork: only call untrack_pfn_clear() on VMAs duplicated for fork()
Date: Tue, 22 Apr 2025 16:49:42 +0200

Not intuitive, but vm_area_dup() located in kernel/fork.c is not only used
for duplicating VMAs during fork(), but also for duplicating VMAs when
splitting VMAs or when mremap()'ing them.

VM_PFNMAP mappings can at least get ordinarily mremap()'ed (no change in
size) and apparently also shrunk during mremap(), which implies
duplicating the VMA in __split_vma() first.

In case of ordinary mremap() (no change in size), we first duplicate the
VMA in copy_vma_and_data()->copy_vma() to then call untrack_pfn_clear() on
the old VMA: we effectively move the VM_PAT reservation.  So the
untrack_pfn_clear() call on the new VMA duplicating is wrong in that
context.

Splitting of VMAs seems problematic, because we don't duplicate/adjust the
reservation when splitting the VMA.  Instead, in memtype_erase() -- called
during zapping/munmap -- we shrink a reservation in case only the end
address matches: Assume we split a VMA into A and B, both would share a
reservation until B is unmapped.

So when unmapping B, the reservation would be updated to cover only A. 
When unmapping A, we would properly remove the now-shrunk reservation. 
That scenario describes the mremap() shrinking (old_size > new_size),
where we split + unmap B, and the untrack_pfn_clear() on the new VMA when
is wrong.

What if we manage to split a VM_PFNMAP VMA into A and B and unmap A first?
It would be broken because we would never free the reservation.  Likely,
there are ways to trigger such a VMA split outside of mremap().

Affecting other VMA duplication was not intended, vm_area_dup() being used
outside of kernel/fork.c was an oversight.  So let's fix that for; how to
handle VMA splits better should be investigated separately.


With a simple reproducer that uses mprotect() to split such a VMA I can
trigger

x86/PAT: pat_mremap:26448 freeing invalid memtype [mem 0x00000000-0x00000fff]

Link: https://lkml.kernel.org/r/20250422144942.2871395-1-david@redhat.com
Fixes: dc84bc2aba85 ("x86/mm/pat: Fix VM_PAT handling when fork() fails in copy_page_range()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/fork.c~kernel-fork-only-call-untrack_pfn_clear-on-vmas-duplicated-for-fork
+++ a/kernel/fork.c
@@ -498,10 +498,6 @@ struct vm_area_struct *vm_area_dup(struc
 	vma_numab_state_init(new);
 	dup_anon_vma_name(orig, new);
 
-	/* track_pfn_copy() will later take care of copying internal state. */
-	if (unlikely(new->vm_flags & VM_PFNMAP))
-		untrack_pfn_clear(new);
-
 	return new;
 }
 
@@ -672,6 +668,11 @@ static __latent_entropy int dup_mmap(str
 		tmp = vm_area_dup(mpnt);
 		if (!tmp)
 			goto fail_nomem;
+
+		/* track_pfn_copy() will later take care of copying internal state. */
+		if (unlikely(tmp->vm_flags & VM_PFNMAP))
+			untrack_pfn_clear(tmp);
+
 		retval = vma_dup_policy(mpnt, tmp);
 		if (retval)
 			goto fail_nomem_policy;
_

Patches currently in -mm which might be from david@redhat.com are

kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint.patch
kernel-events-uprobes-pass-vma-to-set_swbp-set_orig_insn-and-uprobe_write_opcode.patch
kernel-events-uprobes-uprobe_write_opcode-rewrite.patch
selftests-mm-add-simple-vm_pfnmap-tests-based-on-mmaping-dev-mem.patch

