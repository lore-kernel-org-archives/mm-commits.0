From: akpm@linux-foundation.org
Subject: [merged] shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size.patch removed from -mm tree
Date: Fri, 10 May 2013 12:14:54 -0700
Message-ID: <20130510191454.83ED95A4028@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:44446 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3EJTOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 May 2013 15:14:55 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so425669qcz.0
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2013 12:14:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizefan@huawei.com, davej@redhat.com, davidlohr.bueso@hp.com, lizfan@huawei.com, n-horiguchi@ah.jp.nec.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shm: fix null pointer deref when userspace specifies invalid hugepage size
has been removed from the -mm tree.  Its filename was
     shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: shm: fix null pointer deref when userspace specifies invalid hugepage size

Dave reported an oops triggered by trinity:

[  163.917836] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  163.918984] IP: [<ffffffff812c48ed>] newseg+0x10d/0x390
[  163.919705] PGD cf8c1067 PUD cf8c2067 PMD 0
[  163.920326] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  163.929949] CPU: 2 PID: 7636 Comm: trinity-child2 Not tainted 3.9.0+#67
...
[  163.953629] Call Trace:
[  163.957706]  [<ffffffff812be322>] ipcget+0x182/0x380
[  163.962123]  [<ffffffff810b99a5>] ?trace_hardirqs_on_caller+0x115/0x1e0
[  163.966752]  [<ffffffff812c559a>] SyS_shmget+0x5a/0x60
[  163.971163]  [<ffffffff812c47e0>] ? shm_close+0x140/0x140
[  163.975590]  [<ffffffff812c3e60>] ? shm_release+0x50/0x50
[  163.979991]  [<ffffffff812c3df0>] ? shm_get_unmapped_area+0x20/0x20
[  163.984499]  [<ffffffff816caa14>] tracesys+0xdd/0xe2

This bug was introduced by commit af73e4d9506d3b797509f3c030e7dcd554f7d9c4
("hugetlbfs: fix mmap failure in unaligned size request").

Previously it would return -ENODEV, but seems -EINVAL is more appropriate.

Signed-off-by: Li Zefan <lizfan@huawei.com>
Reported-by: Dave Jones <davej@redhat.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    8 +++++++-
 mm/mmap.c |    8 ++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff -puN ipc/shm.c~shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size ipc/shm.c
--- a/ipc/shm.c~shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size
+++ a/ipc/shm.c
@@ -493,7 +493,13 @@ static int newseg(struct ipc_namespace *
 	if (shmflg & SHM_HUGETLB) {
 		struct hstate *hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT)
 						& SHM_HUGE_MASK);
-		size_t hugesize = ALIGN(size, huge_page_size(hs));
+		size_t hugesize;
+
+		if (!hs) {
+			error = -EINVAL;
+			goto no_file;
+		}
+		hugesize = ALIGN(size, huge_page_size(hs));
 
 		/* hugetlb_file_setup applies strict accounting */
 		if (shmflg & SHM_NORESERVE)
diff -puN mm/mmap.c~shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size mm/mmap.c
--- a/mm/mmap.c~shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size
+++ a/mm/mmap.c
@@ -1367,9 +1367,13 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 			len = ALIGN(len, huge_page_size(hstate_file(file)));
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
+		struct hstate *hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) &
+						   SHM_HUGE_MASK);
 
-		len = ALIGN(len, huge_page_size(hstate_sizelog(
-			(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK)));
+		if (!hs)
+			return -EINVAL;
+
+		len = ALIGN(len, huge_page_size(hs));
 		/*
 		 * VM_NORESERVE is used because the reservations will be
 		 * taken when vm_ops->mmap() is called
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
ocfs2-unlock-rw-lock-if-inode-lock-failed.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch

