Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F028219EA
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 19:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713208352; cv=none; b=GpURw4qowSxPEp7xqUuNBC2YpLS51K2AHcqDJhHyMYrWacDKF+eXmC/Or4X69awUTqO3HHYvskhh1IHLY5uK3MZdzpMGqdnXZ7fDHcZLbSGLdu3OA5SRtX4HzHok9bS6edonNpbBAxs8nybVw1RR04IoAJ656R7fMyy+O7Gvgfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713208352; c=relaxed/simple;
	bh=TPR9u4NANZe/AWuWzeOxwtaTFocISroeuWPPeW8TPrI=;
	h=Date:To:From:Subject:Message-Id; b=NtqsEG/8dYHdBOIKGaPheLPVNtb4qj1jHe7suJXTZoA/+fFJwyRU4t2kEn1dopbe7DzKScH3+wJ3HH8F93tHs7tx7KObAshjVlpiUL9xDoc1wXKPH8xTLBSOk2LNlnvM9VAQCNkH3pivQRBUodvSd99JUYUUUqaDgjm3KhK+Xvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zhPUzF2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zhPUzF2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764B5C113CC;
	Mon, 15 Apr 2024 19:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713208350;
	bh=TPR9u4NANZe/AWuWzeOxwtaTFocISroeuWPPeW8TPrI=;
	h=Date:To:From:Subject:From;
	b=zhPUzF2nJ6EZrm1gLD4/kpp1DERCITlqjLCOF32Ui3g7mn9rSglhNJTE7FpTaWuxp
	 7P3vSyk/2VR/iDX/75BjTpSHI/0CVQrNizTk0uS/pDJjkRLB53XdumB5RbbkEYIyNu
	 oNOI8bs54nzT2mFGKHbCKSvVBCKt7gEh8lYLoCmY=
Date: Mon, 15 Apr 2024 12:12:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-clean-up-hugetlb-exclusion-code.patch added to mm-unstable branch
Message-Id: <20240415191230.764B5C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: clean up hugetlb exclusion code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-clean-up-hugetlb-exclusion-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-clean-up-hugetlb-exclusion-code.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/filemap: clean up hugetlb exclusion code
Date: Tue, 16 Apr 2024 01:18:54 +0800

__filemap_add_folio only has two callers, one never passes hugetlb folio
and one always passes in hugetlb folio.  So move the hugetlb related
cgroup charging out of it to make the code cleaner.

Link: https://lkml.kernel.org/r/20240415171857.19244-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/mm/filemap.c~mm-filemap-clean-up-hugetlb-exclusion-code
+++ a/mm/filemap.c
@@ -853,20 +853,12 @@ noinline int __filemap_add_folio(struct
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	bool huge = folio_test_hugetlb(folio);
-	bool charged = false;
-	long nr = 1;
+	long nr;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_swapbacked(folio), folio);
 	mapping_set_update(&xas, mapping);
 
-	if (!huge) {
-		int error = mem_cgroup_charge(folio, NULL, gfp);
-		if (error)
-			return error;
-		charged = true;
-	}
-
 	VM_BUG_ON_FOLIO(index & (folio_nr_pages(folio) - 1), folio);
 	xas_set_order(&xas, index, folio_order(folio));
 	nr = folio_nr_pages(folio);
@@ -931,8 +923,6 @@ unlock:
 	trace_mm_filemap_add_to_page_cache(folio);
 	return 0;
 error:
-	if (charged)
-		mem_cgroup_uncharge(folio);
 	folio->mapping = NULL;
 	/* Leave page->index set: truncation relies upon it */
 	folio_put_refs(folio, nr);
@@ -946,11 +936,16 @@ int filemap_add_folio(struct address_spa
 	void *shadow = NULL;
 	int ret;
 
+	ret = mem_cgroup_charge(folio, NULL, gfp);
+	if (ret)
+		return ret;
+
 	__folio_set_locked(folio);
 	ret = __filemap_add_folio(mapping, folio, index, gfp, &shadow);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		mem_cgroup_uncharge(folio);
 		__folio_clear_locked(folio);
-	else {
+	} else {
 		/*
 		 * The folio might have been evicted from cache only
 		 * recently, in which case it should be activated like
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-filemap-return-early-if-failed-to-allocate-memory-for-split.patch
mm-filemap-clean-up-hugetlb-exclusion-code.patch
lib-xarray-introduce-a-new-helper-xas_get_order.patch
mm-filemap-optimize-filemap-folio-adding.patch

