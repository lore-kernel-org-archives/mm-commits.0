Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C21B170A1B
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 23:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729984139; cv=none; b=Ig/jzWBlOvJCzd/S4EtaTF0WzAHK8mgqHGaUa/y3rFKexeA1aBIPnhNdrZVxD5PdMsbAr5GmR+Nh2TMR7suG5e7MvsdxsxV3GvYbJSQRZZHFb2keT/AxKocpE/h6FyUlPbejTnyqxRmQJiOsZfdFlor8xNbCL15DWNuHAfuKpug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729984139; c=relaxed/simple;
	bh=b8EgVd3jeD4wqN/OFxs6O7fWLWZeWZChbzYLZSLQ8KM=;
	h=Date:To:From:Subject:Message-Id; b=PUIE94AmfBF/C27PEFarK/ubBWaf4VL9Q76TINKfk+uHl53DnKfrKqTmnp9c4CuddvAr8/JCYPMLN1Qz0Cjm86p2p5Qoj6Z9UHwUm1kYJ+QIs6lqLWgjBlIZlFZlrcf2RWN9UH7SouC+Av+ROOgXK5XSwAyzzh7JM8Dbc38avmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ocvEhwC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ocvEhwC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C78C4CEC6;
	Sat, 26 Oct 2024 23:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729984138;
	bh=b8EgVd3jeD4wqN/OFxs6O7fWLWZeWZChbzYLZSLQ8KM=;
	h=Date:To:From:Subject:From;
	b=ocvEhwC4wfguPQjkoLteYbM0RqVFSgQEPCxKKvS3lOyv62YamsRR+TIrV97vjkxZu
	 J6uqmT855a8R6+mMt7p6I6MfY65cESZImdtwThvjb78sS9BL99UFVwyxAr8t4ySQtE
	 HiKU2B5pH5sw92k0NsfXab8NQAxIJoY4XqVdRJzs=
Date: Sat, 26 Oct 2024 16:08:58 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-defer-second-attempt-at-merge-on-mmap-fix.patch added to mm-unstable branch
Message-Id: <20241026230858.D5C78C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unnecessary indirection
has been added to the -mm mm-unstable branch.  Its filename is
     mm-defer-second-attempt-at-merge-on-mmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-defer-second-attempt-at-merge-on-mmap-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: remove unnecessary indirection
Date: Sat, 26 Oct 2024 11:33:01 +0100

Now we removed the merge logic from __mmap_new_file_vma() we can simply
pass in the vma direct rather than a pointer to a VMA, as pointed out by
Vlastimil.

Link: https://lkml.kernel.org/r/5106696d-e625-4d8a-8545-9d1430301730@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/vma.c~mm-defer-second-attempt-at-merge-on-mmap-fix
+++ a/mm/vma.c
@@ -2281,10 +2281,9 @@ static int __mmap_prepare(struct mmap_st
 
 
 static int __mmap_new_file_vma(struct mmap_state *map,
-			       struct vm_area_struct **vmap)
+			       struct vm_area_struct *vma)
 {
 	struct vma_iterator *vmi = map->vmi;
-	struct vm_area_struct *vma = *vmap;
 	int error;
 
 	vma->vm_file = get_file(map->file);
@@ -2352,7 +2351,7 @@ static int __mmap_new_vma(struct mmap_st
 	}
 
 	if (map->file)
-		error = __mmap_new_file_vma(map, &vma);
+		error = __mmap_new_file_vma(map, vma);
 	else if (map->flags & VM_SHARED)
 		error = shmem_zero_setup(vma);
 	else
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-defer-second-attempt-at-merge-on-mmap-fix.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
mm-madvise-implement-lightweight-guard-page-mechanism-fix.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch

