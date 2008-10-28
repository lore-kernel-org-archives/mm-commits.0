From: akpm@linux-foundation.org
Subject: - acpi-suspend-fix-compilation-for-acpi_sleep-unset-and-xen_save_restore-set.patch removed from -mm tree
Date: Mon, 27 Oct 2008 17:11:17 -0700
Message-ID: <200810280011.m9S0BHW7026998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbYJ1AL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 20:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI suspend: fix compilation for ACPI_SLEEP unset and XEN_SAVE_RESTORE set
has been removed from the -mm tree.  Its filename was
     acpi-suspend-fix-compilation-for-acpi_sleep-unset-and-xen_save_restore-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI suspend: fix compilation for ACPI_SLEEP unset and XEN_SAVE_RESTORE set
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/acpi/sleep/main.c~acpi-suspend-fix-compilation-for-acpi_sleep-unset-and-xen_save_restore-set drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-suspend-fix-compilation-for-acpi_sleep-unset-and-xen_save_restore-set
+++ a/drivers/acpi/sleep/main.c
@@ -163,6 +163,8 @@ static void acpi_pm_end(void)
 	acpi_target_sleep_state = ACPI_STATE_S0;
 	acpi_sleep_tts_switch(acpi_target_sleep_state);
 }
+#else /* !CONFIG_ACPI_SLEEP */
+#define acpi_target_sleep_state	ACPI_STATE_S0
 #endif /* CONFIG_ACPI_SLEEP */
 
 #ifdef CONFIG_SUSPEND
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
e100-adapt-to-the-reworked-pci-pm.patch
shrink_slab-handle-bad-shrinkers.patch

