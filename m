Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA76E1EA7EC;
	Wed, 25 Jun 2025 22:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892150; cv=none; b=RU1U3duUUTNhkibpT10YWWrGpEBk9IyWIIvqY2YQtIztNvW6DuqIblgtAIYc/pYFyySOjjbNUybbrHlAVAp1hmgd1Wg3ibpfLjDg/n2H1TLvedXvB9Ow+l7HVDQgEdd8e/Gs0ziZ3o1AE89+qLGlehXvxGO86HE+C+GleMkmVkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892150; c=relaxed/simple;
	bh=iAoMubQlNXYEWTUfhGgvHjnKP3GYwCzJcROpcPjzdrE=;
	h=Date:To:From:Subject:Message-Id; b=sZniYw676tLeYYV/1h3WUpNG3iGW2HXzqIZtLzrJlHpNbK6+9F8Jd/jkBO/tvmWy5rOOAPeb0mNR2x+qsMg+iEKX5P9v/IAkAQe/4j1TqCZRyuVzTDUkaKD+GZNlpHOE9m9on6WfZVf5IHvb+H5QAFtHx6utl2dWIbh7REWC9KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k+lqbq7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k+lqbq7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1D5C4CEEA;
	Wed, 25 Jun 2025 22:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892150;
	bh=iAoMubQlNXYEWTUfhGgvHjnKP3GYwCzJcROpcPjzdrE=;
	h=Date:To:From:Subject:From;
	b=k+lqbq7/OaVkpY429iLTktlZdVC0uyjQlToitQ9JCeXgJbfaoTA1qa2deecaANdPA
	 ysZ6sttUBY/9YyXoCTEFvwjZBzdJWVjW5DthvBXvrow7ub0B/+9hNbC48gOgcfOzIT
	 shV9TRZeYg7PAw6lThPK4vTTyU252pbeGozAyA8M=
Date: Wed, 25 Jun 2025 15:55:49 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-task_mmu-fix-page_is_pfnzero-detection-for-the-huge-zero-folio.patch removed from -mm tree
Message-Id: <20250625225550.2C1D5C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: fix PAGE_IS_PFNZERO detection for the huge zero folio
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-fix-page_is_pfnzero-detection-for-the-huge-zero-folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: fix PAGE_IS_PFNZERO detection for the huge zero folio
Date: Tue, 17 Jun 2025 16:35:32 +0200

is_zero_pfn() does not work for the huge zero folio. Fix it by using
is_huge_zero_pmd().

This can cause the PAGEMAP_SCAN ioctl against /proc/pid/pagemap to
present pages as PAGE_IS_PRESENT rather than as PAGE_IS_PFNZERO.

Found by code inspection.

Link: https://lkml.kernel.org/r/20250617143532.2375383-1-david@redhat.com
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-page_is_pfnzero-detection-for-the-huge-zero-folio
+++ a/fs/proc/task_mmu.c
@@ -2182,7 +2182,7 @@ static unsigned long pagemap_thp_categor
 				categories |= PAGE_IS_FILE;
 		}
 
-		if (is_zero_pfn(pmd_pfn(pmd)))
+		if (is_huge_zero_pmd(pmd))
 			categories |= PAGE_IS_PFNZERO;
 		if (pmd_soft_dirty(pmd))
 			categories |= PAGE_IS_SOFT_DIRTY;
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-remove-vm_bug_ons.patch
mm-gup-remove-vm_bug_ons-fix.patch
mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pmd.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud.patch

