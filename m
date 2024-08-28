Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8792F18638
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724807870; cv=none; b=QZM2uvc3wCJzS/mDmaHF9sYXq5g2ozkGGTGktFKceHVc9LLs5FDs/LY6IUnt9KI99GRlctGDie6uVCqWV0ykMAZVwBZzGYrdm9Av5VlOb4eMUio1TfJD5rJBwM+9BdNZ0/ya5w6UDXHawSr2R4ieusLzigtuUWgLNfoItkmTsPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724807870; c=relaxed/simple;
	bh=UJpv+I8bOeqRTiDvrBL0HgGYYgDjSSJGx2M0hOg+LMw=;
	h=Date:To:From:Subject:Message-Id; b=HlPYqll0Z4n7DgqwZH2uyuLYnWG5ZM2Xq/ar0MUEVtH7xWrqqnyvLf6LaLWy9a6dKcQVYD44PnIi8I912pPoaZGk1F4gJ/+FlRZW4MVXTWaInisA/X3tcyOLxX/jzV+fVhsWyDbbHhGJD40zHhW3BQfgCYDXindxryovTd0RUHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BTahrm1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BTahrm1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED52BC32782;
	Wed, 28 Aug 2024 01:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724807870;
	bh=UJpv+I8bOeqRTiDvrBL0HgGYYgDjSSJGx2M0hOg+LMw=;
	h=Date:To:From:Subject:From;
	b=BTahrm1ucQ3IMROlL7HLcq9Y57utpBhDI6jSU2Cw5QPFkoG6wJ06Dsm4SvZHP4DN9
	 ToD4+AM9Ae/5On3NT4Od10NPBpGXEKVm3zOS1JCKQGZDPCQ5UovesBdvJIvJRLLDfU
	 ZsYP6OHff7jOMoS1Sa3uS9uBdzf+NUS8dzODm4Ac=
Date: Tue, 27 Aug 2024 18:17:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-convert-to-folio_isolate_movable-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20240828011749.ED52BC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-migrate-convert-to-folio_isolate_movable-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-convert-to-folio_isolate_movable-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-convert-to-folio_isolate_movable-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-migrate-convert-to-folio_isolate_movable-checkpatch-fixes
Date: Tue Aug 27 06:17:16 PM PDT 2024

WARNING: suspect code indent for conditional statements (8, 24)
#24: FILE: mm/migrate.c:199:
 	else
+			isolated = folio_isolate_movable(folio,

total: 0 errors, 1 warnings, 10 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-migrate-convert-to-folio_isolate_movable.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-convert-to-folio_isolate_movable-checkpatch-fixes
+++ a/mm/migrate.c
@@ -197,8 +197,7 @@ bool isolate_folio_to_list(struct folio
 	if (lru)
 		isolated = folio_isolate_lru(folio);
 	else
-			isolated = folio_isolate_movable(folio,
-							 ISOLATE_UNEVICTABLE);
+		isolated = folio_isolate_movable(folio, ISOLATE_UNEVICTABLE);
 
 	if (!isolated)
 		return false;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-migrate-convert-to-folio_isolate_movable-checkpatch-fixes.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

