Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B0F21C9E9
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545875; cv=none; b=I/7H2xWgi7CKZzb7t/FsgqcklZ/00ng9mTSAY2MKYgip1x0o1pLJQWVWOkgndTXyNyidAjkD2nMtImUO8RSmO1iDtbFLhGwhESZ+VDLRIy5GxZIuzGCqHGsiAhv7o4Y396UYtdJPb6Qu+I/I3zFpLjPq2F1KnWS92H8RCkwL7Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545875; c=relaxed/simple;
	bh=etgc4E4TDDnd0jdjjx5bTlq1gPGed4M1gRiBASQqnng=;
	h=Date:To:From:Subject:Message-Id; b=EdUv7BB2PlRZmvPnCGa9V11JLm2dKVD3Qn2xycxTLi3r8DXQEIMLYjjlSGpt8qGyCtc8DttIzW2VFF3L3EbZ8OcoacqIewmpyNx2m4JRN+rEJ16MBIZXKvOVGBfCAS68A5w/owgLQB8ndbPcl09XfP0rL4UCulFMr5bc1JhwCcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2YtjWtCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2YtjWtCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772C8C4CEE4;
	Tue,  1 Apr 2025 22:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545875;
	bh=etgc4E4TDDnd0jdjjx5bTlq1gPGed4M1gRiBASQqnng=;
	h=Date:To:From:Subject:From;
	b=2YtjWtCmD5RMeEXFzZvJf5JhsXlDTdX6mHv80dzJWAXHTUpsw6f3oMOSMoBp5m/lu
	 JtrfDLWQcGlmf/mIBrrQG5I9y6o19QAzR4/Mtda9yjdkIgWuq3hCmtYDbhvxI61rAF
	 eGvDk3FwzBCX5Ae1CkB3tRojoi585XeXUg318JUI=
Date: Tue, 01 Apr 2025 15:17:54 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,anshuman.khandual@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-replace-flag-check-with-pagehwpoison-in-check_new_page_bad.patch removed from -mm tree
Message-Id: <20250401221755.772C8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: replace flag check with PageHWPoison() in check_new_page_bad()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-replace-flag-check-with-pagehwpoison-in-check_new_page_bad.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/page_alloc: replace flag check with PageHWPoison() in check_new_page_bad()
Date: Thu, 20 Mar 2025 14:33:46 +0800

This patch replaces the direct check for the __PG_HWPOISON flag with the
PageHWPoison() macro, improving code readability and maintaining
consistency with other parts of the memory management code.

Link: https://lkml.kernel.org/r/20250320063346.489030-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-replace-flag-check-with-pagehwpoison-in-check_new_page_bad
+++ a/mm/page_alloc.c
@@ -1593,7 +1593,7 @@ static __always_inline void page_del_and
 
 static void check_new_page_bad(struct page *page)
 {
-	if (unlikely(page->flags & __PG_HWPOISON)) {
+	if (unlikely(PageHWPoison(page))) {
 		/* Don't complain about hwpoisoned pages */
 		if (PageBuddy(page))
 			__ClearPageBuddy(page);
_

Patches currently in -mm which might be from liuye@kylinos.cn are


