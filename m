Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDE31DE4EF
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 23:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740008521; cv=none; b=QxzeolKq06Whu/aN83CwyiJO3h/0SzdJfbvwNP01+4CNouoq4ssGu5CRqUPeC2obV5Ur0eIxQVm28tTy3lTvIRZqsQdeY23ahz9bbnsgcOacCxrZYbx+FS757/CdcYas8tTVoNKuaACN7hLt0Ro5djY3s5sXVGdDLbHkI4GhhQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740008521; c=relaxed/simple;
	bh=QA1Kz7B89szwtsLi1hENLg+IlEoBk+kNZzX0s7kti7o=;
	h=Date:To:From:Subject:Message-Id; b=dWdqaKPmCgt6y/Ur6rt7h+wtpMn4fIUpFDh/t0FpgYV0YehcHxEBaWG7mwtt7zYsPrw5dLqNNZN4pGk4cweBpmKjTIKdjQ9szGCI/w+0ArfEEobI7bWVTRz5ejuHM4zAK6WQ24uBAoNtVcoafM+RdO7v2FjJ1KIE9df4CvMyGAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BGJ8phty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BGJ8phty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19FDC4CEE0;
	Wed, 19 Feb 2025 23:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740008521;
	bh=QA1Kz7B89szwtsLi1hENLg+IlEoBk+kNZzX0s7kti7o=;
	h=Date:To:From:Subject:From;
	b=BGJ8phtyIHmho04WDf1Swj/ue5Frs9Bt762o5VFMO3/NwrUoMs+S2RLhtTX6uOLSz
	 ZlUfCa6guUiUnU+FgNGTYQqqLk4fiMlVwkW2qX/C01UkZ8Ez5giP/STQgq/GjW9ZB/
	 G4oYQJueAgCtnyl+tQbWdj9TEdjvcoycNXfn4zZM=
Date: Wed, 19 Feb 2025 15:42:00 -0800
To: mm-commits@vger.kernel.org,linmiaohe@huawei.com,david@redhat.com,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20250219234200.F19FDC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio-v3.patch

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
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio-v3
Date: Wed, 19 Feb 2025 14:06:52 +0800

unmap_poisoned_folio(): remove shadowed local `mapping', per Miaohe

Link: https://lkml.kernel.org/r/20250219060653.3849083-1-mawupeng1@huawei.com
Fixes: 6da6b1d4a7df ("mm/hwpoison: convert TTU_IGNORE_HWPOISON to TTU_HWPOISON")
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio-v3
+++ a/mm/memory-failure.c
@@ -1585,8 +1585,6 @@ int unmap_poisoned_folio(struct folio *f
 	}
 
 	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
-		struct address_space *mapping;
-
 		/*
 		 * For hugetlb folios in shared mappings, try_to_unmap
 		 * could potentially call huge_pmd_unshare.  Because of
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio.patch
mm-memory-failure-update-ttu-flag-inside-unmap_poisoned_folio-v3.patch
mm-memory-hotplug-check-folio-ref-count-first-in-do_migrate_range.patch
hwpoison-memory_hotplug-lock-folio-before-unmap-hwpoisoned-folio.patch

