From: akpm@linux-foundation.org
Subject: [merged] sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:35:20 -0700
Message-ID: <20120601193520.6DF6DA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:42188 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab2FATfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:35:21 -0400
Received: by mail-vc0-f202.google.com with SMTP id fl13so245573vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:35:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, gorcunov@openvz.org, oleg@redhat.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_RESTORE
has been removed from the -mm tree.  Its filename was
     sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_RESTORE

For those who doesn't need C/R functionality there is no need to control
last pid, ie the pid for the next fork() call.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/pid_namespace.c~sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent
+++ a/kernel/pid_namespace.c
@@ -196,6 +196,7 @@ void zap_pid_ns_processes(struct pid_nam
 	return;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static int pid_ns_ctl_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -223,8 +224,8 @@ static struct ctl_table pid_ns_ctl_table
 	},
 	{ }
 };
