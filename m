Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD201AC88B;
	Sat,  7 Jun 2025 22:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749336939; cv=none; b=VAY5u5ewuqOO6iEmUFB+WtQnuK3s86Wf9ajMAGPAJRG54xYS4R8b/mX5UmBM9cckSWCTiXwKIAHI+1fGxFnIv1/Ddd7MT1hDQ+6NTbLyfhwBQBX3g32YHqPB3CuLGhgV+Oz4HG5WvoKZZAJ8PXQCVY3aoFFbZtljL0tx1mbNG90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749336939; c=relaxed/simple;
	bh=gRmZaKAoYLs3c8hCQsjMkQe+eEMIUrDOBovFWB8mnMA=;
	h=Date:To:From:Subject:Message-Id; b=EDDNvbYzdjBhx/jzM0XLdJDbsSrEaw10Fh9zkCyoph4mk3Y4jJjkgtCxh+cwkdeaoAb3gVzOPyMSOt5kPVGydk1f5mq98g9h/cVQDqpeh0VB/zTlsoCCDcofhNqT3t4RRWoRduH7b8rh9jN1AQVxfLD2ep8/pV1u5K/k60H2xFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WFrJ82hD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WFrJ82hD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBB9C4CEE4;
	Sat,  7 Jun 2025 22:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749336938;
	bh=gRmZaKAoYLs3c8hCQsjMkQe+eEMIUrDOBovFWB8mnMA=;
	h=Date:To:From:Subject:From;
	b=WFrJ82hDZb9cMdTqQGidrkqk5s6OkBCzwS4aHqhZGSQ2rJdhqzP1pTrXxTFLZWsAc
	 a2BrtOTIlBl91kDD1DcMTa/H15qJdsSCUSlK65s3vOMcBzffqdPOUDBNxumR+oI/5X
	 f4YBmUgACwSY6Id1ubQ5JHyG2amDcje2JH0fSYy0=
Date: Sat, 07 Jun 2025 15:55:38 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,pfalcato@suse.de,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20250607225538.CEBB9C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: reset VMA iterator on commit_merge() OOM failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: reset VMA iterator on commit_merge() OOM failure
Date: Fri, 6 Jun 2025 13:50:32 +0100

While an OOM failure in commit_merge() isn't really feasible due to the
allocation which might fail (a maple tree pre-allocation) being 'too small
to fail', we do need to handle this case correctly regardless.

In vma_merge_existing_range(), we can theoretically encounter failures
which result in an OOM error in two ways - firstly dup_anon_vma() might
fail with an OOM error, and secondly commit_merge() failing, ultimately,
to pre-allocate a maple tree node.

The abort logic for dup_anon_vma() resets the VMA iterator to the initial
range, ensuring that any logic looping on this iterator will correctly
proceed to the next VMA.

However the commit_merge() abort logic does not do the same thing.  This
resulted in a syzbot report occurring because mlockall() iterates through
VMAs, is tolerant of errors, but ended up with an incorrect previous VMA
being specified due to incorrect iterator state.

While making this change, it became apparent we are duplicating logic -
the logic introduced in commit 41e6ddcaa0f1 ("mm/vma: add give_up_on_oom
option on modify/merge, use in uffd release") duplicates the
vmg->give_up_on_oom check in both abort branches.

Additionally, we observe that we can perform the anon_dup check safely on
dup_anon_vma() failure, as this will not be modified should this call
fail.

Finally, we need to reset the iterator in both cases, so now we can simply
use the exact same code to abort for both.

We remove the VM_WARN_ON(err != -ENOMEM) as it would be silly for this to
be otherwise and it allows us to implement the abort check more neatly.

Link: https://lkml.kernel.org/r/20250606125032.164249-1-lorenzo.stoakes@oracle.com
Fixes: 47b16d0462a4 ("mm: abort vma_modify() on merge out of memory failure")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: syzbot+d16409ea9ecc16ed261a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/6842cc67.a00a0220.29ac89.003b.GAE@google.com/
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/mm/vma.c~mm-vma-reset-vma-iterator-on-commit_merge-oom-failure
+++ a/mm/vma.c
@@ -961,26 +961,9 @@ static __must_check struct vm_area_struc
 		err = dup_anon_vma(next, middle, &anon_dup);
 	}
 
-	if (err)
+	if (err || commit_merge(vmg))
 		goto abort;
 
-	err = commit_merge(vmg);
-	if (err) {
-		VM_WARN_ON(err != -ENOMEM);
-
-		if (anon_dup)
-			unlink_anon_vmas(anon_dup);
-
-		/*
-		 * We've cleaned up any cloned anon_vma's, no VMAs have been
-		 * modified, no harm no foul if the user requests that we not
-		 * report this and just give up, leaving the VMAs unmerged.
-		 */
-		if (!vmg->give_up_on_oom)
-			vmg->state = VMA_MERGE_ERROR_NOMEM;
-		return NULL;
-	}
-
 	khugepaged_enter_vma(vmg->target, vmg->flags);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
@@ -989,6 +972,9 @@ abort:
 	vma_iter_set(vmg->vmi, start);
 	vma_iter_load(vmg->vmi);
 
+	if (anon_dup)
+		unlink_anon_vmas(anon_dup);
+
 	/*
 	 * This means we have failed to clone anon_vma's correctly, but no
 	 * actual changes to VMAs have occurred, so no harm no foul - if the
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch

