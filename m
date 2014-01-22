From: akpm@linux-foundation.org
Subject: [merged] fs-compat_ioctlc-fix-an-underflow-issue-harmless.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:07 -0800
Message-ID: <52e02617.8NDLSnbgGi/TWzf7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbaAVUMH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com

Subject: [merged] fs-compat_ioctlc-fix-an-underflow-issue-harmless.patch removed from -mm tree
To: dan.carpenter@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:07 -0800


The patch titled
     Subject: fs/compat_ioctl.c: fix an underflow issue (harmless)
has been removed from the -mm tree.  Its filename was
     fs-compat_ioctlc-fix-an-underflow-issue-harmless.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: fs/compat_ioctl.c: fix an underflow issue (harmless)

We cap "nmsgs" at I2C_RDRW_IOCTL_MAX_MSGS (42) but the current code allows
negative values.  It's harmless but it makes my static checker upset so
I've made nsmgs unsigned.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/compat_ioctl.c~fs-compat_ioctlc-fix-an-underflow-issue-harmless fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~fs-compat_ioctlc-fix-an-underflow-issue-harmless
+++ a/fs/compat_ioctl.c
@@ -680,7 +680,8 @@ static int do_i2c_rdwr_ioctl(unsigned in
 	struct i2c_msg			__user *tmsgs;
 	struct i2c_msg32		__user *umsgs;
 	compat_caddr_t			datap;
-	int				nmsgs, i;
+	u32				nmsgs;
+	int				i;
 
 	if (get_user(nmsgs, &udata->nmsgs))
 		return -EFAULT;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch
drivers-vlynq-vlynqc-fix-another-resource-size-off-by-1-error.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
linux-next.patch
zram-fix-race-between-reset-and-flushing-pending-work.patch

