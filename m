From: akpm@linux-foundation.org
Subject: - missing-include-file-in-tpm_atmelh.patch removed from -mm tree
Date: Sat, 12 May 2007 22:14:31 -0700
Message-ID: <200705130514.l4D5EUCL022720@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384AbXEMFOk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 01:14:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Missing include file in tpm_atmel.h
has been removed from the -mm tree.  Its filename was
     missing-include-file-in-tpm_atmelh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Missing include file in tpm_atmel.h
From: Stephen Rothwell <sfr@canb.auug.org.au>

On PPC64, we need to include asm/prom.h for function definitions.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_atmel.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/char/tpm/tpm_atmel.h~missing-include-file-in-tpm_atmelh drivers/char/tpm/tpm_atmel.h
--- a/drivers/char/tpm/tpm_atmel.h~missing-include-file-in-tpm_atmelh
+++ a/drivers/char/tpm/tpm_atmel.h
@@ -23,6 +23,9 @@
  */
 
 #ifdef CONFIG_PPC64
+
+#include <asm/prom.h>
+
 #define atmel_getb(chip, offset) readb(chip->vendor->iobase + offset);
 #define atmel_putb(val, chip, offset) writeb(val, chip->vendor->iobase + offset)
 #define atmel_request_region request_mem_region
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

powerpc64-symbols-start-with.patch
