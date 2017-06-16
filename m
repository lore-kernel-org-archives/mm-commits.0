From: akpm@linux-foundation.org
Subject: + watchdog-provide-watchdog_reconfigure-for-arch-watchdogs.patch
 added to -mm tree
Date: Fri, 16 Jun 2017 11:25:00 -0700
Message-ID: <5944227c.7AepwgXCLgP/77pl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59366 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753004AbdFPSZC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 14:25:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@gmail.com, babu.moger@oracle.com, benh@kernel.crashing.org, dzickus@redhat.com, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog: provide watchdog_nmi_reconfigure() for arch watchdogs
has been added to the -mm tree.  Its filename is
     watchdog-provide-watchdog_reconfigure-for-arch-watchdogs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-provide-watchdog_reconfigure-for-arch-watchdogs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-provide-watchdog_reconfigure-for-arch-watchdogs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: kernel/watchdog: provide watchdog_nmi_reconfigure() for arch watchdogs

After reconfiguring watchdog sysctls etc., architecture specific watchdogs
may not get all their parameters updated.

watchdog_nmi_reconfigure() can be implemented to pull the new values in
and set the arch NMI watchdog.

Link: http://lkml.kernel.org/r/20170616065715.18390-5-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Don Zickus <dzickus@redhat.com>
Tested-by: Babu Moger <babu.moger@oracle.com>	[sparc]
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff -puN kernel/watchdog.c~watchdog-provide-watchdog_reconfigure-for-arch-watchdogs kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-provide-watchdog_reconfigure-for-arch-watchdogs
+++ a/kernel/watchdog.c
@@ -123,6 +123,11 @@ void __weak watchdog_nmi_disable(unsigne
 {
 }
 
+void __weak watchdog_nmi_reconfigure(void)
+{
+}
+
+
 #ifdef CONFIG_SOFTLOCKUP_DETECTOR
 
 /* Helper for online, unparked cpus. */
@@ -600,6 +605,12 @@ static void watchdog_disable_all_cpus(vo
 	}
 }
 
+static int watchdog_update_cpus(void)
+{
+	return smpboot_update_cpumask_percpu_thread(
+		    &watchdog_threads, &watchdog_cpumask);
+}
+
 #else /* SOFTLOCKUP */
 static int watchdog_park_threads(void)
 {
@@ -619,6 +630,11 @@ static void watchdog_disable_all_cpus(vo
 {
 }
 
+static int watchdog_update_cpus(void)
+{
+	return 0;
+}
+
 static void set_sample_period(void)
 {
 }
@@ -651,6 +667,8 @@ int lockup_detector_suspend(void)
 		watchdog_enabled = 0;
 	}
 
+	watchdog_nmi_reconfigure();
+
 	mutex_unlock(&watchdog_proc_mutex);
 
 	return ret;
@@ -671,6 +689,8 @@ void lockup_detector_resume(void)
 	if (watchdog_running && !watchdog_suspended)
 		watchdog_unpark_threads();
 
+	watchdog_nmi_reconfigure();
+
 	mutex_unlock(&watchdog_proc_mutex);
 	put_online_cpus();
 }
@@ -696,6 +716,8 @@ static int proc_watchdog_update(void)
 	else
 		watchdog_disable_all_cpus();
 
+	watchdog_nmi_reconfigure();
+
 	return err;
 
 }
@@ -881,12 +903,11 @@ int proc_watchdog_cpumask(struct ctl_tab
 			 * a temporary cpumask, so we are likely not in a
 			 * position to do much else to make things better.
 			 */
-#ifdef CONFIG_SOFTLOCKUP_DETECTOR
-			if (smpboot_update_cpumask_percpu_thread(
-				    &watchdog_threads, &watchdog_cpumask) != 0)
+			if (watchdog_update_cpus() != 0)
 				pr_err("cpumask update failed\n");
-#endif
 		}
+
+		watchdog_nmi_reconfigure();
 	}
 out:
 	mutex_unlock(&watchdog_proc_mutex);
_

Patches currently in -mm which might be from npiggin@gmail.com are

watchdog-remove-unused-declaration.patch
watchdog-introduce-arch_touch_nmi_watchdog.patch
watchdog-split-up-config-options.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog.patch

