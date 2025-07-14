Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9132E238D32
	for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2025 23:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752536899; cv=none; b=jVYZVsdqghC9YonDAB2BMLzmCGIx5E1AElHlIzB0DvOL0ZQumXBORZiFS8gKf8puHnM6C5Vkr7duNRcmvcsFk31TBLmy3nEhYuGWHbgjmCZ7iyHT0pnYiJiAaJmbOfkT1vojZOODDhFooFQbi/wPVWMtJ/lDGun4/pHvVkEWq+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752536899; c=relaxed/simple;
	bh=ElCFKFL2FUu3UfwqZAJbvXjQZR9DA1psL7rss0yaV8I=;
	h=Date:To:From:Subject:Message-Id; b=mT53z8g5zg8RD9Mi8XmNjU4I842tBimt+gz0hK8dyS7pAtZ3V9M6iYRuK23l1lgTXTJasC/gBsG2G/7nKf2U79Df0sjk/yPFST+XhaXSRaP0sTBmjo/6gaPSQN32bp0uVwvrH3InEw4rsGLCtEGOcGelkrOk5b8dzk7D//uzd+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V/VxF7k3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V/VxF7k3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1D8C4CEED;
	Mon, 14 Jul 2025 23:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752536898;
	bh=ElCFKFL2FUu3UfwqZAJbvXjQZR9DA1psL7rss0yaV8I=;
	h=Date:To:From:Subject:From;
	b=V/VxF7k3wRtCqgDtT2JUT1ft4Hp7I5zIl8llhkfa99uRNO1J98bLzW/VVy6+JN0qn
	 TXFvJonbrqs3Nkwuj9CMSr7uWeh3VEa+XZDTGU3/Vq0s5FuvMcQIbydi5bw+o4MX5r
	 l32bYuQpXfeBHPNonYr3kEfiq4KGkUuekKsmnxk8=
Date: Mon, 14 Jul 2025 16:48:17 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch added to mm-new branch
Message-Id: <20250714234818.0C1D8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: refactor vma_modify_flags_name() to vma_modify_name()
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: refactor vma_modify_flags_name() to vma_modify_name()
Date: Mon, 14 Jul 2025 14:58:39 +0100

The single instance in which we use this function doesn't actually need to
change VMA flags, so remove this parameter and update the caller
accordingly.

Link: https://lkml.kernel.org/r/20250714135839.178032-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 mm/vma.c     |    4 +---
 mm/vma.h     |   15 +++++++--------
 3 files changed, 10 insertions(+), 13 deletions(-)

--- a/mm/madvise.c~mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name
+++ a/mm/madvise.c
@@ -162,8 +162,8 @@ static int madvise_update_vma(vm_flags_t
 		return 0;
 
 	if (set_new_anon_name)
-		vma = vma_modify_flags_name(&vmi, madv_behavior->prev, vma,
-			range->start, range->end, new_flags, anon_name);
+		vma = vma_modify_name(&vmi, madv_behavior->prev, vma,
+			range->start, range->end, anon_name);
 	else
 		vma = vma_modify_flags(&vmi, madv_behavior->prev, vma,
 			range->start, range->end, new_flags);
--- a/mm/vma.c~mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name
+++ a/mm/vma.c
@@ -1650,17 +1650,15 @@ struct vm_area_struct *vma_modify_flags(
 }
 
 struct vm_area_struct
-*vma_modify_flags_name(struct vma_iterator *vmi,
+*vma_modify_name(struct vma_iterator *vmi,
 		       struct vm_area_struct *prev,
 		       struct vm_area_struct *vma,
 		       unsigned long start,
 		       unsigned long end,
-		       vm_flags_t vm_flags,
 		       struct anon_vma_name *new_name)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
-	vmg.vm_flags = vm_flags;
 	vmg.anon_name = new_name;
 
 	return vma_modify(&vmg);
--- a/mm/vma.h~mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name
+++ a/mm/vma.h
@@ -290,15 +290,14 @@ __must_check struct vm_area_struct
 		unsigned long start, unsigned long end,
 		vm_flags_t vm_flags);
 
-/* We are about to modify the VMA's flags and/or anon_name. */
+/* We are about to modify the VMA's anon_name. */
 __must_check struct vm_area_struct
-*vma_modify_flags_name(struct vma_iterator *vmi,
-		       struct vm_area_struct *prev,
-		       struct vm_area_struct *vma,
-		       unsigned long start,
-		       unsigned long end,
-		       vm_flags_t vm_flags,
-		       struct anon_vma_name *new_name);
+*vma_modify_name(struct vma_iterator *vmi,
+		 struct vm_area_struct *prev,
+		 struct vm_area_struct *vma,
+		 unsigned long start,
+		 unsigned long end,
+		 struct anon_vma_name *new_name);
 
 /* We are about to modify the VMA's memory policy. */
 __must_check struct vm_area_struct
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
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch

