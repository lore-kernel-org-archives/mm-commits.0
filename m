From: akpm@linux-foundation.org
Subject: - sctp-ipv6-inconsistent-lock-state-ipv6_add_addr-sctp_v6_copy_addrlist.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:59:17 -0800
Message-ID: <200703152159.l2FLxHtc027812@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42564 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbXCOV7f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkao2@o2.pl, simon@arlott.org, mm-commits@vger.kernel.org


The patch titled
     SCTP: ipv6: inconsistent lock state ipv6_add_addr/sctp_v6_copy_addrlist
has been removed from the -mm tree.  Its filename was
     sctp-ipv6-inconsistent-lock-state-ipv6_add_addr-sctp_v6_copy_addrlist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SCTP: ipv6: inconsistent lock state ipv6_add_addr/sctp_v6_copy_addrlist
From: Jarek Poplawski <jarkao2@o2.pl>

lockdep found that dev->lock taken from softirq in ipv6_add_addr is also
taken in sctp_v6_copy_addrlist with softirqs enabled, so lockup is
possible.

Noticed-by: Simon Arlott <simon@arlott.org>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/ipv6.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/sctp/ipv6.c~sctp-ipv6-inconsistent-lock-state-ipv6_add_addr-sctp_v6_copy_addrlist net/sctp/ipv6.c
--- a/net/sctp/ipv6.c~sctp-ipv6-inconsistent-lock-state-ipv6_add_addr-sctp_v6_copy_addrlist
+++ a/net/sctp/ipv6.c
@@ -360,7 +360,7 @@ static void sctp_v6_copy_addrlist(struct
 		return;
 	}
 
-	read_lock(&in6_dev->lock);
+	read_lock_bh(&in6_dev->lock);
 	for (ifp = in6_dev->addr_list; ifp; ifp = ifp->if_next) {
 		/* Add the address to the local list.  */
 		addr = t_new(struct sctp_sockaddr_entry, GFP_ATOMIC);
@@ -374,7 +374,7 @@ static void sctp_v6_copy_addrlist(struct
 		}
 	}
 
-	read_unlock(&in6_dev->lock);
+	read_unlock_bh(&in6_dev->lock);
 	rcu_read_unlock();
 }
 
_

Patches currently in -mm which might be from jarkao2@o2.pl are

origin.patch
