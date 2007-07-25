From: akpm@linux-foundation.org
Subject: + acpi-fix-oops-due-to-typo-in-new-throttling-code.patch added to -mm tree
Date: Wed, 25 Jul 2007 00:01:12 -0700
Message-ID: <200707250701.l6P71C0c022115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60533 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129AbXGYHB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2007 03:01:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: luming.yu@gmail.com, len.brown@intel.com


The patch titled
     fix oops due to typo in new throttling code
has been added to the -mm tree.  Its filename is
     acpi-fix-oops-due-to-typo-in-new-throttling-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix oops due to typo in new throttling code
From: Luming Yu <luming.yu@gmail.com>

Signed-off-by: Luming Yu <luming.yu@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/processor_throttling.c~acpi-fix-oops-due-to-typo-in-new-throttling-code drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~acpi-fix-oops-due-to-typo-in-new-throttling-code
+++ a/drivers/acpi/processor_throttling.c
@@ -658,18 +658,20 @@ static int acpi_processor_throttling_seq
 		   pr->throttling.state_count - 1);
 
 	seq_puts(seq, "states:\n");
-	if (acpi_processor_get_throttling == acpi_processor_get_throttling_fadt)
+	if (pr->throttling.acpi_processor_get_throttling ==
+			acpi_processor_get_throttling_fadt) {
 		for (i = 0; i < pr->throttling.state_count; i++)
 			seq_printf(seq, "   %cT%d:                  %02d%%\n",
 				   (i == pr->throttling.state ? '*' : ' '), i,
 				   (pr->throttling.states[i].performance ? pr->
 				    throttling.states[i].performance / 10 : 0));
-	else
+	} else {
 		for (i = 0; i < pr->throttling.state_count; i++)
 			seq_printf(seq, "   %cT%d:                  %02d%%\n",
 				   (i == pr->throttling.state ? '*' : ' '), i,
 				   (int)pr->throttling.states_tss[i].
 				   freqpercentage);
+	}
 
       end:
 	return 0;
_

Patches currently in -mm which might be from luming.yu@gmail.com are

acpi-fix-oops-due-to-typo-in-new-throttling-code.patch
