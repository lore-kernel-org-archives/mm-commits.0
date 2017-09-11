From: akpm@linux-foundation.org
Subject: [merged]
 io_getevents-use-timespec64-to-represent-timeouts.patch removed from -mm
 tree
Date: Mon, 11 Sep 2017 12:38:08 -0700
Message-ID: <20170911193808.cW2xoICpQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48040 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdIKTiJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcrl@kvack.org, deepa.kernel@gmail.com, mm-commits@vger.kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: io_getevents: use timespec64 to represent timeouts
has been removed from the -mm tree.  Its filename was
     io_getevents-use-timespec64-to-represent-timeouts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: io_getevents: use timespec64 to represent timeouts

struct timespec is not y2038 safe.  Use y2038 safe struct timespec64 to
represent timeouts.  The system call interface itself will be changed as
part of different series.

Timeouts will not really need more than 32 bits.  But, replacing these
with timespec64 helps verification of a y2038 safe kernel by getting rid
of timespec internally.

Link: http://lkml.kernel.org/r/20170805041232.20875-3-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   55 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff -puN fs/aio.c~io_getevents-use-timespec64-to-represent-timeouts fs/aio.c
--- a/fs/aio.c~io_getevents-use-timespec64-to-represent-timeouts
+++ a/fs/aio.c
@@ -1297,20 +1297,10 @@ static bool aio_read_events(struct kioct
 
 static long read_events(struct kioctx *ctx, long min_nr, long nr,
 			struct io_event __user *event,
-			struct timespec __user *timeout)
+			ktime_t until)
 {
-	ktime_t until = KTIME_MAX;
 	long ret = 0;
 
-	if (timeout) {
-		struct timespec	ts;
-
-		if (unlikely(copy_from_user(&ts, timeout, sizeof(ts))))
-			return -EFAULT;
-
-		until = timespec_to_ktime(ts);
-	}
-
 	/*
 	 * Note that aio_read_events() is being called as the conditional - i.e.
 	 * we're calling it after prepare_to_wait() has set task state to
@@ -1832,6 +1822,25 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t
 	return ret;
 }
 
+static long do_io_getevents(aio_context_t ctx_id,
+		long min_nr,
+		long nr,
+		struct io_event __user *events,
+		struct timespec64 *ts)
+{
+	ktime_t until = ts ? timespec64_to_ktime(*ts) : KTIME_MAX;
+	struct kioctx *ioctx = lookup_ioctx(ctx_id);
+	long ret = -EINVAL;
+
+	if (likely(ioctx)) {
+		if (likely(min_nr <= nr && min_nr >= 0))
+			ret = read_events(ioctx, min_nr, nr, events, until);
+		percpu_ref_put(&ioctx->users);
+	}
+
+	return ret;
+}
+
 /* io_getevents:
  *	Attempts to read at least min_nr events and up to nr events from
  *	the completion queue for the aio_context specified by ctx_id. If
@@ -1850,15 +1859,14 @@ SYSCALL_DEFINE5(io_getevents, aio_contex
 		struct io_event __user *, events,
 		struct timespec __user *, timeout)
 {
-	struct kioctx *ioctx = lookup_ioctx(ctx_id);
-	long ret = -EINVAL;
+	struct timespec64	ts;
 
-	if (likely(ioctx)) {
-		if (likely(min_nr <= nr && min_nr >= 0))
-			ret = read_events(ioctx, min_nr, nr, events, timeout);
-		percpu_ref_put(&ioctx->users);
+	if (timeout) {
+		if (unlikely(get_timespec64(&ts, timeout)))
+			return -EFAULT;
 	}
-	return ret;
+
+	return do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
 }
 
 #ifdef CONFIG_COMPAT
@@ -1868,17 +1876,14 @@ COMPAT_SYSCALL_DEFINE5(io_getevents, com
 		       struct io_event __user *, events,
 		       struct compat_timespec __user *, timeout)
 {
-	struct timespec t;
-	struct timespec __user *ut = NULL;
+	struct timespec64 t;
 
 	if (timeout) {
-		if (compat_get_timespec(&t, timeout))
+		if (compat_get_timespec64(&t, timeout))
 			return -EFAULT;
 
-		ut = compat_alloc_user_space(sizeof(*ut));
-		if (copy_to_user(ut, &t, sizeof(t)))
-			return -EFAULT;
 	}
-	return sys_io_getevents(ctx_id, min_nr, nr, events, ut);
+
+	return do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
 }
 #endif
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are


