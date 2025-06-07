Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51BC2CA6
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 22:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749334088; cv=none; b=gHK5UpWAUqSqnO9jFhveUlnCNTVeT6hTjw+VshJ5Vm5WG8KgUagw+dW+xFl/f8Ac8ZlKvT9G9Wk0vUKAACYxp0OinqMh+nkpmxmyJA0upPpzxhEUALIvWwvn9ygpyL2SaDZ8+fmRk4HIRWfjbbHSCmkAVd3vxi6fgz4jr5JzaP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749334088; c=relaxed/simple;
	bh=DDU4xLh24pP5lBSM3sPK6kC8j1/sZXbQm8PJg8yyS2k=;
	h=Date:To:From:Subject:Message-Id; b=RhlsiTBdgaoqDKk1D95A/8Q51689iWCYdSyguETq1fGcHgVndBWpzo/dWCSBi4s8knpbBtoerSIfL30eWXUgPRK6z6/HY8n/b3lkQXccWWuFMnOHATpeU12xGPFKPTWXtsi49eK86muGmGgr+xZwlimP7AsL8gpaWcoHLQY3tmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dv5QmILL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dv5QmILL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8D2C4CEE4;
	Sat,  7 Jun 2025 22:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749334087;
	bh=DDU4xLh24pP5lBSM3sPK6kC8j1/sZXbQm8PJg8yyS2k=;
	h=Date:To:From:Subject:From;
	b=dv5QmILL02mOPWYBAlIseeOzCUeKg6B/ZXgRpbm7kk4E38+lqKp/NmTOX2muhKS04
	 jfY0TFxZnCSZZcukVZa6Y167ioMLKE8v41EGMKIuMausMnlk2DC6yFyBhB+FBAMbtI
	 bs5Ex3VA8lp+P3iERN9PTi7KIDDIgzunnqfICyIY=
Date: Sat, 07 Jun 2025 15:08:06 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,peterx@redhat.com,Jason@zx2c4.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,aarcange@redhat.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch added to mm-new branch
Message-Id: <20250607220807.3B8D2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: correctly prevent registering VM_DROPPABLE regions
has been added to the -mm mm-new branch.  Its filename is
     userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: userfaultfd: correctly prevent registering VM_DROPPABLE regions
Date: Sat, 07 Jun 2025 02:40:00 -0400

Patch series "mm: userfaultfd: assorted fixes and cleanups", v2.

Two fixes and two cleanups for userfaultfd.

I added a patch converting BUG_ON()s in the userfaultfd code to
VM_WARN_ON_ONCE() this time around.

Note that the third patch yields a small change in the ABI, but we seem to
have concluded that that's acceptable in this case.


This patch (of 4):

vma_can_userfault() masks off non-userfaultfd VM flags from vm_flags.  The
vm_flags & VM_DROPPABLE test will then always be false, incorrectly
allowing VM_DROPPABLE regions to be registered with userfaultfd.

Additionally, vm_flags is not guaranteed to correspond to the actual VMA's
flags.  Fix this test by checking the VMA's flags directly.

Link: https://lkml.kernel.org/r/20250607-uffd-fixes-v2-0-339dafe9a2fe@columbia.edu
Link: https://lore.kernel.org/linux-mm/5a875a3a-2243-4eab-856f-bc53ccfec3ea@redhat.com/
Link: https://lkml.kernel.org/r/20250607-uffd-fixes-v2-1-339dafe9a2fe@columbia.edu
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/userfaultfd_k.h~userfaultfd-correctly-prevent-registering-vm_droppable-regions
+++ a/include/linux/userfaultfd_k.h
@@ -218,7 +218,7 @@ static inline bool vma_can_userfault(str
 {
 	vm_flags &= __VM_UFFD_FLAGS;
 
-	if (vm_flags & VM_DROPPABLE)
+	if (vma->vm_flags & VM_DROPPABLE)
 		return false;
 
 	if ((vm_flags & VM_UFFD_MINOR) &&
_

Patches currently in -mm which might be from tz2294@columbia.edu are

userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch
userfaultfd-remove-vm_bug_ons.patch
userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch
userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch
compiler_types-remove-unnecessary-indirection-in-compiletime_assert.patch

