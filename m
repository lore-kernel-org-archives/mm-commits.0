From: akpm@linux-foundation.org
Subject: + acpi-add-acpi_osi_dmi_table-evaluation-procedure-for-ia64-machines.patch added to -mm tree
Date: Tue, 27 May 2008 16:20:40 -0700
Message-ID: <200805272320.m4RNKeKx018283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbYE0XVf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 19:21:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: izumi.taku@jp.fujitsu.com, lenb@kernel.org, tony.luck@intel.com


The patch titled
     acpi: add acpi_osi_dmi_table evaluation procedure for ia64 machines
has been added to the -mm tree.  Its filename is
     acpi-add-acpi_osi_dmi_table-evaluation-procedure-for-ia64-machines.patch

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

