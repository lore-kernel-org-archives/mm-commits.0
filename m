Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832521E5B68
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 23:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817829; cv=none; b=Hmi8CFFLVQWZ7MB1H3N+d0UQ6tWP25ZCQW0rMLoHZHhiJYKit/r7w9kYVdt+lLSCdPo2rKWeSP9sS3A4GVS3+uF5itZyV6ifoASIb4XchbY8gd1GASnp8mzDhfmMxyRNOVo5Q+M5J4fAb26ERkW+U5DTiRcyZ4LX5tSdotr9g5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817829; c=relaxed/simple;
	bh=ix8Q8FDiQjSchEdjnrrmsbhbU/ab8hfwqwXQ2sTcZ90=;
	h=Date:To:From:Subject:Message-Id; b=CpM8YoLvp/t0O234MWTNPi95ecJdgQDhF9HTdEoXaCtG0BWe4JKW9t9Xu1SFfVoMNF5Ua6kqiZjBj3NswH4+jaa/aQOsjgAUgLoFj5krxvDsaqzuKm7pRMOQG/OVsmUtmSs+n9PNPsBLuA116aeqDsU7btIo8xPmbdF9WigqYIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z5lcICjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z5lcICjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED136C19424;
	Mon, 10 Nov 2025 23:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762817826;
	bh=ix8Q8FDiQjSchEdjnrrmsbhbU/ab8hfwqwXQ2sTcZ90=;
	h=Date:To:From:Subject:From;
	b=z5lcICjPMNBhkhnOBi5+Y132XRzifJx2VYX89H1F8v7XJA+XfaHUg9qeT9E2mF69e
	 pg7Te7sxoPhRcgToiWlkc4TXtolUXRM+3eP1CfMYtjZuUdfBIykkx9HxPGftZTcs/y
	 envd1IPn45GYHBBmpZYnSzBkfxGJopcozw8UqT2s=
Date: Mon, 10 Nov 2025 15:37:05 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,chriscli@google.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-vma_start_write_killable-in-dup_mmap.patch added to mm-new branch
Message-Id: <20251110233705.ED136C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use vma_start_write_killable() in dup_mmap()
has been added to the -mm mm-new branch.  Its filename is
     mm-use-vma_start_write_killable-in-dup_mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-vma_start_write_killable-in-dup_mmap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use vma_start_write_killable() in dup_mmap()
Date: Mon, 10 Nov 2025 20:32:02 +0000

Allow waiting for the VMA write lock to be interrupted by fatal signals. 
The explicit check for fatal_signal_pending() can be removed as it is
checked during vma_start_write_killable().  Improves the latency of
killing the task as we do not wait for the reader to finish before
checking for signals.

Link: https://lkml.kernel.org/r/20251110203204.1454057-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Chris Li <chriscli@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/mmap.c~mm-use-vma_start_write_killable-in-dup_mmap
+++ a/mm/mmap.c
@@ -1747,7 +1747,9 @@ __latent_entropy int dup_mmap(struct mm_
 	for_each_vma(vmi, mpnt) {
 		struct file *file;
 
-		vma_start_write(mpnt);
+		retval = vma_start_write_killable(mpnt);
+		if (retval < 0)
+			goto loop_out;
 		if (mpnt->vm_flags & VM_DONTCOPY) {
 			retval = vma_iter_clear_gfp(&vmi, mpnt->vm_start,
 						    mpnt->vm_end, GFP_KERNEL);
@@ -1758,14 +1760,6 @@ __latent_entropy int dup_mmap(struct mm_
 			continue;
 		}
 		charge = 0;
-		/*
-		 * Don't duplicate many vmas if we've been oom-killed (for
-		 * example)
-		 */
-		if (fatal_signal_pending(current)) {
-			retval = -EINTR;
-			goto loop_out;
-		}
 		if (mpnt->vm_flags & VM_ACCOUNT) {
 			unsigned long len = vma_pages(mpnt);
 
_

Patches currently in -mm which might be from willy@infradead.org are

hugetlb-optimise-hugetlb_folio_init_tail_vmemmap.patch
migrate-optimise-alloc_migration_target.patch
memory_hotplug-optimise-try_offline_memory_block.patch
mm-constify-__dump_folio-arguments.patch
mm-add-vma_start_write_killable.patch
mm-use-vma_start_write_killable-in-dup_mmap.patch

