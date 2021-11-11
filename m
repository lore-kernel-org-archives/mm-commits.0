Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1DF7C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEE0661108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbhKKC5N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:57:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234632AbhKKC5M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:57:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BBEF61075;
        Thu, 11 Nov 2021 02:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599264;
        bh=QnY2pVf1wuwSGxRtb0a6Zi6Jp70vBxw574Hlch8x300=;
        h=Date:From:To:Subject:From;
        b=K332Q/26uqn8qBhxQH6gb+Fa9QpuOtPAPYOW8ZW46/9SlU+SOPxy+pvdNAZBtgNF7
         aotWaIAz09WMuMRGxt5RojRtV21Z4ypn2SQ+5gBvjwEgeCvNix3h3OUxdqKPluVL2+
         CfMnpPOKhBxskoEySN3v2FRgycfbBO/gOeXW1rSU=
Date:   Wed, 10 Nov 2021 18:54:24 -0800
From:   akpm@linux-foundation.org
To:     dbueso@suse.de, ebiederm@xmission.com, manfred@colorfullife.com,
        mclapinski@google.com, mm-commits@vger.kernel.org
Subject:  [merged]
 ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files.patch
 removed from -mm tree
Message-ID: <20211111025424.HmopAfCXr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: check checkpoint_restore_ns_capable() to modify C/R proc files
has been removed from the -mm tree.  Its filename was
     ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Clapinski <mclapinski@google.com>
Subject: ipc: check checkpoint_restore_ns_capable() to modify C/R proc files

This commit removes the requirement to be root to modify sem_next_id,
msg_next_id and shm_next_id and checks checkpoint_restore_ns_capable
instead.

Since those files are specific to the IPC namespace, there is no reason
they should require root privileges.  This is similar to ns_last_pid,
which also only checks checkpoint_restore_ns_capable.

[akpm@linux-foundation.org: ipc/ipc_sysctl.c needs capability.h for checkpoint_restore_ns_capable()]
Link: https://lkml.kernel.org/r/20210916163717.3179496-1-mclapinski@google.com
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Reviewed-by: Manfred Spraul <manfred@colorfullife.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/ipc/ipc_sysctl.c~ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files
+++ a/ipc/ipc_sysctl.c
@@ -10,6 +10,7 @@
 #include <linux/nsproxy.h>
 #include <linux/sysctl.h>
 #include <linux/uaccess.h>
+#include <linux/capability.h>
 #include <linux/ipc_namespace.h>
 #include <linux/msg.h>
 #include "util.h"
@@ -104,6 +105,19 @@ static int proc_ipc_sem_dointvec(struct
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
@@ -111,6 +125,9 @@ static int proc_ipc_sem_dointvec(struct
 #define proc_ipc_dointvec_minmax_orphans   NULL
 #define proc_ipc_auto_msgmni	   NULL
 #define proc_ipc_sem_dointvec	   NULL
+#ifdef CONFIG_CHECKPOINT_RESTORE
+#define proc_ipc_dointvec_minmax_checkpoint_restore	NULL
+#endif	/* CONFIG_CHECKPOINT_RESTORE */
 #endif
 
 int ipc_mni = IPCMNI;
@@ -198,8 +215,8 @@ static struct ctl_table ipc_kern_table[]
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
@@ -207,8 +224,8 @@ static struct ctl_table ipc_kern_table[]
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
@@ -216,8 +233,8 @@ static struct ctl_table ipc_kern_table[]
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


