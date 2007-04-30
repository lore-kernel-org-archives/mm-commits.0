From: akpm@linux-foundation.org
Subject: - merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:30:23 -0700
Message-ID: <200704301930.l3UJUN75012919@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946729AbXD3TbA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:31:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, mm-commits@vger.kernel.org


The patch titled
     remove dup_namespaces() declaration
has been removed from the -mm tree.  Its filename was
     merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch

This patch was dropped because it was folded into merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch

------------------------------------------------------
Subject: remove dup_namespaces() declaration
From: Cedric Le Goater <clg@fr.ibm.com>

dup_namespaces() does not exist any more, so we should remove the
declaration from nsproxy.h.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nsproxy.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/nsproxy.h~merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix
+++ a/include/linux/nsproxy.h
@@ -31,7 +31,6 @@ struct nsproxy {
 };
 extern struct nsproxy init_nsproxy;
 
-struct nsproxy *dup_namespaces(struct nsproxy *orig);
 int copy_namespaces(int flags, struct task_struct *tsk);
 void get_task_namespaces(struct task_struct *tsk);
 void free_nsproxy(struct nsproxy *ns);
_

Patches currently in -mm which might be from clg@fr.ibm.com are

merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
attach_pid-with-struct-pid-parameter.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
