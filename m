From: akpm@linux-foundation.org
Subject: + ixj-push-bkl-into-driver-and-wrap-ioctls.patch added to -mm tree
Date: Thu, 22 May 2008 16:16:06 -0700
Message-ID: <200805222316.m4MNG6tw026582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758061AbYEVXRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:17:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, domen@coderock.org, nacc@us.ibm.com


The patch titled
     ixj: push BKL into driver and wrap ioctls
has been added to the -mm tree.  Its filename is
     ixj-push-bkl-into-driver-and-wrap-ioctls.patch

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
Subject: ixj: push BKL into driver and wrap ioctls
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Domen Puncer <domen@coderock.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/telephony/ixj.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN drivers/telephony/ixj.c~ixj-push-bkl-into-driver-and-wrap-ioctls drivers/telephony/ixj.c
--- a/drivers/telephony/ixj.c~ixj-push-bkl-into-driver-and-wrap-ioctls
+++ a/drivers/telephony/ixj.c
@@ -6095,15 +6095,15 @@ static int capabilities_check(IXJ *j, st
 	return retval;
 }
 
-static int ixj_ioctl(struct inode *inode, struct file *file_p, unsigned int cmd, unsigned long arg)
+static long do_ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long arg)
 {
 	IXJ_TONE ti;
 	IXJ_FILTER jf;
 	IXJ_FILTER_RAW jfr;
 	void __user *argp = (void __user *)arg;
-
-	unsigned int raise, mant;
+	struct inode *inode = file_p->f_path.dentry->d_inode;
 	unsigned int minor = iminor(inode);
+	unsigned int raise, mant;
 	int board = NUM(inode);
 
 	IXJ *j = get_ixj(NUM(inode));
@@ -6661,6 +6661,15 @@ static int ixj_ioctl(struct inode *inode
 	return retval;
 }
 
+static long ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+	lock_kernel();
+	ret = do_ixj_ioctl(file_p, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 static int ixj_fasync(int fd, struct file *file_p, int mode)
 {
 	IXJ *j = get_ixj(NUM(file_p->f_path.dentry->d_inode));
@@ -6674,7 +6683,7 @@ static const struct file_operations ixj_
         .read           = ixj_enhanced_read,
         .write          = ixj_enhanced_write,
         .poll           = ixj_poll,
-        .ioctl          = ixj_ioctl,
+        .unlocked_ioctl = ixj_ioctl,
         .release        = ixj_release,
         .fasync         = ixj_fasync
 };
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec.patch
linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations-cleanup.patch
paride-push-ioctl-down-into-driver.patch
pktcdvd-push-bkl-down-into-driver.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
pcwd-a-couple-of-watchdogs-escaped-conversion.patch
dac960-push-down-bkl.patch
cm4000_cs-switch-to-unlocked_ioctl.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
snapshot-push-bkl-down-into-ioctl-handlers.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
lcd-push-the-bkl-down-into-the-driver-ioctl-handler.patch

