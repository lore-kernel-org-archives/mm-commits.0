From: akpm@linux-foundation.org
Subject: + acpi-cure-run-together-printk-lines.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:36:46 -0700
Message-ID: <200707290636.l6T6akpd011909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44127 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758451AbXG2GhS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mroos@linux.ee, lenb@kernel.org


The patch titled
     ACPI: cure run-together printk lines
has been added to the -mm tree.  Its filename is
     acpi-cure-run-together-printk-lines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: cure run-together printk lines
From: Meelis Roos <mroos@linux.ee>

Add a newline to printk so next line does not run together with this
line.

Signed-off-by: Meelis Roos <mroos@linux.ee>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/ec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/ec.c~acpi-cure-run-together-printk-lines drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~acpi-cure-run-together-printk-lines
+++ a/drivers/acpi/ec.c
@@ -685,7 +685,7 @@ static int ec_parse_device(struct acpi_e
 
 	ec->handle = handle;
 
-	printk(KERN_INFO PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx",
+	printk(KERN_INFO PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
 			  ec->gpe, ec->command_addr, ec->data_addr);
 
 	return 0;
_

Patches currently in -mm which might be from mroos@linux.ee are

acpi-cure-run-together-printk-lines.patch
