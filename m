From: akpm@linux-foundation.org
Subject: +
 watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch added to
 -mm tree
Date: Tue, 17 Oct 2017 15:03:00 -0700
Message-ID: <59e67e14.hWi4bk2Xo7yNdY5y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52118 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753184AbdJQWDB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:03:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrew.smirnov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog-core-make-use-of-devm_register_reboot_notifier-fix
has been added to the -mm tree.  Its filename is
     watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch

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
Subject: watchdog-core-make-use-of-devm_register_reboot_notifier-fix

small cleanup: avoid 80-col tricks

Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/watchdog_dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/watchdog/watchdog_dev.c~watchdog-core-make-use-of-devm_register_reboot_notifier-fix drivers/watchdog/watchdog_dev.c
--- a/drivers/watchdog/watchdog_dev.c~watchdog-core-make-use-of-devm_register_reboot_notifier-fix
+++ a/drivers/watchdog/watchdog_dev.c
@@ -1020,9 +1020,9 @@ static struct class watchdog_class = {
 static int watchdog_reboot_notifier(struct notifier_block *nb,
 				    unsigned long code, void *data)
 {
-	struct watchdog_device *wdd = container_of(nb, struct watchdog_device,
-						   reboot_nb);
+	struct watchdog_device *wdd;
 
+	wdd = container_of(nb, struct watchdog_device, reboot_nb);
 	if (code == SYS_DOWN || code == SYS_HALT) {
 		if (watchdog_active(wdd)) {
 			int ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

