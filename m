From: akpm@linux-foundation.org
Subject: + netpoll-zap_completion_queue-adjust-skb-users-counter.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:29:32 -0700
Message-ID: <200803172229.m2HMTWbq001600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591AbYCQWaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@gmail.com, akpm@linux-foundation.org, davem@davemloft.net, shemminger@linux-foundation.org


The patch titled
     netpoll: zap_completion_queue: adjust skb->users counter
has been added to the -mm tree.  Its filename is
     netpoll-zap_completion_queue-adjust-skb-users-counter.patch

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
Subject: netpoll: zap_completion_queue: adjust skb->users counter
From: Jarek Poplawski <jarkao2@gmail.com>

zap_completion_queue() retrieves skbs from completion_queue where they have
zero skb->users counter.  Before dev_kfree_skb_any() it should be non-zero
yet, so it's increased now.

Reported-and-tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Cc: Stephen Hemminger <shemminger@osdl.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/netpoll.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN net/core/netpoll.c~netpoll-zap_completion_queue-adjust-skb-users-counter net/core/netpoll.c
--- a/net/core/netpoll.c~netpoll-zap_completion_queue-adjust-skb-users-counter
+++ a/net/core/netpoll.c
@@ -215,10 +215,12 @@ static void zap_completion_queue(void)
 		while (clist != NULL) {
 			struct sk_buff *skb = clist;
 			clist = clist->next;
-			if (skb->destructor)
+			if (skb->destructor) {
+				atomic_inc(&skb->users);
 				dev_kfree_skb_any(skb); /* put this one back */
-			else
+			} else {
 				__kfree_skb(skb);
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from jarkao2@gmail.com are

netpoll-zap_completion_queue-adjust-skb-users-counter.patch

