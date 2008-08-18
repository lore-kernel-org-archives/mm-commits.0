From: akpm@linux-foundation.org
Subject: - acpi-trivial-cleanups.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:30 -0700
Message-ID: <200808181940.m7IJeU93008464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934262AbYHRTuS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:50:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     acpi: trivial cleanups
has been removed from the -mm tree.  Its filename was
     acpi-trivial-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: trivial cleanups
From: Pavel Machek <pavel@suse.cz>

Trivial cleanups for ACPI.  Fix misspelling in printk(), fix mismerge.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |    2 +-
 drivers/acpi/processor_idle.c |    1 -
 drivers/acpi/reboot.c         |    6 +++++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/processor_core.c~acpi-trivial-cleanups drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-trivial-cleanups
+++ a/drivers/acpi/processor_core.c
@@ -123,7 +123,7 @@ struct acpi_processor_errata errata __re
 static int set_no_mwait(const struct dmi_system_id *id)
 {
 	printk(KERN_NOTICE PREFIX "%s detected - "
-		"disable mwait for CPU C-stetes\n", id->ident);
+		"disabling mwait for CPU C-states\n", id->ident);
 	idle_nomwait = 1;
 	return 0;
 }
diff -puN drivers/acpi/processor_idle.c~acpi-trivial-cleanups drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-trivial-cleanups
+++ a/drivers/acpi/processor_idle.c
@@ -41,7 +41,6 @@
 #include <linux/pm_qos_params.h>
 #include <linux/clockchips.h>
 #include <linux/cpuidle.h>
-#include <linux/cpuidle.h>
 
 /*
  * Include the apic definitions for x86 to have the APIC timer related defines
diff -puN drivers/acpi/reboot.c~acpi-trivial-cleanups drivers/acpi/reboot.c
--- a/drivers/acpi/reboot.c~acpi-trivial-cleanups
+++ a/drivers/acpi/reboot.c
@@ -1,4 +1,8 @@
