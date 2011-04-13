From: akpm@linux-foundation.org
Subject: + acpi-remove-acpi_sleep=s4_nonvs.patch added to -mm tree
Date: Tue, 12 Apr 2011 17:14:48 -0700
Message-ID: <201104130014.p3D0Emwg011377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932669Ab1DMAO6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 20:14:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     acpi: remove acpi_sleep=s4_nonvs
has been added to the -mm tree.  Its filename is
     acpi-remove-acpi_sleep=s4_nonvs.patch

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

acpi-remove-acpi_sleep=s4_nonvs.patch

