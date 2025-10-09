Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EC91A9FA4
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 04:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759983051; cv=none; b=Am5qWI+N5j0iElPZqzYmAKgy/QiJpIypCpnYQjtWVB94QyUqmv6xbZcvwmr/stmCBzOC2JYRotf+X+6usQrYKeWLPwbocVXTpnPuQo8b3YehWIwQ8GCB+zO0KgMyih2b0XeIs3VAQo+SmeAXRuq0BAjYxnVMYzCOkgi8YpKnSUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759983051; c=relaxed/simple;
	bh=yR8nZmTZTYbv0Wzg/aOB7TTxVT1V2UaLVsnl1Oopcfo=;
	h=Date:To:From:Subject:Message-Id; b=DI7oYnKctGTiNbfHhtUM3wKdj1L8AOsKCFaT8nt41GSMWNi0bgpYCtOqp7sk736QIj3gzI1XI9CrJvd91jBBISBXAMHOdYgE3StlfC3FN78Wj+wn4R7EkhGUU2IPHB8dF/snwBJVkCbSNsPi4cahePqksni2DllIpNM4mQr+RnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fj+rGAc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fj+rGAc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1013DC4CEE7;
	Thu,  9 Oct 2025 04:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759983051;
	bh=yR8nZmTZTYbv0Wzg/aOB7TTxVT1V2UaLVsnl1Oopcfo=;
	h=Date:To:From:Subject:From;
	b=Fj+rGAc1kd1zHRCDx4ZHxX76Vs2CEra1NzZXYHyMbzPO/f9VeBTn6hJbRE+C5h5pJ
	 4C2a0yFwVM3pVfU7FXYaA0OCKfFMf3GhUrz9OyQy9++ZL2OF+VFinO3J2LJLPGg4CK
	 rDArqNTu1+jTxtogKIF86/xlmZvyzR/NwoYe+Y1c=
Date: Wed, 08 Oct 2025 21:10:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,usamaarif642@gmail.com,richard.weiyang@gmail.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch added to mm-new branch
Message-Id: <20251009041051.1013DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix
Date: Wed Oct  8 09:10:01 PM PDT 2025

remove unneeded map_anon_folio_pmd_nopf() stub, per Wei & David

Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/huge_mm.h~mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix
+++ a/include/linux/huge_mm.h
@@ -644,11 +644,6 @@ static inline bool unmap_huge_pmd_locked
 	return false;
 }
 
-static inline void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
-		struct vm_area_struct *vma, unsigned long haddr)
-{
-}
-
 #define split_huge_pud(__vma, __pmd, __address)	\
 	do { } while (0)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch

