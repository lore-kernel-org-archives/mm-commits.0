From: akpm@linux-foundation.org
Subject: + allow-vlan-interface-on-top-of-bridge-interface.patch added to -mm tree
Date: Fri, 13 Apr 2007 13:32:31 -0700
Message-ID: <200704132032.l3DKWVxF008761@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49701 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965158AbXDMUch (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 16:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: j.borsboom@erasmusmc.nl, greearb@candelatech.com


The patch titled
     allow VLAN interface on top of bridge interface
has been added to the -mm tree.  Its filename is
     allow-vlan-interface-on-top-of-bridge-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: allow VLAN interface on top of bridge interface
From: Jerome Borsboom <j.borsboom@erasmusmc.nl>

When a VLAN interface is created on top of a bridge interface and netfilter
is enabled to see the bridged packets, the packets can be corrupted when
passing through the netfilter code.  This is caused by the VLAN driver not
setting the 'protocol' and 'nh' members of the sk_buff structure.  In
general, this is no problem as the VLAN interface is mostly connected to a
physical ethernet interface which does not use the 'protocol' and 'nh'
members.  For a bridge interface, however, these members do matter.

Signed-off-by: Jerome Borsboom <j.borsboom@erasmusmc.nl>
Cc: Ben Greear <greearb@candelatech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/8021q/vlan_dev.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN net/8021q/vlan_dev.c~allow-vlan-interface-on-top-of-bridge-interface net/8021q/vlan_dev.c
--- a/net/8021q/vlan_dev.c~allow-vlan-interface-on-top-of-bridge-interface
+++ a/net/8021q/vlan_dev.c
@@ -380,6 +380,9 @@ int vlan_dev_hard_header(struct sk_buff 
 		} else {
 			vhdr->h_vlan_encapsulated_proto = htons(len);
 		}
+
+		skb->protocol = htons(ETH_P_8021Q);
+		skb_reset_network_header(skb);
 	}
 
 	/* Before delegating work to the lower layer, enter our MAC-address */
_

Patches currently in -mm which might be from j.borsboom@erasmusmc.nl are

allow-vlan-interface-on-top-of-bridge-interface.patch
