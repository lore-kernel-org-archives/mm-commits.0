Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C56222565
	for <mm-commits@vger.kernel.org>; Mon, 29 Sep 2025 21:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759183050; cv=none; b=Akp3fTQcmpDqY+AW5Kmace4of3iFeJJ58nhT4EnpqoziCL9OQSTQgyoKZsHD2+jrwwsVdaIVJMqZ51B4a/f0tCsmYk194RdnXvk0oLMAq1/CeG6bhOXgpl4ZxCeUfNQ5F5QSOQ4pRR5huh8KLUKPduyoB9ubYtZDJrw/a3mGWGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759183050; c=relaxed/simple;
	bh=xidEQiz7Cg/Zy5cM5Q/Y04uBAwnap5xEw34kl/nsi54=;
	h=Date:To:From:Subject:Message-Id; b=sT136Yf/38Qx0dxcQXdRV8iacXAHnYC8tVKujoR1E/Fmbobp3co+TSq+esd8NDQjIizwldZt9J5AOxV39JJKWjOI13vZkPmooYVgkMrvRg4FrjEiZM3tKFuu+bK5xTQ+HWViB701b4kUT/dsQyZF+gYgLKzbLQxbpaHfgJbnDUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aKgRCbzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aKgRCbzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31517C4CEF4;
	Mon, 29 Sep 2025 21:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759183050;
	bh=xidEQiz7Cg/Zy5cM5Q/Y04uBAwnap5xEw34kl/nsi54=;
	h=Date:To:From:Subject:From;
	b=aKgRCbzrmRasJyJzldjDcb0QnlJvvMejBZxgG4wbRzeUw4jzVy76UhrQBme5FWWdO
	 V0d5fNCckPJOA1WOQ99ZL5OgLFEAWzXF9r5Q6PUUnwWcb4k5Pr+tQPRCS0ejUKS9Ju
	 F8kZeFu9e5504aYqdtml2tlW162nzYU5tx7/N3cM=
Date: Mon, 29 Sep 2025 14:57:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-drop-follow_devmap_pmd-default-stub.patch added to mm-new branch
Message-Id: <20250929215730.31517C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/thp: drop follow_devmap_pmd() default stub
has been added to the -mm mm-new branch.  Its filename is
     mm-thp-drop-follow_devmap_pmd-default-stub.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-drop-follow_devmap_pmd-default-stub.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/thp: drop follow_devmap_pmd() default stub
Date: Mon, 29 Sep 2025 11:46:43 +0100

follow_devmap_pmd() has already been dropped by the commit fd2825b0760a
("mm/gup: remove pXX_devmap usage from get_user_pages()"). The fallback
stub in the header which is now redundant, can be dropped off as well.

Link: https://lkml.kernel.org/r/20250929104643.1100421-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/huge_mm.h~mm-thp-drop-follow_devmap_pmd-default-stub
+++ a/include/linux/huge_mm.h
@@ -691,12 +691,6 @@ static inline void mm_put_huge_zero_foli
 	return;
 }
 
-static inline struct page *follow_devmap_pmd(struct vm_area_struct *vma,
-	unsigned long addr, pmd_t *pmd, int flags, struct dev_pagemap **pgmap)
-{
-	return NULL;
-}
-
 static inline bool thp_migration_supported(void)
 {
 	return false;
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

documentation-mm-drop-pxx_mkdevmap-descriptions-from-page-table-helpers.patch
mm-thp-drop-follow_devmap_pmd-default-stub.patch

