From: akpm@linux-foundation.org
Subject: + drivers-acpi-move-dereference-after-null-test.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:24:03 -0800
Message-ID: <200911030624.nA36O42K029075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755417AbZKCGYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:24:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, lenb@kernel.org


The patch titled
     drivers/acpi: Move dereference after NULL test
has been added to the -mm tree.  Its filename is
     drivers-acpi-move-dereference-after-null-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
