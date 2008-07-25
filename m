From: akpm@linux-foundation.org
Subject: - ixj-push-bkl-into-driver-and-wrap-ioctls.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:28 -0700
Message-ID: <200807252301.m6PN1Swf003711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755694AbYGYXHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, domen@coderock.org, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ixj: push BKL into driver and wrap ioctls
has been removed from the -mm tree.  Its filename was
     ixj-push-bkl-into-driver-and-wrap-ioctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
hugetlb-fix-config_sysctl=n-build.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch

