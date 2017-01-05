From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-add-ability-to-report-non-pf-events-from-uffd-descriptor.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:53:29 -0800
Message-ID: <586d9909.9VaFAaf0TPDpcnER%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36196 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935064AbdAEAyU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@parallels.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: add ability to report non-PF events from uffd descriptor
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-add-ability-to-report-non-pf-events-from-uffd-descriptor.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-add-ability-to-report-non-pf-events-from-uffd-descriptor.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-add-ability-to-report-non-pf-events-from-uffd-descriptor.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: userfaultfd: non-cooperative: add ability to report non-PF events from uffd descriptor

The custom events are queued in ctx->event_wqh not to disturb the
fast-path-ed PF queue-wait-wakeup functions.

The events to be generated (other than PF-s) are requested in UFFD_API
ioctl with the uffd_api.features bits. Those, known by the kernel, are
then turned on and reported back to the user-space.

Link: http://lkml.kernel.org/r/20161216144821.5183-7-aarcange@redhat.com
Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   98 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 96 insertions(+), 2 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-add-ability-to-report-non-pf-events-from-uffd-descriptor fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-add-ability-to-report-non-pf-events-from-uffd-descriptor
+++ a/fs/userfaultfd.c
@@ -12,6 +12,7 @@
  *  mm/ksm.c (mm hashing).
  */
 
+#include <linux/list.h>
 #include <linux/hashtable.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
@@ -45,12 +46,16 @@ struct userfaultfd_ctx {
 	wait_queue_head_t fault_wqh;
 	/* waitqueue head for the pseudo fd to wakeup poll/read */
 	wait_queue_head_t fd_wqh;
+	/* waitqueue head for events */
+	wait_queue_head_t event_wqh;
 	/* a refile sequence protected by fault_pending_wqh lock */
 	struct seqcount refile_seq;
 	/* pseudo fd refcounting */
 	atomic_t refcount;
 	/* userfaultfd syscall flags */
 	unsigned int flags;
+	/* features requested from the userspace */
+	unsigned int features;
 	/* state machine */
 	enum userfaultfd_state state;
 	/* released */
@@ -135,6 +140,8 @@ static void userfaultfd_ctx_put(struct u
 		VM_BUG_ON(waitqueue_active(&ctx->fault_pending_wqh));
 		VM_BUG_ON(spin_is_locked(&ctx->fault_wqh.lock));
 		VM_BUG_ON(waitqueue_active(&ctx->fault_wqh));
+		VM_BUG_ON(spin_is_locked(&ctx->event_wqh.lock));
+		VM_BUG_ON(waitqueue_active(&ctx->event_wqh));
 		VM_BUG_ON(spin_is_locked(&ctx->fd_wqh.lock));
 		VM_BUG_ON(waitqueue_active(&ctx->fd_wqh));
 		mmdrop(ctx->mm);
@@ -425,6 +432,59 @@ out:
 	return ret;
 }
 
+static int __maybe_unused userfaultfd_event_wait_completion(
+		struct userfaultfd_ctx *ctx,
+		struct userfaultfd_wait_queue *ewq)
+{
+	int ret = 0;
+
+	ewq->ctx = ctx;
+	init_waitqueue_entry(&ewq->wq, current);
+
+	spin_lock(&ctx->event_wqh.lock);
+	/*
+	 * After the __add_wait_queue the uwq is visible to userland
+	 * through poll/read().
+	 */
+	__add_wait_queue(&ctx->event_wqh, &ewq->wq);
+	for (;;) {
+		set_current_state(TASK_KILLABLE);
+		if (ewq->msg.event == 0)
+			break;
+		if (ACCESS_ONCE(ctx->released) ||
+		    fatal_signal_pending(current)) {
+			ret = -1;
+			__remove_wait_queue(&ctx->event_wqh, &ewq->wq);
+			break;
+		}
+
+		spin_unlock(&ctx->event_wqh.lock);
+
+		wake_up_poll(&ctx->fd_wqh, POLLIN);
+		schedule();
+
+		spin_lock(&ctx->event_wqh.lock);
+	}
+	__set_current_state(TASK_RUNNING);
+	spin_unlock(&ctx->event_wqh.lock);
+
+	/*
+	 * ctx may go away after this if the userfault pseudo fd is
+	 * already released.
+	 */
+
+	userfaultfd_ctx_put(ctx);
+	return ret;
+}
+
+static void userfaultfd_event_complete(struct userfaultfd_ctx *ctx,
+				       struct userfaultfd_wait_queue *ewq)
+{
+	ewq->msg.event = 0;
+	wake_up_locked(&ctx->event_wqh);
+	__remove_wait_queue(&ctx->event_wqh, &ewq->wq);
+}
+
 static int userfaultfd_release(struct inode *inode, struct file *file)
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
@@ -513,6 +573,12 @@ static inline struct userfaultfd_wait_qu
 	return find_userfault_in(&ctx->fault_pending_wqh);
 }
 
+static inline struct userfaultfd_wait_queue *find_userfault_evt(
+		struct userfaultfd_ctx *ctx)
+{
+	return find_userfault_in(&ctx->event_wqh);
+}
+
 static unsigned int userfaultfd_poll(struct file *file, poll_table *wait)
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
@@ -544,6 +610,9 @@ static unsigned int userfaultfd_poll(str
 		smp_mb();
 		if (waitqueue_active(&ctx->fault_pending_wqh))
 			ret = POLLIN;
+		else if (waitqueue_active(&ctx->event_wqh))
+			ret = POLLIN;
+
 		return ret;
 	default:
 		WARN_ON_ONCE(1);
@@ -608,6 +677,19 @@ static ssize_t userfaultfd_ctx_read(stru
 			break;
 		}
 		spin_unlock(&ctx->fault_pending_wqh.lock);
+
+		spin_lock(&ctx->event_wqh.lock);
+		uwq = find_userfault_evt(ctx);
+		if (uwq) {
+			*msg = uwq->msg;
+
+			userfaultfd_event_complete(ctx, uwq);
+			spin_unlock(&ctx->event_wqh.lock);
+			ret = 0;
+			break;
+		}
+		spin_unlock(&ctx->event_wqh.lock);
+
 		if (signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
@@ -1151,6 +1233,14 @@ out:
 	return ret;
 }
 
+static inline unsigned int uffd_ctx_features(__u64 user_features)
+{
+	/*
+	 * For the current set of features the bits just coincide
+	 */
+	return (unsigned int)user_features;
+}
+
 /*
  * userland asks for a certain API version and we return which bits
  * and ioctl commands are implemented in this kernel for such API
@@ -1169,19 +1259,21 @@ static int userfaultfd_api(struct userfa
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
-	if (uffdio_api.api != UFFD_API || uffdio_api.features) {
+	if (uffdio_api.api != UFFD_API ||
+	    (uffdio_api.features & ~UFFD_API_FEATURES)) {
 		memset(&uffdio_api, 0, sizeof(uffdio_api));
 		if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
 			goto out;
 		ret = -EINVAL;
 		goto out;
 	}
-	uffdio_api.features = UFFD_API_FEATURES;
+	uffdio_api.features &= UFFD_API_FEATURES;
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
 	ret = -EFAULT;
 	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
 		goto out;
 	ctx->state = UFFD_STATE_RUNNING;
+	ctx->features = uffd_ctx_features(uffdio_api.features);
 	ret = 0;
 out:
 	return ret;
@@ -1268,6 +1360,7 @@ static void init_once_userfaultfd_ctx(vo
 
 	init_waitqueue_head(&ctx->fault_pending_wqh);
 	init_waitqueue_head(&ctx->fault_wqh);
+	init_waitqueue_head(&ctx->event_wqh);
 	init_waitqueue_head(&ctx->fd_wqh);
 	seqcount_init(&ctx->refile_seq);
 }
@@ -1308,6 +1401,7 @@ static struct file *userfaultfd_file_cre
 
 	atomic_set(&ctx->refcount, 1);
 	ctx->flags = flags;
+	ctx->features = 0;
 	ctx->state = UFFD_STATE_WAIT_API;
 	ctx->released = false;
 	ctx->mm = current->mm;
_

Patches currently in -mm which might be from xemul@parallels.com are

userfaultfd-non-cooperative-split-the-find_userfault-routine.patch
userfaultfd-non-cooperative-add-ability-to-report-non-pf-events-from-uffd-descriptor.patch
userfaultfd-non-cooperative-add-fork-event.patch
userfaultfd-non-cooperative-add-mremap-event.patch
userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request.patch

