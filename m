Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356131E505
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737004581; cv=none; b=C882OMSYRwl65XWThCI91PN8Kzt17EwjN+hYp9uzJFFoWzqnpyZBlPSQg5HLL3a4FCcbKy3H7LXRxJtI8FwGe6iUn3n6HtpLUteakWpc9IgYNy4g91baMy/mG46mqOcVQ9WsohyOfZn45vzO6nwUyjFkNmS4s9Bxj6sTb1uHbUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737004581; c=relaxed/simple;
	bh=GNVwc3c5najSo8oSWomeMy0oDjmkOmLGZ+k26uHAKec=;
	h=Date:To:From:Subject:Message-Id; b=ZXKZScAOHh8YrbUTxYmboY3L0PYqurAlsUcYqDPHs2errodaWVCCIaxg33Uir3x+1JT25ZApyaMVpu2+WOWkPhhDR8hvwNXW+mEIkV4KxIZ/Ga8mH1XppzvJt3zD/pHdlM5G6ih6pWOO91c77GsfIimGi/XOJmOW/vg3zgRTgVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XfG/9QMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XfG/9QMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C89C4CEE2;
	Thu, 16 Jan 2025 05:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737004580;
	bh=GNVwc3c5najSo8oSWomeMy0oDjmkOmLGZ+k26uHAKec=;
	h=Date:To:From:Subject:From;
	b=XfG/9QMMO+t608AE4xcFcoEUw1uzsn7ApnJECtoHfhiFRAKp/O97q28xfypN9XrMg
	 J+HYNrHMcJ6ZhsSIwd4R3ZA4OGEMpYLjp9h0M7mjIsVc1g5uBu+AkJdrIoqw0+TrPu
	 23JPq6kKpIJkVBU6yE2eCx0GhDS598XfrOJ3yy7M=
Date: Wed, 15 Jan 2025 21:16:20 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,muchun.song@linux.dev,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-khugepaged-fix-call-hpage_collapse_scan_file-for-anonymous-vma.patch removed from -mm tree
Message-Id: <20250116051620.C1C89C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-call-hpage_collapse_scan_file-for-anonymous-vma.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma
Date: Sat, 11 Jan 2025 11:45:11 +0800

syzkaller reported such a BUG_ON():

 ------------[ cut here ]------------
 kernel BUG at mm/khugepaged.c:1835!
 Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
 ...
 CPU: 6 UID: 0 PID: 8009 Comm: syz.15.106 Kdump: loaded Tainted: G        W          6.13.0-rc6 #22
 Tainted: [W]=WARN
 Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
 pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : collapse_file+0xa44/0x1400
 lr : collapse_file+0x88/0x1400
 sp : ffff80008afe3a60
 ...
 Call trace:
  collapse_file+0xa44/0x1400 (P)
  hpage_collapse_scan_file+0x278/0x400
  madvise_collapse+0x1bc/0x678
  madvise_vma_behavior+0x32c/0x448
  madvise_walk_vmas.constprop.0+0xbc/0x140
  do_madvise.part.0+0xdc/0x2c8
  __arm64_sys_madvise+0x68/0x88
  invoke_syscall+0x50/0x120
  el0_svc_common.constprop.0+0xc8/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x34/0x128
  el0t_64_sync_handler+0xc8/0xd0
  el0t_64_sync+0x190/0x198

This indicates that the pgoff is unaligned.  After analysis, I confirm the
vma is mapped to /dev/zero.  Such a vma certainly has vm_file, but it is
set to anonymous by mmap_zero().  So even if it's mmapped by 2m-unaligned,
it can pass the check in thp_vma_allowable_order() as it is an
anonymous-mmap, but then be collapsed as a file-mmap.

It seems the problem has existed for a long time, but actually, since we
have khugepaged_max_ptes_none check before, we will skip collapse it as it
is /dev/zero and so has no present page.  But commit d8ea7cc8547c limit
the check for only khugepaged, so the BUG_ON() can be triggered by
madvise_collapse().

Add vma_is_anonymous() check to make such vma be processed by
hpage_collapse_scan_pmd().

Link: https://lkml.kernel.org/r/20250111034511.2223353-1-liushixin2@huawei.com
Fixes: d8ea7cc8547c ("mm/khugepaged: add flag to predicate khugepaged-only behavior")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-call-hpage_collapse_scan_file-for-anonymous-vma
+++ a/mm/khugepaged.c
@@ -2422,7 +2422,7 @@ skip:
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
-			if (IS_ENABLED(CONFIG_SHMEM) && vma->vm_file) {
+			if (IS_ENABLED(CONFIG_SHMEM) && !vma_is_anonymous(vma)) {
 				struct file *file = get_file(vma->vm_file);
 				pgoff_t pgoff = linear_page_index(vma,
 						khugepaged_scan.address);
@@ -2768,7 +2768,7 @@ int madvise_collapse(struct vm_area_stru
 		mmap_assert_locked(mm);
 		memset(cc->node_load, 0, sizeof(cc->node_load));
 		nodes_clear(cc->alloc_nmask);
-		if (IS_ENABLED(CONFIG_SHMEM) && vma->vm_file) {
+		if (IS_ENABLED(CONFIG_SHMEM) && !vma_is_anonymous(vma)) {
 			struct file *file = get_file(vma->vm_file);
 			pgoff_t pgoff = linear_page_index(vma, addr);
 
_

Patches currently in -mm which might be from liushixin2@huawei.com are


