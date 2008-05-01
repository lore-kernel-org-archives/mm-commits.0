From: akpm@linux-foundation.org
Subject: - isicom-istallion-prepare-for-lock_kernel-pushdown.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:54 -0700
Message-ID: <200805010927.m419RsXp030457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756707AbYEAJ2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     isicom: istallion prepare for lock_kernel pushdown
has been removed from the -mm tree.  Its filename was
     isicom-istallion-prepare-for-lock_kernel-pushdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isicom: istallion prepare for lock_kernel pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This is an ancient driver so just wrap it in lock_kernel internally and
be done.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/istallion.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/char/istallion.c~isicom-istallion-prepare-for-lock_kernel-pushdown drivers/char/istallion.c
--- a/drivers/char/istallion.c~isicom-istallion-prepare-for-lock_kernel-pushdown
+++ a/drivers/char/istallion.c
@@ -4433,6 +4433,8 @@ static int stli_memioctl(struct inode *i
 	done = 0;
 	rc = 0;
 
+	lock_kernel();
+
 	switch (cmd) {
 	case COM_GETPORTSTATS:
 		rc = stli_getportstats(NULL, argp);
@@ -4455,6 +4457,7 @@ static int stli_memioctl(struct inode *i
 		done++;
 		break;
 	}
+	unlock_kernel();
 
 	if (done)
 		return rc;
@@ -4472,6 +4475,8 @@ static int stli_memioctl(struct inode *i
 	if (brdp->state == 0)
 		return -ENODEV;
 
+	lock_kernel();
+
 	switch (cmd) {
 	case STL_BINTR:
 		EBRDINTR(brdp);
@@ -4494,6 +4499,7 @@ static int stli_memioctl(struct inode *i
 		rc = -ENOIOCTLCMD;
 		break;
 	}
+	unlock_kernel();
 	return rc;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

