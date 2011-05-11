From: akpm@linux-foundation.org
Subject: [merged] acpi-remove-acpi_sleep=s4_nonvs.patch removed from -mm tree
Date: Wed, 11 May 2011 12:07:58 -0700
Message-ID: <201105111900.p4BJ0edB018872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840Ab1EKTBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 May 2011 15:01:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     acpi: remove acpi_sleep=s4_nonvs
has been removed from the -mm tree.  Its filename was
     acpi-remove-acpi_sleep=s4_nonvs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: remove acpi_sleep=s4_nonvs
From: Amerigo Wang <amwang@redhat.com>

acpi_sleep=s4_nonvs is superseded by acpi_sleep=nonvs.

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    8 --------
 Documentation/kernel-parameters.txt        |    2 +-
 arch/x86/kernel/acpi/sleep.c               |    5 -----
 3 files changed, 1 insertion(+), 14 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~acpi-remove-acpi_sleep=s4_nonvs Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~acpi-remove-acpi_sleep=s4_nonvs
+++ a/Documentation/feature-removal-schedule.txt
@@ -439,14 +439,6 @@ Who:	Thomas Gleixner <tglx@linutronix.de
 
 ----------------------------
 
-What:	The acpi_sleep=s4_nonvs command line option
-When:	2.6.37
-Files:	arch/x86/kernel/acpi/sleep.c
-Why:	superseded by acpi_sleep=nonvs
-Who:	Rafael J. Wysocki <rjw@sisk.pl>
-
-----------------------------
-
 What: 	PCI DMA unmap state API
 When:	August 2012
 Why:	PCI DMA unmap state API (include/linux/pci-dma.h) was replaced
diff -puN Documentation/kernel-parameters.txt~acpi-remove-acpi_sleep=s4_nonvs Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~acpi-remove-acpi_sleep=s4_nonvs
+++ a/Documentation/kernel-parameters.txt
@@ -245,7 +245,7 @@ bytes respectively. Such letter suffixes
 
 	acpi_sleep=	[HW,ACPI] Sleep options
 			Format: { s3_bios, s3_mode, s3_beep, s4_nohwsig,
-				  old_ordering, s4_nonvs, sci_force_enable }
+				  old_ordering, nonvs, sci_force_enable }
 			See Documentation/power/video.txt for information on
 			s3_bios and s3_mode.
 			s3_beep is for debugging; it makes the PC's speaker beep
diff -puN arch/x86/kernel/acpi/sleep.c~acpi-remove-acpi_sleep=s4_nonvs arch/x86/kernel/acpi/sleep.c
--- a/arch/x86/kernel/acpi/sleep.c~acpi-remove-acpi_sleep=s4_nonvs
+++ a/arch/x86/kernel/acpi/sleep.c
@@ -112,11 +112,6 @@ static int __init acpi_sleep_setup(char 
 #ifdef CONFIG_HIBERNATION
 		if (strncmp(str, "s4_nohwsig", 10) == 0)
 			acpi_no_s4_hw_signature();
-		if (strncmp(str, "s4_nonvs", 8) == 0) {
-			pr_warning("ACPI: acpi_sleep=s4_nonvs is deprecated, "
-					"please use acpi_sleep=nonvs instead");
-			acpi_nvs_nosave();
-		}
 #endif
 		if (strncmp(str, "nonvs", 5) == 0)
 			acpi_nvs_nosave();
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
fscache-remove-dead-code-under-config_workqueue_debugfs.patch

