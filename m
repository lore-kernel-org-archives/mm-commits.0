From: akpm@linux-foundation.org
Subject: + utsns-extract-creeate_uts_ns.patch added to -mm tree
Date: Mon, 04 May 2009 16:39:25 -0700
Message-ID: <200905042339.n44NdPQI020804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328AbZEDXl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 19:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, serue@us.ibm.com


The patch titled
     utsns: extract creeate_uts_ns()
has been added to the -mm tree.  Its filename is
     utsns-extract-creeate_uts_ns.patch

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
Subject: utsns: extract creeate_uts_ns()
From: Alexey Dobriyan <adobriyan@gmail.com>

create_uts_ns() will be used by C/R to create fresh uts_ns.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/utsname.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN kernel/utsname.c~utsns-extract-creeate_uts_ns kernel/utsname.c
--- a/kernel/utsname.c~utsns-extract-creeate_uts_ns
+++ a/kernel/utsname.c
@@ -15,6 +15,16 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 
+static struct uts_namespace *create_uts_ns(void)
+{
+	struct uts_namespace *uts_ns;
+
+	uts_ns = kmalloc(sizeof(struct uts_namespace), GFP_KERNEL);
+	if (uts_ns)
+		kref_init(&uts_ns->kref);
+	return uts_ns;
+}
+
 /*
  * Clone a new ns copying an original utsname, setting refcount to 1
  * @old_ns: namespace to clone
@@ -24,14 +34,13 @@ static struct uts_namespace *clone_uts_n
 {
 	struct uts_namespace *ns;
 
-	ns = kmalloc(sizeof(struct uts_namespace), GFP_KERNEL);
+	ns = create_uts_ns();
 	if (!ns)
 		return ERR_PTR(-ENOMEM);
 
 	down_read(&uts_sem);
 	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
 	up_read(&uts_sem);
-	kref_init(&ns->kref);
 	return ns;
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
ipcns-1-2-remove-useless-get-put-while-clone_newipc.patch
ipcns-2-2-extract-create_ipc_ns.patch
pidns-1-2-make-create_pid_namespace-accept-parent-pidns.patch
pidns-2-2-rewrite-copy_pid_ns.patch

