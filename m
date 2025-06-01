Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF21E156F28
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756850; cv=none; b=PXI7EczH9L3rKizCzEhvp+BtG4ZP6Rs870B9zBjNbAeT5AbAczDFz6xwmHKEWjspJAjzsLRnTPk090k/xOdYXPxwXAtJzJ89QEkJOPP1qcUAPNRIcYixtCBx9oNrbk5VUO0S9Si16LRdJ9LIieDhlh5j5XsRYK2nGH4mjVXvOuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756850; c=relaxed/simple;
	bh=/2+/al5ASGr9HNekVQGPjHEm7iAz4oYUX63WO4XjRqQ=;
	h=Date:To:From:Subject:Message-Id; b=fPecMwQqjNwKBlJyFdhmfXoeIPRRePPzBVzyLMwW43tqgMDlske4eQAvgR6IZBjAEzgfudCU7IIzpC+gX8I8oZm2fjOwfe4xGMNTZOXpa+lQEF71CsWwL0jkH5R62jN7DoOQK39jKSh3PdSW4XJinZEG7stBS7godqSe2fGTLZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UDEoVLtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UDEoVLtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21CCC4CEED;
	Sun,  1 Jun 2025 05:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756849;
	bh=/2+/al5ASGr9HNekVQGPjHEm7iAz4oYUX63WO4XjRqQ=;
	h=Date:To:From:Subject:From;
	b=UDEoVLtQqK5HCRAQw+WF5rwWRFPZhig2HjVNT74Zzg7L8sg4Re/2hv+bPLhWdx54I
	 lgBKQgTEaFWHd/XIcyE2ihVdAOcHBmd1S0JYHB1VpG5hJag9RaoFm9BjktxwNwzr54
	 H7NsCj6Bcq7lp81dJb+5qh5YXT7izhIXjBT7V4O8=
Date: Sat, 31 May 2025 22:47:29 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,jgg@nvidia.com,apopple@nvidia.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmu_notifiers-remove-leftover-stub-macros.patch removed from -mm tree
Message-Id: <20250601054729.B21CCC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mmu_notifiers: remove leftover stub macros
has been removed from the -mm tree.  Its filename was
     mmu_notifiers-remove-leftover-stub-macros.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
mm-hugetlb-unshare-page-tables-during-vma-split-not-before-v2.patch
mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch

