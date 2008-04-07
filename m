From: akpm@linux-foundation.org
Subject: + mtd-chips-add-missing-set_current_state-to-cfi_amdstdstaa_sync.patch added to -mm tree
Date: Mon, 07 Apr 2008 16:15:33 -0700
Message-ID: <200804072315.m37NFXp4029992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755389AbYDGXPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 19:15:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.adamushko@gmail.com, dwmw2@infradead.org


The patch titled
     mtd/chips: add missing set_current_state() to cfi_{amdstd,staa}_sync()
has been added to the -mm tree.  Its filename is
     mtd-chips-add-missing-set_current_state-to-cfi_amdstdstaa_sync.patch

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
Subject: mtd/chips: add missing set_current_state() to cfi_{amdstd,staa}_sync()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

cfi_amdstd_sync() and cfi_staa_sync() call schedule() without changing task's
state appropriately.

In case of e.g.  chip->state == FL_ERASING, cfi_*_sync() will be busy-looping
either redundantly for a fixed interval of time (for SCHED_NORMAL tasks) or
possibly endlessly (for RT tasks and UP).

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/cfi_cmdset_0002.c |    1 +
 drivers/mtd/chips/cfi_cmdset_0020.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/mtd/chips/cfi_cmdset_0002.c~mtd-chips-add-missing-set_current_state-to-cfi_amdstdstaa_sync drivers/mtd/chips/cfi_cmdset_0002.c
--- a/drivers/mtd/chips/cfi_cmdset_0002.c~mtd-chips-add-missing-set_current_state-to-cfi_amdstdstaa_sync
+++ a/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -1763,6 +1763,7 @@ static void cfi_amdstd_sync (struct mtd_
 
 		default:
 			/* Not an idle state */
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 
 			spin_unlock(chip->mutex);
diff -puN drivers/mtd/chips/cfi_cmdset_0020.c~mtd-chips-add-missing-set_current_state-to-cfi_amdstdstaa_sync drivers/mtd/chips/cfi_cmdset_0020.c
--- a/drivers/mtd/chips/cfi_cmdset_0020.c~mtd-chips-add-missing-set_current_state-to-cfi_amdstdstaa_sync
+++ a/drivers/mtd/chips/cfi_cmdset_0020.c
@@ -1015,6 +1015,7 @@ static void cfi_staa_sync (struct mtd_in
 
 		default:
 			/* Not an idle state */
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 
 			spin_unlock_bh(chip->mutex);
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

git-sched.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
mtd-chips-add-missing-set_current_state-to-cfi_amdstdstaa_sync.patch

