From: akpm@linux-foundation.org
Subject: [merged]
 shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:27 -0700
Message-ID: <51dc9af7.aYUuvcbXXSQDOyve%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3GIXV1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [merged] shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:27 -0700


The patch titled
     Subject: ipc/shmc.c: eliminate ugly 80-col tricks
has been removed from the -mm tree.  Its filename was
     shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc/shmc.c: eliminate ugly 80-col tricks


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    4 ++--
 mm/mmap.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN ipc/shm.c~shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix ipc/shm.c
--- a/ipc/shm.c~shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix
+++ a/ipc/shm.c
@@ -491,10 +491,10 @@ static int newseg(struct ipc_namespace *
 
 	sprintf (name, "SYSV%08x", key);
 	if (shmflg & SHM_HUGETLB) {
-		struct hstate *hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT)
-						& SHM_HUGE_MASK);
+		struct hstate *hs;
 		size_t hugesize;
 
+		hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT) & SHM_HUGE_MASK);
 		if (!hs) {
 			error = -EINVAL;
 			goto no_file;
diff -puN mm/mmap.c~shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix mm/mmap.c
--- a/mm/mmap.c~shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix
+++ a/mm/mmap.c
@@ -1368,9 +1368,9 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 			goto out_fput;
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
-		struct hstate *hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) &
-						   SHM_HUGE_MASK);
+		struct hstate *hs;
 
+		hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) & SHM_HUGE_MASK);
 		if (!hs)
 			return -EINVAL;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
mm.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
include-linux-mmzoneh-cleanups.patch
drop_caches-add-some-documentation-and-info-messsge.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

