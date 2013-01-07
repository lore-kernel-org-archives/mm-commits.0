From: akpm@linux-foundation.org
Subject: [merged] ipc-add-sysctl-to-specify-desired-next-object-id.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:25:03 -0800
Message-ID: <20130107192504.56810200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:32811 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab3AGTZI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:25:08 -0500
Received: by mail-la0-f73.google.com with SMTP id fq13so669524lab.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:25:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@parallels.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: add sysctl to specify desired next object id
has been removed from the -mm tree.  Its filename was
     ipc-add-sysctl-to-specify-desired-next-object-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: ipc: add sysctl to specify desired next object id

Add 3 new variables and sysctls to tune them (by one "next_id" variable
for messages, semaphores and shared memory respectively).  This variable
can be used to set desired id for next allocated IPC object.  By default
it's equal to -1 and old behaviour is preserved.  If this variable is
non-negative, then desired idr will be extracted from it and used as a
start value to search for free IDR slot.

Notes:

1) this patch doesn't guarantee that the new object will have desired
   id.  So it's up to user space how to handle new object with wrong id.

2) After a sucessful id allocation attempt, "next_id" will be set back
   to -1 (if it was non-negative).

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   19 +++++++++++++++++
 include/linux/ipc_namespace.h   |    1 
 ipc/ipc_sysctl.c                |   32 ++++++++++++++++++++++++++++++
 ipc/util.c                      |   16 +++++++++++----
 ipc/util.h                      |    1 
 5 files changed, 65 insertions(+), 4 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~ipc-add-sysctl-to-specify-desired-next-object-id Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~ipc-add-sysctl-to-specify-desired-next-object-id
+++ a/Documentation/sysctl/kernel.txt
@@ -38,6 +38,7 @@ show up in /proc/sys/kernel:
 - l2cr                        [ PPC only ]
 - modprobe                    ==> Documentation/debugging-modules.txt
 - modules_disabled
+- msg_next_id		      [ sysv ipc ]
 - msgmax
 - msgmnb
 - msgmni
@@ -62,7 +63,9 @@ show up in /proc/sys/kernel:
 - rtsig-max
 - rtsig-nr
 - sem
+- sem_next_id		      [ sysv ipc ]
 - sg-big-buff                 [ generic SCSI device (sg) ]
+- shm_next_id		      [ sysv ipc ]
 - shm_rmid_forced
 - shmall
 - shmmax                      [ sysv ipc ]
@@ -320,6 +323,22 @@ to false.
 
 ==============================================================
 
+msg_next_id, sem_next_id, and shm_next_id:
+
+These three toggles allows to specify desired id for next allocated IPC
+object: message, semaphore or shared memory respectively.
+
+By default they are equal to -1, which means generic allocation logic.
+Possible values to set are in range {0..INT_MAX}.
+
+Notes:
+1) kernel doesn't guarantee, that new object will have desired id. So,
+it's up to userspace, how to handle an object with "wrong" id.
+2) Toggle with non-default value will be set back to -1 by kernel after
+successful IPC object allocation.
+
+==============================================================
+
 nmi_watchdog:
 
 Enables/Disables the NMI watchdog on x86 systems. When the value is
diff -puN include/linux/ipc_namespace.h~ipc-add-sysctl-to-specify-desired-next-object-id include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-add-sysctl-to-specify-desired-next-object-id
+++ a/include/linux/ipc_namespace.h
@@ -24,6 +24,7 @@ struct ipc_ids {
 	unsigned short seq_max;
 	struct rw_semaphore rw_mutex;
 	struct idr ipcs_idr;
+	int next_id;
 };
 
 struct ipc_namespace {
diff -puN ipc/ipc_sysctl.c~ipc-add-sysctl-to-specify-desired-next-object-id ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-add-sysctl-to-specify-desired-next-object-id
+++ a/ipc/ipc_sysctl.c
@@ -158,6 +158,9 @@ static int proc_ipcauto_dointvec_minmax(
 
 static int zero;
 static int one = 1;
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static int int_max = INT_MAX;
+#endif
 
 static struct ctl_table ipc_kern_table[] = {
 	{
@@ -227,6 +230,35 @@ static struct ctl_table ipc_kern_table[]
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	{
+		.procname	= "sem_next_id",
+		.data		= &init_ipc_ns.ids[IPC_SEM_IDS].next_id,
+		.maxlen		= sizeof(init_ipc_ns.ids[IPC_SEM_IDS].next_id),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &int_max,
+	},
+	{
+		.procname	= "msg_next_id",
+		.data		= &init_ipc_ns.ids[IPC_MSG_IDS].next_id,
+		.maxlen		= sizeof(init_ipc_ns.ids[IPC_MSG_IDS].next_id),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &int_max,
+	},
+	{
+		.procname	= "shm_next_id",
+		.data		= &init_ipc_ns.ids[IPC_SHM_IDS].next_id,
+		.maxlen		= sizeof(init_ipc_ns.ids[IPC_SHM_IDS].next_id),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &int_max,
+	},
+#endif
 	{}
 };
 
diff -puN ipc/util.c~ipc-add-sysctl-to-specify-desired-next-object-id ipc/util.c
--- a/ipc/util.c~ipc-add-sysctl-to-specify-desired-next-object-id
+++ a/ipc/util.c
@@ -122,6 +122,7 @@ void ipc_init_ids(struct ipc_ids *ids)
 
 	ids->in_use = 0;
 	ids->seq = 0;
+	ids->next_id = -1;
 	{
 		int seq_limit = INT_MAX/SEQ_MULTIPLIER;
 		if (seq_limit > USHRT_MAX)
@@ -252,6 +253,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 	kuid_t euid;
 	kgid_t egid;
 	int id, err;
+	int next_id = ids->next_id;
 
 	if (size > IPCMNI)
 		size = IPCMNI;
@@ -264,7 +266,8 @@ int ipc_addid(struct ipc_ids* ids, struc
 	rcu_read_lock();
 	spin_lock(&new->lock);
 
-	err = idr_get_new(&ids->ipcs_idr, new, &id);
+	err = idr_get_new_above(&ids->ipcs_idr, new,
+				(next_id < 0) ? 0 : ipcid_to_idx(next_id), &id);
 	if (err) {
 		spin_unlock(&new->lock);
 		rcu_read_unlock();
@@ -277,9 +280,14 @@ int ipc_addid(struct ipc_ids* ids, struc
 	new->cuid = new->uid = euid;
 	new->gid = new->cgid = egid;
 
-	new->seq = ids->seq++;
-	if(ids->seq > ids->seq_max)
-		ids->seq = 0;
+	if (next_id < 0) {
+		new->seq = ids->seq++;
+		if (ids->seq > ids->seq_max)
+			ids->seq = 0;
+	} else {
+		new->seq = ipcid_to_seqx(next_id);
+		ids->next_id = -1;
+	}
 
 	new->id = ipc_buildid(id, new->seq);
 	return id;
diff -puN ipc/util.h~ipc-add-sysctl-to-specify-desired-next-object-id ipc/util.h
--- a/ipc/util.h~ipc-add-sysctl-to-specify-desired-next-object-id
+++ a/ipc/util.h
@@ -92,6 +92,7 @@ void __init ipc_init_proc_interface(cons
 #define IPC_SHM_IDS	2
 
 #define ipcid_to_idx(id) ((id) % SEQ_MULTIPLIER)
+#define ipcid_to_seqx(id) ((id) / SEQ_MULTIPLIER)
 
 /* must be called with ids->rw_mutex acquired for writing */
 int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

origin.patch

