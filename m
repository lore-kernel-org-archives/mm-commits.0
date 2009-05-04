From: akpm@linux-foundation.org
Subject: + ipcns-extract-create_ipc_ns.patch added to -mm tree
Date: Mon, 04 May 2009 16:40:25 -0700
Message-ID: <200905042340.n44NeP76021424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbZEDXme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 19:42:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, serue@us.ibm.com


The patch titled
     ipcns: extract create_ipc_ns()
has been added to the -mm tree.  Its filename is
     ipcns-extract-create_ipc_ns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipcns: extract create_ipc_ns()
From: Alexey Dobriyan <adobriyan@gmail.com>

clone_ipc_ns() is misnamed, it doesn't clone anything and doesn't use
passed parameter.  Rename it.

create_ipc_ns() will be used by C/R to create fresh ipcns.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/namespace.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN ipc/namespace.c~ipcns-extract-create_ipc_ns ipc/namespace.c
--- a/ipc/namespace.c~ipcns-extract-create_ipc_ns
+++ a/ipc/namespace.c
@@ -14,7 +14,7 @@
 
 #include "util.h"
 
-static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
+static struct ipc_namespace *create_ipc_ns(void)
 {
 	struct ipc_namespace *ns;
 	int err;
@@ -48,14 +48,9 @@ static struct ipc_namespace *clone_ipc_n
 
 struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
 {
-	struct ipc_namespace *new_ns;
-
 	if (!(flags & CLONE_NEWIPC))
 		return get_ipc_ns(ns);
-
-	new_ns = clone_ipc_ns(ns);
-
-	return new_ns;
+	return create_ipc_ns();
 }
 
 /*
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
fs-remove-sparse-errors-in-proc_devtreec.patch
procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch
mm-consolidate-init_mm-definition.patch
mm-consolidate-init_mm-definition-fix.patch
pagemap-document-clarifications.patch
pagemap-documentation-9-more-exported-page-flags.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
utsns-extract-creeate_uts_ns.patch
ipcns-remove-useless-get-put-while-clone_newipc.patch
ipcns-extract-create_ipc_ns.patch
pidns-1-2-make-create_pid_namespace-accept-parent-pidns.patch
pidns-2-2-rewrite-copy_pid_ns.patch

