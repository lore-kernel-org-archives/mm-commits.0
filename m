Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC041E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011014; cv=none; b=Aj31URzX123OAuIsmzJXmbQUVuTAdjCbZLDWkeoRrvZ2Sexvb0WEFFgK5HNp+jKm4bbYDr4joH44yUvF5+4ntyb3mbCGpzrxqVpPMPTFVVtPOuJkkl35UUX8bAV3nZcJPhRz3FsIwAYvGvtNKXAyqb5Huy2YoyGe/xOSD56s/O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011014; c=relaxed/simple;
	bh=sTD54b+ClvIhYyEtYP8OikDbvjD8CNxD6/EFpbLYyg4=;
	h=Date:To:From:Subject:Message-Id; b=DnBW+kNHh3WUbOFm4R8I3cAzVi//5Agjkcp8K+7fDZFE56m8ZSXW6OxPh0gdcY/QlOazBFXoyBp8OOGt4LB/2w/m+JSrniLLXDJNoyG3l1MmVfTYQaA5xzUb6xGdwQLXzNnagjPJBf+mt2cmeSKwEExfG8K4/LPpQidNgOodm8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cVr6Z1gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cVr6Z1gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DB2C4CEE4;
	Mon, 12 May 2025 00:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011013;
	bh=sTD54b+ClvIhYyEtYP8OikDbvjD8CNxD6/EFpbLYyg4=;
	h=Date:To:From:Subject:From;
	b=cVr6Z1ggK1dknqH58psaOZ03lr0REnqt6SVF5PEEQINvk0k/fL7JTrW528QWdHTUZ
	 A1dxuX+9iSrvsQyWWZkwEzYF5t/irNyVk8nw/5856jKrH+VdZ3xeDtd0weFgf2jYU0
	 AqpWVDUsm6bQ2rG0v6Hh2XmcebdeUDSPM2F9P0QU=
Date: Sun, 11 May 2025 17:50:13 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,anshuman.khandual@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch removed from -mm tree
Message-Id: <20250512005013.C6DB2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: simplify free_page_is_bad by removing free_page_is_bad_report
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/page_alloc: simplify free_page_is_bad by removing free_page_is_bad_report
Date: Fri, 28 Mar 2025 09:20:31 +0800

Refactor free_page_is_bad() to call bad_page() directly, removing the
intermediate free_page_is_bad_report(). This reduces unnecessary
indirection, improving code clarity and maintainability without changing
functionality.

Link: https://lkml.kernel.org/r/20250328012031.1204993-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report
+++ a/mm/page_alloc.c
@@ -934,19 +934,13 @@ static const char *page_bad_reason(struc
 	return bad_reason;
 }
 
-static void free_page_is_bad_report(struct page *page)
-{
-	bad_page(page,
-		 page_bad_reason(page, PAGE_FLAGS_CHECK_AT_FREE));
-}
-
 static inline bool free_page_is_bad(struct page *page)
 {
 	if (likely(page_expected_state(page, PAGE_FLAGS_CHECK_AT_FREE)))
 		return false;
 
 	/* Something has gone sideways, find it */
-	free_page_is_bad_report(page);
+	bad_page(page, page_bad_reason(page, PAGE_FLAGS_CHECK_AT_FREE));
 	return true;
 }
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch
mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch
mm-io-mapping-precompute-remap-protection-flags-for-clarity.patch
mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder.patch
mm-numa-remove-unnecessary-local-variable-in-alloc_node_data.patch

