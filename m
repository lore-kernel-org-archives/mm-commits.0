From: akpm@linux-foundation.org
Subject: + mmc-use-shorter-equivalent-set_current_state.patch added to -mm tree
Date: Wed, 26 Mar 2008 12:47:24 -0700
Message-ID: <200803261947.m2QJlOld031406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405AbYCZTra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 15:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     mmc: use shorter, equivalent set_current_state()
has been added to the -mm tree.  Its filename is
     mmc-use-shorter-equivalent-set_current_state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-powerpc.patch
git-ieee1394.patch
infiniband-use-shorter-list_splice_init-for-brevity.patch
mmc-use-shorter-equivalent-set_current_state.patch
git-net.patch
lapb-use-the-shorter-list_head-form-for-brevity.patch
bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch

