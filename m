Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395D82D837E
	for <mm-commits@vger.kernel.org>; Thu, 25 Sep 2025 23:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758841868; cv=none; b=q2J7MFO27JkAt0CpTHUQBQr8hCD7vpFimYrYtIS6U2UaalMmtj3+pnkJmaZQ0xI2lhNdzfy5+C1wm0zsmqabH+1fGJgpYoZ2gRDjYoVEzbdwq68E6x1WPMk8P+5TmGm7C+JCkwohatm9ZfQQTzk4qKoS2JeY8g/hEDnLONUKee8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758841868; c=relaxed/simple;
	bh=81kR8kXvM0UauKoBzT3UNpWyqGRlZXylaHy2FLNs19U=;
	h=Date:To:From:Subject:Message-Id; b=QACYsG8NgzzsWuojUbt0AWKOfXSAWhBVTdQbjQi+GnYLYGv56iHkVDggolmGKpLpb09R9bE8LvdVoP8RueXZkqwV55WsGyt+8dkO8CfqGGbTRe6K44GUdE6+mZlAlC+d/uBdyieUhyRop03GNtvKQaKV4kgEzz20JOZIXWmVMUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WvAoo0uq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WvAoo0uq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF83C4CEF7;
	Thu, 25 Sep 2025 23:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758841867;
	bh=81kR8kXvM0UauKoBzT3UNpWyqGRlZXylaHy2FLNs19U=;
	h=Date:To:From:Subject:From;
	b=WvAoo0uqUkKg64sePJmplsYh8omb6M7Sa4afYl6oTvmIcA8pPgj0/FT5OFXrWIcrH
	 9K5nr3W6ZpIMyZH6KrIu9qk9/9bNn9qeqOryUqhBbs7DNucTcPoQ+ouVvFfBUKpLXC
	 gBae5neEFA15DMBFdKCbZG5kDRkpBX4Obkfgcnx4=
Date: Thu, 25 Sep 2025 16:11:07 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,liushixin2@huawei.com,jannh@google.com,harry.yoo@oracle.com,david@redhat.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-copy_hugetlb_page_range-to-use-pt_share_count.patch removed from -mm tree
Message-Id: <20250925231107.ADF83C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-copy_hugetlb_page_range-to-use-pt_share_count.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
Date: Mon, 15 Sep 2025 18:45:20 -0600

commit 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared
count") introduced ->pt_share_count dedicated to hugetlb PMD share count
tracking, but omitted fixing copy_hugetlb_page_range(), leaving the
function relying on page_count() for tracking that no longer works.

When lazy page table copy for hugetlb is disabled, that is, revert commit
bcd51a3c679d ("hugetlb: lazy page table copies in fork()") fork()'ing with
hugetlb PMD sharing quickly lockup -

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
  1. warn against PMD sharing in copy_hugetlb_page_range(),
  2. fix it.
This patch opts for the second option.
While at it, simplify the comment, the details are not actually relevant
anymore.

Link: https://lkml.kernel.org/r/20250916004520.1604530-1-jane.chu@oracle.com
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    5 +++++
 mm/hugetlb.c             |   15 +++++----------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/mm_types.h~mm-hugetlb-fix-copy_hugetlb_page_range-to-use-pt_share_count
+++ a/include/linux/mm_types.h
@@ -631,6 +631,11 @@ static inline int ptdesc_pmd_pts_count(s
 {
 	return atomic_read(&ptdesc->pt_share_count);
 }
+
+static inline bool ptdesc_pmd_is_shared(struct ptdesc *ptdesc)
+{
+	return !!ptdesc_pmd_pts_count(ptdesc);
+}
 #else
 static inline void ptdesc_pmd_pts_init(struct ptdesc *ptdesc)
 {
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
+		/* If the pagetables are shared, there is nothing to do */
+		if (ptdesc_pmd_is_shared(virt_to_ptdesc(dst_pte))) {
 			addr |= last_addr_mask;
 			continue;
 		}
+#endif
 
 		dst_ptl = huge_pte_lock(h, dst, dst_pte);
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
@@ -7602,7 +7597,7 @@ int huge_pmd_unshare(struct mm_struct *m
 	hugetlb_vma_assert_locked(vma);
 	if (sz != PMD_SIZE)
 		return 0;
-	if (!ptdesc_pmd_pts_count(virt_to_ptdesc(ptep)))
+	if (!ptdesc_pmd_is_shared(virt_to_ptdesc(ptep)))
 		return 0;
 
 	pud_clear(pud);
_

Patches currently in -mm which might be from jane.chu@oracle.com are


