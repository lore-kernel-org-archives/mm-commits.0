From: akpm@linux-foundation.org
Subject: - allow-vlan-interface-on-top-of-bridge-interface.patch removed from -mm tree
Date: Sat, 21 Apr 2007 21:12:09 -0700
Message-ID: <200704220412.l3M4C9aQ019272@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932255AbXDVEMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 00:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: j.borsboom@erasmusmc.nl, greearb@candelatech.com, mm-commits@vger.kernel.org


The patch titled
     allow VLAN interface on top of bridge interface
has been removed from the -mm tree.  Its filename was
     allow-vlan-interface-on-top-of-bridge-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
