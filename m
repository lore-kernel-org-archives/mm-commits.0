Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ACB1E5B68;
	Tue, 23 Dec 2025 02:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766456463; cv=none; b=GB81XtVcP+pfWK84gFJLcibWRnjqpOEzO9CAfObrVoCAd5uDZ/KzDs+pqsW3ur/R+b2UbS/NSRHIU2XjGv/18RNsBFKfB+mfLuXAEdYU4+z3dhIC2DAXtaa8BcO+JBVP2fQjxj+Fgibp2+5rgpuMz0qxalKWeqH5Ohr6qAxMydI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766456463; c=relaxed/simple;
	bh=sjKRAysc6zI3OKiJbM5atdhGhBqn8QO8hy+jV1cKQgQ=;
	h=Date:To:From:Subject:Message-Id; b=XU4BtFVdgIrrt3vGGszvSe5g6uKDEx8QjyMUfibj4k4gH3blYCjZMXq1/IF2CE7YJx8/a1+rlcumva08tFdu1X0JB+NzSIwGC/pWtbAU2lEXM8GcXyRSt4l4kDlb9w71aMPdxaZgaJok6urspXeBrtypDMei2/cuHkAX8egP8UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N8vmlVxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N8vmlVxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74498C4CEF1;
	Tue, 23 Dec 2025 02:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766456462;
	bh=sjKRAysc6zI3OKiJbM5atdhGhBqn8QO8hy+jV1cKQgQ=;
	h=Date:To:From:Subject:From;
	b=N8vmlVximkfC8OicgDdiuYCpISPFj4teFsGXxFHY4V3fAV0OEbSo77qigjqlFPmCj
	 6ccCnQlpwfpveBTrOs27u8MAzeodsXMgVbx/6Mey7714uSlDON3WP2weoIyTpbReqT
	 3t4aN5+ZMiGndlWdVVHga64HyRNU92qajDC6OKdk=
Date: Mon, 22 Dec 2025 18:21:01 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,william.roche@oracle.com,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rientjes@google.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,Liam.Howlett@oracle.com,jiaqiyan@google.com,david@kernel.org,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-teach-kill_accessing_process-to-accept-hugetlb-tail-page-pfn.patch added to mm-hotfixes-unstable branch
Message-Id: <20251223022102.74498C4CEF1@smtp.kernel.org>
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
Date: Mon, 22 Dec 2025 18:21:12 -0700

When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
passed head pfn to kill_accessing_process(), that is not right.  The
precise pfn of the poisoned page should be used in order to determine the
precise vaddr as the SIGBUS payload.

This issue has already been taken care of in the normal path, that is,
hwpoison_user_mappings(), see [1][2].  Furthermore, for [3] to work
correctly in the hugetlb repoisoning case, it's essential to inform VM the
precise poisoned page, not the head page.

Link: https://lkml.kernel.org/r/20251223012113.370674-2-jane.chu@oracle.com
Link: https://lkml.kernel.org/r/20231218135837.3310403-1-willy@infradead.org [1]
Link: https://lkml.kernel.org/r/20250224211445.2663312-1-jane.chu@oracle.com [2]
Link: https://lore.kernel.org/lkml/20251116013223.1557158-1-jiaqiyan@google.com/ [3]
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
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
 
@@ -2038,10 +2042,8 @@ retry:
 		return 0;
 	case MF_HUGETLB_ALREADY_POISONED:
 	case MF_HUGETLB_ACC_EXISTING_POISON:
-		if (flags & MF_ACTION_REQUIRED) {
-			folio = page_folio(p);
-			res = kill_accessing_process(current, folio_pfn(folio), flags);
-		}
+		if (flags & MF_ACTION_REQUIRED)
+			res = kill_accessing_process(current, pfn, flags);
 		if (res == MF_HUGETLB_ALREADY_POISONED)
 			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		else
_

Patches currently in -mm which might be from jane.chu@oracle.com are

mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison.patch
mm-memory-failure-teach-kill_accessing_process-to-accept-hugetlb-tail-page-pfn.patch

