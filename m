Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E804EC4;
	Tue,  8 Oct 2024 00:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728347418; cv=none; b=auj86ZjoUBs0YYyP4bN7im1wLqxsbm7KSVoHVcFWSATlsUiWWSUTbsM3pOKlMsVNfqQ5uTln/riwjDzZPSeJ9LWQXG/510WaVs8OTSbtTC/9jL6nmQPzgxh7TGAJ9J5sa4fut4iTbcGD94rBUUFkcJE4HsgiFGOvk1UmPi1RVj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728347418; c=relaxed/simple;
	bh=0kLb0bq4Rj/Dx9UVhwpykR/7kCxf0Ra4uInKApu8MVA=;
	h=Date:To:From:Subject:Message-Id; b=hotgxJFdjmPtGtpVhGfNT5aVpyhX4FGuzoA8G9yp2mNBq7GjOJTfUXowK6LWITAj7+3wjgpl+oYvuA/7P8M2Ch7QAWX1wTQ6A1/LcecWhk6AvLWBtB9I/y8D0vEs47Tk/mHP5Rg8H73OfQGidPTyA9tM65vIqbdWeVCp4GT6XkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FemlL7VG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FemlL7VG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12574C4CEC6;
	Tue,  8 Oct 2024 00:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728347418;
	bh=0kLb0bq4Rj/Dx9UVhwpykR/7kCxf0Ra4uInKApu8MVA=;
	h=Date:To:From:Subject:From;
	b=FemlL7VG179nJRYRKRJRfCscJ0+KEpVq3rS2awQ9QAqnySodH9mDPCRQkdNGF2mnB
	 1K9MSs6g17eUgl6ZoJ8ad765N2uKBZqWfvSzwnMiVHAYOKDPgKb14eYtvLNSFOnwLp
	 Y6pAELvma7tukL2k/WAjntu2oz1HsPiWuI2WNAF4=
Date: Mon, 07 Oct 2024 17:30:17 -0700
To: mm-commits@vger.kernel.org,w@1wt.eu,vbabka@suse.cz,stable@vger.kernel.org,riel@redhat.com,oleg@redhat.com,mhocko@suse.com,hughd@google.com,deller@gmx.de,ben@decadent.org.uk,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas.patch added to mm-hotfixes-unstable branch
Message-Id: <20241008003018.12574C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: enforce a minimal stack gap even against inaccessible VMAs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas.patch

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
From: Jann Horn <jannh@google.com>
Subject: mm: enforce a minimal stack gap even against inaccessible VMAs
Date: Tue, 08 Oct 2024 00:55:39 +0200

As explained in the comment block this change adds, we can't tell what
userspace's intent is when the stack grows towards an inaccessible VMA.

I have a (highly contrived) C testcase for 32-bit x86 userspace with glibc
that mixes malloc(), pthread creation, and recursion in just the right way
such that the main stack overflows into malloc() arena memory.

I don't know of any specific scenario where this is actually exploitable,
but it seems like it could be a security problem for sufficiently unlucky
userspace.

I believe we should ensure that, as long as code is compiled with
something like -fstack-check, a stack overflow in it can never cause the
main stack to overflow into adjacent heap memory.

My fix effectively reverts the behavior for !vma_is_accessible() VMAs to
the behavior before commit 1be7107fbe18 ("mm: larger stack guard gap,
between vmas"), so I think it should be a fairly safe change even in case
A.

Link: https://lkml.kernel.org/r/20241008-stack-gap-inaccessible-v1-1-848d4d891f21@google.com
Fixes: 561b5e0709e4 ("mm/mmap.c: do not blow on PROT_NONE MAP_FIXED holes in the stack")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Willy Tarreau <w@1wt.eu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   53 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 7 deletions(-)

--- a/mm/mmap.c~mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas
+++ a/mm/mmap.c
@@ -1064,10 +1064,12 @@ static int expand_upwards(struct vm_area
 		gap_addr = TASK_SIZE;
 
 	next = find_vma_intersection(mm, vma->vm_end, gap_addr);
-	if (next && vma_is_accessible(next)) {
-		if (!(next->vm_flags & VM_GROWSUP))
+	if (next && !(next->vm_flags & VM_GROWSUP)) {
+		/* see comments in expand_downwards() */
+		if (vma_is_accessible(prev))
+			return -ENOMEM;
+		if (address == next->vm_start)
 			return -ENOMEM;
-		/* Check that both stack segments have the same anon_vma? */
 	}
 
 	if (next)
@@ -1155,10 +1157,47 @@ int expand_downwards(struct vm_area_stru
 	/* Enforce stack_guard_gap */
 	prev = vma_prev(&vmi);
 	/* Check that both stack segments have the same anon_vma? */
-	if (prev) {
-		if (!(prev->vm_flags & VM_GROWSDOWN) &&
-		    vma_is_accessible(prev) &&
-		    (address - prev->vm_end < stack_guard_gap))
+	if (prev && !(prev->vm_flags & VM_GROWSDOWN) &&
+	    (address - prev->vm_end < stack_guard_gap)) {
+		/*
+		 * If the previous VMA is accessible, this is the normal case
+		 * where the main stack is growing down towards some unrelated
+		 * VMA. Enforce the full stack guard gap.
+		 */
+		if (vma_is_accessible(prev))
+			return -ENOMEM;
+
+		/*
+		 * If the previous VMA is not accessible, we have a problem:
+		 * We can't tell what userspace's intent is.
+		 *
+		 * Case A:
+		 * Maybe userspace wants to use the previous VMA as a
+		 * "guard region" at the bottom of the main stack, in which case
+		 * userspace wants us to grow the stack until it is adjacent to
+		 * the guard region. Apparently some Java runtime environments
+		 * and Rust do that?
+		 * That is kind of ugly, and in that case userspace really ought
+		 * to ensure that the stack is fully expanded immediately, but
+		 * we have to handle this case.
+		 *
+		 * Case B:
+		 * But maybe the previous VMA is entirely unrelated to the stack
+		 * and is only *temporarily* PROT_NONE. For example, glibc
+		 * malloc arenas create a big PROT_NONE region and then
+		 * progressively mark parts of it as writable.
+		 * In that case, we must not let the stack become adjacent to
+		 * the previous VMA. Otherwise, after the region later becomes
+		 * writable, a stack overflow will cause the stack to grow into
+		 * the previous VMA, and we won't have any stack gap to protect
+		 * against this.
+		 *
+		 * As an ugly tradeoff, enforce a single-page gap.
+		 * A single page will hopefully be small enough to not be
+		 * noticed in case A, while providing the same level of
+		 * protection in case B that normal userspace threads get.
+		 */
+		if (address == prev->vm_end)
 			return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from jannh@google.com are

mm-mremap-prevent-racing-change-of-old-pmd-type.patch
mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas.patch

