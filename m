From: akpm@linux-foundation.org
Subject: - acpi-fix-oops-in-acpi_processor_throttling_seq_show.patch removed from -mm tree
Date: Tue, 26 Jun 2007 21:53:56 -0700
Message-ID: <200706270453.l5R4ruY7010140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbXF0EyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 00:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luming.yu@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: fix oops in acpi_processor_throttling_seq_show()
has been removed from the -mm tree.  Its filename was
     acpi-fix-oops-in-acpi_processor_throttling_seq_show.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: fix oops in acpi_processor_throttling_seq_show()
From: "Luming Yu" <luming.yu@gmail.com>

Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/processor_throttling.c~acpi-fix-oops-in-acpi_processor_throttling_seq_show drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~acpi-fix-oops-in-acpi_processor_throttling_seq_show
+++ a/drivers/acpi/processor_throttling.c
@@ -656,18 +656,20 @@ static int acpi_processor_throttling_seq
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

git-acpi.patch
