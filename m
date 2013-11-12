From: akpm@linux-foundation.org
Subject: [folded-merged]
 epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch removed
 from -mm tree
Date: Tue, 12 Nov 2013 14:42:07 -0800
Message-ID: <5282aebf.SfZ8Eyzi7zHPyAAk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab3KLWmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:42:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, paulmck@us.ibm.com, nzimmer@sgi.com, normalperson@yhbt.net, nelhage@nelhage.com, jbaron@akamai.com, davidel@xmailserver.org, akpm@linux-foundation.org

Subject: [folded-merged] epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,davidel@xmailserver.org,jbaron@akamai.com,nelhage@nelhage.com,normalperson@yhbt.net,nzimmer@sgi.com,paulmck@us.ibm.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:42:07 -0800


The patch titled
     Subject: epoll-do-not-take-global-epmutex-for-simple-topologies-fix
has been removed from the -mm tree.  Its filename was
     epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch

This patch was dropped because it was folded into epoll-do-not-take-global-epmutex-for-simple-topologies.patch

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
@@ -585,13 +585,14 @@ static inline void ep_pm_stay_awake_rcu(
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
@@ -829,12 +830,12 @@ static void ep_ptable_queue_proc(struct
 
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
@@ -850,7 +851,7 @@ static unsigned int ep_eventpoll_poll(st
 	 * During ep_insert() we already hold the ep->mtx for the tfile.
 	 * Prevent re-aquisition.
 	 */
-	arg.locked = ((wait && (wait->_qproc == ep_ptable_queue_proc)) ? 1 : 0);
+	arg.locked = wait && (wait->_qproc == ep_ptable_queue_proc);
 	arg.ep = ep;
 
 	/* Insert inside our poll wait queue */
@@ -1553,7 +1554,7 @@ static int ep_send_events(struct eventpo
 	esed.maxevents = maxevents;
 	esed.events = events;
 
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0, 0);
+	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0, false);
 }
 
 static inline struct timespec ep_set_mstimeout(long ms)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-factor-commit-limit-calculation.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch

