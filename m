From: akpm@linux-foundation.org
Subject: + pid-namespace-limit-value-of-ns_last_pid-to-0-max_pid.patch added to -mm tree
Date: Tue, 04 Sep 2012 15:21:21 -0700
Message-ID: <20120904222122.2268D200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:34807 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757739Ab2IDWVZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 18:21:25 -0400
Received: by lagw12 with SMTP id w12so373516lag.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 15:21:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avagin@openvz.org, ebiederm@xmission.com, gorcunov@openvz.org, oleg@redhat.com, xemul@parallels.com


The patch titled
     Subject: pid-namespace: limit value of ns_last_pid to (0, max_pid)
has been added to the -mm tree.  Its filename is
     pid-namespace-limit-value-of-ns_last_pid-to-0-max_pid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Vagin <avagin@openvz.org>
Subject: pid-namespace: limit value of ns_last_pid to (0, max_pid)

The kernel doesn't check the pid for negative values, so if you try to
write -2 to /proc/sys/kernel/ns_last_pid, you will get a kernel panic.

The crash happens because the next pid is -1, and alloc_pidmap() will try
to access to a nonexistent pidmap.

map = &pid_ns->pidmap[pid/BITS_PER_PAGE];

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/pid_namespace.c~pid-namespace-limit-value-of-ns_last_pid-to-0-max_pid kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid-namespace-limit-value-of-ns_last_pid-to-0-max_pid
+++ a/kernel/pid_namespace.c
@@ -232,15 +232,19 @@ static int pid_ns_ctl_handler(struct ctl
 	 */
 
 	tmp.data = &current->nsproxy->pid_ns->last_pid;
-	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
+	return proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 }
 
+extern int pid_max;
+static int zero = 0;
 static struct ctl_table pid_ns_ctl_table[] = {
 	{
 		.procname = "ns_last_pid",
 		.maxlen = sizeof(int),
 		.mode = 0666, /* permissions are checked in the handler */
 		.proc_handler = pid_ns_ctl_handler,
+		.extra1 = &zero,
+		.extra2 = &pid_max,
 	},
 	{ }
 };
_

Patches currently in -mm which might be from avagin@openvz.org are

pid-namespace-limit-value-of-ns_last_pid-to-0-max_pid.patch
linux-next.patch

