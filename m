From: akpm@linux-foundation.org
Subject: - freezer-remove-pf_nofreeze-from-bluetooth-threads.patch removed from -mm tree
Date: Fri, 11 May 2007 12:28:44 -0700
Message-ID: <200705111928.l4BJSixH024560@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759773AbXEKT3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, aneesh.kumar@gmail.com, ego@in.ibm.com, marcel@holtmann.org, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, pavel@ucw.cz, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     freezer: remove PF_NOFREEZE from bluetooth threads
has been removed from the -mm tree.  Its filename was
     freezer-remove-pf_nofreeze-from-bluetooth-threads.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: freezer: remove PF_NOFREEZE from bluetooth threads
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove PF_NOFREEZE from the bluetooth threads, adding try_to_freeze() calls as
required.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Aneesh Kumar <aneesh.kumar@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/bnep/core.c   |    4 +++-
 net/bluetooth/cmtp/core.c   |    4 +++-
 net/bluetooth/hidp/core.c   |    4 +++-
 net/bluetooth/rfcomm/core.c |    3 ++-
 4 files changed, 11 insertions(+), 4 deletions(-)

diff -puN net/bluetooth/bnep/core.c~freezer-remove-pf_nofreeze-from-bluetooth-threads net/bluetooth/bnep/core.c
--- a/net/bluetooth/bnep/core.c~freezer-remove-pf_nofreeze-from-bluetooth-threads
+++ a/net/bluetooth/bnep/core.c
@@ -38,6 +38,7 @@
 #include <linux/wait.h>
 #include <linux/errno.h>
 #include <linux/net.h>
+#include <linux/freezer.h>
 #include <net/sock.h>
 
 #include <linux/socket.h>
@@ -474,11 +475,12 @@ static int bnep_session(void *arg)
 
 	daemonize("kbnepd %s", dev->name);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
 	while (!atomic_read(&s->killed)) {
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		// RX
diff -puN net/bluetooth/cmtp/core.c~freezer-remove-pf_nofreeze-from-bluetooth-threads net/bluetooth/cmtp/core.c
--- a/net/bluetooth/cmtp/core.c~freezer-remove-pf_nofreeze-from-bluetooth-threads
+++ a/net/bluetooth/cmtp/core.c
@@ -34,6 +34,7 @@
 #include <linux/ioctl.h>
 #include <linux/file.h>
 #include <linux/init.h>
+#include <linux/freezer.h>
 #include <net/sock.h>
 
 #include <linux/isdn/capilli.h>
@@ -287,11 +288,12 @@ static int cmtp_session(void *arg)
 
 	daemonize("kcmtpd_ctr_%d", session->num);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
 	while (!atomic_read(&session->terminate)) {
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (sk->sk_state != BT_CONNECTED)
diff -puN net/bluetooth/hidp/core.c~freezer-remove-pf_nofreeze-from-bluetooth-threads net/bluetooth/hidp/core.c
--- a/net/bluetooth/hidp/core.c~freezer-remove-pf_nofreeze-from-bluetooth-threads
+++ a/net/bluetooth/hidp/core.c
@@ -35,6 +35,7 @@
 #include <linux/file.h>
 #include <linux/init.h>
 #include <linux/wait.h>
+#include <linux/freezer.h>
 #include <net/sock.h>
 
 #include <linux/input.h>
@@ -547,13 +548,14 @@ static int hidp_session(void *arg)
 
 	daemonize("khidpd_%04x%04x", vendor, product);
 	set_user_nice(current, -15);
-	current->flags |= PF_NOFREEZE;
 
 	init_waitqueue_entry(&ctrl_wait, current);
 	init_waitqueue_entry(&intr_wait, current);
 	add_wait_queue(ctrl_sk->sk_sleep, &ctrl_wait);
 	add_wait_queue(intr_sk->sk_sleep, &intr_wait);
 	while (!atomic_read(&session->terminate)) {
+		try_to_freeze();
+
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (ctrl_sk->sk_state != BT_CONNECTED || intr_sk->sk_state != BT_CONNECTED)
diff -puN net/bluetooth/rfcomm/core.c~freezer-remove-pf_nofreeze-from-bluetooth-threads net/bluetooth/rfcomm/core.c
--- a/net/bluetooth/rfcomm/core.c~freezer-remove-pf_nofreeze-from-bluetooth-threads
+++ a/net/bluetooth/rfcomm/core.c
@@ -37,6 +37,7 @@
 #include <linux/device.h>
 #include <linux/net.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 #include <net/sock.h>
 #include <asm/uaccess.h>
@@ -1854,6 +1855,7 @@ static void rfcomm_worker(void)
 	BT_DBG("");
 
 	while (!atomic_read(&terminate)) {
+		try_to_freeze();
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!test_bit(RFCOMM_SCHED_WAKEUP, &rfcomm_event)) {
 			/* No pending events. Let's sleep.
@@ -1940,7 +1942,6 @@ static int rfcomm_run(void *unused)
 
 	daemonize("krfcommd");
 	set_user_nice(current, -10);
-	current->flags |= PF_NOFREEZE;
 
 	BT_DBG("");
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
add-common-orderly_poweroff.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
