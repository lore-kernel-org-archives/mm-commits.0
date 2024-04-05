Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590AB171675
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 18:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712343387; cv=none; b=ivFpks4uZck//TV3OJxqp/2Cs9SkBdkxcZyn1otJ8FCduPQvbHXm6A3InaHh0oxAEqUQm7WmSelTd+Bg+M7vM6kX9IKZbasW+XYMPQZK1KX4m+h85+nbnpZLK+BcKiy9nGXmkOFApPfVfBl2TOKSdLX0+kxAmTcESuM254F0fhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712343387; c=relaxed/simple;
	bh=hwIuda/qXYwWa4QWHQhsYV+4PYGUUehOtVJiTO73s9E=;
	h=Date:To:From:Subject:Message-Id; b=ffpluTxj1ul0w+zXzm+e/fI5/0VIkzprhy9ILFb5c/dyAzK5Shaq0x0gE059RThB1vKE1A16BeEUYngqxWyG/TVK8eIY6Qi3Xtko+LS4g+aVChcCNj0KGrFC2hgkUoVUnWMrMPjaXsaeL66GtJVq7SX7MFcEVjxaAOO1yoD5cQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L4V1RWuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L4V1RWuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4E3C433F1;
	Fri,  5 Apr 2024 18:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712343386;
	bh=hwIuda/qXYwWa4QWHQhsYV+4PYGUUehOtVJiTO73s9E=;
	h=Date:To:From:Subject:From;
	b=L4V1RWuJa4zlggyMmRobKQ+DjDfgJjBjgsEpCsM7SbeGD69TBvThOJeZ7TOESyc5G
	 DBYRprGDeCPA6Aygc74be9LYqKDBszfuzrnGhUbkV3rFKrQ/qJ1HteWgiGovkR676i
	 Iv1KFvIBv4KH71RWWvIeTaGFdQBnrx6M927aGG1M=
Date: Fri, 05 Apr 2024 11:56:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,mgorman@techsingularity.net,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch added to mm-unstable branch
Message-Id: <20240405185626.CB4E3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: set pageblock_order to HPAGE_PMD_ORDER in case with !CONFIG_HUGETLB_PAGE but THP enabled
has been added to the -mm mm-unstable branch.  Its filename is
     mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: set pageblock_order to HPAGE_PMD_ORDER in case with !CONFIG_HUGETLB_PAGE but THP enabled
Date: Fri, 5 Apr 2024 20:24:16 +0800

As Vlastimil suggested in previous discussion[1], it doesn't make sense to
set pageblock_order as MAX_PAGE_ORDER when hugetlbfs is not enabled and
THP is enabled.  Instead, it should be set to HPAGE_PMD_ORDER.

[1] https://lore.kernel.org/all/76457ec5-d789-449b-b8ca-dcb6ceb12445@suse.cz/
Link: https://lkml.kernel.org/r/3d57d253070035bdc0f6d6e5681ce1ed0e1934f7.1712286863.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/include/linux/pageblock-flags.h~mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled
+++ a/include/linux/pageblock-flags.h
@@ -28,7 +28,7 @@ enum pageblock_bits {
 	NR_PAGEBLOCK_BITS
 };
 
-#ifdef CONFIG_HUGETLB_PAGE
+#if defined(CONFIG_HUGETLB_PAGE)
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
@@ -45,7 +45,11 @@ extern unsigned int pageblock_order;
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
-#else /* CONFIG_HUGETLB_PAGE */
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE)
+
+#define pageblock_order		min_t(unsigned int, HPAGE_PMD_ORDER, MAX_PAGE_ORDER)
+
+#else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /* If huge pages are not used, group by MAX_ORDER_NR_PAGES */
 #define pageblock_order		MAX_PAGE_ORDER
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch
mm-support-multi-size-thp-numa-balancing-v3.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch
mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch
mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch

