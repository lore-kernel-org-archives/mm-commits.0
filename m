From: akpm@linux-foundation.org
Subject: - pm-schedule-sysrq-poweroff-on-boot-cpu.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:34 -0700
Message-ID: <200807242325.m6ONPYO9010894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023AbYGXXZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rui.zhang@intel.com, harbour@sfinx.od.ua, kosaki.motohiro@jp.fujitsu.com, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pm: schedule sysrq poweroff on boot cpu
has been removed from the -mm tree.  Its filename was
     pm-schedule-sysrq-poweroff-on-boot-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: schedule sysrq poweroff on boot cpu
From: Zhang Rui <rui.zhang@intel.com>

schedule sysrq poweroff on boot cpu.

sysrq poweroff needs to disable nonboot cpus, and we need to run this on boot
cpu to avoid any recursion.  http://bugzilla.kernel.org/show_bug.cgi?id=10897

[kosaki.motohiro@jp.fujitsu.com: build fix]
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Rus <harbour@sfinx.od.ua>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/poweroff.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/power/poweroff.c~pm-schedule-sysrq-poweroff-on-boot-cpu kernel/power/poweroff.c
--- a/kernel/power/poweroff.c~pm-schedule-sysrq-poweroff-on-boot-cpu
+++ a/kernel/power/poweroff.c
@@ -10,6 +10,7 @@
 #include <linux/pm.h>
 #include <linux/workqueue.h>
 #include <linux/reboot.h>
+#include <linux/cpumask.h>
 
 /*
  * When the user hits Sys-Rq o to power down the machine this is the
@@ -25,7 +26,8 @@ static DECLARE_WORK(poweroff_work, do_po
 
 static void handle_poweroff(int key, struct tty_struct *tty)
 {
-	schedule_work(&poweroff_work);
+	/* run sysrq poweroff on boot cpu */
+	schedule_work_on(first_cpu(cpu_online_map), &poweroff_work);
 }
 
 static struct sysrq_key_op	sysrq_poweroff_op = {
_

Patches currently in -mm which might be from rui.zhang@intel.com are

origin.patch
linux-next.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch

