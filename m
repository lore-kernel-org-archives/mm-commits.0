From: akpm@linux-foundation.org
Subject: + drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch added to -mm tree
Date: Thu, 09 May 2013 11:04:14 -0700
Message-ID: <20130509180414.C8DFF5A4298@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:58994 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab3EISEQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 14:04:16 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so316157vcb.2
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 11:04:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, jeff.dagenais@gmail.com, zbr@ioremap.net


The patch titled
     Subject: drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix
has been added to the -mm tree.  Its filename is
     drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch

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
Subject: drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix

don't use kerenldoc token to introduce a non-kerneldoc comment, tweak whitespace

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Cc: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2408.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/w1/slaves/w1_ds2408.c~drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix drivers/w1/slaves/w1_ds2408.c
--- a/drivers/w1/slaves/w1_ds2408.c~drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix
+++ a/drivers/w1/slaves/w1_ds2408.c
@@ -301,7 +301,7 @@ error:
 	return -EIO;
 }
 
-/**
+/*
  * This is a special sequence we must do to ensure the P0 output is not stuck
  * in test mode. This is described in rev 2 of the ds2408's datasheet
  * (http://datasheets.maximintegrated.com/en/ds/DS2408.pdf) under
@@ -312,6 +312,7 @@ static int w1_f29_disable_test_mode(stru
 	int res;
 	u8 magic[10] = {0x96, };
 	u64 rn = le64_to_cpu(*((u64*)&sl->reg_num));
+
 	memcpy(&magic[1], &rn, 8);
 	magic[9] = 0x3C;
 
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

