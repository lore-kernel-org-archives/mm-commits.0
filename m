From: akpm@linux-foundation.org
Subject: - gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:15:01 -0700
Message-ID: <200807250015.m6P0F239013558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547AbYGYAPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david-b@pacbell.net, mb@bu3sch.de, mchehab@infradead.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     gpio-add-bt8xxgpio-driver-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch

This patch was dropped because it was folded into gpio-add-bt8xxgpio-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio-add-bt8xxgpio-driver-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#157: FILE: drivers/gpio/bt8xxgpio.c:7:
+    Please do _only_ contact the people listed _above_ with issues related to this driver.

WARNING: line over 80 characters
#158: FILE: drivers/gpio/bt8xxgpio.c:8:
+    All the other people listed below are not related to this driver. Their names

WARNING: Use #include <linux/gpio.h> instead of <asm/gpio.h>
#199: FILE: drivers/gpio/bt8xxgpio.c:49:
+#include <asm/gpio.h>

ERROR: space required after that ',' (ctx:VxV)
#221: FILE: drivers/gpio/bt8xxgpio.c:71:
+#define bgwrite(dat,adr)    writel((dat), bg->mmio+(adr))
                    ^

WARNING: line over 80 characters
#227: FILE: drivers/gpio/bt8xxgpio.c:77:
+MODULE_PARM_DESC(gpiobase, "The GPIO number base. -1 means dynamic, which is the default.");

ERROR: space required after that ',' (ctx:VxV)
#403: FILE: drivers/gpio/bt8xxgpio.c:253:
+	release_mem_region(pci_resource_start(pdev,0),
 	                                          ^

ERROR: space required after that ',' (ctx:VxV)
#404: FILE: drivers/gpio/bt8xxgpio.c:254:
+			   pci_resource_len(pdev,0));
 			                        ^

total: 3 errors, 4 warnings, 453 lines checked

./patches/gpio-add-bt8xxgpio-driver.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Brownell <david-b@pacbell.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/bt8xxgpio.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/bt8xxgpio.txt~gpio-add-bt8xxgpio-driver-checkpatch-fixes Documentation/bt8xxgpio.txt
diff -puN MAINTAINERS~gpio-add-bt8xxgpio-driver-checkpatch-fixes MAINTAINERS
diff -puN drivers/gpio/Kconfig~gpio-add-bt8xxgpio-driver-checkpatch-fixes drivers/gpio/Kconfig
diff -puN drivers/gpio/Makefile~gpio-add-bt8xxgpio-driver-checkpatch-fixes drivers/gpio/Makefile
diff -puN drivers/gpio/bt8xxgpio.c~gpio-add-bt8xxgpio-driver-checkpatch-fixes drivers/gpio/bt8xxgpio.c
--- a/drivers/gpio/bt8xxgpio.c~gpio-add-bt8xxgpio-driver-checkpatch-fixes
+++ a/drivers/gpio/bt8xxgpio.c
@@ -46,7 +46,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
-#include <asm/gpio.h>
+#include <linux/gpio.h>
 
 /* Steal the hardware definitions from the bttv driver. */
 #include "../media/video/bt8xx/bt848.h"
@@ -68,8 +68,8 @@ struct bt8xxgpio {
 #endif
 };
 
-#define bgwrite(dat,adr)    writel((dat), bg->mmio+(adr))
-#define bgread(adr)         readl(bg->mmio+(adr))
+#define bgwrite(dat, adr)	writel((dat), bg->mmio+(adr))
+#define bgread(adr)		readl(bg->mmio+(adr))
 
 
 static int modparam_gpiobase = -1/* dynamic */;
@@ -250,8 +250,8 @@ static void bt8xxgpio_remove(struct pci_
 	bgwrite(0x0, BT848_GPIO_OUT_EN);
 
 	iounmap(bg->mmio);
-	release_mem_region(pci_resource_start(pdev,0),
-			   pci_resource_len(pdev,0));
+	release_mem_region(pci_resource_start(pdev, 0),
+			   pci_resource_len(pdev, 0));
 	pci_disable_device(pdev);
 
 	pci_set_drvdata(pdev, NULL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
exec-remove-some-includes.patch
inflate-refactor-inflate-malloc-code.patch
drivers-misc-hpiloc-needs-config_pci.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
gpio-sysfs-interface-updated.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
devcgroup-code-cleanup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-limit-change-shrink-usage-checkpatch-fixes.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

