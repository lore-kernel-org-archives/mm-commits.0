Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF8622A4F6;
	Wed, 10 Sep 2025 02:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757469834; cv=none; b=e8qN9wFgDkDMtabbY3/FAuOsIgk5LQYwlwZtBlHvFiM5oP1wERc1RI9gxgQk7IN/uO0mkrLrKTtTyWBoq8ZJGVg45oCecfUjgueifUoGKw7sGMfTVOHeLYtSv+18A3w9EPuhZnOMZQwTScwZD09jOXYuxJNNf+jqSbOPTlwCW/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757469834; c=relaxed/simple;
	bh=FiYdGvg+d7amPCftkDvfEdnvVcG3DDzFXBr+XSwUNOo=;
	h=Date:To:From:Subject:Message-Id; b=BC5azrVGFYMWiSBNWnwoLhzZJLLSRnhLwBtAAkg638fH3SAnWLJrUDTQzfW+CJdjjBxm+e/3fJS/+qmIesIjYhQYBcqcDt7wmLxxEr98pcMcIpbjE09mrxwLJI1BeHKak1/OXK1CiMqoIF9ialD4/6r+NAICnv7OMoGryFjW3UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W/frHJbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W/frHJbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21137C4CEF4;
	Wed, 10 Sep 2025 02:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757469834;
	bh=FiYdGvg+d7amPCftkDvfEdnvVcG3DDzFXBr+XSwUNOo=;
	h=Date:To:From:Subject:From;
	b=W/frHJbbhg0nfbLIzGzu79x77RY/0a31KmizsJiXe//2Hg23KSbBbETRvq0ynbFp6
	 hFw4yBdTLx5dYFCZgF4HKI0ukCI+Zw4i7G59+Qn4REw1EX6omAu0In2UF1DTfzZkWZ
	 RB/zfm+ubMqBVob5kEFYpYWtO1/szWbhzfzP/0m4=
Date: Tue, 09 Sep 2025 19:03:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,liushixin2@huawei.com,david@redhat.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-copy_hugetlb_page_range-to-use-pt_share_count.patch added to mm-hotfixes-unstable branch
Message-Id: <20250910020354.21137C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-copy_hugetlb_page_range-to-use-pt_share_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-copy_hugetlb_page_range-to-use-pt_share_count.patch

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
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
Date: Tue, 9 Sep 2025 12:43:57 -0600

commit 59d9094df3d79 introduced ->pt_share_count dedicated to hugetlb PMD
share count tracking, but omitted fixing copy_hugetlb_page_range(),
leaving the function relying on page_count() for tracking that no longer
works.

When lazy page table copy for hugetlb is disabled (commit bcd51a3c679d),
fork()'ing with hugetlb PMD sharing quickly locks up -

[  239.446559] watchdog: BUG: soft lockup - CPU#75 stuck for 27s!
[  239.446611] RIP: 0010:native_queued_spin_lock_slowpath+0x7e/0x2e0
[  239.446631] Call Trace:
[  239.446633]  <TASK>
[  239.446636]  _raw_spin_lock+0x3f/0x60
[  239.446639]  copy_hugetlb_page_range+0x258/0xb50
[  239.446645]  copy_page_range+0x22b/0x2c0
[  239.446651]  dup_mmap+0x3e2/0x770
[  239.446654]  dup_mm.constprop.0+0x5e/0x230
[  239.446657]  copy_process+0xd17/0x1760
[  239.446660]  kernel_clone+0xc0/0x3e0
[  239.446661]  __do_sys_clone+0x65/0xa0
[  239.446664]  do_syscall_64+0x82/0x930
[  239.446668]  ? count_memcg_events+0xd2/0x190
[  239.446671]  ? syscall_trace_enter+0x14e/0x1f0
[  239.446676]  ? syscall_exit_work+0x118/0x150
[  239.446677]  ? arch_exit_to_user_mode_prepare.constprop.0+0x9/0xb0
[  239.446681]  ? clear_bhb_loop+0x30/0x80
[  239.446684]  ? clear_bhb_loop+0x30/0x80
[  239.446686]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

There are two options to resolve the potential latent issue:
  1. remove the PMD sharing awareness from copy_hugetlb_page_range(),
  2. fix it.
This patch opts for the second option.

Link: https://lkml.kernel.org/r/20250909184357.569259-1-jane.chu@oracle.com
Fixes: 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared
count")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc:
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-copy_hugetlb_page_range-to-use-pt_share_count
+++ a/mm/hugetlb.c
@@ -5594,18 +5594,13 @@ int copy_hugetlb_page_range(struct mm_st
 			break;
 		}
 
-		/*
-		 * If the pagetables are shared don't copy or take references.
-		 *
-		 * dst_pte == src_pte is the common case of src/dest sharing.
-		 * However, src could have 'unshared' and dst shares with
-		 * another vma. So page_count of ptep page is checked instead
-		 * to reliably determine whether pte is shared.
-		 */
-		if (page_count(virt_to_page(dst_pte)) > 1) {
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+		/* If the pagetables are shared don't copy or take references. */
+		if (ptdesc_pmd_pts_count(virt_to_ptdesc(dst_pte)) > 0) {
 			addr |= last_addr_mask;
 			continue;
 		}
+#endif
 
 		dst_ptl = huge_pte_lock(h, dst, dst_pte);
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
_

Patches currently in -mm which might be from jane.chu@oracle.com are

mm-hugetlb-fix-copy_hugetlb_page_range-to-use-pt_share_count.patch

