Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC922746C
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 21:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721942199; cv=none; b=lT32aZHGrY1e95vsjMRrmUMcqhvPivq1GTuaeJpBLrUBCbx+gz5/ovB50bBzeYQcYBqtyVZ/Efc+TqMYu3p5ZY1xseLAtDedhYK91pzPcHJu1e673nQBjSnVEUV+8VeRCew8OQi/7MmUNX56bTH7IbPaag/9l2O5V/9Vtdbhp+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721942199; c=relaxed/simple;
	bh=ZJyyRAjR9++Mpq1GnfSDmKPddyfFiXcGaV+VzJ7EYUs=;
	h=Date:To:From:Subject:Message-Id; b=u1igCaAVrMi/vA7EtRDhmeQALLJdcnLnQmGwzb32C/vHrb1n84uQ143pX17kj/VRCLdsW8n9nOSqw4XJCcL6wgnQ2zk0FVFkC6qSDWo87DUZyii6pZpbsIKhJoQfLUqLe7SwgDMDIEn2eDC7wj+x+7Azpz4Itvn2TD1km0RvBHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rAYM6kZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rAYM6kZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560E8C116B1;
	Thu, 25 Jul 2024 21:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721942198;
	bh=ZJyyRAjR9++Mpq1GnfSDmKPddyfFiXcGaV+VzJ7EYUs=;
	h=Date:To:From:Subject:From;
	b=rAYM6kZj1wuZFGl8Inw/ua+5QZenUR+/ne/fpP6cyTLRAw4sts5zrdLtqeQkBaG+f
	 oGWwwgdxi+RVspcUkgPM9u4Lik2lxYFbANjTi3AV6soguobgWfXqN06vdpjcpq2h95
	 OQJrWgOkADFhKVjv5Hn4BEMbZWZDcKsOTgz3cJ3Q=
Date: Thu, 25 Jul 2024 14:16:37 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch added to mm-unstable branch
Message-Id: <20240725211638.560E8C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: remove left over comment about follow_huge_foo()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: remove left over comment about follow_huge_foo()
Date: Thu, 25 Jul 2024 10:16:43 +0800

The comment is useless after commit 57a196a58421 ("hugetlb: simplify
hugetlb handling in follow_page_mask") since all follow_huge_foo() are
killed.

Link: https://lkml.kernel.org/r/20240725021643.1358536-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-left-over-comment-about-follow_huge_foo
+++ a/mm/hugetlb.c
@@ -7503,10 +7503,6 @@ __weak unsigned long hugetlb_mask_last_p
 
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 
-/*
- * These functions are overwritable if your architecture needs its own
- * behavior.
- */
 bool isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
 	bool ret = true;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch

