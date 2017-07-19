From: akpm@linux-foundation.org
Subject: +
 ipc-convert-ipc_namespacecount-from-atomic_t-to-refcount_t.patch added to
 -mm tree
Date: Wed, 19 Jul 2017 15:34:32 -0700
Message-ID: <596fde78.Yj9DTeJtG9FZoMWd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932078AbdGSWee (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 18:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elena.reshetova@intel.com, adobriyan@gmail.com, arozansk@redhat.com, dave@stgolabs.net, dwindsor@gmail.com, ebiederm@xmission.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, keescook@chromium.org, manfred@colorfullife.com, mingo@redhat.com, peterz@infradead.org, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: convert ipc_namespace.count from atomic_t to refcount_t
has been added to the -mm tree.  Its filename is
     ipc-convert-ipc_namespacecount-from-atomic_t-to-refcount_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-convert-ipc_namespacecount-from-atomic_t-to-refcount_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-convert-ipc_namespacecount-from-atomic_t-to-refcount_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: ipc: convert ipc_namespace.count from atomic_t to refcount_t

refcount_t type and corresponding API should be used instead of atomic_t
when the variable is used as a reference counter.  This allows to avoid
accidental refcounter overflows that might lead to use-after-free
situations.

Link: http://lkml.kernel.org/r/1499417992-3238-2-git-send-email-elena.reshetova@intel.com
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: <arozansk@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    5 +++--
 ipc/msgutil.c                 |    2 +-
 ipc/namespace.c               |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-convert-ipc_namespacecount-from-atomic_t-to-refcount_t include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-convert-ipc_namespacecount-from-atomic_t-to-refcount_t
+++ a/include/linux/ipc_namespace.h
@@ -7,6 +7,7 @@
 #include <linux/notifier.h>
 #include <linux/nsproxy.h>
 #include <linux/ns_common.h>
+#include <linux/refcount.h>
 
 struct user_namespace;
 
@@ -19,7 +20,7 @@ struct ipc_ids {
 };
 
 struct ipc_namespace {
-	atomic_t	count;
+	refcount_t	count;
 	struct ipc_ids	ids[3];
 
 	int		sem_ctls[4];
@@ -118,7 +119,7 @@ extern struct ipc_namespace *copy_ipcs(u
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 {
 	if (ns)
-		atomic_inc(&ns->count);
+		refcount_inc(&ns->count);
 	return ns;
 }
 
diff -puN ipc/msgutil.c~ipc-convert-ipc_namespacecount-from-atomic_t-to-refcount_t ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-convert-ipc_namespacecount-from-atomic_t-to-refcount_t
+++ a/ipc/msgutil.c
@@ -29,7 +29,7 @@ DEFINE_SPINLOCK(mq_lock);
  * and not CONFIG_IPC_NS.
  */
 struct ipc_namespace init_ipc_ns = {
-	.count		= ATOMIC_INIT(1),
+	.count		= REFCOUNT_INIT(1),
 	.user_ns = &init_user_ns,
 	.ns.inum = PROC_IPC_INIT_INO,
 #ifdef CONFIG_IPC_NS
diff -puN ipc/namespace.c~ipc-convert-ipc_namespacecount-from-atomic_t-to-refcount_t ipc/namespace.c
--- a/ipc/namespace.c~ipc-convert-ipc_namespacecount-from-atomic_t-to-refcount_t
+++ a/ipc/namespace.c
@@ -50,7 +50,7 @@ static struct ipc_namespace *create_ipc_
 		goto fail_free;
 	ns->ns.ops = &ipcns_operations;
 
-	atomic_set(&ns->count, 1);
+	refcount_set(&ns->count, 1);
 	ns->user_ns = get_user_ns(user_ns);
 	ns->ucounts = ucounts;
 
@@ -144,7 +144,7 @@ static void free_ipc_ns(struct ipc_names
  */
 void put_ipc_ns(struct ipc_namespace *ns)
 {
-	if (atomic_dec_and_lock(&ns->count, &mq_lock)) {
+	if (refcount_dec_and_lock(&ns->count, &mq_lock)) {
 		mq_clear_sbinfo(ns);
 		spin_unlock(&mq_lock);
 		mq_put_mnt(ns);
_

Patches currently in -mm which might be from elena.reshetova@intel.com are

ipc-convert-ipc_namespacecount-from-atomic_t-to-refcount_t.patch
ipc-convert-sem_undo_listrefcnt-from-atomic_t-to-refcount_t.patch
ipc-convert-kern_ipc_permrefcount-from-atomic_t-to-refcount_t.patch

