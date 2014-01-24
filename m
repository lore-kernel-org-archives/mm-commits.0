From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:03:00 -0800
Message-ID: <52e2b8e4.bou2FQHDhw751wSL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaAXTDA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:03:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: [merged] drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch removed from -mm tree
To: geert@linux-m68k.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:03:00 -0800


The patch titled
     Subject: drivers/rtc/rtc-s5m.c: s5m_rtc_{suspend,resume}() should depend on CONFIG_PM_SLEEP
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

