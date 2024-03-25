Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50EA13C699
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 17:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711389288; cv=none; b=BTskm0MFAnXfdYRlJcaZoeCoYiB/lfmFWvdlRjacDUvaDPhjmW6zOgQ2S8Vu3U7oT2lCo7qx+u6ksXvoOgLsnFfF+y6cKFnHp7XEUnmeWapxYSyjudrnW5AI6SrJ02MkoEhpDeRuPA+rXG1yd5AtuJPwxEyJkOFH4QM4QOPrtG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711389288; c=relaxed/simple;
	bh=6eeJG2x9hs5AZ+XGv45eoP6p+wmxg6J5DivXpmjWub4=;
	h=Date:To:From:Subject:Message-Id; b=OC3S7hsQ3b/shEpHp7umDp0DnPz7DwxX5nn9xZ780LxMhRiEKKT7/rz0XZeKpWXLM3HaI79sytVBWvQqsvmZa8R7eQcCuKu9ZYTDT5Crz+QkvAf/Fipt1oq1FrGxkQh9nfHZvDfI1xMPZ3cKIM4paZYj9UVbqT4KJ42FDLg92Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XRRwm8+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XRRwm8+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B22EC433C7;
	Mon, 25 Mar 2024 17:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711389288;
	bh=6eeJG2x9hs5AZ+XGv45eoP6p+wmxg6J5DivXpmjWub4=;
	h=Date:To:From:Subject:From;
	b=XRRwm8+iH3eVzwQjBXM3h1+EoiBacWofOWcKkpi6XQWVpj5N4XFCgoMrdN9ne6v5Q
	 31VYnJus/5yvfPxQnEXBrw4g12u9VEsWtkUslyu77VH9Vdz3oQmMtH0dYF96YptxfC
	 48V5GLSL04XsM5P5g0OOPhWBbb2bDa+LIT411Woc=
Date: Mon, 25 Mar 2024 10:54:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-clean-up-hugetlb-exclusion-code.patch added to mm-unstable branch
Message-Id: <20240325175448.3B22EC433C7@smtp.kernel.org>
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
Date: Tue, 26 Mar 2024 01:14:03 +0800

__filemap_add_folio only has two callers, one never passes hugetlb folio
and one always passes in hugetlb folio.  So move the hugetlb related
cgroup charging out of it to make the code cleaner.

Link: https://lkml.kernel.org/r/20240325171405.99971-3-ryncsn@gmail.com
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

