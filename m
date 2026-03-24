Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7DE36215C
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388578; cv=none; b=Y4l+kZZ8/9sln8Xw2TP3cNEOHTKuZ0iVV4W88faL1fBBRkPfhsIHvjxZ4fPJDR4iiMlbhalhrlt3ZIAN0DrB94U5mLj+C+y8OiMLKmPzMO66yZE7wBs+F/fZUpltOqfIcGJN6ghNZnYqEEVKT3TubgQS9jVfi7l/D3voGm1+qeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388578; c=relaxed/simple;
	bh=SLyCdKxUkwAixJ8B6ShJTTgKJGjHjZRN4pJef8HZ+jU=;
	h=Date:To:From:Subject:Message-Id; b=oFCuR3ujgFkycXuSy2PdopjjZJ/kAYTQ6lAhsPpVSI3bG5fG/MjHxRpHrpPRCDKSE0BqSwRQAn8FuXYerjEEt1awIS64cAIHjOt+1yGyreog56yB+UWvofsK+kWvpAdIJd5vF7UQ0ATTJJAZx3KprUWmeBna7FMTOOGp7/fjTwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BHVK+yVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BHVK+yVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04799C2BC9E;
	Tue, 24 Mar 2026 21:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388578;
	bh=SLyCdKxUkwAixJ8B6ShJTTgKJGjHjZRN4pJef8HZ+jU=;
	h=Date:To:From:Subject:From;
	b=BHVK+yVuYCluMJ+xa+3nvIJYuyXHKOl1C+QGWVtmZqYD/KICn0p8rDyrfZzGoC3qq
	 YT2t8pKB6Jf9NevzxDqpi3lUnbIY5tWwhorN+DA7vz1B6h+Xbf83IFki38eDA9LzI7
	 VffEeTg6zpdiOZpjA15HsXU6F0JeuujHSu/Nnkds=
Date: Tue, 24 Mar 2026 14:42:57 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,qin.yuA@h3c.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_idlec-remove-redundant-mmu-notifier-in-aging-code.patch removed from -mm tree
Message-Id: <20260324214258.04799C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_idle.c: remove redundant mmu notifier in aging code
has been removed from the -mm tree.  Its filename was
     mm-page_idlec-remove-redundant-mmu-notifier-in-aging-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: qinyu <qin.yuA@h3c.com>
Subject: mm/page_idle.c: remove redundant mmu notifier in aging code
Date: Tue, 3 Feb 2026 18:26:49 +0800

Now we have mmu_notifier_clear_young immediately follows
pmdp_clear_young_notify which internally calls mmu_notifier_clear_young,
this is redundant.  change it with non-notify variant and keep consistent
with ptep aging code.

Link: https://lkml.kernel.org/r/20260203102649.2486836-1-qin.yuA@h3c.com
Signed-off-by: qinyu <qin.yuA@h3c.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_idle.c~mm-page_idlec-remove-redundant-mmu-notifier-in-aging-code
+++ a/mm/page_idle.c
@@ -74,7 +74,7 @@ static bool page_idle_clear_pte_refs_one
 			pmd_t pmdval = pmdp_get(pvmw.pmd);
 
 			if (likely(pmd_present(pmdval)))
-				referenced |= pmdp_clear_young_notify(vma, addr, pvmw.pmd);
+				referenced |= pmdp_test_and_clear_young(vma, addr, pvmw.pmd);
 			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
 		} else {
 			/* unexpected pmd-mapped page? */
_

Patches currently in -mm which might be from qin.yuA@h3c.com are


