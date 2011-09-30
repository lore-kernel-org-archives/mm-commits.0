From: akpm@google.com
Subject: + watchdog-move-watchdog__all_cpus-under-config_sysctl.patch added to -mm tree
Date: Fri, 30 Sep 2011 15:20:46 -0700
Message-ID: <201109302220.p8UMKkc1021456@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:57935 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098Ab1I3WUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2011 18:20:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vvs@sw.ru


The patch titled
     Subject: watchdog: move watchdog_*_all_cpus under CONFIG_SYSCTL
has been added to the -mm tree.  Its filename is
     watchdog-move-watchdog__all_cpus-under-config_sysctl.patch

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
From: Vasily Averin <vvs@sw.ru>
Subject: watchdog: move watchdog_*_all_cpus under CONFIG_SYSCTL

Fix compilation warnings for CONFIG_SYSCTL=n:

fixed compilation warnings in case of disabled CONFIG_SYSCTL
kernel/watchdog.c:483:13: warning: `watchdog_enable_all_cpus' defined but not used
kernel/watchdog.c:500:13: warning: `watchdog_disable_all_cpus' defined but not used

these functions are static and are used only in sysctl handler, so move
them inside #ifdef CONFIG_SYSCTL too

Signed-off-by: Vasily Averin <vvs@sw.ru>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 kernel/watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/watchdog.c~watchdog-move-watchdog__all_cpus-under-config_sysctl kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-move-watchdog__all_cpus-under-config_sysctl
+++ a/kernel/watchdog.c
@@ -482,6 +482,8 @@ static void watchdog_disable(int cpu)
 	}
 }
 
+/* sysctl functions */
+#ifdef CONFIG_SYSCTL
 static void watchdog_enable_all_cpus(void)
 {
 	int cpu;
@@ -511,8 +513,6 @@ static void watchdog_disable_all_cpus(vo
 }
 
 
-/* sysctl functions */
-#ifdef CONFIG_SYSCTL
 /*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
_
Subject: Subject: watchdog: move watchdog_*_all_cpus under CONFIG_SYSCTL

Patches currently in -mm which might be from vvs@sw.ru are

origin.patch
watchdog-move-watchdog__all_cpus-under-config_sysctl.patch

