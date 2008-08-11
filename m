From: akpm@linux-foundation.org
Subject: + e1000e-use-skb_copy_to_linear_data_offset-introduced-in-2622.patch added to -mm tree
Date: Mon, 11 Aug 2008 16:40:09 -0700
Message-ID: <200808112340.m7BNe98U028103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753AbYHKXkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 19:40:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com


The patch titled
     e1000e: use skb_copy_to_linear_data_offset introduced in 2.6.22
has been added to the -mm tree.  Its filename is
     e1000e-use-skb_copy_to_linear_data_offset-introduced-in-2622.patch

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
Subject: e1000e: use skb_copy_to_linear_data_offset introduced in 2.6.22
From: Bruce Allan <bruce.w.allan@intel.com>

The e1000e driver was based on a version of e1000 prior to acme's
introduction of skb_copy_to_linear_data_offset, and was submitted after
acme went through and coverted all the drivers to use it.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/netdev.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/net/e1000e/netdev.c~e1000e-use-skb_copy_to_linear_data_offset-introduced-in-2622 drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-use-skb_copy_to_linear_data_offset-introduced-in-2622
+++ a/drivers/net/e1000e/netdev.c
@@ -510,9 +510,12 @@ static bool e1000_clean_rx_irq(struct e1
 			    netdev_alloc_skb(netdev, length + NET_IP_ALIGN);
 			if (new_skb) {
 				skb_reserve(new_skb, NET_IP_ALIGN);
-				memcpy(new_skb->data - NET_IP_ALIGN,
-				       skb->data - NET_IP_ALIGN,
-				       length + NET_IP_ALIGN);
+				skb_copy_to_linear_data_offset(new_skb,
+							       -NET_IP_ALIGN,
+							       (skb->data -
+								NET_IP_ALIGN),
+							       (length +
+								NET_IP_ALIGN));
 				/* save the skb in buffer_info as good */
 				buffer_info->skb = skb;
 				skb = new_skb;
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

