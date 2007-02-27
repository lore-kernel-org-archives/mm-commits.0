From: akpm@linux-foundation.org
Subject: + ipv6-anycast-refcnt-fix.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:48:24 -0800
Message-ID: <200702272048.l1RKmSdP028018@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51135 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbXB0Usp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:48:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xmxwx@asn.pl


The patch titled
     IPv6 anycast refcnt fix
has been added to the -mm tree.  Its filename is
     ipv6-anycast-refcnt-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ipv6-anycast-refcnt-fix.patch
