Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD74C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 17:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E649610E9
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 17:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbhIPRyu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 13:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357896AbhIPRwZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 13:52:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE64F61056;
        Thu, 16 Sep 2021 17:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631814665;
        bh=zYIW2JMJeDULcrgs/kWuOfcu4hUU/nZNXnmPm3uPmJc=;
        h=Date:From:To:Subject:From;
        b=O362SfmnwmnxIUB1I74U7m0qKeqGF9kvNf7Ldmgdw8reJGrIwOTFONc0F3/KihdV2
         kCS3aOdtVB3mo7BV5vJWnVdFVj1FkFU2eRbl2Ih0gnp40lwMmtaPASmFOWNWsGXcI4
         5ob7KgjAnxztMvvvYVZw39RWTKtFaK2scwoN9Y30=
Date:   Thu, 16 Sep 2021 10:51:04 -0700
From:   akpm@linux-foundation.org
To:     dave@stgolabs.net, ebiederm@xmission.com, manfred@colorfullife.com,
        mclapinski@google.com, mm-commits@vger.kernel.org
Subject:  +
 ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files.patch
 added to -mm tree
Message-ID: <20210916175104.Fx0YqSM5k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: check checkpoint_restore_ns_capable() to modify C/R proc files
has been added to the -mm tree.  Its filename is
     ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Clapinski <mclapinski@google.com>
Subject: ipc: check checkpoint_restore_ns_capable() to modify C/R proc files

This commit removes the requirement to be root to modify sem_next_id,
msg_next_id and shm_next_id and checks checkpoint_restore_ns_capable
instead.

Since those files are specific to the IPC namespace, there is no reason
they should require root privileges.  This is similar to ns_last_pid,
which also only checks checkpoint_restore_ns_capable.

Link: https://lkml.kernel.org/r/20210916163717.3179496-1-mclapinski@google.com
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/ipc/ipc_sysctl.c~ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files
+++ a/ipc/ipc_sysctl.c
@@ -104,6 +104,19 @@ static int proc_ipc_sem_dointvec(struct
 	return ret;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static int proc_ipc_dointvec_minmax_checkpoint_restore(struct ctl_table *table,
+		int write, void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct user_namespace *user_ns = current->nsproxy->ipc_ns->user_ns;
+
+	if (write && !checkpoint_restore_ns_capable(user_ns))
+		return -EPERM;
+
+	return proc_ipc_dointvec_minmax(table, write, buffer, lenp, ppos);
+}
+#endif
+
 #else
 #define proc_ipc_doulongvec_minmax NULL
 #define proc_ipc_dointvec	   NULL
@@ -111,6 +124,9 @@ static int proc_ipc_sem_dointvec(struct
 #define proc_ipc_dointvec_minmax_orphans   NULL
 #define proc_ipc_auto_msgmni	   NULL
 #define proc_ipc_sem_dointvec	   NULL
+#ifdef CONFIG_CHECKPOINT_RESTORE
+#define proc_ipc_dointvec_minmax_checkpoint_restore	NULL
+#endif	/* CONFIG_CHECKPOINT_RESTORE */
 #endif
 
 int ipc_mni = IPCMNI;
@@ -198,8 +214,8 @@ static struct ctl_table ipc_kern_table[]
 		.procname	= "sem_next_id",
 		.data		= &init_ipc_ns.ids[IPC_SEM_IDS].next_id,
 		.maxlen		= sizeof(init_ipc_ns.ids[IPC_SEM_IDS].next_id),
-		.mode		= 0644,
-		.proc_handler	= proc_ipc_dointvec_minmax,
+		.mode		= 0666,
+		.proc_handler	= proc_ipc_dointvec_minmax_checkpoint_restore,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_INT_MAX,
 	},
@@ -207,8 +223,8 @@ static struct ctl_table ipc_kern_table[]
 		.procname	= "msg_next_id",
 		.data		= &init_ipc_ns.ids[IPC_MSG_IDS].next_id,
 		.maxlen		= sizeof(init_ipc_ns.ids[IPC_MSG_IDS].next_id),
-		.mode		= 0644,
-		.proc_handler	= proc_ipc_dointvec_minmax,
+		.mode		= 0666,
+		.proc_handler	= proc_ipc_dointvec_minmax_checkpoint_restore,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_INT_MAX,
 	},
@@ -216,8 +232,8 @@ static struct ctl_table ipc_kern_table[]
 		.procname	= "shm_next_id",
 		.data		= &init_ipc_ns.ids[IPC_SHM_IDS].next_id,
 		.maxlen		= sizeof(init_ipc_ns.ids[IPC_SHM_IDS].next_id),
-		.mode		= 0644,
-		.proc_handler	= proc_ipc_dointvec_minmax,
+		.mode		= 0666,
+		.proc_handler	= proc_ipc_dointvec_minmax_checkpoint_restore,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_INT_MAX,
 	},
_

Patches currently in -mm which might be from mclapinski@google.com are

ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files.patch

