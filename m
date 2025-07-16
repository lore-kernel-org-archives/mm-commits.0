Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1511CD2C
	for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2025 20:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752699323; cv=none; b=NYQDnxGQAvwULBmEqrRWD3d5aAgGllmQDASbOCad4T6ZNLSu0jEWtJs1Sw4ZZq80QEVDYf9tVY/v8ijAphHWbs5ODfdz5fkjTHm4CjRc5xWOP7q+F96lls9rmB+IFvLHpzWZRDhwR4JcHGNNxsvfbw3lfIvvRvJgd7rTJZaHjl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752699323; c=relaxed/simple;
	bh=WQ6LGfr4m906uY+jN8vlH4QpJLs7L3pLj6HjwI/snX4=;
	h=Date:To:From:Subject:Message-Id; b=H7/0l93yuEkPvuvpmnT8u0kKkde09p721MDEDTC/xK/bhesuiL34QKeqC48XscxaQxDZPvbirSdIP14QvvKLf9acq5jzeor4CqiIJnHLGHKOju0RpsPJ4JqOy3K52iOliMVTH/IB9cHCfziKd4VZpQDyhBDygipKedKvcGjAr6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eNb34fYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eNb34fYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED860C4CEF1;
	Wed, 16 Jul 2025 20:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752699323;
	bh=WQ6LGfr4m906uY+jN8vlH4QpJLs7L3pLj6HjwI/snX4=;
	h=Date:To:From:Subject:From;
	b=eNb34fYOMyKxIf2vbwFXi0trfEQLZBZrKurSfYsEsWIzbocCdiXTqccwSnEttk6m1
	 +bkTE70wGTXkdYyfzjWb1lp06Nwb32rkixmzjPmL4VljM9lPM4WhKfaubfxIxFxMYi
	 kMSZ0mFo7q9VL6NdqYgTwMyTbxUbKqwwNlXhgEgc=
Date: Wed, 16 Jul 2025 13:55:22 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-permit-mremap-move-of-multiple-vmas-fix-2.patch added to mm-unstable branch
Message-Id: <20250716205522.ED860C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: reset VMI on unmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-permit-mremap-move-of-multiple-vmas-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-permit-mremap-move-of-multiple-vmas-fix-2.patch

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
Subject: mm/mremap: reset VMI on unmap
Date: Wed, 16 Jul 2025 20:29:54 +0100

Any separate VMA iterator may become invalidated when VMAs are unmapped at
nodes in proximity to the current position of the iterator.

Therefore, reset the iterator at each point where this occurs on a mremap
move.

Link: https://lkml.kernel.org/r/4fbf4271-6ab9-49c0-b30f-c8716bf19f09@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mremap.c~mm-mremap-permit-mremap-move-of-multiple-vmas-fix-2
+++ a/mm/mremap.c
@@ -1112,6 +1112,7 @@ static void unmap_source_vma(struct vma_
 
 	err = do_vmi_munmap(&vmi, mm, addr, len, vrm->uf_unmap, /* unlock= */false);
 	vrm->vma = NULL; /* Invalidated. */
+	vrm->vmi_needs_reset = true;
 	if (err) {
 		/* OOM: unable to split vma, just get accounts right */
 		vm_acct_memory(len >> PAGE_SHIFT);
@@ -1367,6 +1368,7 @@ static unsigned long mremap_to(struct vm
 		err = do_munmap(mm, vrm->new_addr, vrm->new_len,
 				vrm->uf_unmap_early);
 		vrm->vma = NULL; /* Invalidated. */
+		vrm->vmi_needs_reset = true;
 		if (err)
 			return err;
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix-2.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch

