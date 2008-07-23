From: akpm@linux-foundation.org
Subject: - pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:23:14 -0700
Message-ID: <200807232335.m6NNZpMS018049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960AbYGWXgn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:36:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, harbour@sfinx.od.ua, pavel@ucw.cz, rjw@sisk.pl, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     pm-schedule-sysrq-poweroff-on-boot-cpu fix
has been removed from the -mm tree.  Its filename was
     pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch

This patch was dropped because it was folded into pm-schedule-sysrq-poweroff-on-boot-cpu.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm-schedule-sysrq-poweroff-on-boot-cpu fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

My IA64 machine can't build on today's mmotm(Jul 13).
So, below patch is necessary, I think.

----------------------------------------------------
Against: mmotm, Jul 13
Applies after: pm-schedule-sysrq-poweroff-on-boot-cpu.patch

Now, handle_poweroff() use cpu_online_map variable.
So cpumask.h sould be included.
Otherwise it cause following build error on ia64 (I guess also sevaral othor platfom).

	kernel/power/poweroff.c: In function 'handle_poweroff':
	kernel/power/poweroff.c:29: error: implicit declaration of function 'first_cpu'
	kernel/power/poweroff.c:29: error: 'cpu_online_map' undeclared (first use in this function)
	kernel/power/poweroff.c:29: error: (Each undeclared identifier is reported only once
	kernel/power/poweroff.c:29: error: for each function it appears in.)
	make[2]: *** [kernel/power/poweroff.o] Error 1
	make[1]: *** [kernel/power] Error 2

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Rus <harbour@sfinx.od.ua>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/poweroff.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/power/poweroff.c~pm-schedule-sysrq-poweroff-on-boot-cpu-fix kernel/power/poweroff.c
--- a/kernel/power/poweroff.c~pm-schedule-sysrq-poweroff-on-boot-cpu-fix
+++ a/kernel/power/poweroff.c
@@ -10,6 +10,7 @@
 #include <linux/pm.h>
 #include <linux/workqueue.h>
 #include <linux/reboot.h>
+#include <linux/cpumask.h>
 
 /*
  * When the user hits Sys-Rq o to power down the machine this is the
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
mm-create-sys-kernel-mm.patch
mm-make-config_migration-available-w-o-config_numa.patch
mm-fix-ever-decreasing-swap-priority.patch
pm-schedule-sysrq-poweroff-on-boot-cpu.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch

