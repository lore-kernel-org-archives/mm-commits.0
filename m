From: akpm@linux-foundation.org
Subject: + rtc-s3c-balance-state-changes-of-wakeup-flag.patch added to -mm tree
Date: Fri, 17 Sep 2010 13:12:28 -0700
Message-ID: <201009172012.o8HKCST9007739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435Ab0IQUNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 16:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vzapolskiy@gmail.com, a.zummo@towertech.it, atul.dahiya@samsung.com, ben@fluff.org.uk, kgene.kim@samsung.com, stable@kernel.org, taeggyun.ko@samsung.com


The patch titled
     rtc: s3c: balance state changes of wakeup flag
has been added to the -mm tree.  Its filename is
     rtc-s3c-balance-state-changes-of-wakeup-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: s3c: balance state changes of wakeup flag
From: Vladimir Zapolskiy <vzapolskiy@gmail.com>

This change resolves a problem about unbalanced calls of
enable_irq_wakeup() and disable_irq_wakeup() for alarm interrupt.

Bug reproduction:

root@eb600:~# echo 0 > /sys/class/rtc/rtc0/wakealarm

WARNING: at kernel/irq/manage.c:361 set_irq_wake+0x7c/0xe4()
 Unbalanced IRQ 46 wake disable
Modules linked in:
[<c0025708>] (unwind_backtrace+0x0/0xd8) from [<c003358c>] (warn_slowpath_common+0x44/0x5c)
[<c003358c>] (warn_slowpath_common+0x44/0x5c) from [<c00335dc>] (warn_slowpath_fmt+0x24/0x30)
[<c00335dc>] (warn_slowpath_fmt+0x24/0x30) from [<c0058c20>] (set_irq_wake+0x7c/0xe4)
[<c0058c20>] (set_irq_wake+0x7c/0xe4) from [<c01b5e80>] (s3c_rtc_setalarm+0xa8/0xb8)
[<c01b5e80>] (s3c_rtc_setalarm+0xa8/0xb8) from [<c01b47a0>] (rtc_set_alarm+0x60/0x74)
[<c01b47a0>] (rtc_set_alarm+0x60/0x74) from [<c01b5a98>] (rtc_sysfs_set_wakealarm+0xc8/0xd8)
[<c01b5a98>] (rtc_sysfs_set_wakealarm+0xc8/0xd8) from [<c01891ec>] (dev_attr_store+0x20/0x24)
[<c01891ec>] (dev_attr_store+0x20/0x24) from [<c00be934>] (sysfs_write_file+0x104/0x13c)
[<c00be934>] (sysfs_write_file+0x104/0x13c) from [<c0080e7c>] (vfs_write+0xb0/0x158)
[<c0080e7c>] (vfs_write+0xb0/0x158) from [<c0080fcc>] (sys_write+0x3c/0x68)
[<c0080fcc>] (sys_write+0x3c/0x68) from [<c0020ec0>] (ret_fast_syscall+0x0/0x28)

Signed-off-by: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ben Dooks <ben@fluff.org.uk>
Cc: Atul Dahiya <atul.dahiya@samsung.com>
Cc: Taekgyun Ko <taeggyun.ko@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-s3c-balance-state-changes-of-wakeup-flag drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-s3c-balance-state-changes-of-wakeup-flag
+++ a/drivers/rtc/rtc-s3c.c
@@ -310,11 +310,6 @@ static int s3c_rtc_setalarm(struct devic
 
 	s3c_rtc_setaie(alrm->enabled);
 
-	if (alrm->enabled)
-		enable_irq_wake(s3c_rtc_alarmno);
-	else
-		disable_irq_wake(s3c_rtc_alarmno);
-
 	return 0;
 }
 
@@ -587,6 +582,10 @@ static int s3c_rtc_suspend(struct platfo
 		ticnt_en_save &= S3C64XX_RTCCON_TICEN;
 	}
 	s3c_rtc_enable(pdev, 0);
+
+	if (device_may_wakeup(&pdev->dev))
+		enable_irq_wake(s3c_rtc_alarmno);
+
 	return 0;
 }
 
@@ -600,6 +599,10 @@ static int s3c_rtc_resume(struct platfor
 		tmp = readb(s3c_rtc_base + S3C2410_RTCCON);
 		writeb(tmp | ticnt_en_save, s3c_rtc_base + S3C2410_RTCCON);
 	}
+
+	if (device_may_wakeup(&pdev->dev))
+		disable_irq_wake(s3c_rtc_alarmno);
+
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from vzapolskiy@gmail.com are

rtc-s3c-balance-state-changes-of-wakeup-flag.patch

