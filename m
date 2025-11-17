Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1CF1E1E16
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343075; cv=none; b=rAo5vES5FaxQfciWpVodXuCqE0uZoLqTKu8yA23Hi/0FPqDay6W75o3xUq5TNf5EGESkmVK2MEz54lqjtbH2Sl9gg4ktosSdad6ZsWf/MzNfk1jUR4IpacuSJC9A0Ql6MG1kLvxybMpHVc5xCcZa6nG1qaVsXXn8AoaE5f8ErWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343075; c=relaxed/simple;
	bh=oasi/U51RYm6fhp1jP82RFHwra9k9iQr766PCH7jS1E=;
	h=Date:To:From:Subject:Message-Id; b=cf019LbpAcmdDAtLfbp11a5Y4J2MZIR+bIOWg19MjXuamVjX232A+kRG88SnOCZKc4/MaTZzOj6P+m39VFnFzhU5AE1U/84KqlV0lZwMRAy6FHLqLQi8AgAqBUpjlG5KflZ98Kzhz/beE/cEo3UPS0rfI8x+RVWdM7MOe3NW6N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xivA+E8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xivA+E8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E548DC19421;
	Mon, 17 Nov 2025 01:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343075;
	bh=oasi/U51RYm6fhp1jP82RFHwra9k9iQr766PCH7jS1E=;
	h=Date:To:From:Subject:From;
	b=xivA+E8Zg+uxd/pDPlUJxZNXF1iFWkkPxMURuNi6xcWXkh46MSTTUx2LHOnTHXKhu
	 wwlOadusv9TKwVFbc8qjKV665u+5QzWQmoR68FX5m9hWgTMVElhQAT1WTwzVMBj7iN
	 2wXXKkBmCEa0Fnttf83E2CChFBxN3mW813TBXky8=
Date: Sun, 16 Nov 2025 17:31:13 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,david@redhat.com,apopple@nvidia.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-drop-follow_devmap_pmd-default-stub.patch removed from -mm tree
Message-Id: <20251117013114.E548DC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/thp: drop follow_devmap_pmd() default stub
has been removed from the -mm tree.  Its filename was
     mm-thp-drop-follow_devmap_pmd-default-stub.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/thp: drop follow_devmap_pmd() default stub
Date: Mon, 29 Sep 2025 11:46:43 +0100

follow_devmap_pmd() has already been dropped by the commit fd2825b0760a
("mm/gup: remove pXX_devmap usage from get_user_pages()").  The fallback
stub in the header which is now redundant, can be dropped off as well.

Link: https://lkml.kernel.org/r/20250929104643.1100421-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/huge_mm.h~mm-thp-drop-follow_devmap_pmd-default-stub
+++ a/include/linux/huge_mm.h
@@ -682,12 +682,6 @@ static inline void mm_put_huge_zero_foli
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


