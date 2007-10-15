From: akpm@linux-foundation.org
Subject: + virtualization-of-sysv-msg-queues-is-incomplete.patch added to -mm tree
Date: Mon, 15 Oct 2007 12:24:47 -0700
Message-ID: <200710151924.l9FJOlEo020794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758889AbXJOTZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 15:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dev@openvz.org, Nadia.Derbey@bull.net, alexey@openvz.org, ebiederm@xmission.com, pierre.peiffer@bull.net, serue@us.ibm.com


The patch titled
     virtualization of sysv msg queues is incomplete
has been added to the -mm tree.  Its filename is
     virtualization-of-sysv-msg-queues-is-incomplete.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: virtualization of sysv msg queues is incomplete
From: Kirill Korotaev <dev@openvz.org>

Virtualization of sysv msg queues is incomplete: msg_hdrs and msg_bytes
variables visible from userspace are global.  Let's make them
per-namespace.

Signed-off-by: Alexey Kuznetsov <alexey@openvz.org>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h |    2 ++
 ipc/msg.c           |   21 ++++++++++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff -puN include/linux/ipc.h~virtualization-of-sysv-msg-queues-is-incomplete include/linux/ipc.h
--- a/include/linux/ipc.h~virtualization-of-sysv-msg-queues-is-incomplete
+++ a/include/linux/ipc.h
@@ -111,6 +111,8 @@ struct ipc_namespace {
 	int		msg_ctlmax;
 	int		msg_ctlmnb;
 	int		msg_ctlmni;
+	atomic_t	msg_bytes;
+	atomic_t	msg_hdrs;
 
 	size_t		shm_ctlmax;
 	size_t		shm_ctlall;
diff -puN ipc/msg.c~virtualization-of-sysv-msg-queues-is-incomplete ipc/msg.c
--- a/ipc/msg.c~virtualization-of-sysv-msg-queues-is-incomplete
+++ a/ipc/msg.c
@@ -66,9 +66,6 @@ struct msg_sender {
 #define SEARCH_NOTEQUAL		3
 #define SEARCH_LESSEQUAL	4
 
-static atomic_t msg_bytes =	ATOMIC_INIT(0);
-static atomic_t msg_hdrs =	ATOMIC_INIT(0);
-
 static struct ipc_ids init_msg_ids;
 
 #define msg_ids(ns)	(*((ns)->ids[IPC_MSG_IDS]))
@@ -88,6 +85,8 @@ static void __msg_init_ns(struct ipc_nam
 	ns->msg_ctlmax = MSGMAX;
 	ns->msg_ctlmnb = MSGMNB;
 	ns->msg_ctlmni = MSGMNI;
+	atomic_set(&ns->msg_bytes, 0);
+	atomic_set(&ns->msg_hdrs, 0);
 	ipc_init_ids(ids);
 }
 
@@ -293,10 +292,10 @@ static void freeque(struct ipc_namespace
 		struct msg_msg *msg = list_entry(tmp, struct msg_msg, m_list);
 
 		tmp = tmp->next;
-		atomic_dec(&msg_hdrs);
+		atomic_dec(&ns->msg_hdrs);
 		free_msg(msg);
 	}
-	atomic_sub(msq->q_cbytes, &msg_bytes);
+	atomic_sub(msq->q_cbytes, &ns->msg_bytes);
 	security_msg_queue_free(msq);
 	ipc_rcu_putref(msq);
 }
@@ -463,8 +462,8 @@ asmlinkage long sys_msgctl(int msqid, in
 		down_read(&msg_ids(ns).rw_mutex);
 		if (cmd == MSG_INFO) {
 			msginfo.msgpool = msg_ids(ns).in_use;
-			msginfo.msgmap = atomic_read(&msg_hdrs);
-			msginfo.msgtql = atomic_read(&msg_bytes);
+			msginfo.msgmap = atomic_read(&ns->msg_hdrs);
+			msginfo.msgtql = atomic_read(&ns->msg_bytes);
 		} else {
 			msginfo.msgmap = MSGMAP;
 			msginfo.msgpool = MSGPOOL;
@@ -735,8 +734,8 @@ long do_msgsnd(int msqid, long mtype, vo
 		list_add_tail(&msg->m_list, &msq->q_messages);
 		msq->q_cbytes += msgsz;
 		msq->q_qnum++;
-		atomic_add(msgsz, &msg_bytes);
-		atomic_inc(&msg_hdrs);
+		atomic_add(msgsz, &ns->msg_bytes);
+		atomic_inc(&ns->msg_hdrs);
 	}
 
 	err = 0;
@@ -840,8 +839,8 @@ long do_msgrcv(int msqid, long *pmtype, 
 			msq->q_rtime = get_seconds();
 			msq->q_lrpid = task_tgid_vnr(current);
 			msq->q_cbytes -= msg->m_ts;
-			atomic_sub(msg->m_ts, &msg_bytes);
-			atomic_dec(&msg_hdrs);
+			atomic_sub(msg->m_ts, &ns->msg_bytes);
+			atomic_dec(&ns->msg_hdrs);
 			ss_wakeup(&msq->q_senders, 0);
 			msg_unlock(msq);
 			break;
_

Patches currently in -mm which might be from dev@openvz.org are

shrink_dcache_sb-speedup.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
virtualization-of-sysv-msg-queues-is-incomplete.patch
