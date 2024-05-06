Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4C33B79F
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957173; cv=none; b=gwMjSCEHYaZXCxNXzK6mw4IkQzYA1MCz6kgQJoK529o5wVbxl1VrXM80V6vnFDOJ8yxLNrC32e8HymDMnlB3j8eRM2C8dUnM+XEaC/3bF0PrBoe6PEwUAvDZ4TDDV82lrmC+fgpmgmxtYd/jkGkvgkcVn2QxelfMLVCiqBr5qzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957173; c=relaxed/simple;
	bh=BaqLxlZe4linQRLdBPd31kHNCQFjKFpyKGFQJAqA6RE=;
	h=Date:To:From:Subject:Message-Id; b=dggdx72Z3nNFgWRHvPYve81u9NTo7tWLfbQP1m33tKpWkE7Hwg8SoWMNUIwT/vl5ogxH2nmfsYUwyKZVZaxROIYIN5MLhqgycKNU2qw8WBOUke9GQWwlQD/5c9h8IQYK27F3cymam3/+j+WMGBGnHy2YLdNyHVKB6CBGdiGnTko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vXhAMY4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vXhAMY4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11859C116B1;
	Mon,  6 May 2024 00:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957173;
	bh=BaqLxlZe4linQRLdBPd31kHNCQFjKFpyKGFQJAqA6RE=;
	h=Date:To:From:Subject:From;
	b=vXhAMY4Nk9tE8nCwcPuwphZLXa67/DLN9CmvTcp1RYM4TqwH4zjWjt1kqSG1HdQR3
	 RP0SriSkFWO8mdj1nGoBDknTRTYavYT4NhGP9tsiBTn6Rg+hZmA0/hB1ujgVZRjZE6
	 4IkhH99Uunrd4wO/6IvHMqucgmDR0ylYsy9/kZVQ=
Date: Sun, 05 May 2024 17:59:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] thp-remove-hpage_pmd_order-minimum-assertion.patch removed from -mm tree
Message-Id: <20240506005933.11859C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: thp: remove HPAGE_PMD_ORDER minimum assertion
has been removed from the -mm tree.  Its filename was
     thp-remove-hpage_pmd_order-minimum-assertion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: thp: remove HPAGE_PMD_ORDER minimum assertion
Date: Mon, 29 Apr 2024 20:00:55 +0100

We now handle order-1 folios correctly, so we don't need this assertion
any more.

Link: https://lkml.kernel.org/r/20240429190114.3126789-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/huge_memory.c~thp-remove-hpage_pmd_order-minimum-assertion
+++ a/mm/huge_memory.c
@@ -740,11 +740,6 @@ static int __init hugepage_init(void)
 	 * hugepages can't be allocated by the buddy allocator
 	 */
 	MAYBE_BUILD_BUG_ON(HPAGE_PMD_ORDER > MAX_PAGE_ORDER);
-	/*
-	 * we use page->mapping and page->index in second tail page
-	 * as list_head: assuming THP order >= 2
-	 */
-	MAYBE_BUILD_BUG_ON(HPAGE_PMD_ORDER < 2);
 
 	err = hugepage_init_sysfs(&hugepage_kobj);
 	if (err)
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

