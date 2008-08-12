From: akpm@linux-foundation.org
Subject: + acpi-trivial-cleanups.patch added to -mm tree
Date: Tue, 12 Aug 2008 16:20:54 -0700
Message-ID: <200808122320.m7CNKs0n018966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876AbYHLXVB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 19:21:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, andi@firstfloor.org


The patch titled
     acpi: trivial cleanups
has been added to the -mm tree.  Its filename is
     acpi-trivial-cleanups.patch

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
