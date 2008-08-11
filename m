From: akpm@linux-foundation.org
Subject: + e1000e-increase-tx-timeout-factor-for-10mbps.patch added to -mm tree
Date: Mon, 11 Aug 2008 16:40:11 -0700
Message-ID: <200808112340.m7BNeBjp028110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847AbYHKXkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 19:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com


The patch titled
     e1000e: increase Tx timeout factor for 10Mbps
has been added to the -mm tree.  Its filename is
     e1000e-increase-tx-timeout-factor-for-10mbps.patch

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
Subject: e1000e: increase Tx timeout factor for 10Mbps
From: Bruce Allan <bruce.w.allan@intel.com>

Prevent Tx hangs from happening on 10Mb flood ping by increasing the
timeout factor.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/e1000e/netdev.c~e1000e-increase-tx-timeout-factor-for-10mbps drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-increase-tx-timeout-factor-for-10mbps
+++ a/drivers/net/e1000e/netdev.c
@@ -3058,7 +3058,7 @@ static void e1000_watchdog_task(struct w
 			case SPEED_10:
 				txb2b = 0;
 				netdev->tx_queue_len = 10;
-				adapter->tx_timeout_factor = 14;
+				adapter->tx_timeout_factor = 16;
 				break;
 			case SPEED_100:
 				txb2b = 0;
_

Patches currently in -mm which might be from bruce.w.allan@intel.com are

origin.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
e1000e-return-1-instead-of-a-non-zero-value-for-link-up-indication.patch
e1000e-set-interruptthrottlerate-to-default-when-invalid-value-used.patch
e1000e-use-skb_copy_to_linear_data_offset-introduced-in-2622.patch
e1000e-increase-tx-timeout-factor-for-10mbps.patch
e1000e-increase-minimum-frame-size-allowed.patch
e1000e-test-for-unusable-msi-support.patch
e1000e-remove-unnecessary-snippet-missed-in-prior-check_options-update.patch

