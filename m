Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1166138
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956194; cv=none; b=EIHsNScuQBWlquabcZIlhBkMowplxueJfRzMr/6hVxKB0KL+Qwlp//gG1HskObS1MoFxEIoAPa050Xqyz8ydOJAIVITdihiIIBH/9PnQv0LavshqMhDqnlD2YNnF2bpEuXLK6EXn2tNkmzyufB2XRjw7kH2pO34AzBWBx4eI/zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956194; c=relaxed/simple;
	bh=dMVZ/r7CA2DsBRO7+cgQgOao9dllXNNpIfJnR3yjoKo=;
	h=Date:To:From:Subject:Message-Id; b=dj/n5wFxDGzMYP3kg4EJ3JAneVSkySId4O2VHDs02Tip/g2L4b22Qm+7IAX4QzOZ7lqWy8aGdvKsB6nPda50tTfy+OmNoHS+J9eWaBA3cZLxm8xS+7ifmDzG1lUj/wD6Jz1gEEf4yV+CPrzDdLiZl9/0qadoae2E//7UvdOnAWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Pa6v+a+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Pa6v+a+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1151BC4DDE0;
	Mon,  6 May 2024 00:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956194;
	bh=dMVZ/r7CA2DsBRO7+cgQgOao9dllXNNpIfJnR3yjoKo=;
	h=Date:To:From:Subject:From;
	b=2Pa6v+a+WoWFoCh+oNPEGtpJPrDP5tsRfUNTQN8EYV1klV5ObS5Mm3w09k9MWRNzC
	 psj4N/akHhk1SlbDdVfwiPK1DXdKQcq8hzbMsqq6zcYwJpLOBj9GlyxhBEzgm8Y3rM
	 GjxZisGRLPdpRdWRMzJcdUE3GkTnONPSu38jHL1g=
Date: Sun, 05 May 2024 17:43:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch removed from -mm tree
Message-Id: <20240506004314.1151BC4DDE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch

This patch was dropped because it was folded into mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix
Date: Mon Apr 15 01:28:36 PM PDT 2024

remove unneeded `extern'

Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix
+++ a/include/linux/hugetlb.h
@@ -862,7 +862,7 @@ static inline int hstate_index(struct hs
 }
 
 int dissolve_free_hugetlb_folio(struct folio *folio);
-extern int dissolve_free_hugetlb_folios(unsigned long start_pfn,
+int dissolve_free_hugetlb_folios(unsigned long start_pfn,
 				    unsigned long end_pfn);
 
 #ifdef CONFIG_MEMORY_FAILURE
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios.patch
doc-split-bufferrst-out-of-api-summaryrst-fix-fix.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix.patch
kernel-watchdog_perfc-tidy-up-kerneldoc.patch

