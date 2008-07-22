From: akpm@linux-foundation.org
Subject: - workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch removed from -mm tree
Date: Tue, 22 Jul 2008 03:28:40 -0700
Message-ID: <200807221028.m6MASeXU023343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbYGVK2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 06:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     workqueue: proper error unwinding in cpu hotplug error path
has been removed from the -mm tree.  Its filename was
     workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueue: proper error unwinding in cpu hotplug error path
From: Akinobu Mita <akinobu.mita@gmail.com>

Add proper error unwinding in error path in CPU_UP_PREPARE notifier.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN kernel/workqueue.c~workqueue-proper-error-unwinding-in-cpu-hotplug-error-path kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-proper-error-unwinding-in-cpu-hotplug-error-path
+++ a/kernel/workqueue.c
@@ -928,6 +928,15 @@ static int __devinit workqueue_cpu_callb
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
 				wq->name, cpu);
+
+			list_for_each_entry_continue_reverse(wq, &workqueues,
+							list) {
+				cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+				start_workqueue_thread(cwq, -1);
+				cleanup_workqueue_thread(cwq);
+			}
+			cpu_clear(cpu, cpu_populated_map);
+
 			return NOTIFY_BAD;
 
 		case CPU_ONLINE:
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
move-memory_read_from_buffer-from-fsh-to-stringh.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer-fix.patch
pm-hibernation-simplify-memory-bitmap.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
aty-use-memory_read_from_buffer-fix.patch
auxdisplay-small-cleanups.patch
workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
firmware-use-memory_read_from_buffer.patch
firmware-use-memory_read_from_buffer-fix.patch
dcdbas-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer-fix.patch
dell_rbu-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer-fix.patch

