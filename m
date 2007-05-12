From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-kaio-eventfd-support-example.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:20 -0700
Message-ID: <200705120535.l4C5ZK87002282@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756301AbXELFfX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     signal/timer/event: KAIO eventfd support example
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-kaio-eventfd-support-example.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: signal/timer/event: KAIO eventfd support example
From: Davide Libenzi <davidel@xmailserver.org>

This is an example about how to add eventfd support to the current KAIO code,
in order to enable KAIO to post readiness events to a pollable fd (hence
compatible with POSIX select/poll).  The KAIO code simply signals the eventfd
fd when events are ready, and this triggers a POLLIN in the fd.  This patch
uses a reserved for future use member of the struct iocb to pass an eventfd
file descriptor, that KAIO will use to post events every time a request
completes.  At that point, an aio_getevents() will return the completed result
to a struct io_event.  I made a quick test program to verify the patch, and it
runs fine here:

http://www.xmailserver.org/eventfd-aio-test.c

The test program uses poll(2), but it'd, of course, work with select and epoll
too.

This can allow to schedule both block I/O and other poll-able devices
requests, and wait for results using select/poll/epoll.  In a typical
scenario, an application would submit KAIO request using aio_submit(), and
will also use epoll_ctl() on the whole other class of devices (that with the
addition of signals, timers and user events, now it's pretty much complete),
and then would:

	epoll_wait(...);
	for_each_event {
		if (curr_event_is_kaiofd) {
			aio_getevents();
			dispatch_aio_events();
		} else {
			dispatch_epoll_event();
		}
	}

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c                |   28 ++++++++++++++++++++++++++--
 include/linux/aio.h     |    6 ++++++
 include/linux/aio_abi.h |   18 +++++++++++++++++-
 3 files changed, 49 insertions(+), 3 deletions(-)

diff -puN fs/aio.c~signal-timer-event-fds-v9-kaio-eventfd-support-example fs/aio.c
--- a/fs/aio.c~signal-timer-event-fds-v9-kaio-eventfd-support-example
+++ a/fs/aio.c
@@ -30,6 +30,7 @@
 #include <linux/highmem.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
+#include <linux/eventfd.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -417,6 +418,7 @@ static struct kiocb fastcall *__aio_get_
 	req->private = NULL;
 	req->ki_iovec = NULL;
 	INIT_LIST_HEAD(&req->ki_run_list);
+	req->ki_eventfd = ERR_PTR(-EINVAL);
 
 	/* Check if the completion queue has enough free space to
 	 * accept an event from this io.
@@ -458,6 +460,8 @@ static inline void really_put_req(struct
 {
 	assert_spin_locked(&ctx->ctx_lock);
 
+	if (!IS_ERR(req->ki_eventfd))
+		fput(req->ki_eventfd);
 	if (req->ki_dtor)
 		req->ki_dtor(req);
 	if (req->ki_iovec != &req->ki_inline_vec)
@@ -942,6 +946,14 @@ int fastcall aio_complete(struct kiocb *
 		return 1;
 	}
 
+	/*
+	 * Check if the user asked us to deliver the result through an
+	 * eventfd. The eventfd_signal() function is safe to be called
+	 * from IRQ context.
+	 */
+	if (!IS_ERR(iocb->ki_eventfd))
+		eventfd_signal(iocb->ki_eventfd, 1);
+
 	info = &ctx->ring_info;
 
 	/* add a completion event to the ring buffer.
@@ -1526,8 +1538,7 @@ int fastcall io_submit_one(struct kioctx
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2 ||
-		     iocb->aio_reserved3)) {
+	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
 		pr_debug("EINVAL: io_submit: reserve field set\n");
 		return -EINVAL;
 	}
@@ -1551,6 +1562,19 @@ int fastcall io_submit_one(struct kioctx
 		fput(file);
 		return -EAGAIN;
 	}
+	if (iocb->aio_flags & IOCB_FLAG_RESFD) {
+		/*
+		 * If the IOCB_FLAG_RESFD flag of aio_flags is set, get an
+		 * instance of the file* now. The file descriptor must be
+		 * an eventfd() fd, and will be signaled for each completed
+		 * event using the eventfd_signal() function.
+		 */
+		req->ki_eventfd = eventfd_fget((int) iocb->aio_resfd);
+		if (unlikely(IS_ERR(req->ki_eventfd))) {
+			ret = PTR_ERR(req->ki_eventfd);
+			goto out_put_req;
+		}
+	}
 
 	req->ki_filp = file;
 	ret = put_user(req->ki_key, &user_iocb->aio_key);
diff -puN include/linux/aio.h~signal-timer-event-fds-v9-kaio-eventfd-support-example include/linux/aio.h
--- a/include/linux/aio.h~signal-timer-event-fds-v9-kaio-eventfd-support-example
+++ a/include/linux/aio.h
@@ -119,6 +119,12 @@ struct kiocb {
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
+
+	/*
+	 * If the aio_resfd field of the userspace iocb is not zero,
+	 * this is the underlying file* to deliver event to.
+	 */
+	struct file		*ki_eventfd;
 };
 
 #define is_sync_kiocb(iocb)	((iocb)->ki_key == KIOCB_SYNC_KEY)
diff -puN include/linux/aio_abi.h~signal-timer-event-fds-v9-kaio-eventfd-support-example include/linux/aio_abi.h
--- a/include/linux/aio_abi.h~signal-timer-event-fds-v9-kaio-eventfd-support-example
+++ a/include/linux/aio_abi.h
@@ -45,6 +45,14 @@ enum {
 	IOCB_CMD_PWRITEV = 8,
 };
 
+/*
+ * Valid flags for the "aio_flags" member of the "struct iocb".
+ *
+ * IOCB_FLAG_RESFD - Set if the "aio_resfd" member of the "struct iocb"
+ *                   is valid.
+ */
+#define IOCB_FLAG_RESFD		(1 << 0)
+
 /* read() from /dev/aio returns these structures. */
 struct io_event {
 	__u64		data;		/* the data field from the iocb */
@@ -84,7 +92,15 @@ struct iocb {
 
 	/* extra parameters */
 	__u64	aio_reserved2;	/* TODO: use this for a (struct sigevent *) */
-	__u64	aio_reserved3;
+
+	/* flags for the "struct iocb" */
+	__u32	aio_flags;
+
+	/*
+	 * if the IOCB_FLAG_RESFD flag of "aio_flags" is set, this is an
+	 * eventfd to signal AIO readiness to
+	 */
+	__u32	aio_resfd;
 }; /* 64 bytes */
 
 #undef IFBIG
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch
