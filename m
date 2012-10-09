From: akpm@linux-foundation.org
Subject: + pidns-remove-recursion-from-free_pid_ns-v3.patch added to -mm tree
Date: Tue, 09 Oct 2012 11:48:34 -0700
Message-ID: <20121009184834.DB2ED100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:34054 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab2JISsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:48:36 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so668502vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:48:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avagin@openvz.org, ebiederm@xmission.com, gorcunov@openvz.org, greg@kroah.com, oleg@redhat.com, stable@vger.kernel.org, xemul@parallels.com


The patch titled
     Subject: pidns: remove recursion from free_pid_ns()
has been added to the -mm tree.  Its filename is
     pidns-remove-recursion-from-free_pid_ns-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Vagin <avagin@openvz.org>
Subject: pidns: remove recursion from free_pid_ns()

Here is a stack trace of recursion:
free_pid_ns(parent)
  put_pid_ns(parent)
    kref_put(&ns->kref, free_pid_ns);
      free_pid_ns

This patch turns the recursion into loops.

pidns can be nested many times, so in case of recursion a simple userspace
program can provoke a kernel panic due to exceed of a kernel stack.

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kref.h   |   12 ++++++++++++
 kernel/pid_namespace.c |   16 ++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff -puN include/linux/kref.h~pidns-remove-recursion-from-free_pid_ns-v3 include/linux/kref.h
--- a/include/linux/kref.h~pidns-remove-recursion-from-free_pid_ns-v3
+++ a/include/linux/kref.h
@@ -95,6 +95,18 @@ static inline int kref_put(struct kref *
 	return kref_sub(kref, 1, release);
 }
 
+/**
+ * kref_put - decrement refcount for object.
+ * @kref: object.
+ *
+ * Decrement the refcount.
+ * Return 1 if refcount is zero.
+ */
+static inline int __kref_put(struct kref *kref)
+{
+	return atomic_dec_and_test(&kref->refcount);
+}
+
 static inline int kref_put_mutex(struct kref *kref,
 				 void (*release)(struct kref *kref),
 				 struct mutex *lock)
diff -puN kernel/pid_namespace.c~pidns-remove-recursion-from-free_pid_ns-v3 kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-remove-recursion-from-free_pid_ns-v3
+++ a/kernel/pid_namespace.c
@@ -139,11 +139,19 @@ void free_pid_ns(struct kref *kref)
 
 	ns = container_of(kref, struct pid_namespace, kref);
 
-	parent = ns->parent;
-	destroy_pid_namespace(ns);
+	while (1) {
+		parent = ns->parent;
+		destroy_pid_namespace(ns);
 
-	if (parent != NULL)
-		put_pid_ns(parent);
+		if (parent == &init_pid_ns)
+			break;
+
+		/* kref_put cannot be used for avoiding recursion */
+		if (__kref_put(&parent->kref) == 0)
+			break;
+
+		ns = parent;
+	}
 }
 EXPORT_SYMBOL_GPL(free_pid_ns);
 
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch
pidns-remove-recursion-from-free_pid_ns-v3.patch

