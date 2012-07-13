From: akpm@linux-foundation.org
Subject: + nsproxy-move-free_nsproxy-out-of-do_exit-path.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:08:27 -0700
Message-ID: <20120713210827.947CA100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:47070 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2GMVI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:08:29 -0400
Received: by qcqs25 with SMTP id s25so387150qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:08:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, dledford@redhat.com, ebiederm@xmission.com, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, ldv@altlinux.org, serge.hallyn@ubuntu.com, viro@zeniv.linux.org.uk, xemul@openvz.org


The patch titled
     Subject: nsproxy: move free_nsproxy() out of do_exit() path
has been added to the -mm tree.  Its filename is
     nsproxy-move-free_nsproxy-out-of-do_exit-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: nsproxy: move free_nsproxy() out of do_exit() path

free_nsproxy() is too heavy to be on the exit path.  Let's free namespaces
asynchronously to not block exit_group() syscall.

Microbenchmark:

: #define _GNU_SOURCE
: #include <unistd.h>
: #include <sched.h>
: #include <stdlib.h>
: #include <sys/wait.h>
:
: int
: main(void)
: {
:       int i;
:       for (i = 0; i < 1024; i++) {
:               if (fork()) {
:                       wait(NULL);
:                       continue;
:               }
:               unshare(CLONE_NEWIPC);
:               exit(0);
:       }
:       return 0;
: }

Before the patch:

real    0m8.335s
user    0m0.000s
sys     0m0.265s

After:

real    0m0.569s
user    0m0.001s
sys     0m0.154s

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Doug Ledford <dledford@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nsproxy.h |    1 +
 kernel/nsproxy.c        |   34 +++++++++++++++++++++++-----------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff -puN include/linux/nsproxy.h~nsproxy-move-free_nsproxy-out-of-do_exit-path include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~nsproxy-move-free_nsproxy-out-of-do_exit-path
+++ a/include/linux/nsproxy.h
@@ -24,6 +24,7 @@ struct fs_struct;
  */
 struct nsproxy {
 	atomic_t count;
+	struct work_struct free_nsproxy_work;
 	struct uts_namespace *uts_ns;
 	struct ipc_namespace *ipc_ns;
 	struct mnt_namespace *mnt_ns;
diff -puN kernel/nsproxy.c~nsproxy-move-free_nsproxy-out-of-do_exit-path kernel/nsproxy.c
--- a/kernel/nsproxy.c~nsproxy-move-free_nsproxy-out-of-do_exit-path
+++ a/kernel/nsproxy.c
@@ -41,13 +41,17 @@ struct nsproxy init_nsproxy = {
 #endif
 };
 
+static void free_nsproxy_work(struct work_struct *work);
+
 static inline struct nsproxy *create_nsproxy(void)
 {
 	struct nsproxy *nsproxy;
 
 	nsproxy = kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
-	if (nsproxy)
+	if (nsproxy) {
 		atomic_set(&nsproxy->count, 1);
+		INIT_WORK(&nsproxy->free_nsproxy_work, free_nsproxy_work);
+	}
 	return nsproxy;
 }
 
@@ -166,6 +170,14 @@ out:
 
 void free_nsproxy(struct nsproxy *ns)
 {
+	/*
+	 * wait for others to get what they want from this nsproxy.
+	 *
+	 * cannot release this nsproxy via the call_rcu() since
+	 * put_mnt_ns() will want to sleep
+	 */
+	synchronize_rcu();
+
 	if (ns->mnt_ns)
 		put_mnt_ns(ns->mnt_ns);
 	if (ns->uts_ns)
@@ -178,6 +190,14 @@ void free_nsproxy(struct nsproxy *ns)
 	kmem_cache_free(nsproxy_cachep, ns);
 }
 
+static void free_nsproxy_work(struct work_struct *work)
+{
+	struct nsproxy *ns = container_of(work, struct nsproxy,
+			free_nsproxy_work);
+
+	free_nsproxy(ns);
+}
+
 /*
  * Called from unshare. Unshare all the namespaces part of nsproxy.
  * On success, returns the new nsproxy.
@@ -215,16 +235,8 @@ void switch_task_namespaces(struct task_
 
 	rcu_assign_pointer(p->nsproxy, new);
 
-	if (ns && atomic_dec_and_test(&ns->count)) {
-		/*
-		 * wait for others to get what they want from this nsproxy.
-		 *
-		 * cannot release this nsproxy via the call_rcu() since
-		 * put_mnt_ns() will want to sleep
-		 */
-		synchronize_rcu();
-		free_nsproxy(ns);
-	}
+	if (ns && atomic_dec_and_test(&ns->count))
+		schedule_work(&ns->free_nsproxy_work);
 }
 
 void exit_task_namespaces(struct task_struct *p)
_
Subject: Subject: nsproxy: move free_nsproxy() out of do_exit() path

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems.patch
nsproxy-move-free_nsproxy-out-of-do_exit-path.patch

