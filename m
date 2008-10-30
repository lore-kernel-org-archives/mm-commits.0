From: akpm@linux-foundation.org
Subject: - drivers-scsi-megaraid-use-div_round_up.patch removed from -mm tree
Date: Thu, 30 Oct 2008 10:16:11 -0700
Message-ID: <200810301716.m9UHGBO5014596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759AbYJ3RQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 13:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/megaraid: Use DIV_ROUND_UP
has been removed from the -mm tree.  Its filename was
     drivers-scsi-megaraid-use-div_round_up.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/megaraid: Use DIV_ROUND_UP
From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~drivers-scsi-megaraid-use-div_round_up drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~drivers-scsi-megaraid-use-div_round_up
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -1718,7 +1718,7 @@ static int megasas_create_frame_pool(str
 	 * Calculated the number of 64byte frames required for SGL
 	 */
 	sgl_sz = sge_sz * instance->max_num_sge;
-	frame_count = (sgl_sz + MEGAMFI_FRAME_SIZE - 1) / MEGAMFI_FRAME_SIZE;
+	frame_count = DIV_ROUND_UP(sgl_sz, MEGAMFI_FRAME_SIZE);
 
 	/*
 	 * We need one extra frame for the MFI command
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-i2c-busses-i2c-s3c2410c-correct-use-of-and.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
fs-namespacec-drop-code-after-return.patch

