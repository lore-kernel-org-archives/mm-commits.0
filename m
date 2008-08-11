From: akpm@linux-foundation.org
Subject: + e1000e-increase-minimum-frame-size-allowed.patch added to -mm tree
Date: Mon, 11 Aug 2008 16:40:13 -0700
Message-ID: <200808112340.m7BNeDZs028113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753867AbYHKXkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 19:40:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com


The patch titled
     e1000e: increase minimum frame size allowed
has been added to the -mm tree.  Its filename is
     e1000e-increase-minimum-frame-size-allowed.patch

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
Subject: e1000e: increase minimum frame size allowed
From: Bruce Allan <bruce.w.allan@intel.com>

Setting an MTU value below 68 was disabling the network connection and
would not reconnect until the driver was reloaded.  Prevent changing the
MTU to anything below 68.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/e1000e/netdev.c~e1000e-increase-minimum-frame-size-allowed drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-increase-minimum-frame-size-allowed
+++ a/drivers/net/e1000e/netdev.c
@@ -3724,7 +3724,7 @@ static int e1000_change_mtu(struct net_d
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
 
-	if ((max_frame < ETH_ZLEN + ETH_FCS_LEN) ||
+	if ((new_mtu < ETH_ZLEN + ETH_FCS_LEN + VLAN_HLEN) ||
 	    (max_frame > MAX_JUMBO_FRAME_SIZE)) {
 		e_err("Invalid MTU setting\n");
 		return -EINVAL;
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

