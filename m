From: akpm@linux-foundation.org
Subject: + shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch added to -mm tree
Date: Thu, 09 May 2013 12:21:31 -0700
Message-ID: <20130509192131.9CC3031C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:43730 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3EITVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 15:21:33 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so323564yen.5
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 12:21:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davej@redhat.com, davidlohr.bueso@hp.com, lizefan@huawei.com, lizfan@huawei.com, n-horiguchi@ah.jp.nec.com, riel@redhat.com


The patch titled
     Subject: shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix
has been added to the -mm tree.  Its filename is
     shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix

eliminate ugly 80-col tricks

Cc: Dave Jones <davej@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Li Zefan <lizfan@huawei.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
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
@@ -1367,9 +1367,9 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 			len = ALIGN(len, huge_page_size(hstate_file(file)));
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
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

