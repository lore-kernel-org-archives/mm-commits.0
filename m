Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A265C1D555
	for <mm-commits@vger.kernel.org>; Sat, 22 Nov 2025 22:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763848940; cv=none; b=ONlTsVd2BTqIb/IWm4lYm5GzOcSPMV1YGuWJTljRgNSnLso/lAFvr66m2cah3Y+vzHj0s4HL9jtVwbEEkPJOKths5Qmte0wMud8WQMCAmWQQwzPAmF0SXoByGYpqhz/LQTCimgCq9RVH4N6Jtno5qWOw5EDWtnoyPPwRbWvYFmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763848940; c=relaxed/simple;
	bh=U5STrxWaygmIztIgN59BJv39LoK9FTXunsE6Kxu4+l4=;
	h=Date:To:From:Subject:Message-Id; b=ixwGuBjEFRczJ4WtvKJw3tIVPXV0ZF0Rj7TZLTUyYrBiVwppxYsJxX/xqLSu9mEOufAYMy6K1OKgU1qmm0M+pUuoD6hLFaaEsHf4QXUD3AdWeY4CTp8I8u4CJtoUNlFGKeSowHF8UYxUWSl5XuNLAh5OpmsJCGMZBzaYZQ5gN2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FmMrGuU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FmMrGuU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20278C4CEF5;
	Sat, 22 Nov 2025 22:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763848940;
	bh=U5STrxWaygmIztIgN59BJv39LoK9FTXunsE6Kxu4+l4=;
	h=Date:To:From:Subject:From;
	b=FmMrGuU5nFqV9puEV2w3K04997ZwtPW7G11whNNxrUQeklNGIWjWGSRk/0Tp7lWuI
	 x5QEo1nfFdy318sVU1gPFA1re7IGMjPJ192pQ6khJrp86DMnSqiwif5UjRPeAZ0qEQ
	 hvLcAPLImzYBI/g3QEmYPoPxqblfAqPX9zAZngiM=
Date: Sat, 22 Nov 2025 14:02:19 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-folio-split-stats-counting.patch added to mm-new branch
Message-Id: <20251122220220.20278C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix folio split stats counting
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-fix-folio-split-stats-counting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-folio-split-stats-counting.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: fix folio split stats counting
Date: Fri, 21 Nov 2025 21:55:29 -0500

The "return <error code>" statements for error checks at the beginning of
__folio_split() skip necessary count_vm_event() and count_mthp_stat() at
the end of the function.  Fix these by replacing them with "ret = <error
code>; goto out;".

Link: https://lkml.kernel.org/r/20251122025529.1562592-5-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-folio-split-stats-counting
+++ a/mm/huge_memory.c
@@ -3954,16 +3954,20 @@ static int __folio_split(struct folio *f
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 
-	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
-		return -EINVAL;
+	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (new_order >= old_order)
-		return -EINVAL;
+	if (new_order >= old_order) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = folio_check_splittable(folio, new_order, split_type,
 				     /* warn = */ true);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (is_anon) {
 		/*
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch
mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch
mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch
mm-huge_memory-make-min_order_for_split-always-return-an-order.patch
mm-huge_memory-fix-folio-split-stats-counting.patch

