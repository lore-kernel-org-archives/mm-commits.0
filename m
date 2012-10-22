From: akpm@linux-foundation.org
Subject: [merged] pidns-remove-recursion-from-free_pid_ns-v5.patch removed from -mm tree
Date: Mon, 22 Oct 2012 12:13:30 -0700
Message-ID: <20121022191330.B75D61E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40684 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2JVTNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 15:13:32 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so376908vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 12:13:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, avagin@openvz.org, ebiederm@xmission.com, greg@kroah.com, oleg@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns: remove recursion from free_pid_ns()
has been removed from the -mm tree.  Its filename was
     pidns-remove-recursion-from-free_pid_ns-v5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: pidns: remove recursion from free_pid_ns()

free_pid_ns() operates in a recursive fashion:

free_pid_ns(parent)
  put_pid_ns(parent)
    kref_put(&ns->kref, free_pid_ns);
      free_pid_ns

thus if there was a huge nesting of namespaces the userspace may trigger
avalanche calling of free_pid_ns leading to kernel stack exhausting and a
panic eventually.

This patch turns the recursion into an iterative loop.

Based on a patch by Andrew Vagin.

[akpm@linux-foundation.org: export put_pid_ns() to modules]
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    8 +-------
 kernel/pid_namespace.c        |   21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff -puN include/linux/pid_namespace.h~pidns-remove-recursion-from-free_pid_ns-v5 include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pidns-remove-recursion-from-free_pid_ns-v5
+++ a/include/linux/pid_namespace.h
@@ -47,15 +47,9 @@ static inline struct pid_namespace *get_
 }
 
 extern struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns);
-extern void free_pid_ns(struct kref *kref);
 extern void zap_pid_ns_processes(struct pid_namespace *pid_ns);
 extern int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd);
-
-static inline void put_pid_ns(struct pid_namespace *ns)
-{
-	if (ns != &init_pid_ns)
-		kref_put(&ns->kref, free_pid_ns);
-}
+extern void put_pid_ns(struct pid_namespace *ns);
 
 #else /* !CONFIG_PID_NS */
 #include <linux/err.h>
diff -puN kernel/pid_namespace.c~pidns-remove-recursion-from-free_pid_ns-v5 kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-remove-recursion-from-free_pid_ns-v5
+++ a/kernel/pid_namespace.c
@@ -133,19 +133,26 @@ struct pid_namespace *copy_pid_ns(unsign
 	return create_pid_namespace(old_ns);
 }
 
-void free_pid_ns(struct kref *kref)
+static void free_pid_ns(struct kref *kref)
 {
-	struct pid_namespace *ns, *parent;
+	struct pid_namespace *ns;
 
 	ns = container_of(kref, struct pid_namespace, kref);
-
-	parent = ns->parent;
 	destroy_pid_namespace(ns);
+}
+
+void put_pid_ns(struct pid_namespace *ns)
+{
+	struct pid_namespace *parent;
 
-	if (parent != NULL)
-		put_pid_ns(parent);
+	while (ns != &init_pid_ns) {
+		parent = ns->parent;
+		if (!kref_put(&ns->kref, free_pid_ns))
+			break;
+		ns = parent;
+	}
 }
-EXPORT_SYMBOL_GPL(free_pid_ns);
+EXPORT_SYMBOL_GPL(put_pid_ns);
 
 void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 {
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

