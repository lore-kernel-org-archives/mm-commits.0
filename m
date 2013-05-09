From: akpm@linux-foundation.org
Subject: + mm-remove-compressed-copy-from-zram-in-memory-fix.patch added to -mm tree
Date: Thu, 09 May 2013 11:28:15 -0700
Message-ID: <20130509182815.95CCB5A4137@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:39529 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3EIS2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 14:28:17 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so318514vcb.3
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 11:28:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dan.magenheimer@oracle.com, hughd@google.com, konrad@darnok.org, minchan@kernel.org, ngupta@vflare.org, shli@kernel.org, sjenning@linux.vnet.ibm.com


The patch titled
     Subject: mm-remove-compressed-copy-from-zram-in-memory-fix
has been added to the -mm tree.  Its filename is
     mm-remove-compressed-copy-from-zram-in-memory-fix.patch

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
Subject: mm-remove-compressed-copy-from-zram-in-memory-fix

tweak comment text

Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN mm/page_io.c~mm-remove-compressed-copy-from-zram-in-memory-fix mm/page_io.c
--- a/mm/page_io.c~mm-remove-compressed-copy-from-zram-in-memory-fix
+++ a/mm/page_io.c
@@ -88,20 +88,20 @@ void end_swap_bio_read(struct bio *bio,
 		sis = page_swap_info(page);
 		if (sis->flags & SWP_BLKDEV) {
 			/*
-			 * Swap subsystem does lazy swap slot free with
-			 * expecting the page would be swapped out again
-			 * so we can avoid unnecessary write if the page
-			 * isn't redirty.
-			 * It's good for real swap storage  because we can
+			 * The swap subsystem performs lazy swap slot freeing,
+			 * expecting that the page will be swapped out again.
+			 * So we can avoid an unnecessary write if the page
+			 * isn't redirtied.
+			 * This is good for real swap storage because we can
 			 * reduce unnecessary I/O and enhance wear-leveling
-			 * if you use SSD as swap device.
-			 * But if you use in-memory swap device(ex, zram),
-			 * it causes duplicated copy between uncompressed
+			 * if an SSD is used as the as swap device.
+			 * But if in-memory swap device (eg zram) is used,
+			 * this causes a duplicated copy between uncompressed
 			 * data in VM-owned memory and compressed data in
-			 * zram-owned memory. So let's free zram-owned memory
-			 * and make the VM-owned decompressed page *dirty*
-			 * so the page should be swap out somewhere again if
-			 * we want to reclaim it, again.
+			 * zram-owned memory.  So let's free zram-owned memory
+			 * and make the VM-owned decompressed page *dirty*,
+			 * so the page should be swapped out somewhere again if
+			 * we again wish to reclaim it.
 			 */
 			struct gendisk *disk = sis->bdev->bd_disk;
 			if (disk->fops->swap_slot_free_notify) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
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

