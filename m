Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EC45250;
	Mon,  6 May 2024 00:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955331; cv=none; b=oj/z7XmIRuzpAh3HjZKMPLbdVlodIYEe+5ZG+rZnfrWyyAvUEm44DOcDB+fmCmfaP5FaKfJ5Y+reF1cXEJjo0P+bLJ+Ez58YSSnCulhsX/7Ufyu2GPuQsFFv/sLG+sbpApxP6o/Ro+DR2Yq5MkOJlMlocttDt6E3J6uMwYFb5u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955331; c=relaxed/simple;
	bh=z4D3EWwSw0nb9bCGZiCBKNDVSTNeZ5mzAhFlrAvOJYs=;
	h=Date:To:From:Subject:Message-Id; b=Vl28pEMWzcO2Ymnrv6aCnUOHBa9s9ipcr/Oq4rkbAlzvi4pZaQBaLp15X9oIMxbpLsDtGFvjrmD4AiP6Lec1mz8X5opBcGcKFr8etvh33CNQ5I1V0TDBFodveeYMSllubpR8JbI6EH0LP8cI0Ww8B9VHrVxoBY0QY5QtTMb4pCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/rNehg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/rNehg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925E9C113CC;
	Mon,  6 May 2024 00:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955331;
	bh=z4D3EWwSw0nb9bCGZiCBKNDVSTNeZ5mzAhFlrAvOJYs=;
	h=Date:To:From:Subject:From;
	b=a/rNehg4HXgCSiGqxJg6mkLvEdG4D2Va9NLMGNUE77TawyVr71aeacSjWOOUZ29aJ
	 99ieMJ3pBFgYqDSSjWcfKtSsHbq8YFEUoixZufim2ZvPc/oeXRfGx92qQHsK4fAuXZ
	 3DEyeMFFoFJ4HiuTsIxqJB2Nl8b+FXZ45IAeAHpA=
Date: Sun, 05 May 2024 17:28:51 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,peterx@redhat.com,david@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-task_mmu-fix-loss-of-young-dirty-bits-during-pagemap-scan.patch removed from -mm tree
Message-Id: <20240506002851.925E9C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: fix loss of young/dirty bits during pagemap scan
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-fix-loss-of-young-dirty-bits-during-pagemap-scan.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: fs/proc/task_mmu: fix loss of young/dirty bits during pagemap scan
Date: Mon, 29 Apr 2024 12:40:17 +0100

make_uffd_wp_pte() was previously doing:

  pte = ptep_get(ptep);
  ptep_modify_prot_start(ptep);
  pte = pte_mkuffd_wp(pte);
  ptep_modify_prot_commit(ptep, pte);

But if another thread accessed or dirtied the pte between the first 2
calls, this could lead to loss of that information.  Since
ptep_modify_prot_start() gets and clears atomically, the following is the
correct pattern and prevents any possible race.  Any access after the
first call would see an invalid pte and cause a fault:

  pte = ptep_modify_prot_start(ptep);
  pte = pte_mkuffd_wp(pte);
  ptep_modify_prot_commit(ptep, pte);

Link: https://lkml.kernel.org/r/20240429114017.182570-1-ryan.roberts@arm.com
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-loss-of-young-dirty-bits-during-pagemap-scan
+++ a/fs/proc/task_mmu.c
@@ -1825,7 +1825,7 @@ static void make_uffd_wp_pte(struct vm_a
 		pte_t old_pte;
 
 		old_pte = ptep_modify_prot_start(vma, addr, pte);
-		ptent = pte_mkuffd_wp(ptent);
+		ptent = pte_mkuffd_wp(old_pte);
 		ptep_modify_prot_commit(vma, addr, pte, old_pte, ptent);
 	} else if (is_swap_pte(ptent)) {
 		ptent = pte_swp_mkuffd_wp(ptent);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch
mm-debug_vm_pgtable-test-pmd_leaf-behavior-with-pmd_mkinvalid.patch
mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast.patch

