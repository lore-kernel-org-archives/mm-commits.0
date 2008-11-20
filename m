From: akpm@linux-foundation.org
Subject: - kobject-return-the-result-of-uevent-sending-by-netlink.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:46 -0800
Message-ID: <200811202043.mAKKhkKX007671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755538AbYKTUoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:44:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom.leiming@gmail.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     kobject: return the result of uevent sending by netlink
has been removed from the -mm tree.  Its filename was
     kobject-return-the-result-of-uevent-sending-by-netlink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kobject: return the result of uevent sending by netlink
From: Ming Lei <tom.leiming@gmail.com>

We should return the result of uevent sending by netlink to caller, when
uevent_helper is disabled and CONFIG_NET is defined.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject_uevent.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN lib/kobject_uevent.c~kobject-return-the-result-of-uevent-sending-by-netlink lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~kobject-return-the-result-of-uevent-sending-by-netlink
+++ a/lib/kobject_uevent.c
@@ -225,8 +225,10 @@ int kobject_uevent_env(struct kobject *k
 			}
 
 			NETLINK_CB(skb).dst_group = 1;
-			netlink_broadcast(uevent_sock, skb, 0, 1, GFP_KERNEL);
-		}
+			retval = netlink_broadcast(uevent_sock, skb, 0, 1,
+						   GFP_KERNEL);
+		} else
+			retval = -ENOMEM;
 	}
 #endif
 
_

Patches currently in -mm which might be from tom.leiming@gmail.com are

linux-next.patch

