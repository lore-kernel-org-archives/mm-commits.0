From: akpm@linux-foundation.org
Subject: + kernel-reboot-add-devm_register_reboot_notifier-fix.patch added to -mm tree
Date: Wed, 29 Mar 2017 16:19:03 -0700
Message-ID: <58dc40e7.8zGYuNVlGMeM9JKa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753411AbdC2XTF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 19:19:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrew.smirnov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-reboot-add-devm_register_reboot_notifier-fix
has been added to the -mm tree.  Its filename is
     kernel-reboot-add-devm_register_reboot_notifier-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-reboot-add-devm_register_reboot_notifier-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-reboot-add-devm_register_reboot_notifier-fix.patch

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
@@ -5,6 +5,8 @@
 #include <linux/notifier.h>
 #include <uapi/linux/reboot.h>
 
+struct device;
+
 #define SYS_DOWN	0x0001	/* Notify of system down */
 #define SYS_RESTART	SYS_DOWN
 #define SYS_HALT	0x0002	/* Notify of system halt */
@@ -38,7 +40,6 @@ extern int reboot_force;
 extern int register_reboot_notifier(struct notifier_block *);
 extern int unregister_reboot_notifier(struct notifier_block *);
 
-struct device;
 extern int devm_register_reboot_notifier(struct device *, struct notifier_block *);
 
 extern int register_restart_handler(struct notifier_block *);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

