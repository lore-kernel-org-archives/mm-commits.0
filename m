From: akpm@linux-foundation.org
Subject: + pm-acpi-hibernation-utilize-hardware-signature.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:41:05 -0700
Message-ID: <200807111846.m6BIkkja031033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754874AbYGKSrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, andi@firstfloor.org, lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     pm: acpi hibernation: utilize hardware signature
has been added to the -mm tree.  Its filename is
     pm-acpi-hibernation-utilize-hardware-signature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: acpi hibernation: utilize hardware signature
From: Shaohua Li <shaohua.li@intel.com>

ACPI defines a hardware signature.  BIOS calculates the signature according to
hardware configure and if hardware changes while hibernated, the signature
will change.  In that case, S4 resume should fail.

Still, there may be systems on which this mechanism does not work correctly,
so it is better to provide a workaround for them.  For this reason, add a new
switch to the acpi_sleep= command line argument allowing one to disable
hardware signature checking.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 +++-
 arch/x86/kernel/acpi/sleep.c        |    2 ++
 drivers/acpi/sleep/main.c           |   22 ++++++++++++++++++++++
 include/linux/acpi.h                |    1 +
 4 files changed, 28 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~pm-acpi-hibernation-utilize-hardware-signature Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~pm-acpi-hibernation-utilize-hardware-signature
+++ a/Documentation/kernel-parameters.txt
@@ -148,10 +148,12 @@ and is between 256 and 4096 characters. 
 			default: 0
 
 	acpi_sleep=	[HW,ACPI] Sleep options
-			Format: { s3_bios, s3_mode, s3_beep, old_ordering }
+			Format: { s3_bios, s3_mode, s3_beep, s4_nohwsig, old_ordering }
 			See Documentation/power/video.txt for s3_bios and s3_mode.
 			s3_beep is for debugging; it makes the PC's speaker beep
 			as soon as the kernel's real-mode entry point is called.
+			s4_nohwsig prevents ACPI hardware signature from being
+			used during resume from hibernation.
 			old_ordering causes the ACPI 1.0 ordering of the _PTS
 			control method, wrt putting devices into low power
 			states, to be enforced (the ACPI 2.0 ordering of _PTS is
diff -puN arch/x86/kernel/acpi/sleep.c~pm-acpi-hibernation-utilize-hardware-signature arch/x86/kernel/acpi/sleep.c
--- a/arch/x86/kernel/acpi/sleep.c~pm-acpi-hibernation-utilize-hardware-signature
+++ a/arch/x86/kernel/acpi/sleep.c
@@ -140,6 +140,8 @@ static int __init acpi_sleep_setup(char 
 			acpi_realmode_flags |= 2;
 		if (strncmp(str, "s3_beep", 7) == 0)
 			acpi_realmode_flags |= 4;
+		if (strncmp(str, "s4_nohwsig", 10) == 0)
+			acpi_no_s4_hw_signature();
 		if (strncmp(str, "old_ordering", 12) == 0)
 			acpi_old_suspend_ordering();
 		str = strchr(str, ',');
diff -puN drivers/acpi/sleep/main.c~pm-acpi-hibernation-utilize-hardware-signature drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~pm-acpi-hibernation-utilize-hardware-signature
+++ a/drivers/acpi/sleep/main.c
@@ -283,6 +283,15 @@ static struct platform_suspend_ops acpi_
 #endif /* CONFIG_SUSPEND */
 
 #ifdef CONFIG_HIBERNATION
+static unsigned long s4_hardware_signature;
+static struct acpi_table_facs *facs;
+static bool nosigcheck;
+
+void __init acpi_no_s4_hw_signature(void)
+{
+	nosigcheck = true;
+}
+
 static int acpi_hibernation_begin(void)
 {
 	acpi_target_sleep_state = ACPI_STATE_S4;
@@ -316,6 +325,12 @@ static void acpi_hibernation_leave(void)
 	acpi_enable();
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(ACPI_STATE_S4);
+	/* Check the hardware signature */
+	if (facs && s4_hardware_signature != facs->hardware_signature) {
+		printk(KERN_EMERG "ACPI: Hardware changed while hibernated, "
+			"cannot resume!\n");
+		panic("ACPI S4 hardware signature mismatch");
+	}
 }
 
 static void acpi_pm_enable_gpes(void)
@@ -519,6 +534,13 @@ int __init acpi_sleep_init(void)
 			&acpi_hibernation_ops_old : &acpi_hibernation_ops);
 		sleep_states[ACPI_STATE_S4] = 1;
 		printk(" S4");
+		if (!nosigcheck) {
+			acpi_get_table_by_index(ACPI_TABLE_INDEX_FACS,
+				(struct acpi_table_header **)&facs);
+			if (facs)
+				s4_hardware_signature =
+					facs->hardware_signature;
+		}
 	}
 #endif
 	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
diff -puN include/linux/acpi.h~pm-acpi-hibernation-utilize-hardware-signature include/linux/acpi.h
--- a/include/linux/acpi.h~pm-acpi-hibernation-utilize-hardware-signature
+++ a/include/linux/acpi.h
@@ -236,6 +236,7 @@ int acpi_check_mem_region(resource_size_
 		      const char *name);
 
 #ifdef CONFIG_PM_SLEEP
+void __init acpi_no_s4_hw_signature(void);
 void __init acpi_old_suspend_ordering(void);
 #endif /* CONFIG_PM_SLEEP */
 #else	/* CONFIG_ACPI */
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
pm-serio-speed-up-resume.patch
pm-acpi-hibernation-utilize-hardware-signature.patch

