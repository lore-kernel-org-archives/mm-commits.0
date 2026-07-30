Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0120E3890F6
	for <mm-commits@vger.kernel.org>; Thu, 30 Jul 2026 22:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785450948; cv=none; b=N60GzqDsvX2AZc2Ky0NGlzBBb5fbZoNCXcIDqsZ3ZN8zaG948TIBG6zX3mPfybDGsTZGqegpvaAolD1xjWRMHE09Hl+rLR/FYjVYiaaopHVVbEn4ykp/Ffo0ra8rwgs0DFXaSVcTpGeCWkEgTZlFajadF4khkQ3O8QFeZpRZQFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785450948; c=relaxed/simple;
	bh=4GzcZtsKTFu2qPnenbKvTKttCG5yWMFSO3lLigyhg34=;
	h=Date:To:From:Subject:Message-Id; b=io1qY4ldIO7zExHOIklgL3/KaENwjzPM7P2YVaudNtVYjNp87t4isFKKdUEW3mA4FkJCNpnMI8x9RwKS0F5e706y9vMt0l5IvzPTfOei4or3TgvGRei6tVTc1cpBahxBrYPwF9Y/AqGllp6cNHFAIBmfDJbekxjuVaDvSWKBGlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WadU7t+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WadU7t+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9AC1F000E9;
	Thu, 30 Jul 2026 22:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785450946;
	bh=FtlnheQSQYFjw1xfrLm0KRytPR94NvoN3pTMbzCfj+0=;
	h=Date:To:From:Subject;
	b=WadU7t+13STm4cRMUcUI7ZSWpI7VKUFqwgrzTlyyLl/RoTTyMz+EZvjuImshuYU++
	 P6aNY8P0xSH61ZlSbVUx36IrqPSPf/GY0XIEsIXyzCtd+xKyCm9pgNNh3OLeTAEHWT
	 vcL5f87IVLiYFn+P6ujy0jdF+I3B/wDr5AggvrYw=
Date: Thu, 30 Jul 2026 15:35:45 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@kernel.org,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-proper-pte-accessor-in-move_ptes.patch added to mm-new branch
Message-Id: <20260730223546.6E9AC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use proper PTE accessor in move_ptes()
has been added to the -mm mm-new branch.  Its filename is
     mm-use-proper-pte-accessor-in-move_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-proper-pte-accessor-in-move_ptes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm: use proper PTE accessor in move_ptes()
Date: Mon, 20 Jul 2026 16:16:33 +0200

Follow the pattern established by commit c33c794828f2 ("mm: ptep_get()
conversion") and use the proper PTE accessor instead of a direct pointer
dereference.

Link: https://lore.kernel.org/20260720141633.501799-1-agordeev@linux.ibm.com
Fixes: b36b701bbcd9 ("mm: expose abnormal new_pte during move_ptes")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-use-proper-pte-accessor-in-move_ptes
+++ a/mm/mremap.c
@@ -264,7 +264,7 @@ static int move_ptes(struct pagetable_mo
 
 	for (; old_addr < old_end; old_ptep += nr_ptes, old_addr += nr_ptes * PAGE_SIZE,
 		new_ptep += nr_ptes, new_addr += nr_ptes * PAGE_SIZE) {
-		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
+		VM_WARN_ON_ONCE(!pte_none(ptep_get(new_ptep)));
 
 		nr_ptes = 1;
 		max_nr_ptes = (old_end - old_addr) >> PAGE_SHIFT;
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

mm-use-proper-pte-accessor-in-move_ptes.patch

