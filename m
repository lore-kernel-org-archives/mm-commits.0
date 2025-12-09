Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1D02874E1
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 18:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765304053; cv=none; b=C3rAtCkxXd5xOjj7yH4Y0xDyipO1vbcJ4GqiVAFCMueZXlAu1gvST7ohS3waEKGVtPpfg0QzDpRPZOJ6bV5J0t/wImpAKal/0rh0mvR5B8uFxtJlzlcNL0q3H4ACjplgBNcBWCG1ZKZF9kYnHC9r1bLC+MEbtyxXfYQN82SCY4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765304053; c=relaxed/simple;
	bh=pzDIBPjJg/3mhaAJMnrsSh57fmNXTpPOx1d4W/LOpWU=;
	h=Date:To:From:Subject:Message-Id; b=gnptK61eiyCXRoipaPBbbth6XT6N5Vlq/Y5aoTY+RqtzWbuTxSqn4P3421RrY7yt8qsNg3vAgRgf0S8MTuBHZUeB2J/n1p41ql0nGZg2KBb8OCTfBVvxCo9e+KevxjQdkB9rbSg1QXpdh1hdAAqzmjHoykxnyKd+exopPFYmoJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U4UuEKN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U4UuEKN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2402CC4CEF5;
	Tue,  9 Dec 2025 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765304052;
	bh=pzDIBPjJg/3mhaAJMnrsSh57fmNXTpPOx1d4W/LOpWU=;
	h=Date:To:From:Subject:From;
	b=U4UuEKN8fvWaZFRosm1+mBf/EgZP3VI4pk1BFhcEexaJ696BcAuHzfNqooDu5TmyO
	 2Y7RFH+MYmG+Bt15N4ovoLzx1Pu2QCAt1ACY4LsWq+uDbyw4WPjT/JRwQ3Gs4i6nG4
	 mL00XIoBoDFosHlIuKKpxpBQp2hbmGR4znBMcsPw=
Date: Tue, 09 Dec 2025 10:14:11 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-fix-missing-pte_unmap_unlock-in-damos_va_migrate_pmd_entry.patch added to mm-unstable branch
Message-Id: <20251209181412.2402CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: fix missing pte_unmap_unlock in damos_va_migrate_pmd_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-fix-missing-pte_unmap_unlock-in-damos_va_migrate_pmd_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-fix-missing-pte_unmap_unlock-in-damos_va_migrate_pmd_entry.patch

This patch will later appear in the mm-unstable branch at
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
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm/damon/vaddr: fix missing pte_unmap_unlock in damos_va_migrate_pmd_entry()
Date: Wed, 10 Dec 2025 00:10:34 +0900

If the PTE page table lock is acquired by pte_offset_map_lock(), the lock
must be released via pte_unmap_unlock().

However, in damos_va_migrate_pmd_entry(), if damos_va_filter_out() returns
true, it immediately returns without releasing the lock.

This fixes the issue by not stopping page table traversal when
damos_va_filter_out() returns true and ensuring that the lock is released.

Link: https://lkml.kernel.org/r/20251209151034.77221-1-akinobu.mita@gmail.com
Fixes: 09efc56a3b1c ("mm/damon/vaddr: consistently use only pmd_entry for damos_migrate")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-fix-missing-pte_unmap_unlock-in-damos_va_migrate_pmd_entry
+++ a/mm/damon/vaddr.c
@@ -743,7 +743,7 @@ huge_out:
 		if (!folio)
 			continue;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
-			return 0;
+			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
 		nr = folio_nr_pages(folio);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

mm-damon-vaddr-fix-missing-pte_unmap_unlock-in-damos_va_migrate_pmd_entry.patch

