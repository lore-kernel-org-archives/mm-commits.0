From: akpm@linux-foundation.org
Subject: + stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines.patch added to -mm tree
Date: Wed, 01 Jul 2009 22:53:45 -0700
Message-ID: <200907020553.n625rjWr013828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbZGBFyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 01:54:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, rusty@rustcorp.com.au, stable@kernel.org, travis@sgi.com


The patch titled
     stop_machine() stalls for a considerable period on large cpu count machines
has been added to the -mm tree.  Its filename is
     stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: stop_machine() stalls for a considerable period on large cpu count machines
From: Robin Holt <holt@sgi.com>

Mike Travis noted that a 2048 cpu machine booting would take hours to get
through its modprobes.  We would get numerous back traces from stop_cpu
indicating they had not serviced interrupts.

A quick code review indicated we have a situation of heavy cacheline
contention due to the 'state' (read-mostly) and 'thread_ack'
(write-mostly) variables being located in the same cacheline.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN kernel/stop_machine.c~stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines
+++ a/kernel/stop_machine.c
@@ -13,6 +13,13 @@
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
+/*
+ * It is important to keep 'thread_ack' and 'state' in a seperate
+ * cachelines to prevent cacheline sharing between threads updating
+ * thread_ack and other threads spinning on state.
+ */
+static atomic_t thread_ack	____cacheline_aligned;
+
 /* This controls the threads on each CPU. */
 enum stopmachine_state {
 	/* Dummy starting state for thread. */
@@ -26,7 +33,7 @@ enum stopmachine_state {
 	/* Exit */
 	STOPMACHINE_EXIT,
 };
-static enum stopmachine_state state;
+static enum stopmachine_state state ____cacheline_aligned;
 
 struct stop_machine_data {
 	int (*fn)(void *);
@@ -36,7 +43,6 @@ struct stop_machine_data {
 
 /* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
 static unsigned int num_threads;
-static atomic_t thread_ack;
 static DEFINE_MUTEX(lock);
 /* setup_lock protects refcount, stop_machine_wq and stop_machine_work. */
 static DEFINE_MUTEX(setup_lock);
_

Patches currently in -mm which might be from holt@sgi.com are

stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines.patch
stop_machine-stalls-for-a-considerable-period-on-large-cpu-count-machines-fix.patch

