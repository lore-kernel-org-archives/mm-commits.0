Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964A727442;
	Fri, 12 Apr 2024 23:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712964082; cv=none; b=noXxRx3N7joEYCPp9nxHMMNwAPNHXMone57UHQBn9EjJL9q0pAUjt6QD569aJe73tmvjGEd3Xj72idWCJNDtfFG1bTGxNwXzOVLZFQ3U+M4WNtjrPkcSujrtCgww6O2hRizZKXOED392IohQ1EeSb4s3QYHSu+U9q7vepcrqOF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712964082; c=relaxed/simple;
	bh=sI0/OsZ2FQB7zuUSJnWG2iFUvueFTFQT6NbEiqw/lkA=;
	h=Date:To:From:Subject:Message-Id; b=UyB8MiGDOL8RhWBJYVNGDBQqwhbhsN+bcTrLZGEZkuGwGlBFX8bfm6e3j3m/LgsUHJGLVWs31xjS4AjDVt11k7Toq8eb4+Vtjxja8PdaOg/efs2wiZmOVGYjnyWXF/iwcqkSJGmIoUWYxv3jp4am6eklczBYmDx+Qt3Ye0VhYGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uFL8KfTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uFL8KfTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132D3C113CC;
	Fri, 12 Apr 2024 23:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712964082;
	bh=sI0/OsZ2FQB7zuUSJnWG2iFUvueFTFQT6NbEiqw/lkA=;
	h=Date:To:From:Subject:From;
	b=uFL8KfTceVDYrXOO/Z0ZCcLYkWSquI6q1AamcNnn5tFFiT0V0FTAApmSe5aEjteNP
	 V/0hmdRkALbksiB6fLFBkohVUyGgvDoGGykjMqkV7S80gqTVeHEmRe43g7MSh0m8L8
	 kyxzGZn0r3OdkkC3rTR2jiJvHYtvGuuyk2uJi4zE=
Date: Fri, 12 Apr 2024 16:21:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20240412232122.132D3C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: fix deadlock when hugetlb_optimize_vmemmap is enabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: fix deadlock when hugetlb_optimize_vmemmap is enabled
Date: Fri, 12 Apr 2024 10:57:54 +0800

extend comment per Oscar

Link: https://lkml.kernel.org/r/20240412025754.1897615-1-linmiaohe@huawei.com
Fixes: a6b40850c442 ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2
+++ a/mm/memory-failure.c
@@ -159,6 +159,10 @@ static int __page_handle_poison(struct p
 	 * dissolve_free_huge_page() might hold cpu_hotplug_lock via static_key_slow_dec()
 	 * when hugetlb vmemmap optimization is enabled. This will break current lock
 	 * dependency chain and leads to deadlock.
+	 * Disabling pcp before dissolving the page was a deterministic approach because
+	 * we made sure that those pages cannot end up in any PCP list. Draining PCP lists
+	 * expels those pages to the buddy system, but nothing guarantees that those pages
+	 * do not get back to a PCP queue if we need to refill those.
 	 */
 	ret = dissolve_free_huge_page(page);
 	if (!ret) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled.patch
mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2.patch
fork-defer-linking-file-vma-until-vma-is-fully-initialized.patch

