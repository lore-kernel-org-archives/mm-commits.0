From: akpm@linux-foundation.org
Subject: [merged] proc-ns-use-d_set_d_op-api-to-set-dentry-ops-in-proc_ns_instantiate.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:50 -0700
Message-ID: <20120326193250.80E92A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:61517 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab2CZTcx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pshelar@nicira.com, davem@davemloft.net, ebiederm@xmission.com, jesse@nicira.com, jpettit@nicira.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-ns: use d_set_d_op() API to set dentry ops in proc_ns_instantiate().
has been removed from the -mm tree.  Its filename was
     proc-ns-use-d_set_d_op-api-to-set-dentry-ops-in-proc_ns_instantiate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Pravin B Shelar <pshelar@nicira.com>
Subject: proc-ns: use d_set_d_op() API to set dentry ops in proc_ns_instantiate().

The namespace cleanup path leaks a dentry which holds a reference count on
a network namespace.  Keeping that network namespace from being freed when
the last user goes away.  Leaving things like vlan devices in the leaked network namespace.

If you use ip netns add for much real work this problem becomes apparent
pretty quickly.  It light testing the problem hides because frequently you
simply don't notice the leak.

Use d_set_d_op() so that DCACHE_OP_* flags are set correctly.

This issue exists back to 3.0.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reported-by: Justin Pettit <jpettit@nicira.com>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Jesse Gross <jesse@nicira.com>
Cc: David Miller <davem@davemloft.net>
Cc: <stable@vger.kernel.org>
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

Patches currently in -mm which might be from pshelar@nicira.com are

origin.patch

