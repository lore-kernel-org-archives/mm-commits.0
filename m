From: akpm@linux-foundation.org
Subject: + missing-include-file-in-tpm_atmelh.patch added to -mm tree
Date: Fri, 11 May 2007 12:42:58 -0700
Message-ID: <200705111942.l4BJgwEP024865@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763428AbXEKTnO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:43:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au


The patch titled
     Missing include file in tpm_atmel.h
has been added to the -mm tree.  Its filename is
     missing-include-file-in-tpm_atmelh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Missing include file in tpm_atmel.h
From: Stephen Rothwell <sfr@canb.auug.org.au>

On PPC64, we need to include asm/prom.h for function definitions.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_atmel.h |    3 +++
 1 files changed, 3 insertions(+)

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

origin.patch
consolidate-asm-pollh.patch
missing-include-file-in-tpm_atmelh.patch
powerpc64-symbols-start-with.patch
