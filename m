Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F218919D064;
	Thu, 10 Oct 2024 20:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728593299; cv=none; b=mVO5P2+vVrKwRAC483hzfFz/aBtehWlpRIj/V/vcwTmgEmD47sxZDDURdRoEfyTRDacsIeW2i1wg8BWIWrzSyIC2bKK7ILbJdCa4/qEUSe5JUfrDZtZPxzv0FTsOu44ssgMP+uVpF3kGHBc7MHM9+93zTMHauGIrtuXgRzHlZ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728593299; c=relaxed/simple;
	bh=7SjMNgYx9sTS4Z06fO/CTb2R4UVzNqiqGFjfpM2SXXE=;
	h=Date:To:From:Subject:Message-Id; b=iOg1rehBzWuuuGMMh4mwmSlZzGpMU+9alaci1I5E5u7asPjlfO4u/c0UoEj8vAmT6C258aATbKcDpPEE70ORafdf5ct0mb1FHVA5nabWzE+zITlRepRmUH6UxlrzVvFFLhLCKZ0mf18NtziBOCRnB7IHd7Ie18bnlWnuU2ghVH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R1T/8WrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R1T/8WrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81927C4CEC5;
	Thu, 10 Oct 2024 20:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728593298;
	bh=7SjMNgYx9sTS4Z06fO/CTb2R4UVzNqiqGFjfpM2SXXE=;
	h=Date:To:From:Subject:From;
	b=R1T/8WrZG9djrgH1xTqfqqs5jmZISmf7l8suAVlR0fhJiwM8XSxpRAPQkD1Vf/iHn
	 jJxnT5raZ8FRQvZBGQ4WpM6nVr56heC1LrMR73EIr2FmQuUx8P3f+vBTOPgCxk4y8F
	 XI2GaqjKM8sjySbJRpd9qN/AOxirXU2in7hPMliY=
Date: Thu, 10 Oct 2024 13:48:17 -0700
To: mm-commits@vger.kernel.org,w@1wt.eu,vbabka@suse.cz,stable@vger.kernel.org,riel@redhat.com,oleg@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hughd@google.com,deller@gmx.de,ben@decadent.org.uk,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas.patch removed from -mm tree
Message-Id: <20241010204818.81927C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: enforce a minimal stack gap even against inaccessible VMAs
has been removed from the -mm tree.  Its filename was
     mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas.patch

This patch was dropped because an updated version will be issued

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

[akpm@linux-foundation.org: s/prev/next/ in !CONFIG_STACK_GROWSUP section, per Lorenzo]
  Closes: https://lore.kernel.org/oe-kbuild-all/202410090632.brLG8w0b-lkp@intel.com/
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
Cc: kernel test robot <lkp@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
+		if (vma_is_accessible(next))
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

mm-mremap-fix-move_normal_pmd-retract_page_tables-race.patch

