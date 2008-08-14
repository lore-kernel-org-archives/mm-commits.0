From: akpm@linux-foundation.org
Subject: + drivers-scsi-use-div_round_up.patch added to -mm tree
Date: Thu, 14 Aug 2008 14:59:23 -0700
Message-ID: <200808142159.m7ELxOMp031699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbYHNV72 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 17:59:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, James.Bottomley@HansenPartnership.com


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

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi: Use DIV_ROUND_UP
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
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/esp_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/esp_scsi.c~drivers-scsi-use-div_round_up drivers/scsi/esp_scsi.c
--- a/drivers/scsi/esp_scsi.c~drivers-scsi-use-div_round_up
+++ a/drivers/scsi/esp_scsi.c
@@ -1464,7 +1464,7 @@ static void esp_msgin_sdtr(struct esp *e
 
 		one_clock = esp->ccycle / 1000;
 		rounded_up = (period << 2);
-		rounded_up = (rounded_up + one_clock - 1) / one_clock;
+		rounded_up = DIV_ROUND_UP(rounded_up, one_clock);
 		stp = rounded_up;
 		if (stp && esp->rev >= FAS236) {
 			if (stp >= 50)
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
net-ieee80211-adjust-error-handling.patch
drivers-atm-use-div_round_up.patch
drivers-block-use-div_round_up.patch
drivers-media-video-use-div_round_up.patch
drivers-misc-use-div_round_up.patch
drivers-net-wan-use-div_round_up.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch

