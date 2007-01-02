From: akpm@osdl.org
Subject: + fix-implicit-declarations-in-via-pmu.patch added to -mm tree
Date: Tue, 02 Jan 2007 12:51:52 -0800
Message-ID: <200701022051.l02Kpqwm029281@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59697 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965AbXABUwQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 15:52:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com


The patch titled
     Fix implicit declarations in via-pmu
has been added to the -mm tree.  Its filename is
     fix-implicit-declarations-in-via-pmu.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

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

fix-implicit-declarations-in-via-pmu.patch
git-agpgart.patch
git-cpufreq.patch
remove-hotplug-cpu-crap-from-cpufreq.patch
fix-implicit-declarations-in-i386-processc.patch
