Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408FC2CA6
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 22:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749334093; cv=none; b=mN6SY8Nl9cIMbyPqqR6U6bVzFkfC1XGXH/onH2TvcML1Gqtol41g3/e7t2VFv+Du/ZpZ+sYMPksPbwuPIzqq3/3DwRz1+dvrmlNYaEQZjOZ/rKNOj6iFvdgfPTZ8bv5M3i8+Fc7fmGSq/X5oTQlBYoR7GJ5WHiX1GL9BZz/zMuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749334093; c=relaxed/simple;
	bh=WglNg5AlDPV/tCatpB52Ys5sSEP9WdFkJdusmSMeaso=;
	h=Date:To:From:Subject:Message-Id; b=F1vKEnrH5iIf6Blx+F2kGlAHKdufRO2E4hPqbp0GxAS8HwwRw8kXN2sPH7rSOelYQaOew1moIvtTAL9XynWdGGEnOu1NWEA/YmoTwkfhv+my6Js2GM3LNCIGtDhL8xl9nZUoZNV6Snw18vZTT4HK7aOZAPeOehxB73xeNEEQIgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wevDnrr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wevDnrr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1606C4CEE4;
	Sat,  7 Jun 2025 22:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749334092;
	bh=WglNg5AlDPV/tCatpB52Ys5sSEP9WdFkJdusmSMeaso=;
	h=Date:To:From:Subject:From;
	b=wevDnrr8Zv++BqHkTj7FzPbTicZ8IUAjO+NSvPbqGDxpkSSnyX1yWYNe35xYGg6N6
	 /kaWXgnmn+ffZyvJJHRgjuL8zVrS5n8+sDxM+0oAJbr/7F6XOx7ERLVTUvqIKLH+Jk
	 ddYDEyLNkrn3XNSNmc5KM8x3M07SVZALMVK58Lr0=
Date: Sat, 07 Jun 2025 15:08:12 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,peterx@redhat.com,Jason@zx2c4.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,aarcange@redhat.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch added to mm-new branch
Message-Id: <20250607220812.D1606C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: prevent unregistering VMAs through a different userfaultfd
has been added to the -mm mm-new branch.  Its filename is
     userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch

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
Subject: userfaultfd: prevent unregistering VMAs through a different userfaultfd
Date: Sat, 07 Jun 2025 02:40:02 -0400

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
were registered with.  Additionally, reorder the WARN() checks to avoid
the aforementioned wp_async issue in the WARN()s.

This change slightly modifies the ABI. It should not be backported to
-stable.

While at it, correct the comment for the no userfaultfd case.  This seems
to be a copy-paste artifact from the analogous userfaultfd_register()
check.

Link: https://lkml.kernel.org/r/20250607-uffd-fixes-v2-3-339dafe9a2fe@columbia.edu
Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd
+++ a/fs/userfaultfd.c
@@ -1467,6 +1467,16 @@ static int userfaultfd_unregister(struct
 				!!(cur->vm_flags & __VM_UFFD_FLAGS));
 
 		/*
+		 * Check that this VMA isn't already owned by a different
+		 * userfaultfd. This provides for more strict behavior by
+		 * preventing a VMA registered with a userfaultfd from being
+		 * unregistered through a different userfaultfd.
+		 */
+		if (cur->vm_userfaultfd_ctx.ctx &&
+		    cur->vm_userfaultfd_ctx.ctx != ctx)
+			goto out_unlock;
+
+		/*
 		 * Check not compatible vmas, not strictly required
 		 * here as not compatible vmas cannot have an
 		 * userfaultfd_ctx registered on them, but this
@@ -1489,15 +1499,14 @@ static int userfaultfd_unregister(struct
 	for_each_vma_range(vmi, vma, end) {
 		cond_resched();
 
-		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vma->vm_flags, wp_async));
-
 		/*
-		 * Nothing to do: this vma is already registered into this
-		 * userfaultfd and with the right tracking mode too.
+		 * Nothing to do: this vma is not registered with userfaultfd.
 		 */
 		if (!vma->vm_userfaultfd_ctx.ctx)
 			goto skip;
 
+		VM_WARN_ON_ONCE(vma->vm_userfaultfd_ctx.ctx != ctx);
+		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vma->vm_flags, wp_async));
 		WARN_ON(!(vma->vm_flags & VM_MAYWRITE));
 
 		if (vma->vm_start > start)
_

Patches currently in -mm which might be from tz2294@columbia.edu are

userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch
userfaultfd-remove-vm_bug_ons.patch
userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch
userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch
compiler_types-remove-unnecessary-indirection-in-compiletime_assert.patch

