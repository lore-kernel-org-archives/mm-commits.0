Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F8F1D3564
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 22:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729116497; cv=none; b=PnH4GAKSOrGfi3cxu5q4RHLm5p3u+RgnEWtf6LAP/Ko33KerOOxhXO6ZmIHlV2T8735c03761ItLGv/XEBb6oUew5hdpLQ9YyIMqBNHVgP5QJc5TthISsiYEQHMc66ZkjivWj2QPcn/PVtaTj6/QEh/XXIDgqUZ3wGIcgzoyhYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729116497; c=relaxed/simple;
	bh=uiMs/K+JCcfOURSHFZ/NtfngBATDqp0PCMM+2bFFqrQ=;
	h=Date:To:From:Subject:Message-Id; b=KsYhiK9V4G4DpGEktBr3Kw05kubPA61yrx+tJx90UxjB75SXPYHy3oaKSlAxewTk+bv9A9bRFScGUne+eFTFdQ2/MFfhDAaTUeRZt2FR73PjPVJ8SbjiWrU6xsorCDhbjAl0fZ1KLcTF8GIf6lzTHjTWCziNRxa6nr5jqSRfWas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yh51oAS5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yh51oAS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0C0C4CED0;
	Wed, 16 Oct 2024 22:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729116496;
	bh=uiMs/K+JCcfOURSHFZ/NtfngBATDqp0PCMM+2bFFqrQ=;
	h=Date:To:From:Subject:From;
	b=Yh51oAS5MJtWT57S/LKpM4i3YOBamQXpfaPHlmLLEBQ7gRD9qQ7P6zqsVnBSXTq2w
	 NI3THdGbPkVl2kB4+v6A0QxYdEcwiJ/ShLg8c0c2st6hqQEDOX3aILU7StjlhkqQc0
	 MBO/7jWzZ7NlC3LsHeBN9ohp8g0WrUx9MUpT+fiI=
Date: Wed, 16 Oct 2024 15:08:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mark-mas-allocation-in-vms_abort_munmap_vmas-as-__gfp_nofail.patch added to mm-hotfixes-unstable branch
Message-Id: <20241016220816.3C0C0C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mark mas allocation in vms_abort_munmap_vmas as __GFP_NOFAIL
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mark-mas-allocation-in-vms_abort_munmap_vmas-as-__gfp_nofail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mark-mas-allocation-in-vms_abort_munmap_vmas-as-__gfp_nofail.patch

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
Subject: mm: mark mas allocation in vms_abort_munmap_vmas as __GFP_NOFAIL
Date: Wed, 16 Oct 2024 17:07:53 +0200

vms_abort_munmap_vmas() is a recovery path where, on entry, some VMAs have
already been torn down halfway (in a way we can't undo) but are still
present in the maple tree.

At this point, we *must* remove the VMAs from the VMA tree, otherwise we
get UAF.

Because removing VMA tree nodes can require memory allocation, the
existing code has an error path which tries to handle this by reattaching
the VMAs; but that can't be done safely.

A nicer way to fix it would probably be to preallocate enough maple tree
nodes for the removal before the point of no return, or something like
that; but for now, fix it the easy and kinda ugly way, by marking this
allocation __GFP_NOFAIL.

Link: https://lkml.kernel.org/r/20241016-fix-munmap-abort-v1-1-601c94b2240d@google.com
Fixes: 4f87153e82c4 ("mm: change failure of MAP_FIXED to restoring the gap on failure")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/vma.h~mm-mark-mas-allocation-in-vms_abort_munmap_vmas-as-__gfp_nofail
+++ a/mm/vma.h
@@ -241,15 +241,9 @@ static inline void vms_abort_munmap_vmas
 	 * failure method of leaving a gap where the MAP_FIXED mapping failed.
 	 */
 	mas_set_range(mas, vms->start, vms->end - 1);
-	if (unlikely(mas_store_gfp(mas, NULL, GFP_KERNEL))) {
-		pr_warn_once("%s: (%d) Unable to abort munmap() operation\n",
-			     current->comm, current->pid);
-		/* Leaving vmas detached and in-tree may hamper recovery */
-		reattach_vmas(mas_detach);
-	} else {
-		/* Clean up the insertion of the unfortunate gap */
-		vms_complete_munmap_vmas(vms, mas_detach);
-	}
+	mas_store_gfp(mas, NULL, GFP_KERNEL|__GFP_NOFAIL);
+	/* Clean up the insertion of the unfortunate gap */
+	vms_complete_munmap_vmas(vms, mas_detach);
 }
 
 int
_

Patches currently in -mm which might be from jannh@google.com are

mm-mremap-fix-move_normal_pmd-retract_page_tables-race.patch
maintainers-add-myself-as-memory-mapping-vma-reviewer.patch
mm-mark-mas-allocation-in-vms_abort_munmap_vmas-as-__gfp_nofail.patch

