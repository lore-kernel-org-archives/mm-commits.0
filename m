From: akpm@linux-foundation.org
Subject: + pidns-rewrite-copy_pid_ns.patch added to -mm tree
Date: Mon, 04 May 2009 16:42:05 -0700
Message-ID: <200905042342.n44Ng5xE022502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbZEDXpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 19:45:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ebiederm@xmission.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     pidns: rewrite copy_pid_ns()
has been added to the -mm tree.  Its filename is
     pidns-rewrite-copy_pid_ns.patch

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
Subject: pidns: rewrite copy_pid_ns()
From: Alexey Dobriyan <adobriyan@gmail.com>

copy_pid_ns() is a perfect example of a case where unwinding leads to more
code and makes it less clear.  Watch the diffstat.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN kernel/pid_namespace.c~pidns-rewrite-copy_pid_ns kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-rewrite-copy_pid_ns
+++ a/kernel/pid_namespace.c
@@ -116,23 +116,11 @@ static void destroy_pid_namespace(struct
 
 struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
 {
-	struct pid_namespace *new_ns;
-
-	BUG_ON(!old_ns);
-	new_ns = get_pid_ns(old_ns);
 	if (!(flags & CLONE_NEWPID))
-		goto out;
-
-	new_ns = ERR_PTR(-EINVAL);
+		return get_pid_ns(old_ns);
 	if (flags & CLONE_THREAD)
-		goto out_put;
-
-	new_ns = create_pid_namespace(old_ns);
-
-out_put:
-	put_pid_ns(old_ns);
-out:
-	return new_ns;
+		return ERR_PTR(-EINVAL);
+	return create_pid_namespace(old_ns);
 }
 
 void free_pid_ns(struct kref *kref)
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
pidns-make-create_pid_namespace-accept-parent-pidns.patch
pidns-rewrite-copy_pid_ns.patch
utsns-extract-creeate_uts_ns.patch
ipcns-remove-useless-get-put-while-clone_newipc.patch
ipcns-extract-create_ipc_ns.patch

