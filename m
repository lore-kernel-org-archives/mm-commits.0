From: akpm@linux-foundation.org
Subject: [folded-merged]
 watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch removed
 from -mm tree
Date: Fri, 17 Nov 2017 15:18:33 -0800
Message-ID: <5a0f6e49.D9vS5g5rQC83TOgw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54040 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030448AbdKQXSf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:18:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrew.smirnov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog-core-make-use-of-devm_register_reboot_notifier-fix
has been removed from the -mm tree.  Its filename was
     watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch

This patch was dropped because it was folded into watchdog-core-make-use-of-devm_register_reboot_notifier.patch

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

watchdog-core-make-use-of-devm_register_reboot_notifier.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch

