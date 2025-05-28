Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605826AD3
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 00:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748392364; cv=none; b=GOvNPYpEp3zjBDBFGnm4Eu5ZTgn1FGMfJ2XT8PFxmiGQyKbrEIO5ShqE/COsRCdzD0Icq0FakgUAGLoXCFcyZ5PXMNmWiyoSVUkSFPIHZWXuxnhQ8RxfgyMOmow0xS4gFGYnRvrSg9rISWaCbYFjP2MZxk3PmNL31MLCd2j+Szw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748392364; c=relaxed/simple;
	bh=7WTDD7VMmmCurKteuX2E6qCVWPH88yxkN3564kHi9sU=;
	h=Date:To:From:Subject:Message-Id; b=Q6wGt31CMD925s62/Pe6SIAtZ2jT+jrgO/YcDuXXw8HobC49rxIAIUS2krzat+rHsw4lkzms6rPJjayJJ0o9mLi0s24JiaszwZrtJn1zILCLOU20as/IJw1S5VghRZObzVSGGhyoJS/pYuWiP5N40CU76aSAQd3adE8Lms5eIHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xPnDxN8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xPnDxN8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B183C4CEE9;
	Wed, 28 May 2025 00:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748392363;
	bh=7WTDD7VMmmCurKteuX2E6qCVWPH88yxkN3564kHi9sU=;
	h=Date:To:From:Subject:From;
	b=xPnDxN8NiflOIkC867KEnMQ2SthreizRo8UPgfzszegyvAxbVu4J+vfjnwExVzwdk
	 cqSLv4mFsMeZjKQ9Zn1riqkLDt0HDAeq1F6xz7LKG60bn1fpU96EnnErwJBS12qYM5
	 2Pwh17NGGraIvwotKAoeB5/JXIcs4QmyNrADsFKk=
Date: Tue, 27 May 2025 17:32:42 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,jgg@nvidia.com,apopple@nvidia.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmu_notifiers-remove-leftover-stub-macros.patch added to mm-unstable branch
Message-Id: <20250528003243.7B183C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mmu_notifiers: remove leftover stub macros
has been added to the -mm mm-unstable branch.  Its filename is
     mmu_notifiers-remove-leftover-stub-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmu_notifiers-remove-leftover-stub-macros.patch

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
From: Jann Horn <jannh@google.com>
Subject: mmu_notifiers: remove leftover stub macros
Date: Fri, 23 May 2025 00:30:17 +0200

Commit ec8832d007cb ("mmu_notifiers: don't invalidate secondary TLBs as
part of mmu_notifier_invalidate_range_end()") removed the main definitions
of {ptep,pmdp_huge,pudp_huge}_clear_flush_notify; just their
!CONFIG_MMU_NOTIFIER stubs are left behind, remove them.

Link: https://lkml.kernel.org/r/20250523-mmu-notifier-cleanup-unused-v1-1-cc1f47ebec33@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/mmu_notifier.h~mmu_notifiers-remove-leftover-stub-macros
+++ a/include/linux/mmu_notifier.h
@@ -654,9 +654,6 @@ static inline void mmu_notifier_subscrip
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
 #define ptep_clear_young_notify ptep_test_and_clear_young
 #define pmdp_clear_young_notify pmdp_test_and_clear_young
-#define	ptep_clear_flush_notify ptep_clear_flush
-#define pmdp_huge_clear_flush_notify pmdp_huge_clear_flush
-#define pudp_huge_clear_flush_notify pudp_huge_clear_flush
 
 static inline void mmu_notifier_synchronize(void)
 {
_

Patches currently in -mm which might be from jannh@google.com are

mm-hugetlb-unshare-page-tables-during-vma-split-not-before.patch
mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch
mmu_notifiers-remove-leftover-stub-macros.patch

