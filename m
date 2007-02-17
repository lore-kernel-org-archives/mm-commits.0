From: akpm@linux-foundation.org
Subject: + acpi_boot_init-making-bad-check-on-return-code.patch added to -mm tree
Date: Fri, 16 Feb 2007 17:25:43 -0800
Message-ID: <200702170125.l1H1PhPr015706@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43862 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946248AbXBQB04 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 20:26:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpk@sgi.com, ayoung@sgi.com, lenb@kernel.org, tony.luck@intel.com


The patch titled
     acpi_boot_init() making bad check on return code
has been added to the -mm tree.  Its filename is
     acpi_boot_init-making-bad-check-on-return-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi_boot_init() making bad check on return code
From: John Keller <jpk@sgi.com>

acpi_boot_init() is making a bad check on the return status from
acpi_table_parse().  acpi_table_parse() now returns zero on success, one on
failure.

Signed-off-by: Aaron Young <ayoung@sgi.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/acpi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/ia64/kernel/acpi.c~acpi_boot_init-making-bad-check-on-return-code arch/ia64/kernel/acpi.c
--- a/arch/ia64/kernel/acpi.c~acpi_boot_init-making-bad-check-on-return-code
+++ a/arch/ia64/kernel/acpi.c
@@ -651,7 +651,7 @@ int __init acpi_boot_init(void)
 	 * information -- the successor to MPS tables.
 	 */
 
-	if (acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt) < 1) {
+	if (acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt)) {
 		printk(KERN_ERR PREFIX "Can't find MADT\n");
 		goto skip_madt;
 	}
@@ -702,7 +702,7 @@ int __init acpi_boot_init(void)
 	 * gets interrupts such as power and sleep buttons.  If it's not
 	 * on a Legacy interrupt, it needs to be setup.
 	 */
-	if (acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt) < 1)
+	if (acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt))
 		printk(KERN_ERR PREFIX "Can't find FADT\n");
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from jpk@sgi.com are

origin.patch
git-acpi.patch
acpi_boot_init-making-bad-check-on-return-code.patch
