Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9D614A8D;
	Mon, 29 Apr 2024 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714407052; cv=none; b=JLrMxbFZmOMYsQVQdmkDTxzU9LvCeTGFioQBjrs4MDceDAiiM2rB6zUriXb1/0O3BDlPKtGh8lRMs6la/JFOM0RxryriZs0czE7MQgmeO5g589pptkLcvWrCIanpx6/3qDRaxo9P+fcFNWvvTOPZWp9EbIF+20i7X3WygfollHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714407052; c=relaxed/simple;
	bh=+49JafRNLR0YbNyyfR5+QT7Xh40cqEpM8mjCJBjvD+c=;
	h=Date:To:From:Subject:Message-Id; b=n1/adTb2uB9y48sIQS9NGFjOi4modsfY27AVc737mcKhfD6tSes/HdAKeCZ3w7mwUXVAYbieIdNjw5wsB2ssQ7OS9TCa8046TBSMNVMjQyBh4M7ckYqnKXEWvjVCNKgDYDOeQT4PJpl8EbRKV+HSr3CdX+XupvzOEw6jJkvM/yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lNFDt+zG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lNFDt+zG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34802C113CD;
	Mon, 29 Apr 2024 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714407051;
	bh=+49JafRNLR0YbNyyfR5+QT7Xh40cqEpM8mjCJBjvD+c=;
	h=Date:To:From:Subject:From;
	b=lNFDt+zGx+62tLZXtk7O7y5GJcXuFUIRXnKdKnH2iCeOvQ2I5CErgp26xB2tM4cUS
	 oGYV6vnBG6P+xQYEVjvvIGFf59NiSSiysCEzV9BbmqqAbW0mNOuO3bOrhnpy6/nX5D
	 9m5V6IYVbFa47fc3KCsCtzV8q9pse3ZE0PT54Ndk=
Date: Mon, 29 Apr 2024 09:10:49 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,peterx@redhat.com,david@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-fix-loss-of-young-dirty-bits-during-pagemap-scan.patch added to mm-hotfixes-unstable branch
Message-Id: <20240429161051.34802C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: fix loss of young/dirty bits during pagemap scan
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-fix-loss-of-young-dirty-bits-during-pagemap-scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-fix-loss-of-young-dirty-bits-during-pagemap-scan.patch

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

fs-proc-task_mmu-fix-loss-of-young-dirty-bits-during-pagemap-scan.patch
fs-proc-task_mmu-fix-uffd-wp-confusion-in-pagemap_scan_pmd_entry.patch
selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch
mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast.patch

