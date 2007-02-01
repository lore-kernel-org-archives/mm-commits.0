From: akpm@osdl.org
Subject: - aio-completion-signal-notification.patch removed from -mm tree
Date: Thu, 01 Feb 2007 14:56:16 -0800
Message-ID: <200702012256.l11MuHoY025460@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46333 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933023AbXBAW5I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:57:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.dugue@bull.net, bcrl@kvack.org, drepper@redhat.com, laurent.vivier@bull.net, mingo@elte.hu, suparna@in.ibm.com, tglx@linutronix.de, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: AIO completion signal notification
has been removed from the -mm tree.  Its filename was
     aio-completion-signal-notification.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: aio: AIO completion signal notification
=46rom: Sbastien Dugu <sebastien.dugue@bull.net>

The current 2.6 kernel does not support notification of user space via =
an RT
signal upon an asynchronous IO completion.  The POSIX specification sta=
tes
that when an AIO request completes, a signal can be delivered to the
application as notification.

This patch adds a struct sigevent *aio_sigeventp to the iocb.  The rele=
vant
fields (pid, signal number and value) are stored in the kiocb for use w=
hen the
request completes.

That sigevent structure is filled by the application as part of the AIO
request preparation.  Upon request completion, the kernel notifies the
application using those sigevent parameters.  If SIGEV_NONE has been
specified, then the old behaviour is retained and the application must =
rely on
polling the completion queue using io_getevents().

A struct sigevent *aio_sigeventp field is added to struct iocb in
include/linux/aio_abi.h

A struct aio_notify containing the sigevent parameters is defined in ai=
o.h:

  struct aio_notify {
	struct task_struct	*target;
	__u16			signo;
	__u16			notify;
	sigval_t		value;
  };

A struct aio_notify ki_notify is added to struct kiocb in include/linux=
/aio.h

In io_submit_one(), if the application provided a sigevent then
setup_sigevent() is called which does the following:

	- check access to the user sigevent and make a local copy

	- if the requested notification is SIGEV_NONE, then nothing to do

	- fill in the kiocb->ki_notify fields (notify, signo, value)

	- check sigevent consistency, get the signal target task and
	  save it in kiocb->ki_notify.target

	- preallocate a sigqueue for this event using sigqueue_alloc()

Upon request completion, in aio_complete(), if notification is needed f=
or this
request (iocb->ki_notify.notify !=3D SIGEV_NONE), then aio_send_signal(=
) is
called to signal the target task as follows:

	- fill in the siginfo struct to be sent to the task

	- if notify is SIGEV_THREAD_ID then send signal to specific task
	  using send_sigqueue()

	- else send signal to task group using send_5group_sigqueue()

Notes concerning sigqueue preallocation:

To ensure reliable delivery of completion notification, the sigqueue is
preallocated in the submission path so that there is no chance it can f=
ail in
the completion path.

Unlike the posix-timers case (currently the single other user of sigque=
ue
preallocation), where the sigqueue is allocated for the lifetime of the=
 timer
and freed at timer destruction time, the aio case is a bit more tricky =
due to
the async nature of the whole thing.

In the aio case, the sigqueue exists for the lifetime of the request,
therefore it must be freed only once the signal for the request complet=
ion has
been delivered.  This involves changing __sigqueue_free() to free the s=
igqueue
when the signal is collected if si_code is SI_ASYNCIO even if it was
preallocated as well as explicitly calling sigqueue_free() in submissio=
n and
completion error paths.

Signed-off-by: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Signed-off-by: Laurent Vivier <laurent.vivier@bull.net>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c                |  115 ++++++++++++++++++++++++++++++++++++--
 fs/compat.c             |   18 +++++
 include/linux/aio.h     |   12 +++
 include/linux/aio_abi.h |    3=20
 kernel/signal.c         |    2=20
 5 files changed, 144 insertions(+), 6 deletions(-)

diff -puN fs/aio.c~aio-completion-signal-notification fs/aio.c
--- a/fs/aio.c~aio-completion-signal-notification
+++ a/fs/aio.c
@@ -419,6 +419,7 @@ static struct kiocb fastcall *__aio_get_
 	req->ki_dtor =3D NULL;
 	req->private =3D NULL;
 	req->ki_iovec =3D NULL;
+	req->ki_notify.sigq =3D NULL;
 	INIT_LIST_HEAD(&req->ki_run_list);
=20
 	/* Check if the completion queue has enough free space to
@@ -465,6 +466,12 @@ static inline void really_put_req(struct
 		req->ki_dtor(req);
 	if (req->ki_iovec !=3D &req->ki_inline_vec)
 		kfree(req->ki_iovec);
+
+	/* Release task ref */
+	if (req->ki_notify.notify =3D=3D SIGEV_THREAD_ID ||
+	    req->ki_notify.notify =3D=3D SIGEV_SIGNAL)
+		put_task_struct(req->ki_notify.target);
+
 	kmem_cache_free(kiocb_cachep, req);
 	ctx->reqs_active--;
=20
@@ -916,6 +923,79 @@ void fastcall kick_iocb(struct kiocb *io
 }
 EXPORT_SYMBOL(kick_iocb);
=20
+static int aio_send_signal(struct aio_notify *notify)
+{
+	struct sigqueue *sigq =3D notify->sigq;
+	struct siginfo *info =3D &sigq->info;
+	int ret;
+
+	memset(info, 0, sizeof(struct siginfo));
+
+	info->si_signo =3D notify->signo;
+	info->si_errno =3D 0;
+	info->si_code =3D SI_ASYNCIO;
+	info->si_pid =3D 0;
+	info->si_uid =3D 0;
+	info->si_value =3D notify->value;
+
+	if (notify->notify & SIGEV_THREAD_ID)
+		ret =3D send_sigqueue(notify->signo, sigq, notify->target);
+	else
+		ret =3D send_group_sigqueue(notify->signo, sigq, notify->target);
+
+	return ret;
+}
+
+static long aio_setup_sigevent(struct aio_notify *notify,
+			       struct sigevent __user *user_event)
+{
+	sigevent_t event;
+	struct task_struct *target;
+
+	if (copy_from_user(&event, user_event, sizeof(event)))
+		return -EFAULT;
+
+	if (event.sigev_notify =3D=3D SIGEV_NONE)
+		return 0;
+
+	notify->notify =3D event.sigev_notify;
+	notify->signo =3D event.sigev_signo;
+	notify->value =3D event.sigev_value;
+
+	read_lock(&tasklist_lock);
+	target =3D good_sigevent(&event);
+
+	if (unlikely(!target || (target->flags & PF_EXITING)))
+		goto out_unlock;
+
+	/*
+	 * At this point, we know that notify is either SIGEV_SIGNAL or
+	 * SIGEV_THREAD_ID and the target task is valid. So get a reference
+	 * on the task, it will be dropped in really_put_req() when
+	 * we're done with the request.
+	 */
+	get_task_struct(target);
+	notify->target =3D target;
+	read_unlock(&tasklist_lock);
+
+	/*
+	 * NOTE: we cannot free the sigqueue in the completion path as
+	 * the signal may not have been delivered to the target task.
+	 * Therefore it has to be freed in __sigqueue_free() when the
+	 * signal is collected if si_code is SI_ASYNCIO.
+	 */
+	notify->sigq =3D sigqueue_alloc();
+
+	if (unlikely(!notify->sigq))
+		return -EAGAIN;
+
+	return 0;
+
+out_unlock:
+	read_unlock(&tasklist_lock);
+	return -EINVAL;
+}
+
 /* aio_complete
  *	Called when the io request on the given iocb is complete.
  *	Returns true if this is the last user of the request.  The=20
@@ -963,8 +1043,11 @@ int fastcall aio_complete(struct kiocb *
 	 * cancelled requests don't get events, userland was given one
 	 * when the event got cancelled.
 	 */
-	if (kiocbIsCancelled(iocb))
+	if (kiocbIsCancelled(iocb)) {
+		if (iocb->ki_notify.sigq)
+			sigqueue_free(iocb->ki_notify.sigq);
 		goto put_rq;
+	}
=20
 	ring =3D kmap_atomic(info->ring_pages[0], KM_IRQ1);
=20
@@ -994,6 +1077,15 @@ int fastcall aio_complete(struct kiocb *
 	kunmap_atomic(ring, KM_IRQ1);
=20
 	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+
+	if (iocb->ki_notify.notify !=3D SIGEV_NONE) {
+		ret =3D aio_send_signal(&iocb->ki_notify);
+
+		/* If signal generation failed, release the sigqueue */
+		if (ret)
+			sigqueue_free(iocb->ki_notify.sigq);
+	}
+
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret =3D __aio_put_req(ctx, iocb);
@@ -1545,8 +1637,7 @@ int fastcall io_submit_one(struct kioctx
 	ssize_t ret;
=20
 	/* enforce forwards compatibility on users */
-	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2 ||
-		     iocb->aio_reserved3)) {
+	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved3)) {
 		pr_debug("EINVAL: io_submit: reserve field set\n");
 		return -EINVAL;
 	}
@@ -1555,6 +1646,7 @@ int fastcall io_submit_one(struct kioctx
 	if (unlikely(
 	    (iocb->aio_buf !=3D (unsigned long)iocb->aio_buf) ||
 	    (iocb->aio_nbytes !=3D (size_t)iocb->aio_nbytes) ||
+	    (iocb->aio_sigeventp !=3D (unsigned long)iocb->aio_sigeventp) ||
 	    ((ssize_t)iocb->aio_nbytes < 0)
 	   )) {
 		pr_debug("EINVAL: io_submit: overflow check\n");
@@ -1588,11 +1680,21 @@ int fastcall io_submit_one(struct kioctx
 	init_waitqueue_func_entry(&req->ki_wait.wait, aio_wake_function);
 	INIT_LIST_HEAD(&req->ki_wait.wait.task_list);
  	req->ki_run_list.next =3D req->ki_run_list.prev =3D NULL;
+	/* handle setting up the sigevent for POSIX AIO signals */
+	req->ki_notify.notify =3D SIGEV_NONE;
+
+	if (iocb->aio_sigeventp) {
+		ret =3D aio_setup_sigevent(&req->ki_notify,
+					 (struct sigevent __user *)(unsigned long)
+					 iocb->aio_sigeventp);
+		if (ret)
+			goto out_put_req;
+	}
=20
 	ret =3D aio_setup_iocb(req);
=20
 	if (ret)
-		goto out_put_req;
+		goto out_sigqfree;
=20
 	spin_lock_irq(&ctx->ctx_lock);
 	aio_run_iocb(req);
@@ -1605,6 +1707,11 @@ int fastcall io_submit_one(struct kioctx
 	aio_put_req(req);	/* drop extra ref to req */
 	return 0;
=20
+out_sigqfree:
+	/* Undo the sigqueue alloc if someting went bad */
+	if (req->ki_notify.sigq)
+		sigqueue_free(req->ki_notify.sigq);
+
 out_put_req:
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
diff -puN fs/compat.c~aio-completion-signal-notification fs/compat.c
--- a/fs/compat.c~aio-completion-signal-notification
+++ a/fs/compat.c
@@ -665,6 +665,7 @@ compat_sys_io_submit(aio_context_t ctx_i
 		compat_uptr_t uptr;
 		struct iocb __user *user_iocb;
 		struct iocb tmp;
+		struct compat_sigevent __user *uevent;
=20
 		if (unlikely(get_user(uptr, iocb + i))) {
 			ret =3D -EFAULT;
@@ -678,6 +679,23 @@ compat_sys_io_submit(aio_context_t ctx_i
 			break;
 		}
=20
+		uevent =3D (struct compat_sigevent __user *)tmp.aio_sigeventp;
+
+		if (uevent) {
+			struct sigevent __user *event =3D NULL;
+			struct sigevent kevent;
+
+			event =3D compat_alloc_user_space(sizeof(*event));
+
+			if (get_compat_sigevent(&kevent, uevent) ||
+			    copy_to_user(event, &kevent, sizeof(*event))) {
+				ret =3D -EFAULT;
+				break;
+			}
+
+			tmp.aio_sigeventp =3D (__u64)event;
+		}
+
 		ret =3D io_submit_one(ctx, user_iocb, &tmp);
 		if (ret)
 			break;
diff -puN include/linux/aio.h~aio-completion-signal-notification includ=
e/linux/aio.h
--- a/include/linux/aio.h~aio-completion-signal-notification
+++ a/include/linux/aio.h
@@ -7,6 +7,7 @@
 #include <linux/uio.h>
=20
 #include <asm/atomic.h>
+#include <asm/siginfo.h>
=20
 #define AIO_MAXSEGS		4
 #define AIO_KIOGRP_NR_ATOMIC	8
@@ -54,6 +55,14 @@ struct kioctx;
 #define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED, &(iocb)->ki_fla=
gs)
 #define kiocbIsRestarted(iocb)	test_bit(KIF_RESTARTED, &(iocb)->ki_fla=
gs)
=20
+struct aio_notify {
+	struct task_struct	*target;
+	__u16			signo;
+	__u16			notify;
+	sigval_t		value;
+	struct sigqueue		*sigq;
+};
+
 /* is there a better place to document function pointer methods? */
 /**
  * ki_retry	-	iocb forward progress callback
@@ -123,6 +132,9 @@ struct kiocb {
=20
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
+
+	/* to notify a process on I/O event */
+	struct aio_notify	ki_notify;
 };
=20
 #define is_sync_kiocb(iocb)	((iocb)->ki_key =3D=3D KIOCB_SYNC_KEY)
diff -puN include/linux/aio_abi.h~aio-completion-signal-notification in=
clude/linux/aio_abi.h
--- a/include/linux/aio_abi.h~aio-completion-signal-notification
+++ a/include/linux/aio_abi.h
@@ -82,8 +82,9 @@ struct iocb {
 	__u64	aio_nbytes;
 	__s64	aio_offset;
=20
+	__u64	aio_sigeventp;	/* pointer to struct sigevent */
+
 	/* extra parameters */
-	__u64	aio_reserved2;	/* TODO: use this for a (struct sigevent *) */
 	__u64	aio_reserved3;
 }; /* 64 bytes */
=20
diff -puN kernel/signal.c~aio-completion-signal-notification kernel/sig=
nal.c
--- a/kernel/signal.c~aio-completion-signal-notification
+++ a/kernel/signal.c
@@ -296,7 +296,7 @@ static struct sigqueue *__sigqueue_alloc
=20
 static void __sigqueue_free(struct sigqueue *q)
 {
-	if (q->flags & SIGQUEUE_PREALLOC)
+	if (q->flags & SIGQUEUE_PREALLOC && q->info.si_code !=3D SI_ASYNCIO)
 		return;
 	atomic_dec(&q->user->sigpending);
 	free_uid(q->user);
_

Patches currently in -mm which might be from sebastien.dugue@bull.net a=
re

aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
add-listio-syscall-support.patch
add-listio-syscall-support-fix.patch
add-listio-syscall-support-fix-2.patch
