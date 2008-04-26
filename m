From: akpm@linux-foundation.org
Subject: - mmc-use-shorter-equivalent-set_current_state.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:56 -0700
Message-ID: <200804261640.m3QGeuW6031072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953AbYDZQla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     mmc: use shorter, equivalent set_current_state()
has been removed from the -mm tree.  Its filename was
     mmc-use-shorter-equivalent-set_current_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: use shorter, equivalent set_current_state()
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio_irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/core/sdio_irq.c~mmc-use-shorter-equivalent-set_current_state drivers/mmc/core/sdio_irq.c
--- a/drivers/mmc/core/sdio_irq.c~mmc-use-shorter-equivalent-set_current_state
+++ a/drivers/mmc/core/sdio_irq.c
@@ -128,12 +128,12 @@ static int sdio_irq_thread(void *_host)
 			}
 		}
 
-		set_task_state(current, TASK_INTERRUPTIBLE);
+		set_current_state(TASK_INTERRUPTIBLE);
 		if (host->caps & MMC_CAP_SDIO_IRQ)
 			host->ops->enable_sdio_irq(host, 1);
 		if (!kthread_should_stop())
 			schedule_timeout(period);
-		set_task_state(current, TASK_RUNNING);
+		set_current_state(TASK_RUNNING);
 	} while (!kthread_should_stop());
 
 	if (host->caps & MMC_CAP_SDIO_IRQ)
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
mfd-use-shorter-set_current_state.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
nbd-delete-superfluous-test-for-__gnuc__.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

