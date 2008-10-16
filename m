From: akpm@linux-foundation.org
Subject: + drivers-base-sysc-update-comments.patch added to -mm tree
Date: Thu, 16 Oct 2008 13:36:52 -0700
Message-ID: <200810162036.m9GKaqEg015829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbYJPUg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 16:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s3c24xx@gmail.com, greg@kroah.com, qhfeng.kernel@gmail.com


The patch titled
     drivers/base/sys.c: update comments
has been added to the -mm tree.  Its filename is
     drivers-base-sysc-update-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

drivers-base-sysc-update-comments.patch

