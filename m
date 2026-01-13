Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B6A30BF4E;
	Tue, 13 Jan 2026 23:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768346592; cv=none; b=TjCXTrqtXAOxG3Z7t367/UhjyJHuf0hV23/xQ1oGTsSCbO4DjmGtwo4VPLKj5gKKCiaSaau1ZD3CmxNW0rHwmfJKHEpj/bFdZgXBtElQl2bVlylxpPxGYwWIamIob5vSRLgqfGewsOTx+CSJd5Vf3c+NC9XIq7UOWq2lItgRL/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768346592; c=relaxed/simple;
	bh=NXrOCIc7NG6wQj1ZH5/XTIB7/G9i7gY2RVrzyqIfAdg=;
	h=Date:To:From:Subject:Message-Id; b=butqeCLeg99d/LhTYlx4DxKmfothVq7FOLTjjOcLCZKNywp8ls9c82LkEaEV43X7S3exNbXi7sT3uBuyKHJ7bs59PFpOJEqLl8Iydgl5k1A4cUuN5dXOTyJT1XH65BN0EUZ7SqqKj6I+kFfNqFt8lWoGZcePhWUCixVQ5C9tJig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J4Djwcsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J4Djwcsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CEBC116C6;
	Tue, 13 Jan 2026 23:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768346592;
	bh=NXrOCIc7NG6wQj1ZH5/XTIB7/G9i7gY2RVrzyqIfAdg=;
	h=Date:To:From:Subject:From;
	b=J4DjwcsuX0dw3XlmgRtul21cYtw82cYoQ7emJdBZdI3DtH7QF/Q1euwC+/KqhwJnT
	 GY7yLZ+ulf8mkKCXeT9AskhmQ7r/q5TcNrUIFyXv8/wJrdXlGuQNiSKIO/ZPPpfr2U
	 WjGoQ0wCX/IZR1TcdbvmaLx0NAMb/LzGwDQ7iy6s=
Date: Tue, 13 Jan 2026 15:23:11 -0800
To: mm-commits@vger.kernel.org,william.roche@oracle.com,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rientjes@google.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,Liam.Howlett@oracle.com,david@kernel.org,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-teach-kill_accessing_process-to-accept-hugetlb-tail-page-pfn.patch added to mm-hotfixes-unstable branch
Message-Id: <20260113232312.27CEBC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-teach-kill_accessing_process-to-accept-hugetlb-tail-page-pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-teach-kill_accessing_process-to-accept-hugetlb-tail-page-pfn.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison.patch
mm-memory-failure-teach-kill_accessing_process-to-accept-hugetlb-tail-page-pfn.patch

