From: akpm@linux-foundation.org
Subject: + signals-kill-block_all_signals-and-unblock_all_signals.patch
 added to -mm tree
Date: Wed, 16 Sep 2015 15:16:47 -0700
Message-ID: <55f9ea4f.maSjVUwOai8p28x/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbbIPWQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Sep 2015 18:16:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, airlied@gmail.com, daniel.vetter@ffwll.ch, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: signals: kill block_all_signals() and unblock_all_signals()
has been added to the -mm tree.  Its filename is
     signals-kill-block_all_signals-and-unblock_all_signals.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signals-kill-block_all_signals-and-unblock_all_signals.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signals-kill-block_all_signals-and-unblock_all_signals.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signals: kill block_all_signals() and unblock_all_signals()

It is hardly possible to enumerate all problems with block_all_signals()
and unblock_all_signals().  Just for example,

1. block_all_signals(SIGSTOP/etc) simply can't help if the caller is
   multithreaded. Another thread can dequeue the signal and force the
   group stop.

2. Even is the caller is single-threaded, it will "stop" anyway. It
   will not sleep, but it will spin in kernel space until SIGCONT or
   SIGKILL.

And a lot more. In short, this interface doesn't work at all, at least
the last 10+ years.

Daniel said:

  Yeah the only times I played around with the DRM_LOCK stuff was when
  old drivers accidentally deadlocked - my impression is that the entire
  DRM_LOCK thing was never really tested properly ;-) Hence I'm all for
  purging where this leaks out of the drm subsystem.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_lock.c |   41 ----------------------------
 include/drm/drmP.h         |    1 
 include/linux/sched.h      |    7 ----
 kernel/signal.c            |   51 -----------------------------------
 4 files changed, 2 insertions(+), 98 deletions(-)

diff -puN drivers/gpu/drm/drm_lock.c~signals-kill-block_all_signals-and-unblock_all_signals drivers/gpu/drm/drm_lock.c
--- a/drivers/gpu/drm/drm_lock.c~signals-kill-block_all_signals-and-unblock_all_signals
+++ a/drivers/gpu/drm/drm_lock.c
@@ -38,8 +38,6 @@
 #include "drm_legacy.h"
 #include "drm_internal.h"
 
-static int drm_notifier(void *priv);
-
 static int drm_lock_take(struct drm_lock_data *lock_data, unsigned int context);
 
 /**
@@ -118,14 +116,8 @@ int drm_legacy_lock(struct drm_device *d
 	 * really probably not the correct answer but lets us debug xkb
  	 * xserver for now */
 	if (!file_priv->is_master) {
-		sigemptyset(&dev->sigmask);
-		sigaddset(&dev->sigmask, SIGSTOP);
-		sigaddset(&dev->sigmask, SIGTSTP);
-		sigaddset(&dev->sigmask, SIGTTIN);
-		sigaddset(&dev->sigmask, SIGTTOU);
 		dev->sigdata.context = lock->context;
 		dev->sigdata.lock = master->lock.hw_lock;
-		block_all_signals(drm_notifier, dev, &dev->sigmask);
 	}
 
 	if (dev->driver->dma_quiescent && (lock->flags & _DRM_LOCK_QUIESCENT))
@@ -169,7 +161,6 @@ int drm_legacy_unlock(struct drm_device
 		/* FIXME: Should really bail out here. */
 	}
 
-	unblock_all_signals();
 	return 0;
 }
 
@@ -287,38 +278,6 @@ int drm_legacy_lock_free(struct drm_lock
 	return 0;
 }
 
-/**
- * If we get here, it means that the process has called DRM_IOCTL_LOCK
- * without calling DRM_IOCTL_UNLOCK.
- *
- * If the lock is not held, then let the signal proceed as usual.  If the lock
- * is held, then set the contended flag and keep the signal blocked.
- *
- * \param priv pointer to a drm_device structure.
- * \return one if the signal should be delivered normally, or zero if the
- * signal should be blocked.
- */
-static int drm_notifier(void *priv)
-{
-	struct drm_device *dev = priv;
-	struct drm_hw_lock *lock = dev->sigdata.lock;
-	unsigned int old, new, prev;
-
-	/* Allow signal delivery if lock isn't held */
-	if (!lock || !_DRM_LOCK_IS_HELD(lock->lock)
-	    || _DRM_LOCKING_CONTEXT(lock->lock) != dev->sigdata.context)
-		return 1;
-
-	/* Otherwise, set flag to force call to
-	   drmUnlock */
-	do {
-		old = lock->lock;
-		new = old | _DRM_LOCK_CONT;
-		prev = cmpxchg(&lock->lock, old, new);
-	} while (prev != old);
-	return 0;
-}
-
 /**
  * This function returns immediately and takes the hw lock
  * with the kernel context if it is free, otherwise it gets the highest priority when and if
diff -puN include/drm/drmP.h~signals-kill-block_all_signals-and-unblock_all_signals include/drm/drmP.h
--- a/include/drm/drmP.h~signals-kill-block_all_signals-and-unblock_all_signals
+++ a/include/drm/drmP.h
@@ -822,7 +822,6 @@ struct drm_device {
 
 	struct drm_sg_mem *sg;	/**< Scatter gather memory */
 	unsigned int num_crtcs;                  /**< Number of CRTCs on this device */
-	sigset_t sigmask;
 
 	struct {
 		int context;
diff -puN include/linux/sched.h~signals-kill-block_all_signals-and-unblock_all_signals include/linux/sched.h
--- a/include/linux/sched.h~signals-kill-block_all_signals-and-unblock_all_signals
+++ a/include/linux/sched.h
@@ -1560,9 +1560,7 @@ struct task_struct {
 
 	unsigned long sas_ss_sp;
 	size_t sas_ss_size;
-	int (*notifier)(void *priv);
-	void *notifier_data;
-	sigset_t *notifier_mask;
+
 	struct callback_head *task_works;
 
 	struct audit_context *audit_context;
@@ -2466,9 +2464,6 @@ static inline int dequeue_signal_lock(st
 	return ret;
 }
 
-extern void block_all_signals(int (*notifier)(void *priv), void *priv,
-			      sigset_t *mask);
-extern void unblock_all_signals(void);
 extern void release_task(struct task_struct * p);
 extern int send_sig_info(int, struct siginfo *, struct task_struct *);
 extern int force_sigsegv(int, struct task_struct *);
diff -puN kernel/signal.c~signals-kill-block_all_signals-and-unblock_all_signals kernel/signal.c
--- a/kernel/signal.c~signals-kill-block_all_signals-and-unblock_all_signals
+++ a/kernel/signal.c
@@ -503,41 +503,6 @@ int unhandled_signal(struct task_struct
 	return !tsk->ptrace;
 }
 
-/*
- * Notify the system that a driver wants to block all signals for this
- * process, and wants to be notified if any signals at all were to be
- * sent/acted upon.  If the notifier routine returns non-zero, then the
- * signal will be acted upon after all.  If the notifier routine returns 0,
- * then then signal will be blocked.  Only one block per process is
- * allowed.  priv is a pointer to private data that the notifier routine
- * can use to determine if the signal should be blocked or not.
- */
-void
-block_all_signals(int (*notifier)(void *priv), void *priv, sigset_t *mask)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&current->sighand->siglock, flags);
-	current->notifier_mask = mask;
-	current->notifier_data = priv;
-	current->notifier = notifier;
-	spin_unlock_irqrestore(&current->sighand->siglock, flags);
-}
-
-/* Notify the system that blocking has ended. */
-
-void
-unblock_all_signals(void)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&current->sighand->siglock, flags);
-	current->notifier = NULL;
-	current->notifier_data = NULL;
-	recalc_sigpending();
-	spin_unlock_irqrestore(&current->sighand->siglock, flags);
-}
-
 static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 {
 	struct sigqueue *q, *first = NULL;
@@ -580,19 +545,8 @@ static int __dequeue_signal(struct sigpe
 {
 	int sig = next_signal(pending, mask);
 
-	if (sig) {
-		if (current->notifier) {
-			if (sigismember(current->notifier_mask, sig)) {
-				if (!(current->notifier)(current->notifier_data)) {
-					clear_thread_flag(TIF_SIGPENDING);
-					return 0;
-				}
-			}
-		}
-
+	if (sig)
 		collect_signal(sig, pending, info);
-	}
-
 	return sig;
 }
 
@@ -2483,9 +2437,6 @@ EXPORT_SYMBOL(force_sig);
 EXPORT_SYMBOL(send_sig);
 EXPORT_SYMBOL(send_sig_info);
 EXPORT_SYMBOL(sigprocmask);
-EXPORT_SYMBOL(block_all_signals);
-EXPORT_SYMBOL(unblock_all_signals);
