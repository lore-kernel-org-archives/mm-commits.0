Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B29A1AAE10;
	Tue, 13 Aug 2024 21:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723584764; cv=none; b=gmuf4XsqBybhpngJ1UnE5Y+kkBuonIolia0S4ZAwEH3j/pqvOxDHQRc/RN4eALf15TcDRs4RAAUb2emEO0MOSrYYh6Ay9Q33FRg9hfoHeSPmQB7dMoUepSYn4k73LqzW98AGkLy4Q+Qu3a53oAdta+vm0stjYK3W1NM1G5L2WkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723584764; c=relaxed/simple;
	bh=Eh1AfJGoCff66D+hMQ28lVVRYQb3I2KauSOTKfmmVgA=;
	h=Date:To:From:Subject:Message-Id; b=GmvVOxug5zWbrmq5ZgRoKVIr+SdUdf9Uh1KZcKDzA9MUmeY7Uu4XoeSjgpcveedZ5pITbDIiadP1Oug0+oT74etL3cj8S1sdCJR5W5PPKe65rdeUxtyYg5+q8WPPsBXvR+Bej3beesxsrIPP/FiASe9wgUXkfyz/PMyNBWMCb0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LltE6ePF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LltE6ePF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FACC4AF11;
	Tue, 13 Aug 2024 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723584763;
	bh=Eh1AfJGoCff66D+hMQ28lVVRYQb3I2KauSOTKfmmVgA=;
	h=Date:To:From:Subject:From;
	b=LltE6ePF23nNsRUKojsXZi/tT3HNva7Mu1K+3n4sbZVhkDzdTd9TFJRs1/vJtZ3pv
	 G/3c9KoqZ5/v8OPjqgxQEqceQP0+dBev3+AN4JAd6mkkd3NSWos0kuBAtgrf6u3LdT
	 9TmTITY6wsgdbcl1LafDdIC1tSTW+L0UvaDPnJZw=
Date: Tue, 13 Aug 2024 14:32:43 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,xemul@virtuozzo.com,stable@vger.kernel.org,hughd@google.com,david@redhat.com,aarcange@redhat.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-dont-bug_on-if-khugepaged-yanks-our-page-table.patch added to mm-hotfixes-unstable branch
Message-Id: <20240813213243.B9FACC4AF11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: don't BUG_ON() if khugepaged yanks our page table
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-dont-bug_on-if-khugepaged-yanks-our-page-table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-dont-bug_on-if-khugepaged-yanks-our-page-table.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jann Horn <jannh@google.com>
Subject: userfaultfd: don't BUG_ON() if khugepaged yanks our page table
Date: Tue, 13 Aug 2024 22:25:22 +0200

Since khugepaged was changed to allow retracting page tables in file
mappings without holding the mmap lock, these BUG_ON()s are wrong - get
rid of them.

We could also remove the preceding "if (unlikely(...))" block, but then we
could reach pte_offset_map_lock() with transhuge pages not just for file
mappings but also for anonymous mappings - which would probably be fine
but I think is not necessarily expected.

Link: https://lkml.kernel.org/r/20240813-uffd-thp-flip-fix-v2-2-5efa61078a41@google.com
Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-dont-bug_on-if-khugepaged-yanks-our-page-table
+++ a/mm/userfaultfd.c
@@ -807,9 +807,10 @@ retry:
 			err = -EFAULT;
 			break;
 		}
-
-		BUG_ON(pmd_none(*dst_pmd));
-		BUG_ON(pmd_trans_huge(*dst_pmd));
+		/*
+		 * For shmem mappings, khugepaged is allowed to remove page
+		 * tables under us; pte_offset_map_lock() will deal with that.
+		 */
 
 		err = mfill_atomic_pte(dst_pmd, dst_vma, dst_addr,
 				       src_addr, flags, &folio);
_

Patches currently in -mm which might be from jannh@google.com are

userfaultfd-fix-checks-for-huge-pmds.patch
userfaultfd-dont-bug_on-if-khugepaged-yanks-our-page-table.patch
mm-fix-harmless-type-confusion-in-lock_vma_under_rcu.patch

