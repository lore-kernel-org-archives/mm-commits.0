From: akpm@linux-foundation.org
Subject: + kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch added to -mm tree
Date: Wed, 08 May 2013 14:24:55 -0700
Message-ID: <20130508212455.C4D9531C15D@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:62388 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3EHVY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 17:24:57 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so227347ves.0
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 14:24:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jwboyer@redhat.com, keescook@chromium.org


The patch titled
     Subject: kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix
has been added to the -mm tree.  Its filename is
     kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch

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
Subject: kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix

use pr_warn_once()

Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/printk.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix kernel/printk.c
--- a/kernel/printk.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix
+++ a/kernel/printk.c
@@ -398,9 +398,9 @@ static int check_syslog_permissions(int
 		 * a warning.
 		 */
 		if (capable(CAP_SYS_ADMIN)) {
-			printk_once(KERN_WARNING "%s (%d): "
-				 "Attempt to access syslog with CAP_SYS_ADMIN "
-				 "but no CAP_SYSLOG (deprecated).\n",
+			pr_warn_once("%s (%d): Attempt to access syslog with "
+				     "CAP_SYS_ADMIN but no CAP_SYSLOG "
+				     "(deprecated).\n",
 				 current->comm, task_pid_nr(current));
 			return 0;
 		}
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

