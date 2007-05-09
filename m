From: akpm@linux-foundation.org
Subject: + sata_promise-fix-another-error-decode-regression.patch added to -mm tree
Date: Wed, 09 May 2007 13:42:47 -0700
Message-ID: <200705092042.l49Kgl97000560@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755779AbXEIUnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 16:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikpe@it.uu.se, htejun@gmail.com, jeff@garzik.org


The patch titled
     sata_promise: fix another error decode regression
has been added to the -mm tree.  Its filename is
     sata_promise-fix-another-error-decode-regression.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_promise: fix another error decode regression
From: Mikael Pettersson <mikpe@it.uu.se>

The sata_promise error decode update changed pdc_host_intr() to return and
not complete the qc after detecting an error.  Unfortunately not completing
the qc:s causes them to always time out on error, which is wrong and has
nasty side-effects.

This patch updates pdc_error_intr() to call ata_port_abort(), similar to
ahci and sata_sil24.  Doing this is important as it makes EH see the
original error and not a bogus timeout.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_promise.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/ata/sata_promise.c~sata_promise-fix-another-error-decode-regression drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~sata_promise-fix-another-error-decode-regression
+++ a/drivers/ata/sata_promise.c
@@ -45,7 +45,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.05"
+#define DRV_VERSION	"2.06"
 
 
 enum {
@@ -653,6 +653,8 @@ static void pdc_error_intr(struct ata_po
 	qc->err_mask |= ac_err_mask;
 
 	pdc_reset_port(ap);
+
+	ata_port_abort(ap);
 }
 
 static inline unsigned int pdc_host_intr( struct ata_port *ap,
_

Patches currently in -mm which might be from mikpe@it.uu.se are

origin.patch
ata-sata_promise-do-not-freeze-ports.patch
sata_promise-fix-another-error-decode-regression.patch
