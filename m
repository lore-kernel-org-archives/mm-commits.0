From: akpm@linux-foundation.org
Subject: - netpoll-fix-a-leak-n-bug-in-netpoll_cleanup.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:33:59 -0700
Message-ID: <200707132234.l6DMXxcp025133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43481 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937350AbXGMWpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ssatyam@cse.iitk.ac.in, mm-commits@vger.kernel.org


The patch titled
     netpoll: fix a leak-n-bug in netpoll_cleanup()
has been removed from the -mm tree.  Its filename was
     netpoll-fix-a-leak-n-bug-in-netpoll_cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: netpoll: fix a leak-n-bug in netpoll_cleanup()
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

93ec2c723e3f8a216dde2899aeb85c648672bc6b applied excessive duct tape to the
netpoll beast's netpoll_cleanup(), thus substituting one leak with another,
and opening up a little buglet :-)

net_device->npinfo (netpoll_info) is a shared and refcounted object and
cannot simply be set NULL the first time netpoll_cleanup() is called. 
Otherwise, further netpoll_cleanup()'s see np->dev->npinfo == NULL and
become no-ops, thus leaking.  And it's a bug too: the first call to
netpoll_cleanup() would thus (annoyingly) "disable" other (still alive)
netpolls too.  Maybe nobody noticed this because netconsole (only user of
netpoll) never supported multiple netpoll objects earlier.

This is a trivial and obvious one-line fixlet.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/netpoll.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN net/core/netpoll.c~netpoll-fix-a-leak-n-bug-in-netpoll_cleanup net/core/netpoll.c
--- a/net/core/netpoll.c~netpoll-fix-a-leak-n-bug-in-netpoll_cleanup
+++ a/net/core/netpoll.c
@@ -785,7 +785,6 @@ void netpoll_cleanup(struct netpoll *np)
 				spin_unlock_irqrestore(&npinfo->rx_lock, flags);
 			}
 
-			np->dev->npinfo = NULL;
 			if (atomic_dec_and_test(&npinfo->refcnt)) {
 				skb_queue_purge(&npinfo->arp_tx);
 				skb_queue_purge(&npinfo->txq);
@@ -799,6 +798,7 @@ void netpoll_cleanup(struct netpoll *np)
 					kfree_skb(skb);
 				}
 				kfree(npinfo);
+				np->dev->npinfo = NULL;
 			}
 		}
 
_

Patches currently in -mm which might be from ssatyam@cse.iitk.ac.in are

origin.patch
git-ocfs2.patch
drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch
drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch
introduce-write_trylock_irqsave.patch
