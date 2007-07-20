From: akpm@linux-foundation.org
Subject: + spufs-remove-spurious-warn_on-for-spu_deactivate-for-nosched-contexts.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:50:53 -0700
Message-ID: <200707201850.l6KIorNp010859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36901 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757350AbXGTSvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jk@ozlabs.org, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     spufs: remove spurious WARN_ON for spu_deactivate for NOSCHED contexts
has been added to the -mm tree.  Its filename is
     spufs-remove-spurious-warn_on-for-spu_deactivate-for-nosched-contexts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spufs: remove spurious WARN_ON for spu_deactivate for NOSCHED contexts
From: Jeremy Kerr <jk@ozlabs.org>

In 6cbf93960e64f313f6e247cbca7afaa50e3ee2c we added a WARN_ON for calling
spu_deactivate on contexts created with the SPU_CREATE_NOSCHED flag.  However,
all NOSCHED contexts will need to be deactivated when the context is
destroyed, so this gives a spurious warning when any NOSCHED context is
closed.

This change removes the WARN_ON.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/sched.c |    9 ---------
 1 files changed, 9 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/sched.c~spufs-remove-spurious-warn_on-for-spu_deactivate-for-nosched-contexts arch/powerpc/platforms/cell/spufs/sched.c
--- a/arch/powerpc/platforms/cell/spufs/sched.c~spufs-remove-spurious-warn_on-for-spu_deactivate-for-nosched-contexts
+++ a/arch/powerpc/platforms/cell/spufs/sched.c
@@ -581,15 +581,6 @@ static int __spu_deactivate(struct spu_c
  */
 void spu_deactivate(struct spu_context *ctx)
 {
-	/*
-	 * We must never reach this for a nosched context,
-	 * but handle the case gracefull instead of panicing.
-	 */
-	if (ctx->flags & SPU_CREATE_NOSCHED) {
-		WARN_ON(1);
-		return;
-	}
-
 	__spu_deactivate(ctx, 1, MAX_PRIO);
 	spuctx_switch_state(ctx, SPUCTX_UTIL_USER);
 }
_

Patches currently in -mm which might be from jk@ozlabs.org are

origin.patch
spufs-avoid-unexpectedly-restaring-mfc-during-context-save.patch
spufs-make-signal-notification-files-readonly-for-nosched-contexts.patch
spufs-remove-spurious-warn_on-for-spu_deactivate-for-nosched-contexts.patch
spufs-add-spu-stats-in-sysfs-and-ctx-stat-file-in-spufs.patch
spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved.patch
spufs-fix-array-size-of-channel-index.patch
spufs-remove-needless-context-save-restore-code.patch
spufs-fix-decr_status-meanings.patch
spufs-fix-read-and-write-for-decr_status-file.patch
spufs-limit-saving-mfc_cntl-bits.patch
spufs-dont-halt-decrementer-at-restore-step-47.patch
spufs-change-decrementer-restore-timing.patch
spufs-remove-unused-file-argument-from-spufs_run_spu.patch
spufs-use-find_first_bit-instead-of-sched_find_first_bit.patch
