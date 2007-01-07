From: akpm@osdl.org
Subject: - fix-implicit-declarations-in-via-pmu.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:57:57 -0800
Message-ID: <200701070757.l077vvHq012921@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40695 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbXAGH6G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:58:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Fix implicit declarations in via-pmu
has been removed from the -mm tree.  Its filename was
     fix-implicit-declarations-in-via-pmu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix implicit declarations in via-pmu
From: Dave Jones <davej@redhat.com>

drivers/macintosh/via-pmu.c: In function 'pmac_suspend_devices':
drivers/macintosh/via-pmu.c:2014: error: implicit declaration of function 'pm_prepare_console'
drivers/macintosh/via-pmu.c: In function 'pmac_wakeup_devices':
drivers/macintosh/via-pmu.c:2139: error: implicit declaration of function 'pm_restore_console'

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/macintosh/via-pmu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/macintosh/via-pmu.c~fix-implicit-declarations-in-via-pmu drivers/macintosh/via-pmu.c
--- a/drivers/macintosh/via-pmu.c~fix-implicit-declarations-in-via-pmu
+++ a/drivers/macintosh/via-pmu.c
@@ -44,6 +44,7 @@
 #include <linux/sysdev.h>
 #include <linux/freezer.h>
 #include <linux/syscalls.h>
+#include <linux/suspend.h>
 #include <linux/cpu.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
_

Patches currently in -mm which might be from davej@redhat.com are

git-cpufreq.patch
remove-hotplug-cpu-crap-from-cpufreq.patch
