From: akpm@linux-foundation.org
Subject: - pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch removed from -mm tree
Date: Mon, 30 Jul 2007 14:43:56 -0700
Message-ID: <200707302143.l6ULhuRK031927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40127 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967587AbXG3Vol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 17:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, greg@kroah.com, lenb@kernel.org, pavel@ucw.cz, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     PM: Fix compilation of suspend code if CONFIG_PM is unset
has been removed from the -mm tree.  Its filename was
     pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: PM: Fix compilation of suspend code if CONFIG_PM is unset
From: Rafael J. Wysocki <rjw@sisk.pl>

Some platforms, particularly in the ARM tree, require that suspend_set_ops()
and pm_suspend() be defined even if CONFIG_PM is not set.  Make this
requirement be satisfied.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/suspend.h~pm-fix-compilation-of-suspend-code-if-config_pm-is-unset include/linux/suspend.h
--- a/include/linux/suspend.h~pm-fix-compilation-of-suspend-code-if-config_pm-is-unset
+++ a/include/linux/suspend.h
@@ -81,6 +81,7 @@ struct platform_suspend_ops {
 #ifdef CONFIG_SUSPEND
 extern struct platform_suspend_ops *suspend_ops;
 
+#ifdef CONFIG_PM
 /**
  * suspend_set_ops - set platform dependent suspend operations
  * @ops: The new suspend operations to set.
@@ -107,12 +108,12 @@ extern void arch_suspend_disable_irqs(vo
 extern void arch_suspend_enable_irqs(void);
 
 extern int pm_suspend(suspend_state_t state);
-#else /* !CONFIG_SUSPEND */
+#else /* CONFIG_PM */
 #define suspend_valid_only_mem	NULL
 
 static inline void suspend_set_ops(struct platform_suspend_ops *ops) {}
 static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
-#endif /* !CONFIG_SUSPEND */
+#endif /* CONFIG_PM */
 
 /* struct pbe is used for creating lists of pages that should be restored
  * atomically during the resume from disk, because the page frames they have
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
shrink_slab-handle-bad-shrinkers.patch
