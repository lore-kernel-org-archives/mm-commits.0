From: akpm@linux-foundation.org
Subject: + netpoll-revert-two-bogus-cleanups-that-broke-netconsole.patch added to -mm tree
Date: Tue, 04 Mar 2008 12:39:51 -0800
Message-ID: <200803042039.m24Kdp5n028062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759AbYCDUkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:40:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net


The patch titled
     netpoll: revert two bogus cleanups that broke netconsole
has been added to the -mm tree.  Its filename is
     netpoll-revert-two-bogus-cleanups-that-broke-netconsole.patch

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
Subject: netpoll: revert two bogus cleanups that broke netconsole
From: David Miller <davem@davemloft.net>

Based upon a report by Andrew Morton and code analysis done by Jarek
Poplawski.

This reverts 33f807ba0d9259e7c75c7a2ce8bd2787e5b540c7 ("[NETPOLL]: Kill
NETPOLL_RX_DROP, set but never tested.") and
c7b6ea24b43afb5749cb704e143df19d70e23dea ("[NETPOLL]: Don't need rx_flags.").

The rx_flags did get tested for zero vs.  non-zero and therefore we do need
those tests and that code which sets NETPOLL_RX_DROP et al.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/netpoll.h |    7 ++++---
 net/core/netpoll.c      |   12 ++++++++----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff -puN include/linux/netpoll.h~netpoll-revert-two-bogus-cleanups-that-broke-netconsole include/linux/netpoll.h
--- a/include/linux/netpoll.h~netpoll-revert-two-bogus-cleanups-that-broke-netconsole
+++ a/include/linux/netpoll.h
@@ -25,6 +25,7 @@ struct netpoll {
 
 struct netpoll_info {
 	atomic_t refcnt;
+	int rx_flags;
 	spinlock_t rx_lock;
 	struct netpoll *rx_np; /* netpoll that registered an rx_hook */
 	struct sk_buff_head arp_tx; /* list of arp requests to reply to */
@@ -50,12 +51,12 @@ static inline int netpoll_rx(struct sk_b
 	unsigned long flags;
 	int ret = 0;
 
-	if (!npinfo || !npinfo->rx_np)
+	if (!npinfo || (!npinfo->rx_np && !npinfo->rx_flags))
 		return 0;
 
 	spin_lock_irqsave(&npinfo->rx_lock, flags);
-	/* check rx_np again with the lock held */
-	if (npinfo->rx_np && __netpoll_rx(skb))
+	/* check rx_flags again with the lock held */
+	if (npinfo->rx_flags && __netpoll_rx(skb))
 		ret = 1;
 	spin_unlock_irqrestore(&npinfo->rx_lock, flags);
 
diff -puN net/core/netpoll.c~netpoll-revert-two-bogus-cleanups-that-broke-netconsole net/core/netpoll.c
--- a/net/core/netpoll.c~netpoll-revert-two-bogus-cleanups-that-broke-netconsole
+++ a/net/core/netpoll.c
@@ -39,6 +39,8 @@ static struct sk_buff_head skb_pool;
 static atomic_t trapped;
 
 #define USEC_PER_POLL	50
+#define NETPOLL_RX_ENABLED  1
+#define NETPOLL_RX_DROP     2
 
 #define MAX_SKB_SIZE \
 		(MAX_UDP_CHUNK + sizeof(struct udphdr) + \
@@ -126,11 +128,13 @@ static int poll_one_napi(struct netpoll_
 	if (!test_bit(NAPI_STATE_SCHED, &napi->state))
 		return budget;
 
+	npinfo->rx_flags |= NETPOLL_RX_DROP;
 	atomic_inc(&trapped);
 
 	work = napi->poll(napi, budget);
 
 	atomic_dec(&trapped);
+	npinfo->rx_flags &= ~NETPOLL_RX_DROP;
 
 	return budget - work;
 }
@@ -472,7 +476,7 @@ int __netpoll_rx(struct sk_buff *skb)
 	if (skb->dev->type != ARPHRD_ETHER)
 		goto out;
 
-	/* if receive ARP during middle of NAPI poll, then queue */
+	/* check if netpoll clients need ARP */
 	if (skb->protocol == htons(ETH_P_ARP) &&
 	    atomic_read(&trapped)) {
 		skb_queue_tail(&npi->arp_tx, skb);
@@ -534,9 +538,6 @@ int __netpoll_rx(struct sk_buff *skb)
 	return 1;
 
 out:
-	/* If packet received while already in poll then just
-	 * silently drop.
-	 */
 	if (atomic_read(&trapped)) {
 		kfree_skb(skb);
 		return 1;
@@ -675,6 +676,7 @@ int netpoll_setup(struct netpoll *np)
 			goto release;
 		}
 
+		npinfo->rx_flags = 0;
 		npinfo->rx_np = NULL;
 
 		spin_lock_init(&npinfo->rx_lock);
@@ -756,6 +758,7 @@ int netpoll_setup(struct netpoll *np)
 
 	if (np->rx_hook) {
 		spin_lock_irqsave(&npinfo->rx_lock, flags);
+		npinfo->rx_flags |= NETPOLL_RX_ENABLED;
 		npinfo->rx_np = np;
 		spin_unlock_irqrestore(&npinfo->rx_lock, flags);
 	}
@@ -797,6 +800,7 @@ void netpoll_cleanup(struct netpoll *np)
 			if (npinfo->rx_np == np) {
 				spin_lock_irqsave(&npinfo->rx_lock, flags);
 				npinfo->rx_np = NULL;
+				npinfo->rx_flags &= ~NETPOLL_RX_ENABLED;
 				spin_unlock_irqrestore(&npinfo->rx_lock, flags);
 			}
 
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
git-powerpc.patch
git-net.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
git-sparc64.patch
bluetooth-hci_core-defer-hci_unregister_sysfs.patch
bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027.patch
the-kernel-gets-no-ip-from-some-dhcp-servers.patch
rxrpc-fix-rxrpc_recvmsgs-returning-of-msg_name.patch
netpoll-revert-two-bogus-cleanups-that-broke-netconsole.patch
netlink-use-generic-lsm-hook.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
asm-futexh-should-include-linux-uaccessh.patch
remove-duplicated-unlikely-in-is_err.patch

