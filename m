Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5137D2701BA
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 00:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745368657; cv=none; b=p8y0+WaIyv8Og6Feebc7I96/XeqMXO2RKTh0QzYlGmk9nwDm1jKnjRejhvbOgk4FaF400dEIc3mHNFeLA+JRt+rA1AO2jnx6W2zUwr4CgY+mqbNt3i7/kKlsyNQbuJB5dlW7lcqVfTM9NDLCcdLVftsozu7kMaPIqSJ5C9YfwyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745368657; c=relaxed/simple;
	bh=sIbN2Lq5RgVIXw+8avnBJtNlBYoeOIOLFviuRe6QmWk=;
	h=Date:To:From:Subject:Message-Id; b=k9EnPu24yHsn7s0rsVoUf4iZp1LxG7e5Ba6FQ2daG9wgVE462ckFvMvGooWNJ//XHVFLxfadR7ugKThmA82AlEFttzt759zcVb9cMqQU1U9OirqJoqYeCS/lrwbng0i7P6US4o9T2rbQEKcSS4PwLvsRAa0lw60/WuybabgHOZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gcX3Y2DE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gcX3Y2DE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A27CC4CEE9;
	Wed, 23 Apr 2025 00:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745368656;
	bh=sIbN2Lq5RgVIXw+8avnBJtNlBYoeOIOLFviuRe6QmWk=;
	h=Date:To:From:Subject:From;
	b=gcX3Y2DEyF//DW99VnKUqRJNW+C+C2kl8YsEqwLK4WqADtyMzrOyZXKDYpg0GTo2h
	 i8V2Y3ZwYSVUYZ3TsGCB5uBPnZWtKlPAO1BYIG9QNX1XYZKHKaHOH7grjtCkLc60P1
	 xnv7FLabi1Mj6zzpjv9XD8e3vK81eLwSPcLxO7UA=
Date: Tue, 22 Apr 2025 17:37:35 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,riel@surriel.com,peterz@infradead.org,mingo@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-fork-only-call-untrack_pfn_clear-on-vmas-duplicated-for-fork.patch added to mm-hotfixes-unstable branch
Message-Id: <20250423003736.6A27CC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/fork: only call untrack_pfn_clear() on VMAs duplicated for fork()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kernel-fork-only-call-untrack_pfn_clear-on-vmas-duplicated-for-fork.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-fork-only-call-untrack_pfn_clear-on-vmas-duplicated-for-fork.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

kernel-fork-only-call-untrack_pfn_clear-on-vmas-duplicated-for-fork.patch
kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint.patch
kernel-events-uprobes-pass-vma-to-set_swbp-set_orig_insn-and-uprobe_write_opcode.patch
kernel-events-uprobes-uprobe_write_opcode-rewrite.patch

