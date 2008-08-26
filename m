From: akpm@linux-foundation.org
Subject: + acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically.patch added to -mm tree
Date: Tue, 26 Aug 2008 16:06:44 -0700
Message-ID: <200808262306.m7QN6iIw032498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbYHZXHZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 19:07:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: astarikovskiy@suse.de, andi@firstfloor.org, hmh@hmh.eng.br, maxi@daemonizer.de, stable@kernel.org


The patch titled
     ACPI: EC: Don't degrade to poll mode at storm automatically
has been added to the -mm tree.  Its filename is
     acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically.patch

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
Subject: ACPI: EC: Don't degrade to poll mode at storm automatically
From: Alexey Starikovskiy <astarikovskiy@suse.de>

Not all users of semi-broken EC devices want to degrade to poll mode, so
give them right to choose.

This fixes a regression in 2.6.26 (from 2.6.25.3).  Initially reported as
"Asus Eee PC hotkeys stop working if pressed quickly" in bugzilla
<http://bugzilla.kernel.org/show_bug.cgi?id=11089>.

The regression was caused by a recently added check for interrupt storms. 
The Eee PC triggers this check and switches to polling.  When multiple
events arrive between polling intervals, only one is fetched from the EC. 
This causes erroneous behaviour; ultimately events stop being delivered
altogether when the EC buffer overflows.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++
 drivers/acpi/ec.c                   |   36 ++++++++++++++++++--------
 2 files changed, 31 insertions(+), 10 deletions(-)

diff -puN Documentation/kernel-parameters.txt~acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically
+++ a/Documentation/kernel-parameters.txt
@@ -741,6 +741,11 @@ and is between 256 and 4096 characters. 
 
 	eata=		[HW,SCSI]
 
+	ec_intr=	[HW,ACPI] ACPI Embedded Controller interrupt mode
+			Format: <int>
+			0: polling mode
+			non-0: interrupt mode (default)
+
 	edd=		[EDD]
 			Format: {"off" | "on" | "skip[mbr]"}
 
diff -puN drivers/acpi/ec.c~acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically
+++ a/drivers/acpi/ec.c
@@ -110,6 +110,8 @@ static struct acpi_ec {
 	u8 handlers_installed;
 } *boot_ec, *first_ec;
 
+int acpi_ec_intr = 1; /* Default is interrupt mode */
+
 /* 
  * Some Asus system have exchanged ECDT data/command IO addresses.
  */
@@ -516,12 +518,14 @@ static u32 acpi_ec_gpe_handler(void *dat
 	acpi_status status = AE_OK;
 	struct acpi_ec *ec = data;
 	u8 state = acpi_ec_read_status(ec);
+	static bool warn_done = 0;
 
 	pr_debug(PREFIX "~~~> interrupt\n");
 	atomic_inc(&ec->irq_count);
-	if (atomic_read(&ec->irq_count) > 5) {
-		pr_err(PREFIX "GPE storm detected, disabling EC GPE\n");
-		ec_switch_to_poll_mode(ec);
+	if (!warn_done && atomic_read(&ec->irq_count) > 5) {
+		pr_warning(PREFIX "GPE storm detected, try to use ec_intr=0 "
+			"kernel option, if you see problems with keyboard.\n");
+		warn_done = 1;
 		goto end;
 	}
 	clear_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
@@ -848,20 +852,21 @@ static int ec_install_handlers(struct ac
 	acpi_status status;
 	if (ec->handlers_installed)
 		return 0;
-	status = acpi_install_gpe_handler(NULL, ec->gpe,
+	if (acpi_ec_intr) {
+		status = acpi_install_gpe_handler(NULL, ec->gpe,
 					  ACPI_GPE_EDGE_TRIGGERED,
 					  &acpi_ec_gpe_handler, ec);
-	if (ACPI_FAILURE(status))
-		return -ENODEV;
-
-	acpi_set_gpe_type(NULL, ec->gpe, ACPI_GPE_TYPE_RUNTIME);
-	acpi_enable_gpe(NULL, ec->gpe, ACPI_NOT_ISR);
+		if (ACPI_FAILURE(status))
+			return -ENODEV;
 
+		acpi_set_gpe_type(NULL, ec->gpe, ACPI_GPE_TYPE_RUNTIME);
+		acpi_enable_gpe(NULL, ec->gpe, ACPI_NOT_ISR);
+	}
 	status = acpi_install_address_space_handler(ec->handle,
 						    ACPI_ADR_SPACE_EC,
 						    &acpi_ec_space_handler,
 						    NULL, ec);
-	if (ACPI_FAILURE(status)) {
+	if (ACPI_FAILURE(status) && acpi_ec_intr) {
 		acpi_remove_gpe_handler(NULL, ec->gpe, &acpi_ec_gpe_handler);
 		return -ENODEV;
 	}
@@ -1047,3 +1052,14 @@ static void __exit acpi_ec_exit(void)
 	return;
 }
 #endif	/* 0 */
+
+static int __init acpi_ec_set_intr_mode(char *str)
+{
+	if (!get_option(&str, &acpi_ec_intr)) {
+		acpi_ec_intr = 0;
+		return 0;
+	}
+	return 1;
+}
+
+__setup("ec_intr=", acpi_ec_set_intr_mode);
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

linux-next.patch
acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically.patch
acpi-avoid-dropping-rapid-hotkey-events-or-other-gpes-on-asus-eeepc.patch

