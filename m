From: akpm@osdl.org
Subject: + connector-some-fixes-for-ia64-unaligned-access-errors.patch added to -mm tree
Date: Tue, 12 Dec 2006 16:45:13 -0800
Message-ID: <200612130045.kBD0jDUM022902@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34167 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964827AbWLMAp3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 19:45:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: erikj@sgi.com, johnpol@2ka.mipt.ru, tony.luck@intel.com


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

Here, we just adjust how the variables are declared and use memcpy to
avoid the error messages.

Signed-off-by: Erik Jacobson <erikj@sgi.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/connector/cn_proc.c |   94 +++++++++++++++++-----------------
 1 files changed, 47 insertions(+), 47 deletions(-)

diff -puN drivers/connector/cn_proc.c~connector-some-fixes-for-ia64-unaligned-access-errors drivers/connector/cn_proc.c
--- a/drivers/connector/cn_proc.c~connector-some-fixes-for-ia64-unaligned-access-errors
+++ a/drivers/connector/cn_proc.c
@@ -49,7 +49,7 @@ static inline void get_seq(__u32 *ts, in
 void proc_fork_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
-	struct proc_event *ev;
+	struct proc_event ev;
 	__u8 buffer[CN_PROC_MSG_SIZE];
 	struct timespec ts;
 
@@ -57,19 +57,19 @@ void proc_fork_connector(struct task_str
 		return;
 
 	msg = (struct cn_msg*)buffer;
-	ev = (struct proc_event*)msg->data;
-	get_seq(&msg->seq, &ev->cpu);
+	get_seq(&msg->seq, &ev.cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
-	ev->what = PROC_EVENT_FORK;
-	ev->event_data.fork.parent_pid = task->real_parent->pid;
-	ev->event_data.fork.parent_tgid = task->real_parent->tgid;
-	ev->event_data.fork.child_pid = task->pid;
-	ev->event_data.fork.child_tgid = task->tgid;
+	ev.timestamp_ns = timespec_to_ns(&ts);
+	ev.what = PROC_EVENT_FORK;
+	ev.event_data.fork.parent_pid = task->real_parent->pid;
+	ev.event_data.fork.parent_tgid = task->real_parent->tgid;
+	ev.event_data.fork.child_pid = task->pid;
+	ev.event_data.fork.child_tgid = task->tgid;
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
-	msg->len = sizeof(*ev);
+	msg->len = sizeof(ev);
+	memcpy(msg->data, &ev, sizeof(ev));
 	/*  If cn_netlink_send() failed, the data is not sent */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
@@ -77,7 +77,7 @@ void proc_fork_connector(struct task_str
 void proc_exec_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
-	struct proc_event *ev;
+	struct proc_event ev;
 	struct timespec ts;
 	__u8 buffer[CN_PROC_MSG_SIZE];
 
@@ -85,24 +85,24 @@ void proc_exec_connector(struct task_str
 		return;
 
 	msg = (struct cn_msg*)buffer;
-	ev = (struct proc_event*)msg->data;
-	get_seq(&msg->seq, &ev->cpu);
+	get_seq(&msg->seq, &ev.cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
-	ev->what = PROC_EVENT_EXEC;
-	ev->event_data.exec.process_pid = task->pid;
-	ev->event_data.exec.process_tgid = task->tgid;
+	ev.timestamp_ns = timespec_to_ns(&ts);
+	ev.what = PROC_EVENT_EXEC;
+	ev.event_data.exec.process_pid = task->pid;
+	ev.event_data.exec.process_tgid = task->tgid;
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
-	msg->len = sizeof(*ev);
+	msg->len = sizeof(ev);
+	memcpy(msg->data, &ev, sizeof(ev));
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
 void proc_id_connector(struct task_struct *task, int which_id)
 {
 	struct cn_msg *msg;
-	struct proc_event *ev;
+	struct proc_event ev;
 	__u8 buffer[CN_PROC_MSG_SIZE];
 	struct timespec ts;
 
@@ -110,32 +110,32 @@ void proc_id_connector(struct task_struc
 		return;
 
 	msg = (struct cn_msg*)buffer;
-	ev = (struct proc_event*)msg->data;
-	ev->what = which_id;
-	ev->event_data.id.process_pid = task->pid;
-	ev->event_data.id.process_tgid = task->tgid;
+	ev.what = which_id;
+	ev.event_data.id.process_pid = task->pid;
+	ev.event_data.id.process_tgid = task->tgid;
 	if (which_id == PROC_EVENT_UID) {
-	 	ev->event_data.id.r.ruid = task->uid;
-	 	ev->event_data.id.e.euid = task->euid;
+	 	ev.event_data.id.r.ruid = task->uid;
+	 	ev.event_data.id.e.euid = task->euid;
 	} else if (which_id == PROC_EVENT_GID) {
-	   	ev->event_data.id.r.rgid = task->gid;
-	   	ev->event_data.id.e.egid = task->egid;
+	   	ev.event_data.id.r.rgid = task->gid;
+	   	ev.event_data.id.e.egid = task->egid;
 	} else
 	     	return;
-	get_seq(&msg->seq, &ev->cpu);
+	get_seq(&msg->seq, &ev.cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev.timestamp_ns = timespec_to_ns(&ts);
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
-	msg->len = sizeof(*ev);
+	msg->len = sizeof(ev);
+	memcpy(msg->data, &ev, sizeof(ev));
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
 void proc_exit_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
-	struct proc_event *ev;
+	struct proc_event ev;
 	__u8 buffer[CN_PROC_MSG_SIZE];
 	struct timespec ts;
 
@@ -143,19 +143,19 @@ void proc_exit_connector(struct task_str
 		return;
 
 	msg = (struct cn_msg*)buffer;
-	ev = (struct proc_event*)msg->data;
-	get_seq(&msg->seq, &ev->cpu);
+	get_seq(&msg->seq, &ev.cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
-	ev->what = PROC_EVENT_EXIT;
-	ev->event_data.exit.process_pid = task->pid;
-	ev->event_data.exit.process_tgid = task->tgid;
-	ev->event_data.exit.exit_code = task->exit_code;
-	ev->event_data.exit.exit_signal = task->exit_signal;
+	ev.timestamp_ns = timespec_to_ns(&ts);
+	ev.what = PROC_EVENT_EXIT;
+	ev.event_data.exit.process_pid = task->pid;
+	ev.event_data.exit.process_tgid = task->tgid;
+	ev.event_data.exit.exit_code = task->exit_code;
+	ev.event_data.exit.exit_signal = task->exit_signal;
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
-	msg->len = sizeof(*ev);
+	msg->len = sizeof(ev);
+	memcpy(msg->data, &ev, sizeof(ev));
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -170,7 +170,7 @@ void proc_exit_connector(struct task_str
 static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 {
 	struct cn_msg *msg;
-	struct proc_event *ev;
+	struct proc_event ev;
 	__u8 buffer[CN_PROC_MSG_SIZE];
 	struct timespec ts;
 
@@ -178,16 +178,16 @@ static void cn_proc_ack(int err, int rcv
 		return;
 
 	msg = (struct cn_msg*)buffer;
-	ev = (struct proc_event*)msg->data;
 	msg->seq = rcvd_seq;
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
-	ev->cpu = -1;
-	ev->what = PROC_EVENT_NONE;
-	ev->event_data.ack.err = err;
+	ev.timestamp_ns = timespec_to_ns(&ts);
+	ev.cpu = -1;
+	ev.what = PROC_EVENT_NONE;
+	ev.event_data.ack.err = err;
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = rcvd_ack + 1;
-	msg->len = sizeof(*ev);
+	msg->len = sizeof(ev);
+	memcpy(msg->data, &ev, sizeof(ev));
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
_

Patches currently in -mm which might be from erikj@sgi.com are

connector-some-fixes-for-ia64-unaligned-access-errors.patch

