From: akpm@linux-foundation.org
Subject: + fs-compat_ioctlc-fix-an-underflow-issue-harmless.patch added to -mm tree
Date: Mon, 16 Dec 2013 11:55:52 -0800
Message-ID: <52af5ac8.W6dlbgnvAz9VNLmn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3LPTzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com

Subject: + fs-compat_ioctlc-fix-an-underflow-issue-harmless.patch added to -mm tree
To: dan.carpenter@oracle.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:52 -0800


The patch titled
     Subject: fs/compat_ioctl.c: fix an underflow issue (harmless)
has been added to the -mm tree.  Its filename is
     fs-compat_ioctlc-fix-an-underflow-issue-harmless.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-compat_ioctlc-fix-an-underflow-issue-harmless.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-compat_ioctlc-fix-an-underflow-issue-harmless.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
video-mmp-delete-a-stray-mutex_unlock.patch
video-mmp-using-plain-integer-as-null-pointer.patch
ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch
drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
fs-compat_ioctlc-fix-an-underflow-issue-harmless.patch
drivers-mailbox-omap-make-mbox-irq-signed-for-error-handling.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
linux-next.patch

