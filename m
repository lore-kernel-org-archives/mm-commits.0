From: akpm@linux-foundation.org
Subject: + sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:37:42 -0800
Message-ID: <20120113223742.9C1C11E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:45298 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2AMWho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:37:44 -0500
Received: by qcsc20 with SMTP id c20so110560qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 14:37:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, gorcunov@openvz.org, oleg@redhat.com, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: sysctl: make kernel.ns_last_pid control dependent on CHECKPOINT_RESTORE
has been added to the -mm tree.  Its filename is
     sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -191,6 +191,7 @@ void zap_pid_ns_processes(struct pid_nam
 	return;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static int pid_ns_ctl_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -218,13 +219,16 @@ static struct ctl_table pid_ns_ctl_table
 	},
 	{ }
 };
