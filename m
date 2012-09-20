From: akpm@linux-foundation.org
Subject: [to-be-updated] net-do-not-disable-sg-for-aoe.patch removed from -mm tree
Date: Thu, 20 Sep 2012 14:21:31 -0700
Message-ID: <20120920212131.E9249100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46949 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2ITVVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Sep 2012 17:21:33 -0400
Received: by qafl39 with SMTP id l39so133282qaf.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Sep 2012 14:21:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, jesse@nicira.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net: do not disable sg for AoE
has been removed from the -mm tree.  Its filename was
     net-do-not-disable-sg-for-aoe.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: net: do not disable sg for AoE

A change in a series of VLAN-related changes appears to have inadvertently
disabled the use of the scatter gather feature of network cards for
transmission of non-IP ethernet protocols like ATA over Ethernet (AoE). 
Below is a reference to the commit that introduces a "harmonize_features"
function that turns off scatter gather when the NIC does not support
hardware checksumming for the ethernet protocol of an sk buff.

  commit f01a5236bd4b140198fbcc550f085e8361fd73fa
  Author: Jesse Gross <jesse@nicira.com>
  Date:   Sun Jan 9 06:23:31 2011 +0000

      net offloading: Generalize netif_get_vlan_features().

The can_checksum_protocol function is not equipped to consider a protocol
that does not require checksumming.  Calling it for a protocol that
requires no checksum is inappropriate.

The patch below has harmonize_features call can_checksum_protocol when the
protocol needs a checksum, so that the network layer is not forced to
perform unnecessary skb linearization on the transmission of AoE packets. 
Unnecessary linearization results in decreased performance and increased
memory pressure, as reported here:

  http://www.spinics.net/lists/linux-mm/msg15184.html

The problem has probably not been widely experienced yet, because only
recently has the kernel.org-distributed aoe driver acquired the ability to
use payloads of over a page in size, with the patchset recently included
in the mm tree:

  https://lkml.org/lkml/2012/8/28/140

The coraid.com-distributed aoe driver already could use payloads of
greater than a page in size, but its users generally do not use the newest
kernels.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/core/dev.c~net-do-not-disable-sg-for-aoe net/core/dev.c
--- a/net/core/dev.c~net-do-not-disable-sg-for-aoe
+++ a/net/core/dev.c
@@ -2144,7 +2144,8 @@ static bool can_checksum_protocol(netdev
 static netdev_features_t harmonize_features(struct sk_buff *skb,
 	__be16 protocol, netdev_features_t features)
 {
-	if (!can_checksum_protocol(features, protocol)) {
+	if (protocol != htons(ETH_P_AOE) &&
+	    !can_checksum_protocol(features, protocol)) {
 		features &= ~NETIF_F_ALL_CSUM;
 		features &= ~NETIF_F_SG;
 	} else if (illegal_highdma(skb->dev, skb)) {
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-for-performance-support-larger-packet-payloads.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch
aoe-become-i-o-request-queue-handler-for-increased-user-control.patch
aoe-use-a-kernel-thread-for-transmissions.patch
aoe-use-packets-that-work-with-the-smallest-mtu-local-interface.patch
aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter.patch
aoe-do-revalidation-steps-in-order.patch
aoe-disallow-unsupported-aoe-minor-addresses.patch
aoe-associate-frames-with-the-aoe-storage-target.patch
aoe-increase-net_device-reference-count-while-using-it.patch
aoe-remove-unused-code-and-add-cosmetic-improvements.patch
aoe-update-internal-version-number-to-49.patch
aoe-update-copyright-year-in-touched-files.patch
aoe-update-documentation-with-new-url-and-vm-settings-reference.patch

