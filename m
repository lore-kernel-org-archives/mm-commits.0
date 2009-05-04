From: akpm@linux-foundation.org
Subject: + ipcns-remove-useless-get-put-while-clone_newipc.patch added to -mm tree
Date: Mon, 04 May 2009 16:40:22 -0700
Message-ID: <200905042340.n44NeMdb021415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbZEDXmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 19:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, serue@us.ibm.com


The patch titled
     ipcns: remove useless get/put while CLONE_NEWIPC
has been added to the -mm tree.  Its filename is
     ipcns-remove-useless-get-put-while-clone_newipc.patch

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
Subject: ipcns: remove useless get/put while CLONE_NEWIPC
From: Alexey Dobriyan <adobriyan@gmail.com>

copy_ipcs() doesn't actually copy anything. If new ipcns is created, it's
created from scratch, in this case get/put on old ipcns isn't needed.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/namespace.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN ipc/namespace.c~ipcns-remove-useless-get-put-while-clone_newipc ipc/namespace.c
--- a/ipc/namespace.c~ipcns-remove-useless-get-put-while-clone_newipc
+++ a/ipc/namespace.c
@@ -50,15 +50,11 @@ struct ipc_namespace *copy_ipcs(unsigned
 {
 	struct ipc_namespace *new_ns;
 
-	BUG_ON(!ns);
-	get_ipc_ns(ns);
-
 	if (!(flags & CLONE_NEWIPC))
-		return ns;
+		return get_ipc_ns(ns);
 
 	new_ns = clone_ipc_ns(ns);
 
-	put_ipc_ns(ns);
 	return new_ns;
 }
 
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
ipcns-2-2-extract-create_ipc_ns.patch
pidns-1-2-make-create_pid_namespace-accept-parent-pidns.patch
pidns-2-2-rewrite-copy_pid_ns.patch

