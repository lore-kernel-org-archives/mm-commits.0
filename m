From: akpm@linux-foundation.org
Subject: + workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:26:04 -0700
Message-ID: <200807220826.m6M8Q4I6018588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759AbYGVI0n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:26:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, oleg@tv-sign.ru


The patch titled
     workqueue: proper error unwinding in cpu hotplug error path
has been added to the -mm tree.  Its filename is
     workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
pm-hibernation-simplify-memory-bitmap.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch
ipc-use-simple_read_from_buffer.patch
nwflash-use-simple_read_from_buffer.patch
firmware-use-memory_read_from_buffer.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch
move-memory_read_from_buffer-from-fsh-to-stringh.patch

