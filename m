From: akpm@linux-foundation.org
Subject: [merged]
 kernel-watchdogc-touch_nmi_watchdog-should-only-touch-local-cpu-not-every-one.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:48 -0700
Message-ID: <533f0868.HKe3B0bb+bwmWck4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaDDTat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dzickus@redhat.com, benzh@chromium.org

Subject: [merged] kernel-watchdogc-touch_nmi_watchdog-should-only-touch-local-cpu-not-every-one.patch removed from -mm tree
To: benzh@chromium.org,dzickus@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:48 -0700


The patch titled
     Subject: kernel/watchdog.c: touch_nmi_watchdog should only touch local cpu not every one
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-touch_nmi_watchdog-should-only-touch-local-cpu-not-every-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ben Zhang <benzh@chromium.org>
Subject: kernel/watchdog.c: touch_nmi_watchdog should only touch local cpu not every one

I ran into a scenario where while one cpu was stuck and should have
panic'd because of the NMI watchdog, it didn't.  The reason was another
cpu was spewing stack dumps on to the console.  Upon investigation, I
noticed that when writing to the console and also when dumping the stack,
the watchdog is touched.

This causes all the cpus to reset their NMI watchdog flags and the 'stuck'
cpu just spins forever.

This change causes the semantics of touch_nmi_watchdog to be changed
slightly.  Previously, I accidentally changed the semantics and we noticed
there was a codepath in which touch_nmi_watchdog could be touched from a
preemtible area.  That caused a BUG() to happen when CONFIG_DEBUG_PREEMPT
was enabled.  I believe it was the acpi code.

My attempt here re-introduces the change to have the touch_nmi_watchdog()
code only touch the local cpu instead of all of the cpus.  But instead of
using __get_cpu_var(), I use the __raw_get_cpu_var() version.

This avoids the preemption problem.  However my reasoning wasn't because I
was trying to be lazy.  Instead I rationalized it as, well if preemption
is enabled then interrupts should be enabled to and the NMI watchdog will
have no reason to trigger.  So it won't matter if the wrong cpu is touched
because the percpu interrupt counters the NMI watchdog uses should still
be incrementing.

Don said:

: I'm ok with this patch, though it does alter the behaviour of how
: touch_nmi_watchdog works.  For the most part I don't think most callers
: need to touch all of the watchdogs (on each cpu).  Perhaps a corner case
: will pop up (the scheduler??  to mimic touch_all_softlockup_watchdogs() ).
: 
: But this does address an issue where if a system is locked up and one cpu
: is spewing out useful debug messages (or error messages), the hard lockup
: will fail to go off.  We have seen this on RHEL also.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Ben Zhang <benzh@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN kernel/watchdog.c~kernel-watchdogc-touch_nmi_watchdog-should-only-touch-local-cpu-not-every-one kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdogc-touch_nmi_watchdog-should-only-touch-local-cpu-not-every-one
+++ a/kernel/watchdog.c
@@ -158,14 +158,14 @@ void touch_all_softlockup_watchdogs(void
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	if (watchdog_user_enabled) {
-		unsigned cpu;
