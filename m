From: akpm@linux-foundation.org
Subject: + merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch added to -mm tree
Date: Sat, 24 Mar 2007 23:50:35 -0800
Message-ID: <200703250750.l2P7oZYD023166@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35370 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbXCYHum (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 03:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com


The patch titled
     remove dup_namespaces() declaration
has been added to the -mm tree.  Its filename is
     merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
