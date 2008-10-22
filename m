From: akpm@linux-foundation.org
Subject: - drivers-base-sysc-update-comments.patch removed from -mm tree
Date: Wed, 22 Oct 2008 13:08:54 -0700
Message-ID: <200810222008.m9MK8sBD013871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194AbYJVUI5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 16:08:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s3c24xx@gmail.com, greg@kroah.com, qhfeng.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/base/sys.c: update comments
has been removed from the -mm tree.  Its filename was
     drivers-base-sysc-update-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/base/sys.c: update comments
From: Qinghuang Feng <s3c24xx@gmail.com>

There are no functions named sys_device_shutdown or sys_device_suspend in
the kernel.  They should be changed to sysdev_shutdown and sysdev_suspend
respectively.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/sys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/sys.c~drivers-base-sysc-update-comments drivers/base/sys.c
--- a/drivers/base/sys.c~drivers-base-sysc-update-comments
+++ a/drivers/base/sys.c
@@ -355,7 +355,7 @@ static void __sysdev_resume(struct sys_d
  *	sysdev_suspend - Suspend all system devices.
  *	@state:		Power state to enter.
  *
- *	We perform an almost identical operation as sys_device_shutdown()
+ *	We perform an almost identical operation as sysdev_shutdown()
  *	above, though calling ->suspend() instead. Interrupts are disabled
  *	when this called. Devices are responsible for both saving state and
  *	quiescing or powering down the device.
@@ -437,7 +437,7 @@ aux_driver:
 /**
  *	sysdev_resume - Bring system devices back to life.
  *
- *	Similar to sys_device_suspend(), but we iterate the list forwards
+ *	Similar to sysdev_suspend(), but we iterate the list forwards
  *	to guarantee that parent devices are resumed before their children.
  *
  *	Note: Interrupts are disabled when called.
_

Patches currently in -mm which might be from s3c24xx@gmail.com are

linux-next.patch

