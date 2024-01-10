Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88586DDA3;
	Wed, 10 Jan 2024 04:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rnhwtp6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51440C433F1;
	Wed, 10 Jan 2024 04:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704861848;
	bh=+6fdKkPZhTIdFY2AyAKSnwV4oFfhJZdPoqrogPUEyAM=;
	h=Date:To:From:Subject:From;
	b=rnhwtp6gF68hBPm+inPSE3hvZ6fnEh53xKkQazjIBNfGD/FdkNCZs1TqEZL+0I5qQ
	 GpSXnz6gGEGaITcvrJLd28XXRet90Xqd8J9u5ZP+5w/lwgbktEeQqZIn55yMdUVPr7
	 sEUqhzBLLQ1LMQCioN7LyZAjeUBaVYiFQ/tMAZw8=
Date: Tue, 09 Jan 2024 20:44:07 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,surenb@google.com,stable@vger.kernel.org,sfr@canb.auug.org.au,seanjc@google.com,ryan.roberts@arm.com,peterx@redhat.com,mirq-linux@rere.qmqm.pl,Liam.Howlett@oracle.com,hughd@google.com,david@redhat.com,avagin@google.com,arnd@arndb.de,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20240110044408.51440C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: move mmu notification mechanism inside mm lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: fs/proc/task_mmu: move mmu notification mechanism inside mm lock
Date: Tue, 9 Jan 2024 16:24:42 +0500

Move mmu notification mechanism inside mm lock to prevent race condition
in other components which depend on it.  The notifier will invalidate
memory range.  Depending upon the number of iterations, different memory
ranges would be invalidated.

The following warning would be removed by this patch:
WARNING: CPU: 0 PID: 5067 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:734 kvm_mmu_notifier_change_pte+0x860/0x960 arch/x86/kvm/../../../virt/kvm/kvm_main.c:734

There is no behavioural and performance change with this patch when
there is no component registered with the mmu notifier.

Link: https://lkml.kernel.org/r/20240109112445.590736-1-usama.anjum@collabora.com
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reported-by: syzbot+81227d2bd69e9dedb802@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/000000000000f6d051060c6785bc@google.com/
Reviewed-by: Sean Christopherson <seanjc@google.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock
+++ a/fs/proc/task_mmu.c
@@ -2448,13 +2448,6 @@ static long do_pagemap_scan(struct mm_st
 	if (ret)
 		return ret;
 
-	/* Protection change for the range is going to happen. */
-	if (p.arg.flags & PM_SCAN_WP_MATCHING) {
-		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA, 0,
-					mm, p.arg.start, p.arg.end);
-		mmu_notifier_invalidate_range_start(&range);
-	}
-
 	for (walk_start = p.arg.start; walk_start < p.arg.end;
 			walk_start = p.arg.walk_end) {
 		long n_out;
@@ -2467,8 +2460,20 @@ static long do_pagemap_scan(struct mm_st
 		ret = mmap_read_lock_killable(mm);
 		if (ret)
 			break;
+
+		/* Protection change for the range is going to happen. */
+		if (p.arg.flags & PM_SCAN_WP_MATCHING) {
+			mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA, 0,
+						mm, walk_start, p.arg.end);
+			mmu_notifier_invalidate_range_start(&range);
+		}
+
 		ret = walk_page_range(mm, walk_start, p.arg.end,
 				      &pagemap_scan_ops, &p);
+
+		if (p.arg.flags & PM_SCAN_WP_MATCHING)
+			mmu_notifier_invalidate_range_end(&range);
+
 		mmap_read_unlock(mm);
 
 		n_out = pagemap_scan_flush_buffer(&p);
@@ -2494,9 +2499,6 @@ static long do_pagemap_scan(struct mm_st
 	if (pagemap_scan_writeback_args(&p.arg, uarg))
 		ret = -EFAULT;
 
-	if (p.arg.flags & PM_SCAN_WP_MATCHING)
-		mmu_notifier_invalidate_range_end(&range);
-
 	kfree(p.vec_buf);
 	return ret;
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock.patch

