From: akpm@linux-foundation.org
Subject: + lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch added to -mm tree
Date: Wed, 08 May 2013 13:25:06 -0700
Message-ID: <20130508202506.D3A5B31C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:47931 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab3EHUZI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 16:25:08 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so220156qec.1
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 13:25:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, anish198519851985@gmail.com, chanho.min@lge.com, jkosina@suse.cz, joe@perches.com, nyc@holomorphy.com


The patch titled
     Subject: lib-bitmapc-speed-up-bitmap_find_free_region-fix
has been added to the -mm tree.  Its filename is
     lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch

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
Subject: lib-bitmapc-speed-up-bitmap_find_free_region-fix

reduce scope of locals, remove barely comprehensible comment

Cc: Chanho Min <chanho.min@lge.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: anish singh <anish198519851985@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-speed-up-bitmap_find_free_region-fix lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-speed-up-bitmap_find_free_region-fix
+++ a/lib/bitmap.c
@@ -1114,13 +1114,15 @@ done:
  */
 int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
 {
-	int pos, end, nbit, i;	/* scans bitmap by regions of size order */
 	int nlongs = BITS_TO_LONGS(bits);
+	int i;
 
 	for (i = 0; i < nlongs; i++)
 		if (bitmap[i] != ~0UL) {
-			pos = i * BITS_PER_LONG;
-			nbit = min(bits, pos + BITS_PER_LONG);
+			int pos = i * BITS_PER_LONG;
+			int nbit = min(bits, pos + BITS_PER_LONG);
+			int end;
+
 			for (; (end = pos + (1 << order)) <= nbit; pos = end) {
 				if (!__reg_op(bitmap, pos, order,
 					REG_OP_ISFREE))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
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

