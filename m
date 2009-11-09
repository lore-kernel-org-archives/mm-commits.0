From: akpm@linux-foundation.org
Subject: [merged] drivers-acpi-move-dereference-after-null-test.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:54:58 -0800
Message-ID: <200911091954.nA9Jsw7A022845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934AbZKITzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/acpi: Move dereference after NULL test
has been removed from the -mm tree.  Its filename was
     drivers-acpi-move-dereference-after-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/acpi: Move dereference after NULL test
From: Julia Lawall <julia@diku.dk>

If the NULL test on pr is needed, then the dereference should be after the
NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/processor_throttling.c~drivers-acpi-move-dereference-after-null-test drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~drivers-acpi-move-dereference-after-null-test
+++ a/drivers/acpi/processor_throttling.c
@@ -1133,15 +1133,15 @@ int acpi_processor_get_throttling_info(s
 	int result = 0;
 	struct acpi_processor_throttling *pthrottling;
 
+	if (!pr)
+		return -EINVAL;
+
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			  "pblk_address[0x%08x] duty_offset[%d] duty_width[%d]\n",
 			  pr->throttling.address,
 			  pr->throttling.duty_offset,
 			  pr->throttling.duty_width));
 
-	if (!pr)
-		return -EINVAL;
