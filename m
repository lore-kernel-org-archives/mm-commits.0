Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8622378D6B
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388661; cv=none; b=FC1jC5QnEPYCW8G9WFBYrg6aC7Jojr/1oAqRsSWXvsaPRijEzndK2HSqQRBZ+q6AJ1AR0qnXWx/Tl/JKnBx7B5l0NFO+4gd0oeVl/4Ai+E8DQQU91f7JpLzJFqg+8Xjru90nrw1yNKPsFLQOp79prb68Ugq62NlEsVkz+Y9WTLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388661; c=relaxed/simple;
	bh=KewBKcBYPvfH2xnYZqj0+7LrBnnI8BQXwtJS1APSgKY=;
	h=Date:To:From:Subject:Message-Id; b=j9WrcYHREGELb/O0GBP9GJEPXd02lCh9acPOUO7nvYF6dIHFKDHhjqpDehSgHYKkwdgvVfoNUseaJfC4h5Obd9MwTj43Q6GNFdmA87SO5bH5ybmn/tNUt5uE8tn+ioy72NkuOAKiLnrVYUMXx5NyPYV3RG69R3Q0YVBV4ccQQ6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fz3voszX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fz3voszX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03BEC19424;
	Tue, 24 Mar 2026 21:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388661;
	bh=KewBKcBYPvfH2xnYZqj0+7LrBnnI8BQXwtJS1APSgKY=;
	h=Date:To:From:Subject:From;
	b=Fz3voszXy77ZTkyuCOET0nEBEEMvNkmrpOTeIhkEs7uXLKlkP97UI8fgJvtG/9V/V
	 7KA0ZZPPptwD72PYlWU1iYdgr40GxDX9E0paAhN18wa4u7+FmmYR7ZnoA6QlfR2wsm
	 xUdrX/fWHUeSLKmUoKxFRnevwbPtXht1huGr+unw=
Date: Tue, 24 Mar 2026 14:44:21 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,david@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-replace-read_once-in-pud_trans_unstable.patch removed from -mm tree
Message-Id: <20260324214421.B03BEC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: replace READ_ONCE() in pud_trans_unstable()
has been removed from the -mm tree.  Its filename was
     mm-replace-read_once-in-pud_trans_unstable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: replace READ_ONCE() in pud_trans_unstable()
Date: Fri, 27 Feb 2026 04:03:00 +0000

Replace READ_ONCE() with the existing standard page table accessor for PUD
aka pudp_get() in pud_trans_unstable().  This does not create any
functional change for platforms that do not override pudp_get(), which
still defaults to READ_ONCE().

Link: https://lkml.kernel.org/r/20260227040300.2091901-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pgtable.h~mm-replace-read_once-in-pud_trans_unstable
+++ a/include/linux/pgtable.h
@@ -2004,7 +2004,7 @@ static inline int pud_trans_unstable(pud
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	pud_t pudval = READ_ONCE(*pud);
+	pud_t pudval = pudp_get(pud);
 
 	if (pud_none(pudval) || pud_trans_huge(pudval))
 		return 1;
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


