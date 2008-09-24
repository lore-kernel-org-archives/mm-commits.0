From: akpm@linux-foundation.org
Subject: + drivers-scsi-use-div_round_up.patch added to -mm tree
Date: Wed, 24 Sep 2008 12:48:13 -0700
Message-ID: <200809241948.m8OJmEp3013269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbYIXTsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Sep 2008 15:48:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, James.Bottomley@HansenPartnership.com, willy@linux.intel.com


The patch titled
     drivers/scsi: Use DIV_ROUND_UP
has been added to the -mm tree.  Its filename is
     drivers-scsi-use-div_round_up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
drivers-media-common-tuners-drop-code-after-return-or-goto.patch
drivers-infiniband-hw-drop-code-after-return.patch
drivers-atm-use-div_round_up.patch
net-atm-lecc-drop-code-after-return.patch
drivers-net-wan-use-div_round_up.patch
drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
drivers-block-use-div_round_up.patch
net-9p-trans_fdc-introduce-missing-kfree.patch
fs-9p-use-an-is_err-test-rather-than-a-null-test.patch
fs-namespacec-drop-code-after-return.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

