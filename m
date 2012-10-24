From: akpm@linux-foundation.org
Subject: + ipc-add-sysctl-to-specify-desired-next-object-id.patch added to -mm tree
Date: Wed, 24 Oct 2012 14:38:56 -0700
Message-ID: <20121024213856.F0D9A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40856 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935411Ab2JXVi6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 17:38:58 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so118872yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 14:38:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: ipc: add sysctl to specify desired next object id
has been added to the -mm tree.  Its filename is
     ipc-add-sysctl-to-specify-desired-next-object-id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    1 +
 ipc/ipc_sysctl.c              |   28 ++++++++++++++++++++++++++++
 ipc/util.c                    |   16 ++++++++++++----
 ipc/util.h                    |    1 +
 4 files changed, 42 insertions(+), 4 deletions(-)

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
@@ -158,6 +158,7 @@ static int proc_ipcauto_dointvec_minmax(
 
 static int zero;
 static int one = 1;
+static int int_max = INT_MAX;
 
 static struct ctl_table ipc_kern_table[] = {
 	{
@@ -227,6 +228,33 @@ static struct ctl_table ipc_kern_table[]
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
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
+		if(ids->seq > ids->seq_max)
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
proc-check-vma-vm_file-before-dereferencing.patch
ipc-remove-forced-assignment-of-selected-message.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup.patch
ipc-message-queue-copy-feature-introduced.patch
selftests-ipc-message-queue-copy-feature-test.patch

