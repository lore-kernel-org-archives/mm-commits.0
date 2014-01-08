From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch added to -mm tree
Date: Wed, 08 Jan 2014 14:51:35 -0800
Message-ID: <52cdd677.OQ6h5zVrd+ST4Y03%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaAHWvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 17:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: + drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch added to -mm tree
To: geert@linux-m68k.org
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 14:51:35 -0800


The patch titled
     Subject: drivers/rtc/rtc-s5m.c: s5m_rtc_{suspend,resume}() should depend on CONFIG_PM_SLEEP
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: drivers/rtc/rtc-s5m.c: s5m_rtc_{suspend,resume}() should depend on CONFIG_PM_SLEEP

If CONFIG_PM_SLEEP=n:

drivers/rtc/rtc-s5m.c:643: warning: `s5m_rtc_resume' defined but not used
drivers/rtc/rtc-s5m.c:654: warning: `s5m_rtc_suspend' defined but not used

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-s5m.c~drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep
+++ a/drivers/rtc/rtc-s5m.c
@@ -639,6 +639,7 @@ static void s5m_rtc_shutdown(struct plat
 	s5m_rtc_enable_smpl(info, false);
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int s5m_rtc_resume(struct device *dev)
 {
 	struct s5m_rtc_info *info = dev_get_drvdata(dev);
@@ -660,6 +661,7 @@ static int s5m_rtc_suspend(struct device
 
 	return ret;
 }
+#endif /* CONFIG_PM_SLEEP */
 
 static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
rtc-rtc-cmos-remove-superfluous-name-cast.patch
rtc-disable-rtc_drv_cmos-on-atari.patch
drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
futex-switch-to-user_ds-for-futex-test.patch
linux-next.patch

