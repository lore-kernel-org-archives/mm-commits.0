Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11FA4C9A
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 06:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736661817; cv=none; b=fvLs00WSxtEIcQJ1G9qddXSnM62GYpJHs//OdkloyyC9JDySzmL69dQGihUUPnoamKLYbBGPoFCxybDHmvHUmlKrjhp5oEE2itx5XWDI84sQW+c/p7v/DXLJ4noiiUQ3//LzYNwo4OWsM4j07sRYa+T7vLhM5Rvr2gA/JocJirw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736661817; c=relaxed/simple;
	bh=hP3lnq2LEva0E9DOp+DdXfEu8h3LTkNQqT+p2GtSgOE=;
	h=Date:To:From:Subject:Message-Id; b=gWBqOSyouEmfmGFuAr5yDpmqoxIfhIbKP5anZA3FXWAeP5/xYEy8fFbUruOhaGIMrtejMV0h1VNyriQVCZJo94AdNWVjDHmg8ygm6EYXvX1Q5HBzcrJZoVEUpiseWkx3oVhPBixEFShqE8iABx+11IwjDhI3LrJ8bp0TijcX2P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jfxNT57L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jfxNT57L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC93C4CEE0;
	Sun, 12 Jan 2025 06:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736661817;
	bh=hP3lnq2LEva0E9DOp+DdXfEu8h3LTkNQqT+p2GtSgOE=;
	h=Date:To:From:Subject:From;
	b=jfxNT57LLE6ouqpk6uUcZFJI81vF8r3ISjmukqhew74Icy9JeUmcvLFbEypl++Or5
	 EwSdbnq9UC99RMqOrC+XQDT/9cq9CNF+qTArgMoSww91YeyIrJwrPM36aKzPnm8qUy
	 ARH9vPPTFakhhSmnybsJ47NI6Y5gXoFP+7cBQATI=
Date: Sat, 11 Jan 2025 22:03:36 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,muchun.song@linux.dev,hannes@cmpxchg.org,chengming.zhou@linux.dev,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-call-hpage_collapse_scan_file-for-anonymous-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20250112060337.0DC93C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-call-hpage_collapse_scan_file-for-anonymous-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-call-hpage_collapse_scan_file-for-anonymous-vma.patch

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
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
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

mm-khugepaged-fix-call-hpage_collapse_scan_file-for-anonymous-vma.patch

