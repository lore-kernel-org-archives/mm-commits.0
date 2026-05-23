Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B0A282F10
	for <mm-commits@vger.kernel.org>; Sat, 23 May 2026 03:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779508265; cv=none; b=Q268L26e0GIqdjmp293PzZz5/QsBaa9X7pZG/Rfnvy0ohqQHBrX0KU0VGeosdapEHk0YBi8+QxkUIDAKeiEHu/xumUnAIYanJVS08CQ6ygC55xBGhtSMREs78yz4bvxnHwmCteIF5IDiCl4Vdvs5BWdPoVmDOHNhquEt/PXV9sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779508265; c=relaxed/simple;
	bh=z+uWO0DcXPZF9oqnHDo1K0Rkf3qbcSq7ayqWFq7/I3c=;
	h=Date:To:From:Subject:Message-Id; b=Gs2ylSGM4zZx7awYY2TQ+je6/rFzGHcInKzjxbzu3Qn+UNGJN2hQHLlsO+VBFEt2l6Hbj6IsidcpkHDCGW1IF1mgbPoVS3/fxzJiXc99Bq6QTx6ZtoL6hzH6/LQzcW3kS2hZ8t5xzhdKQ05shHZAyYr6jee3abgGuxd32XV+wvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=husOWCLg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="husOWCLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD631F000E9;
	Sat, 23 May 2026 03:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779508263;
	bh=bI8YcPX7AOzBbDClnFFmb8yhog4+9VPEt07rfVzNUEg=;
	h=Date:To:From:Subject;
	b=husOWCLgkbAVOIvx2nA0EbQhTVQssmDcAMK4Znlr9QECuG9wqz84ASfmWO/iv0Owv
	 tAEKM7dmjOfc2Yk/HAUCwxYCoHkIUEm+NFI1Fe3QRFgPGRj+iVWfKZe4rGq+xVqThu
	 erPzbuhCyKoQuypS8h4Ft8NGdfr0mgI6qD5uztMk=
Date: Fri, 22 May 2026 20:51:03 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,osalvador@kernel.org,nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,mawupeng1@huawei.com,ljs@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260523035103.8DD631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix
Date: Fri May 22 08:44:25 PM PDT 2026

- address possible race identified by Sashiko

- s/out/out_unlock/, per Miaohe

Link: https://sashiko.dev/#/patchset/20260522010305.4099834-1-mawupeng1@huawei.com
Link: https://lore.kernel.org/f39f405e-4b4b-8f79-70fe-a2b5b62114eb@huawei.com
Cc: David Hildenbrand <david@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wupeng Ma <mawupeng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix
+++ a/mm/memory-failure.c
@@ -1970,14 +1970,15 @@ static int get_huge_page_for_hwpoison(un
 				 bool *migratable_cleared)
 {
 	struct page *page = pfn_to_page(pfn);
-	struct folio *folio = page_folio(page);
+	struct folio *folio;
 	bool count_increased = false;
 	int ret, rc;
 
 	spin_lock_irq(&hugetlb_lock);
+	folio = page_folio(page);
 	if (!folio_test_hugetlb(folio)) {
 		ret = MF_HUGETLB_NON_HUGEPAGE;
-		goto out;
+		goto out_unlock;
 	} else if (flags & MF_COUNT_INCREASED) {
 		ret = MF_HUGETLB_IN_USED;
 		count_increased = true;
@@ -1993,13 +1994,13 @@ static int get_huge_page_for_hwpoison(un
 	} else {
 		ret = MF_HUGETLB_RETRY;
 		if (!(flags & MF_NO_RETRY))
-			goto out;
+			goto out_unlock;
 	}
 
 	rc = hugetlb_update_hwpoison(folio, page);
 	if (rc >= MF_HUGETLB_FOLIO_PRE_POISONED) {
 		ret = rc;
-		goto out;
+		goto out_unlock;
 	}
 
 	/*
@@ -2013,7 +2014,7 @@ static int get_huge_page_for_hwpoison(un
 
 	spin_unlock_irq(&hugetlb_lock);
 	return ret;
-out:
+out_unlock:
 	spin_unlock_irq(&hugetlb_lock);
 	if (count_increased)
 		folio_put(folio);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch
selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch
mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix-2.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch

