From: akpm@linux-foundation.org
Subject: - acpi-add-checking-for-null-early-param.patch removed from -mm tree
Date: Fri, 22 Aug 2008 15:55:45 -0700
Message-ID: <200808222255.m7MMtjLw020846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261AbYHVW4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 18:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     acpi: add checking for NULL early param
has been removed from the -mm tree.  Its filename was
     acpi-add-checking-for-null-early-param.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: add checking for NULL early param
From: Cyrill Gorcunov <gorcunov@gmail.com>

The early_param handling function could recieve NULL pointer as argument
in case if user didn't enter parameter value.  So we have to be ready for
a such situation and do check for NULL pointer if needed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/tables.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/acpi/tables.c~acpi-add-checking-for-null-early-param drivers/acpi/tables.c
--- a/drivers/acpi/tables.c~acpi-add-checking-for-null-early-param
+++ a/drivers/acpi/tables.c
@@ -300,6 +300,8 @@ int __init acpi_table_init(void)
 
 static int __init acpi_parse_apic_instance(char *str)
 {
+	if (!str)
+		return -EINVAL;
 
 	acpi_apic_instance = simple_strtoul(str, NULL, 0);
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

linux-next.patch

