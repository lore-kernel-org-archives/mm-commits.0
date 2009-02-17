From: akpm@linux-foundation.org
Subject: [merged] dmar-fix-endless-unknown-dmar-structure-type-loop.patch removed from -mm tree
Date: Tue, 17 Feb 2009 12:08:47 -0800
Message-ID: <200902172008.n1HK8lJT001171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443AbZBQUPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 15:15:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyb@cybernetics.com, 7eggert@gmx.de, avi@redhat.com, dwmw2@infradead.org, iommu@lists.linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     dmar: fix endless "Unknown DMAR structure type" loop
has been removed from the -mm tree.  Its filename was
     dmar-fix-endless-unknown-dmar-structure-type-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmar: fix endless "Unknown DMAR structure type" loop
From: Tony Battersby <tonyb@cybernetics.com>

I have a SuperMicro C2SBX motherboard with BIOS revision 1.0b.  With vt-d
enabled in the BIOS, Linux gets into an endless loop printing
"DMAR:Unknown DMAR structure type" when booting.  Here is the DMAR ACPI
table:

DMAR @ 0x7fe86dec
  0000: 44 4d 41 52 98 00 00 00 01 6f 49 6e 74 65 6c 20  DMAR.....oIntel
  0010: 4f 45 4d 44 4d 41 52 20 00 00 04 06 4c 4f 48 52  OEMDMAR ....LOHR
  0020: 01 00 00 00 23 00 00 00 00 00 00 00 00 00 00 00  ....#...........
  0030: 01 00 58 00 00 00 00 00 00 a0 e8 7f 00 00 00 00  ..X.............
  0040: ff ff ef 7f 00 00 00 00 01 08 00 00 00 00 1d 00  ................
  0050: 01 08 00 00 00 00 1d 01 01 08 00 00 00 00 1d 02  ................
  0060: 01 08 00 00 00 00 1d 07 01 08 00 00 00 00 1a 00  ................
  0070: 01 08 00 00 00 00 1a 01 01 08 00 00 00 00 1a 02  ................
  0080: 01 08 00 00 00 00 1a 07 01 08 00 00 00 00 1a 07  ................
  0090: c0 00 68 00 04 10 66 60                          ..h...f`

Here are the messages printed by the kernel:

DMAR:Host address width 36
DMAR:RMRR base: 0x000000007fe8a000 end: 0x000000007fefffff
DMAR:Unknown DMAR structure type
DMAR:Unknown DMAR structure type
DMAR:Unknown DMAR structure type
...

Although I not very familiar with ACPI, to me it looks like struct
acpi_dmar_header::length == 0x0058 is incorrect, causing
parse_dmar_table() to look at an invalid offset on the next loop.  This
offset happens to have struct acpi_dmar_header::length == 0x0000, which
prevents the loop from ever terminating.  This patch checks for this
condition and bails out instead of looping forever.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Cc: Bodo Eggert <7eggert@gmx.de>
Cc: Avi Kivity <avi@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: <iommu@lists.linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/dmar.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/pci/dmar.c~dmar-fix-endless-unknown-dmar-structure-type-loop drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~dmar-fix-endless-unknown-dmar-structure-type-loop
+++ a/drivers/pci/dmar.c
@@ -330,6 +330,14 @@ parse_dmar_table(void)
 	entry_header = (struct acpi_dmar_header *)(dmar + 1);
 	while (((unsigned long)entry_header) <
 			(((unsigned long)dmar) + dmar_tbl->length)) {
+		/* Avoid looping forever on bad ACPI tables */
+		if (entry_header->length == 0) {
+			printk(KERN_WARNING PREFIX
+				"Invalid 0-length structure\n");
+			ret = -EINVAL;
+			break;
+		}
+
 		dmar_table_print_dmar_entry(entry_header);
 
 		switch (entry_header->type) {
_

Patches currently in -mm which might be from tonyb@cybernetics.com are

linux-next.patch
make-shm_get_stat-more-robust.patch

