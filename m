Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EABC155757
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 00:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779151104; cv=none; b=MMtgIx7rE2ivlLU5FoYljDRFz4wXNQ91cQ10YguW+0n63f/n7fdjpaHnoju26pHubyvtaN4AjCf+Xp0ccPRKMMU4dO4lDTQXvyRRR3ICGCndGP2q1TXlOE+l85YBzqEYJx4VfVUmZWMkAExjo7R1wYAHsmyBk14MUTqdgWTMtV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779151104; c=relaxed/simple;
	bh=ErmeiZFpWZTkzyCetIv+5zrdr9RqdHThLOIbnrNljts=;
	h=Date:To:From:Subject:Message-Id; b=om0YMMonePQwQE5r2RH4TNKXwMl2VscWkrbwLGDEzdfJgmm4KJK+H+Z+A/ZcZrzfD8GzZzprIeQYzwNpPq3/jxZ7KLRDDqMkvCYKKIFfbYrg+lK7jPtA2pIow3vgLgS9BT7jGKsL2MDnL4Yga7Iw18n/HlagRVdFXR5eqT4Kq30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WBlvnWeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WBlvnWeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDA6C2BCB7;
	Tue, 19 May 2026 00:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779151103;
	bh=ErmeiZFpWZTkzyCetIv+5zrdr9RqdHThLOIbnrNljts=;
	h=Date:To:From:Subject:From;
	b=WBlvnWeDC/Q/DLjDOKjjQxWgpP/Ch17RnqLc/MSL85Cm1jlYWWhja8UpsjRr31KCX
	 8E42auctwCZMIR+rOnFOK8QIMxRnNGZpNp27xknwKz1sGSPue9+REf9fTwxHg4I7bl
	 MOJ4+n413MUOS1KRlAXYdXRd0cpTIswTdFyTMTTw=
Date: Mon, 18 May 2026 17:38:23 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,osalvador@kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-remove-hugetlb-output-parameter-from-try_memory_failure_hugetlb.patch added to mm-new branch
Message-Id: <20260519003823.CEDA6C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: remove hugetlb output parameter from try_memory_failure_hugetlb()
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-remove-hugetlb-output-parameter-from-try_memory_failure_hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-remove-hugetlb-output-parameter-from-try_memory_failure_hugetlb.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/memory-failure: remove hugetlb output parameter from try_memory_failure_hugetlb()
Date: Fri, 15 May 2026 10:01:43 +0800

Use -ENOENT return value to distinguish "not a hugetlb page" from "hugetlb
handled", instead of carrying an extra output parameter.

Link: https://lore.kernel.org/20260515020144.164941-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-hugetlb-output-parameter-from-try_memory_failure_hugetlb
+++ a/mm/memory-failure.c
@@ -2026,13 +2026,14 @@ out:
  * So some of prechecks for hwpoison (pinning, and testing/setting
  * PageHWPoison) should be done in single hugetlb_lock range.
  * Returns:
- *	0		- not hugetlb, or recovered
+ *	0		- recovered
+ *	-ENOENT		- no hugetlb page
  *	-EBUSY		- not recovered
  *	-EOPNOTSUPP	- hwpoison_filter'ed
  *	-EHWPOISON	- folio or exact page already poisoned
  *	-EFAULT		- kill_accessing_process finds current->mm null
  */
-static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
+static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 {
 	int res, rv;
 	struct page *p = pfn_to_page(pfn);
@@ -2040,13 +2041,11 @@ static int try_memory_failure_hugetlb(un
 	unsigned long page_flags;
 	bool migratable_cleared = false;
 
-	*hugetlb = 1;
 retry:
 	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
 	switch (res) {
 	case MF_HUGETLB_NON_HUGEPAGE:	/* fallback to normal page handling */
-		*hugetlb = 0;
-		return 0;
+		return -ENOENT;
 	case MF_HUGETLB_RETRY:
 		if (!(flags & MF_NO_RETRY)) {
 			flags |= MF_NO_RETRY;
@@ -2107,9 +2106,9 @@ retry:
 }
 
 #else
-static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
+static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 {
-	return 0;
+	return -ENOENT;
 }
 
 static inline unsigned long folio_free_raw_hwp(struct folio *folio, bool flag)
@@ -2347,7 +2346,6 @@ int memory_failure(unsigned long pfn, in
 	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
-	int hugetlb = 0;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -2386,8 +2384,11 @@ int memory_failure(unsigned long pfn, in
 	}
 
 try_again:
-	res = try_memory_failure_hugetlb(pfn, flags, &hugetlb);
-	if (hugetlb)
+	res = try_memory_failure_hugetlb(pfn, flags);
+	/*
+	 * -ENOENT means the page we found is not hugetlb, so proceed with normal page handling
+	 */
+	if (res != -ENOENT)
 		goto unlock_mutex;
 
 	if (TestSetPageHWPoison(p)) {
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memory-failure-use-bool-for-forcekill-state.patch
mm-khugepaged-use-align-helpers-for-pmd-alignment.patch
mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order.patch
tools-mm-page-types-fix-typo-in-madvise-error-message.patch
tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler.patch
tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long.patch
mm-memory-failure-remove-hugetlb-output-parameter-from-try_memory_failure_hugetlb.patch

