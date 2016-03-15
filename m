From: akpm@linux-foundation.org
Subject: +
 watchdog-dont-run-proc_watchdog_update-if-new-value-is-same-as-old.patch
 added to -mm tree
Date: Tue, 15 Mar 2016 10:52:17 -0700
Message-ID: <56e84bd1.j40l4d0QGzI8qKO2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbcCORwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 13:52:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johunt@akamai.com, dzickus@redhat.com, stable@vger.kernel.org, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: don't run proc_watchdog_update if new value is same as old
has been added to the -mm tree.  Its filename is
     watchdog-dont-run-proc_watchdog_update-if-new-value-is-same-as-old.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-dont-run-proc_watchdog_update-if-new-value-is-same-as-old.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-dont-run-proc_watchdog_update-if-new-value-is-same-as-old.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joshua Hunt <johunt@akamai.com>
Subject: watchdog: don't run proc_watchdog_update if new value is same as old

While working on a script to restore all sysctl params before a series of
tests I found that writing any value into the
/proc/sys/kernel/{nmi_watchdog,soft_watchdog,watchdog,watchdog_thresh}
causes them to call proc_watchdog_update().

[  955.756196] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[  955.765994] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[  955.774619] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[  955.783182] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.

There doesn't appear to be a reason for doing this work every time a write
occurs, so only do it when the values change.

Signed-off-by: Josh Hunt <johunt@akamai.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: <stable@vger.kernel.org>	[4.1.x+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN kernel/watchdog.c~watchdog-dont-run-proc_watchdog_update-if-new-value-is-same-as-old kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-dont-run-proc_watchdog_update-if-new-value-is-same-as-old
+++ a/kernel/watchdog.c
@@ -923,6 +923,9 @@ static int proc_watchdog_common(int whic
 		 * both lockup detectors are disabled if proc_watchdog_update()
 		 * returns an error.
 		 */
+		if (old == new)
+			goto out;
+
 		err = proc_watchdog_update();
 	}
 out:
@@ -967,7 +970,7 @@ int proc_soft_watchdog(struct ctl_table
 int proc_watchdog_thresh(struct ctl_table *table, int write,
 			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	int err, old;
+	int err, old, new;
 
 	get_online_cpus();
 	mutex_lock(&watchdog_proc_mutex);
@@ -987,6 +990,10 @@ int proc_watchdog_thresh(struct ctl_tabl
 	/*
 	 * Update the sample period. Restore on failure.
 	 */
+	new = ACCESS_ONCE(watchdog_thresh);
+	if (old == new)
+		goto out;
+
 	set_sample_period();
 	err = proc_watchdog_update();
 	if (err) {
_

Patches currently in -mm which might be from johunt@akamai.com are

block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
watchdog-dont-run-proc_watchdog_update-if-new-value-is-same-as-old.patch

