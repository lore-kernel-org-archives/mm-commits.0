From: akpm@linux-foundation.org
Subject: - ipv6-anycast-refcnt-fix.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:53:33 -0800
Message-ID: <200702282353.l1SNrXPG031106@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48392 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932630AbXB1Xxl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:53:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xmxwx@asn.pl, mm-commits@vger.kernel.org


The patch titled
     IPv6 anycast refcnt fix
has been removed from the -mm tree.  Its filename was
     ipv6-anycast-refcnt-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPv6 anycast refcnt fix
From: Michal Wrobel <xmxwx@asn.pl>

Fix a bug in Linux IPv6 stack which caused anycast address to be added to a
device prior DAD has been completed.  This led to incorrect reference count
which resulted in infinite wait for unregister_netdevice completion on
interface removal.

Signed-off-by: Michal Wrobel <xmxwx@asn.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv6/addrconf.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN net/ipv6/addrconf.c~ipv6-anycast-refcnt-fix net/ipv6/addrconf.c
--- a/net/ipv6/addrconf.c~ipv6-anycast-refcnt-fix
+++ a/net/ipv6/addrconf.c
@@ -468,6 +468,8 @@ static void dev_forward_change(struct in
 			ipv6_dev_mc_dec(dev, &addr);
 	}
 	for (ifa=idev->addr_list; ifa; ifa=ifa->if_next) {
+		if (ifa->flags&IFA_F_TENTATIVE)
+			continue;
 		if (idev->cnf.forwarding)
 			addrconf_join_anycast(ifa);
 		else
_

Patches currently in -mm which might be from xmxwx@asn.pl are

git-net.patch
