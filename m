From: akpm@linux-foundation.org
Subject: [merged] watchdog-move-watchdog__all_cpus-under-config_sysctl.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:09 -0700
Message-ID: <201111012114.pA1LE9vc025633@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16292 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:14:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vvs@sw.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: move watchdog_*_all_cpus under CONFIG_SYSCTL
has been removed from the -mm tree.  Its filename was
     watchdog-move-watchdog__all_cpus-under-config_sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Vasily Averin <vvs@sw.ru>
Subject: watchdog: move watchdog_*_all_cpus under CONFIG_SYSCTL

Fix compilation warnings for CONFIG_SYSCTL=n:

fixed compilation warnings in case of disabled CONFIG_SYSCTL
kernel/watchdog.c:483:13: warning: `watchdog_enable_all_cpus' defined but not used
kernel/watchdog.c:500:13: warning: `watchdog_disable_all_cpus' defined but not used

these functions are static and are used only in sysctl handler, so move
them inside #ifdef CONFIG_SYSCTL too

Signed-off-by: Vasily Averin <vvs@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/watchdog.c~watchdog-move-watchdog__all_cpus-under-config_sysctl kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-move-watchdog__all_cpus-under-config_sysctl
+++ a/kernel/watchdog.c
@@ -481,6 +481,8 @@ static void watchdog_disable(int cpu)
 	}
 }
 
+/* sysctl functions */
+#ifdef CONFIG_SYSCTL
 static void watchdog_enable_all_cpus(void)
 {
 	int cpu;
@@ -510,8 +512,6 @@ static void watchdog_disable_all_cpus(vo
 }
 
 
-/* sysctl functions */
-#ifdef CONFIG_SYSCTL
 /*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
_

Patches currently in -mm which might be from vvs@sw.ru are

origin.patch

