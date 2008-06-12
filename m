From: akpm@linux-foundation.org
Subject: - fsl-diu-db-compile-fix.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:36:19 -0700
Message-ID: <200806122036.m5CKaJLt005317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313AbYFLUg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:36:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, yorksun@freescale.com, mm-commits@vger.kernel.org


The patch titled
     fsl-diu-db: compile fix
has been removed from the -mm tree.  Its filename was
     fsl-diu-db-compile-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsl-diu-db: compile fix
From: Jeff Mahoney <jeffm@suse.com>

The variable is expected to be called ofdev.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: York Sun <yorksun@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fsl-diu-fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/fsl-diu-fb.c~fsl-diu-db-compile-fix drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c~fsl-diu-db-compile-fix
+++ a/drivers/video/fsl-diu-fb.c
@@ -1320,7 +1320,7 @@ static void free_irq_local(int irq)
  * Power management hooks. Note that we won't be called from IRQ context,
  * unlike the blank functions above, so we may sleep.
  */
-static int fsl_diu_suspend(struct of_device *dev, pm_message_t state)
+static int fsl_diu_suspend(struct of_device *ofdev, pm_message_t state)
 {
 	struct fsl_diu_data *machine_data;
 
@@ -1330,7 +1330,7 @@ static int fsl_diu_suspend(struct of_dev
 	return 0;
 }
 
-static int fsl_diu_resume(struct of_device *dev)
+static int fsl_diu_resume(struct of_device *ofdev)
 {
 	struct fsl_diu_data *machine_data;
 
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
reiserfs-convert-j_lock-to-mutex.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch

