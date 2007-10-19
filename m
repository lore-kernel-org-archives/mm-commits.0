From: akpm@linux-foundation.org
Subject: - pm-rename-hibernation_ops-to-platform_hibernation_ops.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:53 -0700
Message-ID: <200710190340.l9J3ernY012745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59819 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966306AbXJSD4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, greg@kroah.com, lenb@kernel.org, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     PM: Rename hibernation_ops to platform_hibernation_ops
has been removed from the -mm tree.  Its filename was
     pm-rename-hibernation_ops-to-platform_hibernation_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PM: Rename hibernation_ops to platform_hibernation_ops
From: Rafael J. Wysocki <rjw@sisk.pl>

Rename 'struct hibernation_ops' to 'struct platform_hibernation_ops' in
analogy with 'struct platform_suspend_ops'.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |    2 +-
 include/linux/suspend.h   |    8 ++++----
 kernel/power/disk.c       |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/acpi/sleep/main.c~pm-rename-hibernation_ops-to-platform_hibernation_ops drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~pm-rename-hibernation_ops-to-platform_hibernation_ops
+++ a/drivers/acpi/sleep/main.c
@@ -282,7 +282,7 @@ static void acpi_hibernation_restore_cle
 	acpi_hw_enable_all_runtime_gpes();
 }
 
-static struct hibernation_ops acpi_hibernation_ops = {
+static struct platform_hibernation_ops acpi_hibernation_ops = {
 	.start = acpi_hibernation_start,
 	.pre_snapshot = acpi_hibernation_prepare,
 	.finish = acpi_hibernation_finish,
diff -puN include/linux/suspend.h~pm-rename-hibernation_ops-to-platform_hibernation_ops include/linux/suspend.h
--- a/include/linux/suspend.h~pm-rename-hibernation_ops-to-platform_hibernation_ops
+++ a/include/linux/suspend.h
@@ -127,7 +127,7 @@ extern void drain_local_pages(void);
 extern void mark_free_pages(struct zone *zone);
 
 /**
- * struct hibernation_ops - hibernation platform support
+ * struct platform_hibernation_ops - hibernation platform support
  *
  * The methods in this structure allow a platform to override the default
  * mechanism of shutting down the machine during a hibernation transition.
@@ -164,7 +164,7 @@ extern void mark_free_pages(struct zone 
  *	Called right after the nonboot CPUs have been enabled and before
  *	thawing devices (runs with IRQs on).
  */
-struct hibernation_ops {
+struct platform_hibernation_ops {
 	int (*start)(void);
 	int (*pre_snapshot)(void);
 	void (*finish)(void);
@@ -190,14 +190,14 @@ extern void swsusp_set_page_free(struct 
 extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 
-extern void hibernation_set_ops(struct hibernation_ops *ops);
+extern void hibernation_set_ops(struct platform_hibernation_ops *ops);
 extern int hibernate(void);
 #else /* CONFIG_HIBERNATION */
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
 
-static inline void hibernation_set_ops(struct hibernation_ops *ops) {}
+static inline void hibernation_set_ops(struct platform_hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
 #endif /* CONFIG_HIBERNATION */
 
diff -puN kernel/power/disk.c~pm-rename-hibernation_ops-to-platform_hibernation_ops kernel/power/disk.c
--- a/kernel/power/disk.c~pm-rename-hibernation_ops-to-platform_hibernation_ops
+++ a/kernel/power/disk.c
@@ -45,14 +45,14 @@ enum {
 
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
-static struct hibernation_ops *hibernation_ops;
+static struct platform_hibernation_ops *hibernation_ops;
 
 /**
  * hibernation_set_ops - set the global hibernate operations
  * @ops: the hibernation operations to use in subsequent hibernation transitions
  */
 
-void hibernation_set_ops(struct hibernation_ops *ops)
+void hibernation_set_ops(struct platform_hibernation_ops *ops)
 {
 	if (ops && !(ops->start && ops->pre_snapshot && ops->finish
 	    && ops->prepare && ops->enter && ops->pre_restore
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
revert-x86_64-mm-cpa-einval.patch
shrink_slab-handle-bad-shrinkers.patch
