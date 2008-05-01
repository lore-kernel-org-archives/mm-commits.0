From: akpm@linux-foundation.org
Subject: - rocket-prepare-for-bkl-pushdown.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:00 -0700
Message-ID: <200805010928.m419S0pm030467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757419AbYEAJ2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     rocket: Prepare for BKL pushdown
has been removed from the -mm tree.  Its filename was
     rocket-prepare-for-bkl-pushdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rocket: Prepare for BKL pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Wrap the ioctl code in lock_kernel calls

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff -puN drivers/char/rocket.c~rocket-prepare-for-bkl-pushdown drivers/char/rocket.c
--- a/drivers/char/rocket.c~rocket-prepare-for-bkl-pushdown
+++ a/drivers/char/rocket.c
@@ -1433,29 +1433,38 @@ static int rp_ioctl(struct tty_struct *t
 {
 	struct r_port *info = (struct r_port *) tty->driver_data;
 	void __user *argp = (void __user *)arg;
+	int ret = 0;
 
 	if (cmd != RCKP_GET_PORTS && rocket_paranoia_check(info, "rp_ioctl"))
 		return -ENXIO;
 
+	lock_kernel();
+
 	switch (cmd) {
 	case RCKP_GET_STRUCT:
 		if (copy_to_user(argp, info, sizeof (struct r_port)))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		break;
 	case RCKP_GET_CONFIG:
-		return get_config(info, argp);
+		ret = get_config(info, argp);
+		break;
 	case RCKP_SET_CONFIG:
-		return set_config(info, argp);
+		ret = set_config(info, argp);
+		break;
 	case RCKP_GET_PORTS:
-		return get_ports(info, argp);
+		ret = get_ports(info, argp);
+		break;
 	case RCKP_RESET_RM2:
-		return reset_rm2(info, argp);
+		ret = reset_rm2(info, argp);
+		break;
 	case RCKP_GET_VERSION:
-		return get_version(info, argp);
+		ret = get_version(info, argp);
+		break;
 	default:
-		return -ENOIOCTLCMD;
+		ret = -ENOIOCTLCMD;
 	}
-	return 0;
+	unlock_kernel();
+	return ret;
 }
 
 static void rp_send_xchar(struct tty_struct *tty, char ch)
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

