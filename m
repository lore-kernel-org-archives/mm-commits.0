Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFE82D3A86;
	Tue, 27 Jan 2026 02:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482660; cv=none; b=NGx7p6f7ORzNQL/qo3pmIu9/fIaa1R/x/PeNi2WR48V8JflOHZm3mLN1Jehm+BPK3EhuLxylGQXI1f/oNXLxiJd4b7Zuy1iHTD3Dqv1DmykYU5d2JlzIrHkYpHXSFYVsD/STJj4AU+IiW5auT103Eaa1+RJsMVjTQJGmzyV5fks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482660; c=relaxed/simple;
	bh=wVSxC2FQi5xnB04aj6Za4cP05j2JRK/QbOpV9xXD+D8=;
	h=Date:To:From:Subject:Message-Id; b=CEkrHYov/U499suwoG+MYoXKO/U5z/FiBSbkWbZ+l3/8YW160xctplUiKRsmSJQ/GwmOQ042fG7Oj6VjT3CCh1luU+QcFklLETtu1u/4/LgHAuCveAjva1kR45GCp1zxtSF1d6W3095e9SAj36h4R/ij2xsvEo+pVFAd12V2kiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rMESK48M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rMESK48M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAADC116C6;
	Tue, 27 Jan 2026 02:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482660;
	bh=wVSxC2FQi5xnB04aj6Za4cP05j2JRK/QbOpV9xXD+D8=;
	h=Date:To:From:Subject:From;
	b=rMESK48ME8io6i4/Q+K6GkfF3D1R7bEnXKLtYfVm8R/nHM1r9F0nb0ZGvJTt1g5o6
	 QGXPo9kkdAQzMS/snYT7lgZ51m17zYc9RHgSFCEMCQPMxsLl2e8oZSGCmCw07WirA4
	 Rnwz3bTEGhqACMyY074Yv9BUJhbi8kQ5Lpp2pueo=
Date: Mon, 26 Jan 2026 18:57:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,william.roche@oracle.com,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rientjes@google.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,Liam.Howlett@oracle.com,jiaqiyan@google.com,david@kernel.org,clm@meta.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-teach-kill_accessing_process-to-accept-hugetlb-tail-page-pfn.patch removed from -mm tree
Message-Id: <20260127025740.4DAADC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-teach-kill_accessing_process-to-accept-hugetlb-tail-page-pfn.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn
Date: Tue, 20 Jan 2026 16:22:34 -0700

When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
passed head pfn to kill_accessing_process(), that is not right.  The
precise pfn of the poisoned page should be used in order to determine the
precise vaddr as the SIGBUS payload.

This issue has already been taken care of in the normal path, that is,
hwpoison_user_mappings(), see [1][2].  Further more, for [3] to work
correctly in the hugetlb repoisoning case, it's essential to inform VM the
precise poisoned page, not the head page.

[1] https://lkml.kernel.org/r/20231218135837.3310403-1-willy@infradead.org
[2] https://lkml.kernel.org/r/20250224211445.2663312-1-jane.chu@oracle.com
[3] https://lore.kernel.org/lkml/20251116013223.1557158-1-jiaqiyan@google.com/

Link: https://lkml.kernel.org/r/20260120232234.3462258-2-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Chris Mason <clm@meta.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: William Roche <william.roche@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-teach-kill_accessing_process-to-accept-hugetlb-tail-page-pfn
+++ a/mm/memory-failure.c
@@ -692,6 +692,8 @@ static int check_hwpoisoned_entry(pte_t
 				unsigned long poisoned_pfn, struct to_kill *tk)
 {
 	unsigned long pfn = 0;
+	unsigned long hwpoison_vaddr;
+	unsigned long mask;
 
 	if (pte_present(pte)) {
 		pfn = pte_pfn(pte);
@@ -702,10 +704,12 @@ static int check_hwpoisoned_entry(pte_t
 			pfn = softleaf_to_pfn(entry);
 	}
 
-	if (!pfn || pfn != poisoned_pfn)
+	mask = ~((1UL << (shift - PAGE_SHIFT)) - 1);
+	if (!pfn || pfn != (poisoned_pfn & mask))
 		return 0;
 
-	set_to_kill(tk, addr, shift);
+	hwpoison_vaddr = addr + ((poisoned_pfn - pfn) << PAGE_SHIFT);
+	set_to_kill(tk, hwpoison_vaddr, shift);
 	return 1;
 }
 
@@ -2052,10 +2056,8 @@ retry:
 	case MF_HUGETLB_FOLIO_PRE_POISONED:
 	case MF_HUGETLB_PAGE_PRE_POISONED:
 		rv = -EHWPOISON;
-		if (flags & MF_ACTION_REQUIRED) {
-			folio = page_folio(p);
-			rv = kill_accessing_process(current, folio_pfn(folio), flags);
-		}
+		if (flags & MF_ACTION_REQUIRED)
+			rv = kill_accessing_process(current, pfn, flags);
 		if (res == MF_HUGETLB_PAGE_PRE_POISONED)
 			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		else
_

Patches currently in -mm which might be from jane.chu@oracle.com are


