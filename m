From: akpm@linux-foundation.org
Subject: + fsl-diu-db-compile-fix.patch added to -mm tree
Date: Wed, 11 Jun 2008 23:28:49 -0700
Message-ID: <200806120628.m5C6SnXP005501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487AbYFLG3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 02:29:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, yorksun@freescale.com


The patch titled
     fsl-diu-db: compile fix
has been added to the -mm tree.  Its filename is
     fsl-diu-db-compile-fix.patch

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
fsl-diu-db-compile-fix.patch

