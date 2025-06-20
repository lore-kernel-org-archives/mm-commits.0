Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972CD3597E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 01:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750383249; cv=none; b=dvMECro3A3DowbS7zoMpIl/YSU6j5Fp6lb5dtujxWNtYbW3qsgbKTGUjPTE9cw83b3+CnUG/xeWAslEAMIs9UaQc9zlFvOjqjnqULTxCWbIz5aED3yS4v6l8GZqOJ2J1rF+w7P6wSY2xwdk9ntDhAWRornLTG838pq6tS1dcBjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750383249; c=relaxed/simple;
	bh=oCq3RPhkmokTxFv9fUY5dGlo9gJpPgU8JTGgROhHidY=;
	h=Date:To:From:Subject:Message-Id; b=MKYq/i7wFR4wZAvFK+PmmygM9csNulgScgmDWvYFVcmeny7w/3LA/MJY6qi27bjpuIPtjUWtwTCupIP1y7ENdUT7De3tQIMfWDCl2+veYBbENcdbWsEfqUFZVOoiP0qwxil5od1AgtzZZuSRZAah6FETg7junIaRfDn2kbrW5Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IHhiNrIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IHhiNrIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184EEC4CEEA;
	Fri, 20 Jun 2025 01:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750383249;
	bh=oCq3RPhkmokTxFv9fUY5dGlo9gJpPgU8JTGgROhHidY=;
	h=Date:To:From:Subject:From;
	b=IHhiNrIaM/blDQ2NwiRoyEyIeNl62+SnhcEHNXZqsJ1pn8TC3VRhO5sMxShL5Tc2f
	 L2ijGjtJsJPrQvM5XJ3QjVfR4BEokUBk6YBAMzjRrULQyh5LvRcj9Q7is1foIoC3d/
	 n+BPVFU4uBJPYAUPvA76eKAfrDSohZfFkmjlw2Sg=
Date: Thu, 19 Jun 2025 18:34:08 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,peterx@redhat.com,Jason@zx2c4.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,aarcange@redhat.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch added to mm-unstable branch
Message-Id: <20250620013409.184EEC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: prevent unregistering VMAs through a different userfaultfd
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: userfaultfd: prevent unregistering VMAs through a different userfaultfd
Date: Thu, 19 Jun 2025 21:24:24 -0400

Currently, a VMA registered with a uffd can be unregistered through a
different uffd associated with the same mm_struct.

The existing behavior is slightly broken and may incorrectly reject
unregistering some VMAs due to the following check:

	if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
		goto out_unlock;

where wp_async is derived from ctx, not from cur.  For example, a
file-backed VMA registered with wp_async enabled and UFFD_WP mode cannot
be unregistered through a uffd that does not have wp_async enabled.

Rather than fix this and maintain this odd behavior, make unregistration
stricter by requiring VMAs to be unregistered through the same uffd they
were registered with.  Additionally, reorder the BUG() checks to avoid the
aforementioned wp_async issue in them.  Convert the existing check to
VM_WARN_ON_ONCE() as BUG_ON() is deprecated.

This change slightly modifies the ABI.  It should not be backported to
-stable.  It is expected that no one depends on this behavior, and no such
cases are known.

While at it, correct the comment for the no userfaultfd case.  This seems
to be a copy-paste artifact from the analogous userfaultfd_register()
check.

Link: https://lkml.kernel.org/r/20250619-uffd-fixes-v3-2-a7274d3bd5e4@columbia.edu
Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd
+++ a/fs/userfaultfd.c
@@ -1468,6 +1468,14 @@ static int userfaultfd_unregister(struct
 		       !!(cur->vm_flags & __VM_UFFD_FLAGS));
 
 		/*
+		 * Prevent unregistering through a different userfaultfd than
+		 * the one used for registration.
+		 */
+		if (cur->vm_userfaultfd_ctx.ctx &&
+		    cur->vm_userfaultfd_ctx.ctx != ctx)
+			goto out_unlock;
+
+		/*
 		 * Check not compatible vmas, not strictly required
 		 * here as not compatible vmas cannot have an
 		 * userfaultfd_ctx registered on them, but this
@@ -1490,15 +1498,12 @@ static int userfaultfd_unregister(struct
 	for_each_vma_range(vmi, vma, end) {
 		cond_resched();
 
-		BUG_ON(!vma_can_userfault(vma, vma->vm_flags, wp_async));
-
-		/*
-		 * Nothing to do: this vma is already registered into this
-		 * userfaultfd and with the right tracking mode too.
-		 */
+		/* VMA not registered with userfaultfd. */
 		if (!vma->vm_userfaultfd_ctx.ctx)
 			goto skip;
 
+		VM_WARN_ON_ONCE(vma->vm_userfaultfd_ctx.ctx != ctx);
+		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vma->vm_flags, wp_async));
 		WARN_ON(!(vma->vm_flags & VM_MAYWRITE));
 
 		if (vma->vm_start > start)
_

Patches currently in -mm which might be from tz2294@columbia.edu are

userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch
userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch
userfaultfd-remove-vm_bug_ons.patch
userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch

