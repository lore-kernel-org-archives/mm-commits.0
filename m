From: akpm@osdl.org
Subject: + connector-some-fixes-for-ia64-unaligned-access-errors.patch added to -mm tree
Date: Wed, 13 Dec 2006 13:11:06 -0800
Message-ID: <200612132111.kBDLB6VM020189@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42322 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbWLMVMF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 16:12:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: erikj@sgi.com, johnpol@2ka.mipt.ru, stable@kernel.org, tony.luck@intel.com


The patch titled
     connector: some fixes for ia64 unaligned access errors
has been added to the -mm tree.  Its filename is
     connector-some-fixes-for-ia64-unaligned-access-errors.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: connector: some fixes for ia64 unaligned access errors
From: Erik Jacobson <erikj@sgi.com>

On ia64, the various functions that make up cn_proc.c cause kernel
unaligned access errors.

If you are using these, for example, to get notification about all tasks
forking and exiting, you get multiple unaligned access errors per process.

Use put_unaligned() in the appropriate palces to fix this.

Signed-off-by: Erik Jacobson <erikj@sgi.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/connector/cn_proc.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/connector/cn_proc.c~connector-some-fixes-for-ia64-unaligned-access-errors drivers/connector/cn_proc.c
--- a/drivers/connector/cn_proc.c~connector-some-fixes-for-ia64-unaligned-access-errors
+++ a/drivers/connector/cn_proc.c
@@ -28,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/connector.h>
 #include <asm/atomic.h>
+#include <asm/unaligned.h>
 
 #include <linux/cn_proc.h>
 
@@ -60,7 +61,7 @@ void proc_fork_connector(struct task_str
 	ev = (struct proc_event*)msg->data;
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
 	ev->what = PROC_EVENT_FORK;
 	ev->event_data.fork.parent_pid = task->real_parent->pid;
 	ev->event_data.fork.parent_tgid = task->real_parent->tgid;
@@ -88,7 +89,7 @@ void proc_exec_connector(struct task_str
 	ev = (struct proc_event*)msg->data;
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
 	ev->what = PROC_EVENT_EXEC;
 	ev->event_data.exec.process_pid = task->pid;
 	ev->event_data.exec.process_tgid = task->tgid;
@@ -124,7 +125,7 @@ void proc_id_connector(struct task_struc
 	     	return;
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
@@ -146,7 +147,7 @@ void proc_exit_connector(struct task_str
 	ev = (struct proc_event*)msg->data;
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
 	ev->what = PROC_EVENT_EXIT;
 	ev->event_data.exit.process_pid = task->pid;
 	ev->event_data.exit.process_tgid = task->tgid;
@@ -181,7 +182,7 @@ static void cn_proc_ack(int err, int rcv
 	ev = (struct proc_event*)msg->data;
 	msg->seq = rcvd_seq;
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
 	ev->cpu = -1;
 	ev->what = PROC_EVENT_NONE;
 	ev->event_data.ack.err = err;
_

Patches currently in -mm which might be from erikj@sgi.com are

connector-some-fixes-for-ia64-unaligned-access-errors.patch

