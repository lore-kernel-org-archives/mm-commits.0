From: akpm@linux-foundation.org
Subject: - acpi-pm_test-build-fix.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:38:45 -0800
Message-ID: <200712172338.lBHNcjAO008064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34901 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbXLQXit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:38:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     acpi: pm_test build fix
has been removed from the -mm tree.  Its filename was
     acpi-pm_test-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: pm_test build fix
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix compilation problems related to the /sys/power/pm_test attribute. 
Namely, this attribute should also be available when CONFIG_HIBERNATION is
set and CONFIG_SUSPEND is unset and it should not break compilation when
neither of them is set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/main.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/power/main.c~acpi-pm_test-build-fix kernel/power/main.c
--- a/kernel/power/main.c~acpi-pm_test-build-fix
+++ a/kernel/power/main.c
@@ -50,10 +50,6 @@ int pm_notifier_call_chain(unsigned long
 			== NOTIFY_BAD) ? -EINVAL : 0;
 }
 
-#endif /* CONFIG_PM_SLEEP */
-
-#ifdef CONFIG_SUSPEND
-
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
@@ -127,6 +123,10 @@ power_attr(pm_test);
 static inline int suspend_test(int level) { return 0; }
 #endif /* !CONFIG_PM_DEBUG */
 
+#endif /* CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_SUSPEND
+
 /* This is just an arbitrary number */
 #define FREE_PAGE_NUMBER (100)
 
@@ -484,7 +484,7 @@ static struct attribute * g[] = {
 #ifdef CONFIG_PM_TRACE
 	&pm_trace_attr.attr,
 #endif
-#ifdef CONFIG_PM_DEBUG
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PM_DEBUG)
 	&pm_test_attr.attr,
 #endif
 	NULL,
_

Patches currently in -mm which might be from rjw@sisk.pl are

revert-hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
alpha-strncpy-strncat-fixes.patch
sysctl-fix-ax25-checks.patch
git-acpi.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
git-xfs.patch
page-allocator-clean-up-pcp-draining-functions.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
