Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5521C14
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218889; cv=none; b=EGjMUhPqVTTSWaJGksYM3P2bWDQb1bSnMRutLONP5ew6OKFkVJTRZ1CbK/C5eAswTKQxzwjiF7I44CXnehZxC3lqSd4fN4EUN0isbYAUqSi/iMMBKdUW+T29WUoySkL145uKWOl/gXVla4g0/ONOF09nA9ntOlW9gW2sBHgEEw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218889; c=relaxed/simple;
	bh=brmY+HN0DUkbuiY0pcDJYKsP99Th+r8IJnwSBn52syU=;
	h=Date:To:From:Subject:Message-Id; b=hmfAz3KdW9OYPPivBwJ5oVT5bdLedvAxGi2SaE8ZCExyApOeluhvBvnD10qI8q0pEJk7a6GDWZ9qQo0+u7n2dphm6Zaq2GX8pHb23VzF1vY2OQMPu3ZlhyYtUnlE/N2jU7+7dOAdbyzD9UGfatwiGRM9uzET4vcmnUOofGBUaT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cn6oKsRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cn6oKsRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DEDC116B1;
	Wed, 12 Jun 2024 19:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218889;
	bh=brmY+HN0DUkbuiY0pcDJYKsP99Th+r8IJnwSBn52syU=;
	h=Date:To:From:Subject:From;
	b=Cn6oKsRar/Uhtp4E5nG9bxIqGqOYEc7x9P8RFKgdtTmIRkyi+myHbp+vkyQqpwtqN
	 BZp7bSfOV/E8yramML0izIjwVVFXkm3/1V/Kqep+IQ7YSBoyL7rU7vsiM/nrrDR56j
	 a1TfY0FEmufZHXLYGl1QzLXvwxMCBphUtJpifXmA=
Date: Wed, 12 Jun 2024 12:01:28 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-simplify-put_ref_page.patch added to mm-unstable branch
Message-Id: <20240612190129.64DEDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: simplify put_ref_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-simplify-put_ref_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-simplify-put_ref_page.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: simplify put_ref_page()
Date: Wed, 12 Jun 2024 15:18:23 +0800

Patch series "Some cleanups for memory-failure", v3.

This series contains a few cleanup patches to avoid exporting unused
function, add helper macro, fix some obsolete comments and so on.  More
details can be found in the respective changelogs.  


This patch (of 13):

Remove unneeded page != NULL check.  pfn_to_page() won't return NULL.  No
functional change intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20240612071835.157004-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-simplify-put_ref_page
+++ a/mm/memory-failure.c
@@ -2120,14 +2120,10 @@ static inline unsigned long folio_free_r
 /* Drop the extra refcount in case we come from madvise() */
 static void put_ref_page(unsigned long pfn, int flags)
 {
-	struct page *page;
-
 	if (!(flags & MF_COUNT_INCREASED))
 		return;
 
-	page = pfn_to_page(pfn);
-	if (page)
-		put_page(page);
+	put_page(pfn_to_page(pfn));
 }
 
 static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-simplify-put_ref_page.patch
mm-memory-failure-remove-mf_msg_slab.patch
mm-memory-failure-add-macro-get_page_max_retry_num.patch
mm-memory-failure-save-some-page_folio-calls.patch
mm-memory-failure-remove-unneeded-empty-string.patch
mm-memory-failure-remove-confusing-initialization-to-count.patch
mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch
mm-memory-failure-use-helper-macro-task_pid_nr.patch
mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch
mm-memory-failure-move-some-function-declarations-into-internalh.patch
mm-memory-failure-fix-comment-of-get_hwpoison_page.patch
mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch
mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch

