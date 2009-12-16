From: akpm@linux-foundation.org
Subject: [merged] gru-add-symbolic-names-for-gru-error-code.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:55 -0800
Message-ID: <200912162040.nBGKetRW013688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965025AbZLPUk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: add symbolic names for GRU error code
has been removed from the -mm tree.  Its filename was
     gru-add-symbolic-names-for-gru-error-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: add symbolic names for GRU error code
From: Jack Steiner <steiner@sgi.com>

Use symbol names instead of numbers for error return values for the vtop
functions.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-add-symbolic-names-for-gru-error-code drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-add-symbolic-names-for-gru-error-code
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -40,6 +40,12 @@
 #include "gru_instructions.h"
 #include <asm/uv/uv_hub.h>
 
+/* Return codes for vtop functions */
+#define VTOP_SUCCESS               0
+#define VTOP_INVALID               -1
+#define VTOP_RETRY                 -2
+
+
 /*
  * Test if a physical address is a valid GRU GSEG address
  */
@@ -280,12 +286,12 @@ static int gru_vtop(struct gru_thread_st
 	paddr = paddr & ~((1UL << ps) - 1);
 	*gpa = uv_soc_phys_ram_to_gpa(paddr);
 	*pageshift = ps;
-	return 0;
+	return VTOP_SUCCESS;
 
 inval:
-	return -1;
+	return VTOP_INVALID;
 upm:
-	return -2;
+	return VTOP_RETRY;
 }
 
 
@@ -412,9 +418,9 @@ static int gru_try_dropin(struct gru_thr
 		goto failactive;
 
 	ret = gru_vtop(gts, vaddr, write, atomic, &gpa, &pageshift);
-	if (ret == -1)
+	if (ret == VTOP_INVALID)
 		goto failinval;
-	if (ret == -2)
+	if (ret == VTOP_RETRY)
 		goto failupm;
 
 	if (!(gts->ts_sizeavail & GRU_SIZEAVAIL(pageshift))) {
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

