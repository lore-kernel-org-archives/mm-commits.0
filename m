From: akpm@linux-foundation.org
Subject: + pidns-make-create_pid_namespace-accept-parent-pidns.patch added to -mm tree
Date: Mon, 04 May 2009 16:41:57 -0700
Message-ID: <200905042341.n44Nfveq022397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbZEDXor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 19:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ebiederm@xmission.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     pidns: make create_pid_namespace() accept parent pidns
has been added to the -mm tree.  Its filename is
     pidns-make-create_pid_namespace-accept-parent-pidns.patch

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
Subject: pidns: make create_pid_namespace() accept parent pidns
From: Alexey Dobriyan <adobriyan@gmail.com>

create_pid_namespace() creates everything, but caller has to assign parent
pidns by hand, which is unnatural.  At the moment of call new ->level has
to be taken from somewhere and parent pidns is already available.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/pid_namespace.c~pidns-make-create_pid_namespace-accept-parent-pidns kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-make-create_pid_namespace-accept-parent-pidns
+++ a/kernel/pid_namespace.c
@@ -67,9 +67,10 @@ err_alloc:
 	return NULL;
 }
 
-static struct pid_namespace *create_pid_namespace(unsigned int level)
+static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
 {
 	struct pid_namespace *ns;
+	unsigned int level = parent_pid_ns->level + 1;
 	int i;
 
 	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
@@ -86,6 +87,7 @@ static struct pid_namespace *create_pid_
 
 	kref_init(&ns->kref);
 	ns->level = level;
+	ns->parent = get_pid_ns(parent_pid_ns);
 
 	set_bit(0, ns->pidmap[0].page);
 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
@@ -125,9 +127,7 @@ struct pid_namespace *copy_pid_ns(unsign
 	if (flags & CLONE_THREAD)
 		goto out_put;
 
-	new_ns = create_pid_namespace(old_ns->level + 1);
-	if (!IS_ERR(new_ns))
-		new_ns->parent = get_pid_ns(old_ns);
+	new_ns = create_pid_namespace(old_ns);
 
 out_put:
 	put_pid_ns(old_ns);
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
pidns-2-2-rewrite-copy_pid_ns.patch
utsns-extract-creeate_uts_ns.patch
ipcns-remove-useless-get-put-while-clone_newipc.patch
ipcns-extract-create_ipc_ns.patch

