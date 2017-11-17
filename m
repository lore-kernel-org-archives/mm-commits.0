From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-reboot-add-devm_register_reboot_notifier-fix.patch removed from -mm
 tree
Date: Fri, 17 Nov 2017 15:17:56 -0800
Message-ID: <5a0f6e24.zUQItYh47TlvLiMQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965653AbdKQXR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrew.smirnov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-reboot-add-devm_register_reboot_notifier-fix
has been removed from the -mm tree.  Its filename was
     kernel-reboot-add-devm_register_reboot_notifier-fix.patch

This patch was dropped because it was folded into kernel-reboot-add-devm_register_reboot_notifier.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-reboot-add-devm_register_reboot_notifier-fix

move `struct device' forward declaration to top-of-file

Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/reboot.h~kernel-reboot-add-devm_register_reboot_notifier-fix include/linux/reboot.h
--- a/include/linux/reboot.h~kernel-reboot-add-devm_register_reboot_notifier-fix
+++ a/include/linux/reboot.h
@@ -6,6 +6,8 @@
 #include <linux/notifier.h>
 #include <uapi/linux/reboot.h>
 
+struct device;
+
 #define SYS_DOWN	0x0001	/* Notify of system down */
 #define SYS_RESTART	SYS_DOWN
 #define SYS_HALT	0x0002	/* Notify of system halt */
@@ -39,7 +41,6 @@ extern int reboot_force;
 extern int register_reboot_notifier(struct notifier_block *);
 extern int unregister_reboot_notifier(struct notifier_block *);
 
-struct device;
 extern int devm_register_reboot_notifier(struct device *, struct notifier_block *);
 
 extern int register_restart_handler(struct notifier_block *);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-reboot-add-devm_register_reboot_notifier.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch

