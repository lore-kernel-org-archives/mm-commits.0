From: akpm@linux-foundation.org
Subject: + proc-ns-use-d_set_d_op-api-to-set-dentry-ops-in-proc_ns_instantiate.patch added to -mm tree
Date: Thu, 22 Mar 2012 16:18:24 -0700
Message-ID: <20120322231824.B9684A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:33739 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031470Ab2CVXS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 19:18:26 -0400
Received: by qcsp5 with SMTP id p5so217360qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 16:18:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pshelar@nicira.com, davem@davemloft.net, ebiederm@xmission.com, jesse@nicira.com, jpettit@nicira.com


The patch titled
     Subject: proc-ns: use d_set_d_op() API to set dentry ops in proc_ns_instantiate().
has been added to the -mm tree.  Its filename is
     proc-ns-use-d_set_d_op-api-to-set-dentry-ops-in-proc_ns_instantiate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pravin B Shelar <pshelar@nicira.com>
Subject: proc-ns: use d_set_d_op() API to set dentry ops in proc_ns_instantiate().

Use d_set_d_op() so that DCACHE_OP_* flags are set correctly which fixes
ns cleanup path i.e.  `ip netns delete `.

This issue exists back to 3.0.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reported-by: Justin Pettit <jpettit@nicira.com>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Jesse Gross <jesse@nicira.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/namespaces.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/namespaces.c~proc-ns-use-d_set_d_op-api-to-set-dentry-ops-in-proc_ns_instantiate fs/proc/namespaces.c
--- a/fs/proc/namespaces.c~proc-ns-use-d_set_d_op-api-to-set-dentry-ops-in-proc_ns_instantiate
+++ a/fs/proc/namespaces.c
@@ -53,7 +53,7 @@ static struct dentry *proc_ns_instantiat
 	ei->ns_ops    = ns_ops;
 	ei->ns	      = ns;
 
-	dentry->d_op = &pid_dentry_operations;
+	d_set_d_op(dentry, &pid_dentry_operations);
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
 	if (pid_revalidate(dentry, NULL))
_
Subject: Subject: proc-ns: use d_set_d_op() API to set dentry ops in proc_ns_instantiate().

Patches currently in -mm which might be from pshelar@nicira.com are

proc-ns-use-d_set_d_op-api-to-set-dentry-ops-in-proc_ns_instantiate.patch

