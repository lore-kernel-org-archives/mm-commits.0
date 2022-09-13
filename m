Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270DEC6FA89
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIMVpD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiIMVpC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:45:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5E34507D
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:45:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8301FB810BF
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114F5C433D7;
        Tue, 13 Sep 2022 21:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663105498;
        bh=6Mh7/e+eXAyckj9Ko8zjzmQ84yRWPuMG7Eh05NZybaQ=;
        h=Date:To:From:Subject:From;
        b=T2IqzUjvqFGpMNXCp3Cd6c7ex9EfRg/aZB9NdlhsDahVO3UhsjgypT7TqgHrLi+8j
         E25mTu7Qgq6le+NQXkmJWR/QNv/NPDhpU0tpJgSadzRWTj9Q4mDLYE5FaEECOLmXb8
         gHz+1v0lj+FtudiAlsYbP8JjshhFAmPHc5mo72X4=
Date:   Tue, 13 Sep 2022 14:44:57 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        tim.c.chen@linux.intel.com, shakeelb@google.com,
        manfred@colorfullife.com, legion@kernel.org, ebiederm@xmission.com,
        dennis@kernel.org, dave@stgolabs.net, cl@linux.com,
        alexander.mikhalitsyn@virtuozzo.com, jiebin.sun@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch added to mm-nonmm-unstable branch
Message-Id: <20220913214458.114F5C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: mitigate the lock contention with percpu counter
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jiebin Sun <jiebin.sun@intel.com>
Subject: ipc/msg: mitigate the lock contention with percpu counter
Date: Wed, 14 Sep 2022 03:25:38 +0800

The msg_bytes and msg_hdrs atomic counters are frequently updated when IPC
msg queue is in heavy use, causing heavy cache bounce and overhead. 
Change them to percpu_counter greatly improve the performance.  Since
there is one percpu struct per namespace, additional memory cost is
minimal.  Reading of the count done in msgctl call, which is infrequent. 
So the need to sum up the counts in each CPU is infrequent.

Apply the patch and test the pts/stress-ng-1.4.0
-- system v message passing (160 threads).

Score gain: 3.99x

CPU: ICX 8380 x 2 sockets
Core number: 40 x 2 physical cores
Benchmark: pts/stress-ng-1.4.0
-- system v message passing (160 threads)

Link: https://lkml.kernel.org/r/20220913192538.3023708-3-jiebin.sun@intel.com
Signed-off-by: Jiebin Sun <jiebin.sun@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasily Averin <vasily.averin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    5 ++-
 ipc/msg.c                     |   44 +++++++++++++++++++++-----------
 ipc/namespace.c               |    5 ++-
 ipc/util.h                    |    4 +-
 4 files changed, 39 insertions(+), 19 deletions(-)

--- a/include/linux/ipc_namespace.h~ipc-msg-mitigate-the-lock-contention-with-percpu-counter
+++ a/include/linux/ipc_namespace.h
@@ -11,6 +11,7 @@
 #include <linux/refcount.h>
 #include <linux/rhashtable-types.h>
 #include <linux/sysctl.h>
+#include <linux/percpu_counter.h>
 
 struct user_namespace;
 
@@ -36,8 +37,8 @@ struct ipc_namespace {
 	unsigned int	msg_ctlmax;
 	unsigned int	msg_ctlmnb;
 	unsigned int	msg_ctlmni;
-	atomic_t	msg_bytes;
-	atomic_t	msg_hdrs;
+	struct percpu_counter percpu_msg_bytes;
+	struct percpu_counter percpu_msg_hdrs;
 
 	size_t		shm_ctlmax;
 	size_t		shm_ctlall;
--- a/ipc/msg.c~ipc-msg-mitigate-the-lock-contention-with-percpu-counter
+++ a/ipc/msg.c
@@ -39,6 +39,7 @@
 #include <linux/nsproxy.h>
 #include <linux/ipc_namespace.h>
 #include <linux/rhashtable.h>
+#include <linux/percpu_counter.h>
 
 #include <asm/current.h>
 #include <linux/uaccess.h>
@@ -285,10 +286,10 @@ static void freeque(struct ipc_namespace
 	rcu_read_unlock();
 
 	list_for_each_entry_safe(msg, t, &msq->q_messages, m_list) {
-		atomic_dec(&ns->msg_hdrs);
+		percpu_counter_sub_local(&ns->percpu_msg_hdrs, 1);
 		free_msg(msg);
 	}
-	atomic_sub(msq->q_cbytes, &ns->msg_bytes);
+	percpu_counter_sub_local(&ns->percpu_msg_bytes, msq->q_cbytes);
 	ipc_update_pid(&msq->q_lspid, NULL);
 	ipc_update_pid(&msq->q_lrpid, NULL);
 	ipc_rcu_putref(&msq->q_perm, msg_rcu_free);
@@ -495,17 +496,18 @@ static int msgctl_info(struct ipc_namesp
 	msginfo->msgssz = MSGSSZ;
 	msginfo->msgseg = MSGSEG;
 	down_read(&msg_ids(ns).rwsem);
-	if (cmd == MSG_INFO) {
+	if (cmd == MSG_INFO)
 		msginfo->msgpool = msg_ids(ns).in_use;
-		msginfo->msgmap = atomic_read(&ns->msg_hdrs);
-		msginfo->msgtql = atomic_read(&ns->msg_bytes);
+	max_idx = ipc_get_maxidx(&msg_ids(ns));
+	up_read(&msg_ids(ns).rwsem);
+	if (cmd == MSG_INFO) {
+		msginfo->msgmap = percpu_counter_sum(&ns->percpu_msg_hdrs);
+		msginfo->msgtql = percpu_counter_sum(&ns->percpu_msg_bytes);
 	} else {
 		msginfo->msgmap = MSGMAP;
 		msginfo->msgpool = MSGPOOL;
 		msginfo->msgtql = MSGTQL;
 	}
-	max_idx = ipc_get_maxidx(&msg_ids(ns));
-	up_read(&msg_ids(ns).rwsem);
 	return (max_idx < 0) ? 0 : max_idx;
 }
 
@@ -935,8 +937,8 @@ static long do_msgsnd(int msqid, long mt
 		list_add_tail(&msg->m_list, &msq->q_messages);
 		msq->q_cbytes += msgsz;
 		msq->q_qnum++;
-		atomic_add(msgsz, &ns->msg_bytes);
-		atomic_inc(&ns->msg_hdrs);
+		percpu_counter_add_local(&ns->percpu_msg_bytes, msgsz);
+		percpu_counter_add_local(&ns->percpu_msg_hdrs, 1);
 	}
 
 	err = 0;
@@ -1159,8 +1161,8 @@ static long do_msgrcv(int msqid, void __
 			msq->q_rtime = ktime_get_real_seconds();
 			ipc_update_pid(&msq->q_lrpid, task_tgid(current));
 			msq->q_cbytes -= msg->m_ts;
-			atomic_sub(msg->m_ts, &ns->msg_bytes);
-			atomic_dec(&ns->msg_hdrs);
+			percpu_counter_sub_local(&ns->percpu_msg_bytes, msg->m_ts);
+			percpu_counter_sub_local(&ns->percpu_msg_hdrs, 1);
 			ss_wakeup(msq, &wake_q, false);
 
 			goto out_unlock0;
@@ -1297,20 +1299,34 @@ COMPAT_SYSCALL_DEFINE5(msgrcv, int, msqi
 }
 #endif
 
-void msg_init_ns(struct ipc_namespace *ns)
+int msg_init_ns(struct ipc_namespace *ns)
 {
+	int ret;
+
 	ns->msg_ctlmax = MSGMAX;
 	ns->msg_ctlmnb = MSGMNB;
 	ns->msg_ctlmni = MSGMNI;
 
-	atomic_set(&ns->msg_bytes, 0);
-	atomic_set(&ns->msg_hdrs, 0);
+	ret = percpu_counter_init(&ns->percpu_msg_bytes, 0, GFP_KERNEL);
+	if (ret)
+		goto fail_msg_bytes;
+	ret = percpu_counter_init(&ns->percpu_msg_hdrs, 0, GFP_KERNEL);
+	if (ret)
+		goto fail_msg_hdrs;
 	ipc_init_ids(&ns->ids[IPC_MSG_IDS]);
+	return 0;
+
+	fail_msg_hdrs:
+		percpu_counter_destroy(&ns->percpu_msg_bytes);
+	fail_msg_bytes:
+		return ret;
 }
 
 #ifdef CONFIG_IPC_NS
 void msg_exit_ns(struct ipc_namespace *ns)
 {
+	percpu_counter_destroy(&ns->percpu_msg_bytes);
+	percpu_counter_destroy(&ns->percpu_msg_hdrs);
 	free_ipcs(ns, &msg_ids(ns), freeque);
 	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
 	rhashtable_destroy(&ns->ids[IPC_MSG_IDS].key_ht);
--- a/ipc/namespace.c~ipc-msg-mitigate-the-lock-contention-with-percpu-counter
+++ a/ipc/namespace.c
@@ -66,8 +66,11 @@ static struct ipc_namespace *create_ipc_
 	if (!setup_ipc_sysctls(ns))
 		goto fail_mq;
 
+	err = msg_init_ns(ns);
+	if (err)
+		goto fail_put;
+
 	sem_init_ns(ns);
-	msg_init_ns(ns);
 	shm_init_ns(ns);
 
 	return ns;
--- a/ipc/util.h~ipc-msg-mitigate-the-lock-contention-with-percpu-counter
+++ a/ipc/util.h
@@ -64,7 +64,7 @@ static inline void mq_put_mnt(struct ipc
 
 #ifdef CONFIG_SYSVIPC
 void sem_init_ns(struct ipc_namespace *ns);
-void msg_init_ns(struct ipc_namespace *ns);
+int msg_init_ns(struct ipc_namespace *ns);
 void shm_init_ns(struct ipc_namespace *ns);
 
 void sem_exit_ns(struct ipc_namespace *ns);
@@ -72,7 +72,7 @@ void msg_exit_ns(struct ipc_namespace *n
 void shm_exit_ns(struct ipc_namespace *ns);
 #else
 static inline void sem_init_ns(struct ipc_namespace *ns) { }
-static inline void msg_init_ns(struct ipc_namespace *ns) { }
+static inline int msg_init_ns(struct ipc_namespace *ns) { return 0;}
 static inline void shm_init_ns(struct ipc_namespace *ns) { }
 
 static inline void sem_exit_ns(struct ipc_namespace *ns) { }
_

Patches currently in -mm which might be from jiebin.sun@intel.com are

percpu-add-percpu_counter_add_local-and-percpu_counter_sub_local.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch

