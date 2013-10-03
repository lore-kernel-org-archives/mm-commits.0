From: akpm@linux-foundation.org
Subject: +
 epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch added to
 -mm tree
Date: Thu, 03 Oct 2013 14:52:13 -0700
Message-ID: <524de70d.1mLEnxlQCq3g4bYG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab3JCVwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Oct 2013 17:52:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, paulmck@us.ibm.com, nzimmer@sgi.com, normalperson@yhbt.net, nelhage@nelhage.com, jbaron@akamai.com, davidel@xmailserver.org, akpm@linux-foundation.org

Subject: + epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch added to -mm tree
To: akpm@linux-foundation.org,davidel@xmailserver.org,jbaron@akamai.com,nelhage@nelhage.com,normalperson@yhbt.net,nzimmer@sgi.com,paulmck@us.ibm.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 03 Oct 2013 14:52:13 -0700


The patch titled
     Subject: epoll-do-not-take-global-epmutex-for-simple-topologies-fix
has been added to the -mm tree.  Its filename is
     epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: epoll-do-not-take-global-epmutex-for-simple-topologies-fix

- use `bool' for boolean variables
- remove unneeded/undesirable cast of void*
- add missed ep_scan_ready_list() kerneldoc 

Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Wong <normalperson@yhbt.net>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Nelson Elhage <nelhage@nelhage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/eventpoll.c~epoll-do-not-take-global-epmutex-for-simple-topologies-fix fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-do-not-take-global-epmutex-for-simple-topologies-fix
+++ a/fs/eventpoll.c
@@ -589,13 +589,14 @@ static inline void ep_pm_stay_awake_rcu(
  * @sproc: Pointer to the scan callback.
  * @priv: Private opaque data passed to the @sproc callback.
  * @depth: The current depth of recursive f_op->poll calls.
+ * @ep_locked: caller already holds ep->mtx
  *
  * Returns: The same integer error code returned by the @sproc callback.
  */
 static int ep_scan_ready_list(struct eventpoll *ep,
 			      int (*sproc)(struct eventpoll *,
 					   struct list_head *, void *),
-			      void *priv, int depth, int ep_locked)
+			      void *priv, int depth, bool ep_locked)
 {
 	int error, pwake = 0;
 	unsigned long flags;
@@ -836,12 +837,12 @@ static void ep_ptable_queue_proc(struct
 
 struct readyevents_arg {
 	struct eventpoll *ep;
-	int locked;
+	bool locked;
 };
 
 static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
 {
-	struct readyevents_arg *arg = (struct readyevents_arg *)priv;
+	struct readyevents_arg *arg = priv;
 
 	return ep_scan_ready_list(arg->ep, ep_read_events_proc, NULL,
 				  call_nests + 1, arg->locked);
@@ -857,7 +858,7 @@ static unsigned int ep_eventpoll_poll(st
 	 * During ep_insert() we already hold the ep->mtx for the tfile.
 	 * Prevent re-aquisition.
 	 */
-	arg.locked = ((wait && (wait->_qproc == ep_ptable_queue_proc)) ? 1 : 0);
+	arg.locked = wait && (wait->_qproc == ep_ptable_queue_proc);
 	arg.ep = ep;
 
 	/* Insert inside our poll wait queue */
@@ -1563,7 +1564,7 @@ static int ep_send_events(struct eventpo
 	esed.maxevents = maxevents;
 	esed.events = events;
 
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0, 0);
+	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0, false);
 }
 
 static inline struct timespec ep_set_mstimeout(long ms)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ipc-update-locking-scheme-comments-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

