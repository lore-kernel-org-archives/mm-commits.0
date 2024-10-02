Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22BC21730B
	for <mm-commits@vger.kernel.org>; Wed,  2 Oct 2024 20:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727902541; cv=none; b=qQwvZ4ZUyW13qdckOC85INdADI0iEx5+y7d/wviuuck4MNNDSdtE/wL5sqcHN3QXMhVzvfcPbUnfy6juMuXm+XAmUERhUGRxxjcIHgTzcFaY0Giz670bka7ZSSfPzmFQ48VTWxMmYsJjLRLT8g3jnmS3Rc8cdS7ocG76BvB9nK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727902541; c=relaxed/simple;
	bh=eRy5In3vf6ezocp/VzNxOEXK5B2WNtZJwYBIAl4isfM=;
	h=Date:To:From:Subject:Message-Id; b=ewmbkJR8501wsjBXEeLG4nqPOjYP38go+6JcbpPsqOkN4UHjNoMIg0X/jpIQvYIhEbS+X+SH/cL4q6WNGOkAiyy30mh5KisAHau4WiU56E+eDVnKKb2oVxFGMMRkEGQbQS4AQgy0vlTS0kRrI1BUmJCdK0uT/3W+9istfMukPHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ihCdLqI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ihCdLqI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61582C4CEC2;
	Wed,  2 Oct 2024 20:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727902540;
	bh=eRy5In3vf6ezocp/VzNxOEXK5B2WNtZJwYBIAl4isfM=;
	h=Date:To:From:Subject:From;
	b=ihCdLqI0kx4cWVjH0xxdFoEARQAhjLpEkSkE2l+n4x5D0XvuelKaT+mrDgnzlmtBn
	 GtXbkYdt2XzqyLbvTJbZYKEAGpscNrcs73DNVSJhe3FVOFyoMgddYoElL/BM7ZfeOY
	 9hSWccRXXEVv+EDMrAPY9DdC7zix6UubEsC5A3lM=
Date: Wed, 02 Oct 2024 13:55:39 -0700
To: mm-commits@vger.kernel.org,alexs@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pageksm.patch added to mm-unstable branch
Message-Id: <20241002205540.61582C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageKsm()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pageksm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pageksm.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageKsm()
Date: Wed, 2 Oct 2024 16:25:31 +0100

All callers have been converted to use folio_test_ksm() or
PageAnonNotKsm(), so we can remove this wrapper.

Link: https://lkml.kernel.org/r/20241002152533.1350629-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alex Shi <alexs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    7 +------
 mm/internal.h              |    2 +-
 mm/ksm.c                   |    4 ++--
 3 files changed, 4 insertions(+), 9 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pageksm
+++ a/include/linux/page-flags.h
@@ -725,13 +725,8 @@ static __always_inline bool folio_test_k
 	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) ==
 				PAGE_MAPPING_KSM;
 }
-
-static __always_inline bool PageKsm(const struct page *page)
-{
-	return folio_test_ksm(page_folio(page));
-}
 #else
-TESTPAGEFLAG_FALSE(Ksm, ksm)
+FOLIO_TEST_FLAG_FALSE(ksm)
 #endif
 
 u64 stable_page_flags(const struct page *page);
--- a/mm/internal.h~mm-remove-pageksm
+++ a/mm/internal.h
@@ -1311,7 +1311,7 @@ static inline bool gup_must_unshare(stru
 		smp_rmb();
 
 	/*
-	 * Note that PageKsm() pages cannot be exclusive, and consequently,
+	 * Note that KSM pages cannot be exclusive, and consequently,
 	 * cannot get pinned.
 	 */
 	return !PageAnonExclusive(page);
--- a/mm/ksm.c~mm-remove-pageksm
+++ a/mm/ksm.c
@@ -656,7 +656,7 @@ static int break_ksm(struct vm_area_stru
 	 *
 	 * VM_FAULT_SIGBUS could occur if we race with truncation of the
 	 * backing file, which also invalidates anonymous pages: that's
-	 * okay, that truncation will have unmapped the PageKsm for us.
+	 * okay, that truncation will have unmapped the KSM page for us.
 	 *
 	 * VM_FAULT_OOM: at the time of writing (late July 2009), setting
 	 * aside mem_cgroup limits, VM_FAULT_OOM would only be set if the
@@ -1434,7 +1434,7 @@ out:
  * try_to_merge_one_page - take two pages and merge them into one
  * @vma: the vma that holds the pte pointing to page
  * @page: the PageAnon page that we want to replace with kpage
- * @kpage: the PageKsm page that we want to map instead of page,
+ * @kpage: the KSM page that we want to map instead of page,
  *         or NULL the first time when we want to use page as kpage.
  *
  * This function returns 0 if the pages were merged, -EFAULT otherwise.
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-remove-pageksm.patch

