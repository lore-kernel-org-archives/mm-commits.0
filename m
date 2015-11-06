From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:08 -0800
Message-ID: <563d0830.cWKwiB0pN4BNrmrB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161875AbbKFUGJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: move watchdog_disable_all_cpus() outside of ifdef
has been removed from the -mm tree.  Its filename was
     watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: move watchdog_disable_all_cpus() outside of ifdef

Move watchdog_disable_all_cpus() outside of the ifdef so that it is
available if CONFIG_SYSCTL is not defined.  This is preparation for
"watchdog: implement error handling in update_watchdog_all_cpus() and
callers".

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/watchdog.c~watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-move-watchdog_disable_all_cpus-outside-of-ifdef
+++ a/kernel/watchdog.c
@@ -347,6 +347,9 @@ static void watchdog_interrupt_count(voi
 static int watchdog_nmi_enable(unsigned int cpu);
 static void watchdog_nmi_disable(unsigned int cpu);
 
+static int watchdog_enable_all_cpus(void);
+static void watchdog_disable_all_cpus(void);
+
 /* watchdog kicker functions */
 static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 {
@@ -756,9 +759,6 @@ static int watchdog_enable_all_cpus(void
 	return err;
 }
 
-/* prepare/enable/disable routines */
-/* sysctl functions */
-#ifdef CONFIG_SYSCTL
 static void watchdog_disable_all_cpus(void)
 {
 	if (watchdog_running) {
@@ -767,6 +767,8 @@ static void watchdog_disable_all_cpus(vo
 	}
 }
 
+#ifdef CONFIG_SYSCTL
+
 /*
  * Update the run state of the lockup detectors.
  */
_

Patches currently in -mm which might be from uobergfe@redhat.com are


