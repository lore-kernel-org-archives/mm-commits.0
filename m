From: akpm@linux-foundation.org
Subject: + acpi-remove-references-to-acpi_state_s2-from-acpi_pm_enter.patch added to -mm tree
Date: Tue, 24 Jul 2007 15:12:40 -0700
Message-ID: <200707242212.l6OMCeWW003571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36349 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106AbXGXWMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 18:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, lenb@kernel.org


The patch titled
     ACPI: Remove references to ACPI_STATE_S2 from acpi_pm_enter
has been added to the -mm tree.  Its filename is
     acpi-remove-references-to-acpi_state_s2-from-acpi_pm_enter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: Remove references to ACPI_STATE_S2 from acpi_pm_enter
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove references to ACPI_STATE_S2, introduced by
acpi-implement-the-set_target-callback-from-pm_ops.patch, from acpi_pm_enter().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/acpi/sleep/main.c~acpi-remove-references-to-acpi_state_s2-from-acpi_pm_enter drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-remove-references-to-acpi_state_s2-from-acpi_pm_enter
+++ a/drivers/acpi/sleep/main.c
@@ -81,8 +81,8 @@ static int acpi_pm_prepare(suspend_state
  *	acpi_pm_enter - Actually enter a sleep state.
  *	@pm_state: ignored
  *
- *	Flush caches and go to sleep. For STR or S2, we have to call
- *	arch-specific assembly, which in turn call acpi_enter_sleep_state().
+ *	Flush caches and go to sleep. For STR we have to call arch-specific
+ *	assembly, which in turn call acpi_enter_sleep_state().
  *	It's unfortunate, but it works. Please fix if you're feeling frisky.
  */
 
@@ -95,7 +95,7 @@ static int acpi_pm_enter(suspend_state_t
 	ACPI_FLUSH_CPU_CACHE();
 
 	/* Do arch specific saving of state. */
-	if (acpi_state == ACPI_STATE_S2 || acpi_state == ACPI_STATE_S3) {
+	if (acpi_state == ACPI_STATE_S3) {
 		int error = acpi_save_state_mem();
 
 		if (error) {
@@ -112,7 +112,6 @@ static int acpi_pm_enter(suspend_state_t
 		status = acpi_enter_sleep_state(acpi_state);
 		break;
 
-	case ACPI_STATE_S2:
 	case ACPI_STATE_S3:
 		do_suspend_lowlevel();
 		break;
@@ -129,7 +128,7 @@ static int acpi_pm_enter(suspend_state_t
 	printk(KERN_DEBUG "Back to C!\n");
 
 	/* restore processor state */
-	if (acpi_state == ACPI_STATE_S2 || acpi_state == ACPI_STATE_S3)
+	if (acpi_state == ACPI_STATE_S3)
 		acpi_restore_state_mem();
 
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
_

Patches currently in -mm which might be from rjw@sisk.pl are

pm-fix-compiler-error-of-ppc-dart_iommu.patch
git-acpi.patch
acpi-remove-references-to-acpi_state_s2-from-acpi_pm_enter.patch
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
