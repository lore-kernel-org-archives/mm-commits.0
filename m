Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1AD21FF26;
	Thu, 15 Jan 2026 22:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768515601; cv=none; b=mD5IHuBK/vqn8Nz4fJbLbijQZ4YXYb/erJc86xnESnYEEPtqd3GwKMBunYcNUsdZShtx0nJTIms10JOKuuLoD8OK20ZGmszmUs+kPQEKsTHR+6UZkGO3JOoiEGmeuK0jsoee1IaZaIXDB3u7gTQkj94j6O5hosbN0eAA2B79fxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768515601; c=relaxed/simple;
	bh=T+/9/2cdWEUBKSJ64Hs5G3Vts1++g1oHjyVLUIsdYWI=;
	h=Date:To:From:Subject:Message-Id; b=KayEO2h658QTRd79AbyeEsuLQcXn3FoGo3zYbTH1reQa30lGIBpJX5y+UA2kIdOGz1WNKUsXcqCNc8aaGI4u8Ubae5Y/Su4WrIDHqQbwHlJJR3dI+KS1lIZF3gjflamJkHozV8XAJ51UVSMS9btaHf7tdgIfzZ47x7Nv1dsGMnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y1HR+rjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y1HR+rjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E91C116D0;
	Thu, 15 Jan 2026 22:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768515600;
	bh=T+/9/2cdWEUBKSJ64Hs5G3Vts1++g1oHjyVLUIsdYWI=;
	h=Date:To:From:Subject:From;
	b=Y1HR+rjMQD1+9YPwpqZrYatO2qwpu0tb4n6jzn/w/t6oex90Q6VPJnyS7e4Rcoa/m
	 eU6TCCgdNv85WwmOiYRsI8CiV0Q7DbtSpWfu0G1iqHXWpMwVcZkXr3Z6fheV+Ukaaz
	 /+ZQQEcfY9E6esPJVITxgzWM7PnjAxFKRLuHBu3s=
Date: Thu, 15 Jan 2026 14:19:59 -0800
To: mm-commits@vger.kernel.org,william.roche@oracle.com,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rientjes@google.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,Liam.Howlett@oracle.com,david@kernel.org,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-teach-kill_accessing_process-to-accept-hugetlb-tail-page-pfn.patch removed from -mm tree
Message-Id: <20260115222000.96E91C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-teach-kill_accessing_process-to-accept-hugetlb-tail-page-pfn.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn
Date: Tue, 13 Jan 2026 01:07:51 -0700

When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
passed head pfn to kill_accessing_process(), that is not right.  The
precise pfn of the poisoned page should be used in order to determine the
precise vaddr as the SIGBUS payload.

This issue has already been taken care of in the normal path, that is,
hwpoison_user_mappings(), see [1][2].  Further more, for [3] to work
correctly in the hugetlb repoisoning case, it's essential to inform VM the
precise poisoned page, not the head page.

Link: https://lkml.kernel.org/r/20260113080751.2173497-2-jane.chu@oracle.com
Link: https://lkml.kernel.org/r/20231218135837.3310403-1-willy@infradead.org [1]
Link: https://lkml.kernel.org/r/20250224211445.2663312-1-jane.chu@oracle.com [2]
Link: https://lore.kernel.org/lkml/20251116013223.1557158-1-jiaqiyan@google.com/ [3]
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
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
+	if (!pfn || ((pfn & mask) != (poisoned_pfn & mask)))
 		return 0;
 
-	set_to_kill(tk, addr, shift);
+	hwpoison_vaddr = addr + ((poisoned_pfn - pfn) << PAGE_SHIFT);
+	set_to_kill(tk, hwpoison_vaddr, shift);
 	return 1;
 }
 
@@ -2049,10 +2053,8 @@ retry:
 		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
 	case MF_HUGETLB_FOLIO_PRE_POISONED:
 	case MF_HUGETLB_PAGE_PRE_POISON:
-		if (flags & MF_ACTION_REQUIRED) {
-			folio = page_folio(p);
-			res = kill_accessing_process(current, folio_pfn(folio), flags);
-		}
+		if (flags & MF_ACTION_REQUIRED)
+			res = kill_accessing_process(current, pfn, flags);
 		if (res == MF_HUGETLB_FOLIO_PRE_POISONED)
 			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		else
_

Patches currently in -mm which might be from jane.chu@oracle.com are


