From: akpm@linux-foundation.org
Subject: - drivers-scsi-use-div_round_up.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:10 -0800
Message-ID: <200811102034.mAAKYAEZ024923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534AbYKJUe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, James.Bottomley@HansenPartnership.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi: Use DIV_ROUND_UP
has been removed from the -mm tree.  Its filename was
     drivers-scsi-use-div_round_up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi: Use DIV_ROUND_UP
From: Julia Lawall <julia@diku.dk>

Use the macro DIV_ROUND_UP and eliminate the variable rounded_up, as
suggested by Matthew Wilcox.

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/esp_scsi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/esp_scsi.c~drivers-scsi-use-div_round_up drivers/scsi/esp_scsi.c
--- a/drivers/scsi/esp_scsi.c~drivers-scsi-use-div_round_up
+++ a/drivers/scsi/esp_scsi.c
@@ -1453,7 +1453,7 @@ static void esp_msgin_sdtr(struct esp *e
 		offset = 0;
 
 	if (offset) {
-		int rounded_up, one_clock;
+		int one_clock;
 
 		if (period > esp->max_period) {
 			period = offset = 0;
@@ -1463,9 +1463,7 @@ static void esp_msgin_sdtr(struct esp *e
 			goto do_reject;
 
 		one_clock = esp->ccycle / 1000;
-		rounded_up = (period << 2);
-		rounded_up = (rounded_up + one_clock - 1) / one_clock;
-		stp = rounded_up;
+		stp = DIV_ROUND_UP(period << 2, one_clock);
 		if (stp && esp->rev >= FAS236) {
 			if (stp >= 50)
 				stp--;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
fs-namespacec-drop-code-after-return.patch

