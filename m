From: akpm@linux-foundation.org
Subject: - acpi-add-acpi_osi_dmi_table-evaluation-procedure-for-ia64-machines.patch removed from -mm tree
Date: Tue, 27 May 2008 18:28:11 -0700
Message-ID: <200805280128.m4S1SB7X022833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760111AbYE1B2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 21:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: izumi.taku@jp.fujitsu.com, lenb@kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: add acpi_osi_dmi_table evaluation procedure for ia64 machines
has been removed from the -mm tree.  Its filename was
     acpi-add-acpi_osi_dmi_table-evaluation-procedure-for-ia64-machines.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: add acpi_osi_dmi_table evaluation procedure for ia64 machines
From: Taku Izumi <izumi.taku@jp.fujitsu.com>

Currently, acpi_osi_dmi_table is valid only for x86 machines.  This patch
makes its table valid for ia64 machines too and adds evaluation procedure
for the purpose of checking if OSI(Linux) should be enabled or not.

Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/setup.c |    7 +++++++
 drivers/acpi/Makefile    |    1 +
 2 files changed, 8 insertions(+)

diff -puN arch/ia64/kernel/setup.c~acpi-add-acpi_osi_dmi_table-evaluation-procedure-for-ia64-machines arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~acpi-add-acpi_osi_dmi_table-evaluation-procedure-for-ia64-machines
+++ a/arch/ia64/kernel/setup.c
@@ -1041,3 +1041,10 @@ static int __init run_dmi_scan(void)
 	return 0;
 }
 core_initcall(run_dmi_scan);
+
+static int __init invoke_acpi_blacklisted(void)
+{
+	acpi_blacklisted();
+	return 0;
+}
+postcore_initcall(invoke_acpi_blacklisted);
diff -puN drivers/acpi/Makefile~acpi-add-acpi_osi_dmi_table-evaluation-procedure-for-ia64-machines drivers/acpi/Makefile
--- a/drivers/acpi/Makefile~acpi-add-acpi_osi_dmi_table-evaluation-procedure-for-ia64-machines
+++ a/drivers/acpi/Makefile
@@ -17,6 +17,7 @@ EXTRA_CFLAGS	+= $(ACPI_CFLAGS)
 #
 obj-y				+= tables.o
 obj-$(CONFIG_X86)		+= blacklist.o
+obj-$(CONFIG_IA64)		+= blacklist.o
 
 #
 # ACPI Core Subsystem (Interpreter)
_

Patches currently in -mm which might be from izumi.taku@jp.fujitsu.com are

acpi-add-acpi_osi_dmi_table-evaluation-procedure-for-ia64-machines.patch
acpi-add-dmi-info-to-enable-osilinux-on-primequest.patch

