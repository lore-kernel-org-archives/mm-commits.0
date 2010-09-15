From: akpm@linux-foundation.org
Subject: + acpi-apei-fix-erst-move_data-instruction-implementation.patch added to -mm tree
Date: Wed, 15 Sep 2010 12:45:05 -0700
Message-ID: <201009151945.o8FJj5fJ011836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551Ab0IOTpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Sep 2010 15:45:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, akpm@linux-foundation.org, lenb@kernel.org, martinez.javier@gmail.com


The patch titled
     ACPI, APEI, Fix ERST MOVE_DATA instruction implementation
has been added to the -mm tree.  Its filename is
     acpi-apei-fix-erst-move_data-instruction-implementation.patch

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
Subject: ACPI, APEI, Fix ERST MOVE_DATA instruction implementation
From: Huang Ying <ying.huang@intel.com>

The src_base and dst_base fields in apei_exec_context are physical
address, so they should be ioremaped before being used in ERST
MOVE_DATA instruction.

Reported-by: Javier Martinez Canillas <martinez.javier@gmail.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/apei/erst.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/apei/erst.c~acpi-apei-fix-erst-move_data-instruction-implementation drivers/acpi/apei/erst.c
--- a/drivers/acpi/apei/erst.c~acpi-apei-fix-erst-move_data-instruction-implementation
+++ a/drivers/acpi/apei/erst.c
@@ -266,13 +266,27 @@ static int erst_exec_move_data(struct ap
 {
 	int rc;
 	u64 offset;
+	void *src, *dst;
+
+	/* ioremap does not work in interrupt context */
+	if (in_interrupt())
+		return -EBUSY;
 
 	rc = __apei_exec_read_register(entry, &offset);
 	if (rc)
 		return rc;
-	memmove((void *)ctx->dst_base + offset,
-		(void *)ctx->src_base + offset,
-		ctx->var2);
+
+	src = ioremap(ctx->src_base + offset, ctx->var2);
+	if (!src)
+		return -ENOMEM;
+	dst = ioremap(ctx->dst_base + offset, ctx->var2);
+	if (!dst)
+		return -ENOMEM;
+
+	memmove(dst, src, ctx->var2);
+
+	iounmap(src);
+	iounmap(dst);
 
 	return 0;
 }
_

Patches currently in -mm which might be from ying.huang@intel.com are

acpi-apei-fix-erst-move_data-instruction-implementation.patch

