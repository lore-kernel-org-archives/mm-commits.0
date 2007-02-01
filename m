From: akpm@osdl.org
Subject: + add-listio-syscall-support.patch added to -mm tree
Date: Thu, 01 Feb 2007 15:04:48 -0800
Message-ID: <200702012304.l11N4mlq025717@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47661 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422719AbXBAXOt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 18:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharata@in.ibm.com, ak@suse.de, bcrl@linux.intel.com, hch@infradead.org, jean-pierre.dion@bull.net, laurent.vivier@bull.net, oleg@tv-sign.ru, pbadari@us.ibm.com, sebastien.dugue@bull.net, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     aio: add listio syscall support
has been added to the -mm tree.  Its filename is
     add-listio-syscall-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: aio: add listio syscall support
=46rom: Bharata B Rao <bharata@in.ibm.com>

This patch provides POSIX listio support by means of a new system call.

long lio_submit(aio_context_t ctx_id, int mode, long nr,
	struct iocb __user * __user *iocbpp, struct sigevent __user *event)

This system call is similar to the io_submit() system call, but takes
two more arguments.

'mode' argument can be LIO_WAIT or LIO_NOWAIT.

'event' argument specifies the signal notification mechanism.

This patch is built on support provided by the aio signal notification
patch by Sebastien. The following two structures together provide
the support for grouping iocbs belonging to a list (lio).

struct aio_notify {
	struct task_struct	*target;
	__u16			signo;
	__u16			notify;
	sigval_t		value;
	struct sigqueue		*sigq;
};

struct lio_event {
	atomic_t		lio_users;
	struct aio_notify	lio_notify;
};

A single lio_event struct is maintained for the list of iocbs.  lio_use=
rs
holds the number of requests attached to this lio and lio_notify has th=
e
necessary information for generating completion notification signal.

If the mode is LIO_WAIT, the event argument is ignored and the system c=
all
waits until all the requests of the lio are completed.

If the mode is LIO_NOWAIT, the system call returns immediately after
submitting the io requests and may optionally notify the process on lis=
t io
completion depending on the event argument.

Signed-off-by: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Signed-off-by: Laurent Vivier <laurent.vivier@bull.net>
Signed-off-by: Bharata B Rao <bharata@in.ibm.com>
Cc: Bharata B Rao <bharata@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Benjamin LaHaise <bcrl@linux.intel.com>
Cc: Jean Pierre Dion <jean-pierre.dion@bull.net>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/syscall_table.S |    1=20
 arch/x86_64/ia32/ia32entry.S     |    4=20
 fs/aio.c                         |  188 +++++++++++++++++++++++++----
 fs/compat.c                      |  119 +++++++++++++++---
 include/asm-i386/unistd.h        |    3=20
 include/asm-x86_64/unistd.h      |    4=20
 include/linux/aio.h              |   14 +-
 include/linux/aio_abi.h          |    5=20
 include/linux/syscalls.h         |    2=20
 9 files changed, 295 insertions(+), 45 deletions(-)

diff -puN arch/i386/kernel/syscall_table.S~add-listio-syscall-support a=
rch/i386/kernel/syscall_table.S
--- a/arch/i386/kernel/syscall_table.S~add-listio-syscall-support
+++ a/arch/i386/kernel/syscall_table.S
@@ -319,3 +319,4 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_lio_submit		/* 320 */
diff -puN arch/x86_64/ia32/ia32entry.S~add-listio-syscall-support arch/=
x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~add-listio-syscall-support
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -726,8 +726,10 @@ ia32_sys_call_table:
 	.quad compat_sys_get_robust_list
 	.quad sys_splice
 	.quad sys_sync_file_range
-	.quad sys_tee
+	.quad sys_tee			/* 315 */
 	.quad compat_sys_vmsplice
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
+	.quad quiet_ni_syscall		/* sys_epoll_wait */
+	.quad compat_sys_lio_submit
 ia32_syscall_end:	=09
diff -puN fs/aio.c~add-listio-syscall-support fs/aio.c
--- a/fs/aio.c~add-listio-syscall-support
+++ a/fs/aio.c
@@ -416,6 +416,7 @@ static struct kiocb fastcall *__aio_get_
 	req->ki_ctx =3D ctx;
 	req->ki_cancel =3D NULL;
 	req->ki_retry =3D NULL;
+	req->ki_lio =3D NULL;
 	req->ki_dtor =3D NULL;
 	req->private =3D NULL;
 	req->ki_iovec =3D NULL;
@@ -995,6 +996,72 @@ out_unlock:
 	return -EINVAL;
 }
=20
+/*
+ * lio_notify
+ * When all iocbs belonging to an lio are complete, this initiates
+ * the completion notification for the lio.
+ *
+ * NOTE: lio is freed here after the last iocb completes, but only
+ * for LIO_NOWAIT case. In case of LIO_WAIT, the submitting thread
+ * waits for iocbs to complete and later frees the lio.
+ */
+void lio_notify(struct lio_event *lio)
+{
+	int ret;
+
+	ret =3D atomic_dec_and_test(&lio->lio_users);
+
+	if (unlikely(ret) && lio->lio_notify.notify !=3D SIGEV_NONE) {
+		/* last one -> notify process */
+		if (aio_send_signal(&lio->lio_notify))
+			__sigqueue_free(lio->lio_notify.sigq);
+		kfree(lio);
+	}
+}
+
+/*
+ * lio_create
+ * Allocates a lio_event structure which groups the iocbs belonging
+ * to the lio and sets up the completion notification.
+ *
+ * Case 1: LIO_NOWAIT and NULL sigevent - No need to group the iocbs
+ *	and hence lio_event is not created.
+ * Case 2: LIO_NOWAIT and sigvent - lio_event is created and notificat=
ion
+ *	mechanism is setup.
+ * Case 3: LIO_WAIT - lio_event is created and sigevent is ignored.
+ */
+struct lio_event *lio_create(struct sigevent __user *user_event,
+			int mode)
+{
+	int ret =3D 0;
+	struct lio_event *lio =3D NULL;
+
+	if (unlikely((mode =3D=3D LIO_NOWAIT) && !user_event))
+		return lio;
+
+	lio =3D kzalloc(sizeof(*lio), GFP_KERNEL);
+
+	if (!lio)
+		return ERR_PTR(-EAGAIN);
+
+	/*
+	 * Grab an initial ref on the lio to avoid races between
+	 * submission and completion.
+	 */
+	atomic_set(&lio->lio_users, 1);
+
+	lio->lio_notify.notify =3D SIGEV_NONE;
+
+	if (user_event && (mode =3D=3D LIO_NOWAIT)) {
+		ret =3D aio_setup_sigevent(&lio->lio_notify, user_event);
+		if (ret) {
+			kfree(lio);
+			return ERR_PTR(ret);
+		}
+	}
+	return lio;
+}
+
 /* aio_complete
  *	Called when the io request on the given iocb is complete.
  *	Returns true if this is the last user of the request.  The=20
@@ -1043,6 +1110,9 @@ int fastcall aio_complete(struct kiocb *
 	 * when the event got cancelled.
 	 */
 	if (kiocbIsCancelled(iocb)) {
+		if (iocb->ki_lio)
+			lio_notify(iocb->ki_lio);
+
 		if (iocb->ki_notify.sigq)
 			__sigqueue_free(iocb->ki_notify.sigq);
 		goto put_rq;
@@ -1085,6 +1155,8 @@ int fastcall aio_complete(struct kiocb *
 			__sigqueue_free(iocb->ki_notify.sigq);
 	}
=20
+	if (iocb->ki_lio)
+		lio_notify(iocb->ki_lio);
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret =3D __aio_put_req(ctx, iocb);
@@ -1629,7 +1701,7 @@ static int aio_wake_function(wait_queue_
 }
=20
 int fastcall io_submit_one(struct kioctx *ctx, struct iocb __user *use=
r_iocb,
-			 struct iocb *iocb)
+			 struct iocb *iocb, struct lio_event *lio)
 {
 	struct kiocb *req;
 	struct file *file;
@@ -1690,6 +1762,9 @@ int fastcall io_submit_one(struct kioctx
 			goto out_put_req;
 	}
=20
+	/* Attach this iocb to its lio */
+	req->ki_lio =3D lio;
+
 	ret =3D aio_setup_iocb(req);
=20
 	if (ret)
@@ -1717,6 +1792,48 @@ out_put_req:
 	return ret;
 }
=20
+static int io_submit_group(struct kioctx *ctx, long nr,
+	struct iocb __user * __user *iocbpp, struct lio_event *lio)
+{
+	int i;
+	long ret =3D 0;
+
+	/*
+	 * AKPM: should this return a partial result if some of the IOs were
+	 * successfully submitted?
+	 */
+	for (i =3D 0; i < nr; i++) {
+		struct iocb __user *user_iocb;
+		struct iocb tmp;
+
+		if (unlikely(__get_user(user_iocb, iocbpp + i))) {
+			ret =3D -EFAULT;
+			break;
+		}
+
+		if (unlikely(copy_from_user(&tmp, user_iocb, sizeof(tmp)))) {
+			ret =3D -EFAULT;
+			break;
+		}
+
+		if (lio)
+			atomic_inc(&lio->lio_users);
+
+		ret =3D io_submit_one(ctx, user_iocb, &tmp, lio);
+		if (ret) {
+			if (lio) {
+				/*
+				 * In case of listio, continue with
+				 * the subsequent requests
+				 */
+				atomic_dec(&lio->lio_users);
+			} else
+				break;
+		}
+	}
+	return i ? i : ret;
+}
+
 /* sys_io_submit:
  *	Queue the nr iocbs pointed to by iocbpp for processing.  Returns
  *	the number of iocbs queued.  May return -EINVAL if the aio_context
@@ -1734,7 +1851,6 @@ asmlinkage long sys_io_submit(aio_contex
 {
 	struct kioctx *ctx;
 	long ret =3D 0;
-	int i;
=20
 	if (unlikely((nr*sizeof(*iocbpp)) < 0))
 		return -EINVAL;
@@ -1748,31 +1864,61 @@ asmlinkage long sys_io_submit(aio_contex
 		return -EINVAL;
 	}
=20
-	/*
-	 * AKPM: should this return a partial result if some of the IOs were
-	 * successfully submitted?
-	 */
-	for (i=3D0; i<nr; i++) {
-		struct iocb __user *user_iocb;
-		struct iocb tmp;
+	ret =3D io_submit_group(ctx, nr, iocbpp, NULL);
=20
-		if (unlikely(__get_user(user_iocb, iocbpp + i))) {
-			ret =3D -EFAULT;
-			break;
-		}
+	put_ioctx(ctx);
+	return ret;
+}
=20
-		if (unlikely(copy_from_user(&tmp, user_iocb, sizeof(tmp)))) {
-			ret =3D -EFAULT;
-			break;
-		}
+asmlinkage long sys_lio_submit(aio_context_t ctx_id, int mode, long nr=
,
+	struct iocb __user * __user *iocbpp, struct sigevent __user *event)
+{
+	struct kioctx *ctx;
+	struct lio_event *lio =3D NULL;
+	long ret =3D 0;
=20
-		ret =3D io_submit_one(ctx, user_iocb, &tmp);
-		if (ret)
-			break;
+	if (unlikely((nr*sizeof(*iocbpp)) < 0))
+		return -EINVAL;
+
+	if (unlikely(!access_ok(VERIFY_READ, iocbpp, (nr*sizeof(*iocbpp)))))
+		return -EFAULT;
+
+	ctx =3D lookup_ioctx(ctx_id);
+	if (unlikely(!ctx)) {
+		pr_debug("EINVAL: lio_submit: invalid context id\n");
+		return -EINVAL;
+	}
+
+	lio =3D lio_create(event, mode);
+
+	ret =3D PTR_ERR(lio);
+	if (IS_ERR(lio))
+		goto out_put_ctx;
+
+	ret =3D io_submit_group(ctx, nr, iocbpp, lio);
+
+	/* If we failed to submit even one request just return */
+	if (ret < 0 ) {
+		if (lio)
+			kfree(lio);
+		goto out_put_ctx;
+	}
+
+	/*
+	 * Drop extra ref on the lio now that we're done submitting requests.
+	 */
+	if (lio)
+		lio_notify(lio);
+
+	if (mode =3D=3D LIO_WAIT) {
+		wait_event(ctx->wait, atomic_read(&lio->lio_users) =3D=3D 0);
+		kfree(lio);
 	}
=20
+out_put_ctx:
 	put_ioctx(ctx);
-	return i ? i : ret;
+
+	return ret;
 }
=20
 /* lookup_kiocb
diff -puN fs/compat.c~add-listio-syscall-support fs/compat.c
--- a/fs/compat.c~add-listio-syscall-support
+++ a/fs/compat.c
@@ -644,24 +644,13 @@ out:
 	return ret;
 }
=20
-asmlinkage long
-compat_sys_io_submit(aio_context_t ctx_id, int nr, u32 __user *iocb)
+static int compat_io_submit_group(struct kioctx *ctx, long nr,
+				  u32 __user *iocb, struct lio_event *lio)
 {
-	struct kioctx *ctx;
-	long ret =3D 0;
 	int i;
+	long ret =3D 0;
=20
-	if (unlikely((nr * sizeof(u32)) < 0))
-		return -EINVAL;
-
-	if (unlikely(!access_ok(VERIFY_READ, iocb, (nr * sizeof(u32)))))
-		return -EFAULT;
-
-	ctx =3D lookup_ioctx(ctx_id);
-	if (unlikely(!ctx))
-		return -EINVAL;
-
-	for (i=3D0; i<nr; i++) {
+	for (i =3D 0; i < nr; i++) {
 		compat_uptr_t uptr;
 		struct iocb __user *user_iocb;
 		struct iocb tmp;
@@ -696,13 +685,105 @@ compat_sys_io_submit(aio_context_t ctx_i
 			tmp.aio_sigeventp =3D (__u64)event;
 		}
=20
-		ret =3D io_submit_one(ctx, user_iocb, &tmp);
-		if (ret)
-			break;
+		if (lio)
+			atomic_inc(&lio->lio_users);
+
+		ret =3D io_submit_one(ctx, user_iocb, &tmp, lio);
+		if (ret) {
+			if (lio) {
+				/*
+				 * In case of listio, continue with
+				 * the subsequent requests
+				 */
+				atomic_dec(&lio->lio_users);
+			} else
+				break;
+		}
+
+
 	}
+	return i ? i : ret;
+}
=20
+asmlinkage long
+compat_sys_io_submit(aio_context_t ctx_id, int nr, u32 __user *iocb)
+{
+	struct kioctx *ctx;
+	long ret =3D 0;
+
+	if (unlikely((nr*sizeof(u32)) < 0))
+		return -EINVAL;
+
+	if (unlikely(!access_ok(VERIFY_READ, iocb, (nr * sizeof(u32)))))
+		return -EFAULT;
+
+	ctx =3D lookup_ioctx(ctx_id);
+	if (unlikely(!ctx))
+		return -EINVAL;
+
+	ret =3D compat_io_submit_group(ctx, nr, iocb, NULL);
 	put_ioctx(ctx);
-	return i ? i: ret;
+	return ret;
+}
+
+asmlinkage long
+compat_sys_lio_submit(aio_context_t ctx_id, int mode, int nr, u32 __us=
er *iocb,
+		struct compat_sigevent __user *sig_user)
+{
+	struct kioctx *ctx;
+	struct lio_event *lio =3D NULL;
+	struct sigevent __user *event =3D NULL;
+	long ret =3D 0;
+
+	if (unlikely((nr*sizeof(u32)) < 0))
+		return -EINVAL;
+
+	if (unlikely(!access_ok(VERIFY_READ, iocb, (nr * sizeof(u32)))))
+		return -EFAULT;
+
+	ctx =3D lookup_ioctx(ctx_id);
+	if (unlikely(!ctx))
+		return -EINVAL;
+
+	if (sig_user) {
+		struct sigevent kevent;
+		event =3D compat_alloc_user_space(sizeof(struct sigevent));
+		if (get_compat_sigevent(&kevent, sig_user) ||
+			copy_to_user(event, &kevent, sizeof(struct sigevent))) {
+			ret =3D -EFAULT;
+			goto out_put_ctx;
+		}
+	}
+
+	lio =3D lio_create(event, mode);
+
+	ret =3D PTR_ERR(lio);
+	if (IS_ERR(lio))
+		goto out_put_ctx;
+
+	ret =3D compat_io_submit_group(ctx, nr, iocb, lio);
+
+	/* If we failed to submit even one request just return */
+	if (ret < 0) {
+		if (lio)
+			kfree(lio);
+		goto out_put_ctx;
+	}
+
+	/*
+	 * Drop extra ref on the lio now that we're done submitting requests.
+	 */
+	if (lio)
+		lio_notify(lio);
+
+	if (mode =3D=3D LIO_WAIT) {
+		wait_event(ctx->wait, atomic_read(&lio->lio_users) =3D=3D 0);
+		kfree(lio);
+	}
+
+out_put_ctx:
+	put_ioctx(ctx);
+	return ret;
 }
=20
 struct compat_ncp_mount_data {
diff -puN include/asm-i386/unistd.h~add-listio-syscall-support include/=
asm-i386/unistd.h
--- a/include/asm-i386/unistd.h~add-listio-syscall-support
+++ a/include/asm-i386/unistd.h
@@ -325,10 +325,11 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_lio_submit		320
=20
 #ifdef __KERNEL__
=20
-#define NR_syscalls 320
+#define NR_syscalls 321
=20
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/asm-x86_64/unistd.h~add-listio-syscall-support includ=
e/asm-x86_64/unistd.h
--- a/include/asm-x86_64/unistd.h~add-listio-syscall-support
+++ a/include/asm-x86_64/unistd.h
@@ -619,8 +619,10 @@ __SYSCALL(__NR_sync_file_range, sys_sync
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_lio_submit		280
+__SYSCALL(__NR_lio_submit, sys_lio_submit)
=20
-#define __NR_syscall_max __NR_move_pages
+#define __NR_syscall_max __NR_lio_submit
=20
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/linux/aio.h~add-listio-syscall-support include/linux/=
aio.h
--- a/include/linux/aio.h~add-listio-syscall-support
+++ a/include/linux/aio.h
@@ -63,6 +63,11 @@ struct aio_notify {
 	struct sigqueue		*sigq;
 };
=20
+struct lio_event {
+	atomic_t		lio_users;
+	struct aio_notify	lio_notify;
+};
+
 /* is there a better place to document function pointer methods? */
 /**
  * ki_retry	-	iocb forward progress callback
@@ -117,6 +122,8 @@ struct kiocb {
 	__u64			ki_user_data;	/* user's data for completion */
 	struct wait_bit_queue	ki_wait;
 	loff_t			ki_pos;
+	/* lio this iocb might be attached to */
+	struct lio_event	*ki_lio;
=20
 	atomic_t		ki_bio_count;	/* num bio used for this iocb */
 	void			*private;
@@ -225,12 +232,15 @@ struct mm_struct;
 extern void FASTCALL(exit_aio(struct mm_struct *mm));
 extern struct kioctx *lookup_ioctx(unsigned long ctx_id);
 extern int FASTCALL(io_submit_one(struct kioctx *ctx,
-			struct iocb __user *user_iocb, struct iocb *iocb));
+			struct iocb __user *user_iocb, struct iocb *iocb,
+			struct lio_event *lio));
+struct lio_event *lio_create(struct sigevent __user *user_event, int m=
ode);
+void lio_notify(struct lio_event *lio);
=20
 /* semi private, but used by the 32bit emulations: */
 struct kioctx *lookup_ioctx(unsigned long ctx_id);
 int FASTCALL(io_submit_one(struct kioctx *ctx, struct iocb __user *use=
r_iocb,
-				  struct iocb *iocb));
+				  struct iocb *iocb, struct lio_event *lio));
=20
 #define get_ioctx(kioctx) do {						\
 	BUG_ON(atomic_read(&(kioctx)->users) <=3D 0);			\
diff -puN include/linux/aio_abi.h~add-listio-syscall-support include/li=
nux/aio_abi.h
--- a/include/linux/aio_abi.h~add-listio-syscall-support
+++ a/include/linux/aio_abi.h
@@ -45,6 +45,11 @@ enum {
 	IOCB_CMD_PWRITEV =3D 8,
 };
=20
+enum {
+	LIO_WAIT =3D 0,
+	LIO_NOWAIT =3D 1,
+};
+
 /* read() from /dev/aio returns these structures. */
 struct io_event {
 	__u64		data;		/* the data field from the iocb */
diff -puN include/linux/syscalls.h~add-listio-syscall-support include/l=
inux/syscalls.h
--- a/include/linux/syscalls.h~add-listio-syscall-support
+++ a/include/linux/syscalls.h
@@ -317,6 +317,8 @@ asmlinkage long sys_io_getevents(aio_con
 				struct timespec __user *timeout);
 asmlinkage long sys_io_submit(aio_context_t, long,
 				struct iocb __user * __user *);
+asmlinkage long sys_lio_submit(aio_context_t, int, long,
+		struct iocb __user * __user *, struct sigevent __user *);
 asmlinkage long sys_io_cancel(aio_context_t ctx_id, struct iocb __user=
 *iocb,
 			      struct io_event __user *result);
 asmlinkage ssize_t sys_sendfile(int out_fd, int in_fd,
_

Patches currently in -mm which might be from bharata@in.ibm.com are

rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
add-listio-syscall-support.patch
