From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-oom-notifier-fix.patch removed from -mm tree
Date: Fri, 19 Mar 2010 16:00:17 -0700
Message-ID: <201003192300.o2JN0HPh017183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212Ab0CSXAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg-oom-notifier-fix
has been removed from the -mm tree.  Its filename was
     memcg-oom-notifier-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-oom-notifier-fix
From: Andrew Morton <akpm@linux-foundation.org>

Move kmalloc() outside mutex_lock(&memcg_oom_mutex).

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-oom-notifier-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom-notifier-fix
+++ a/mm/memcontrol.c
@@ -3603,27 +3603,23 @@ static int mem_cgroup_oom_register_event
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup_eventfd_list *event;
 	int type = MEMFILE_TYPE(cft->private);
-	int ret = -ENOMEM;
 
 	BUG_ON(type != _OOM_TYPE);
 
-	mutex_lock(&memcg_oom_mutex);
-
 	event = kmalloc(sizeof(*event),	GFP_KERNEL);
 	if (!event)
-		goto unlock;
+		return -ENOMEM;
 
+	mutex_lock(&memcg_oom_mutex);
 	event->eventfd = eventfd;
 	list_add(&event->list, &memcg->oom_notify);
 
 	/* already in OOM ? */
 	if (atomic_read(&memcg->oom_lock))
 		eventfd_signal(eventfd, 1);
-	ret = 0;
-unlock:
 	mutex_unlock(&memcg_oom_mutex);
 
-	return ret;
+	return 0;
 }
 
 static int mem_cgroup_oom_unregister_event(struct cgroup *cgrp,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
rtc-davinci-rtc-driver-checkpatch-fixes.patch
c2port-fix-device_create-return-value-check-fix.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
memcg-oom-notifier-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

