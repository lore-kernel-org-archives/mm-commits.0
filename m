From: akpm@linux-foundation.org
Subject: + loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch added to -mm tree
Date: Thu, 14 Mar 2013 15:07:34 -0700
Message-ID: <20130314220734.DCB5F5A41D7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:44793 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3CNWHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 18:07:35 -0400
Received: by mail-yh0-f74.google.com with SMTP id z6so280544yhz.1
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 15:07:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, axboe@kernel.dk, psusi@ubuntu.com


The patch titled
     Subject: loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch

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
Subject: loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes

ERROR: that open brace { should be on the previous line
#32: FILE: drivers/block/loop.c:1051:
+	if (bdev)
+	{

WARNING: line over 80 characters
#39: FILE: drivers/block/loop.c:1058:
+		disk_part_iter_init(&piter, bdev->bd_disk, DISK_PITER_INCL_EMPTY);

total: 1 errors, 1 warnings, 26 lines checked

./patches/loop-cleanup-partitions-when-detaching-loop-device.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Phillip Susi <psusi@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/block/loop.c~loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes drivers/block/loop.c
--- a/drivers/block/loop.c~loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes
+++ a/drivers/block/loop.c
@@ -1048,8 +1048,7 @@ static int loop_clr_fd(struct loop_devic
 	if (!part_shift)
 		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
 	mutex_unlock(&lo->lo_ctl_mutex);
-	if (bdev)
-	{
+	if (bdev) {
 		struct disk_part_iter piter;
 		struct hd_struct *part;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
printk-provide-a-wake_up_klogd-off-case-fix.patch
mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

