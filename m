Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE725588F
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729737551; cv=none; b=LeAM0a55ozc2GUIA81ApeWlnhA5TpMziouN8I6quL5yuk11HI3MxVnINyH1qn4c+UGMtl+2oVZc09zJENPSKQTrrZAK74OTLZdj23BFJuBo9cw4/mY9NLnkxKZMS3piu3KOU6mxNid+eJ6mvqaCSjAdegvyxk3/dEAgbVvB3yFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729737551; c=relaxed/simple;
	bh=NW96CbZxdY8hP0v91gYORZ3xQ3NnKe3WUiZvgUavXvc=;
	h=Date:To:From:Subject:Message-Id; b=gr/OcIJRIvXk3l6jWe5Fo7i/qUEuqoqvXgHjnmRpQif4x863gdZiNSydapzBgC/Dt0tuxCu3UUl05GlihTMQcgNNelgY1p7NgW7J39kR6O7nGrSsBsWjhieX9PYR4qFP9IpAqJKhN9EArBaf3X/sEOVPjUFBmHwfz9Fb0U+GIZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BStkfKXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BStkfKXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6496C4CEC6;
	Thu, 24 Oct 2024 02:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729737551;
	bh=NW96CbZxdY8hP0v91gYORZ3xQ3NnKe3WUiZvgUavXvc=;
	h=Date:To:From:Subject:From;
	b=BStkfKXXbQg3CmiHh0pqkYhZW0JyfzG9TFcm4pF5SSoL1XFiyB4cqyQBGLWir0YSK
	 jcy6oiuRgniFYNqRGKCXwJ0z+M8xS398nddaD9k5kdU//Y70msap7ha14iyg9gL6By
	 PBrzypVL6NrMrGwq/bMQ2x93SFjHeyc/tfhu0+pQ=
Date: Wed, 23 Oct 2024 19:39:10 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,jgg@nvidia.com,david@redhat.com,jthoughton@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-missing-mmu_notifier_clear_young-for-mmu_notifier.patch added to mm-unstable branch
Message-Id: <20241024023910.E6496C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add missing mmu_notifier_clear_young for !MMU_NOTIFIER
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-missing-mmu_notifier_clear_young-for-mmu_notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-missing-mmu_notifier_clear_young-for-mmu_notifier.patch

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
From: James Houghton <jthoughton@google.com>
Subject: mm: add missing mmu_notifier_clear_young for !MMU_NOTIFIER
Date: Mon, 21 Oct 2024 16:02:12 +0000

Remove the now unnecessary ifdef in mm/damon/vaddr.c as well.

Link: https://lkml.kernel.org/r/20241021160212.9935-1-jthoughton@google.com
Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    7 +++++++
 mm/damon/vaddr.c             |    2 --
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/mmu_notifier.h~mm-add-missing-mmu_notifier_clear_young-for-mmu_notifier
+++ a/include/linux/mmu_notifier.h
@@ -606,6 +606,13 @@ static inline int mmu_notifier_clear_flu
 	return 0;
 }
 
+static inline int mmu_notifier_clear_young(struct mm_struct *mm,
+					   unsigned long start,
+					   unsigned long end)
+{
+	return 0;
+}
+
 static inline int mmu_notifier_test_young(struct mm_struct *mm,
 					  unsigned long address)
 {
--- a/mm/damon/vaddr.c~mm-add-missing-mmu_notifier_clear_young-for-mmu_notifier
+++ a/mm/damon/vaddr.c
@@ -353,11 +353,9 @@ static void damon_hugetlb_mkold(pte_t *p
 		set_huge_pte_at(mm, addr, pte, entry, psize);
 	}
 
-#ifdef CONFIG_MMU_NOTIFIER
 	if (mmu_notifier_clear_young(mm, addr,
 				     addr + huge_page_size(hstate_vma(vma))))
 		referenced = true;
-#endif /* CONFIG_MMU_NOTIFIER */
 
 	if (referenced)
 		folio_set_young(folio);
_

Patches currently in -mm which might be from jthoughton@google.com are

mm-add-missing-mmu_notifier_clear_young-for-mmu_notifier.patch

