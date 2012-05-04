From: akpm@linux-foundation.org
Subject: [to-be-updated] net-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch removed from -mm tree
Date: Fri, 04 May 2012 14:29:52 -0700
Message-ID: <20120504212952.82940A0274@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46029 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759902Ab2EDV3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2012 17:29:53 -0400
Received: by vcbfl13 with SMTP id fl13so236247vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 04 May 2012 14:29:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@intel.com, davem@davemloft.net, eric.dumazet@gmail.com, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     Subject: net: use this_cpu_xxx replace percpu_xxx funcs
has been removed from the -mm tree.  Its filename was
     net-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alex Shi <alex.shi@intel.com>
Subject: net: use this_cpu_xxx replace percpu_xxx funcs

percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace them
for further code clean up.

And in preempt safe scenario, __this_cpu_xxx funcs has a bit better
performance since __this_cpu_xxx has no redundant preempt_disable()

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/xt_TEE.c |   12 ++++++------
 net/socket.c           |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN net/netfilter/xt_TEE.c~net-use-this_cpu_xxx-replace-percpu_xxx-funcs net/netfilter/xt_TEE.c
--- a/net/netfilter/xt_TEE.c~net-use-this_cpu_xxx-replace-percpu_xxx-funcs
+++ a/net/netfilter/xt_TEE.c
@@ -87,7 +87,7 @@ tee_tg4(struct sk_buff *skb, const struc
 	const struct xt_tee_tginfo *info = par->targinfo;
 	struct iphdr *iph;
 
-	if (percpu_read(tee_active))
+	if (__this_cpu_read(tee_active))
 		return XT_CONTINUE;
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
@@ -124,9 +124,9 @@ tee_tg4(struct sk_buff *skb, const struc
 	ip_send_check(iph);
 
 	if (tee_tg_route4(skb, info)) {
-		percpu_write(tee_active, true);
+		__this_cpu_write(tee_active, true);
 		ip_local_out(skb);
-		percpu_write(tee_active, false);
+		__this_cpu_write(tee_active, false);
 	} else {
 		kfree_skb(skb);
 	}
@@ -168,7 +168,7 @@ tee_tg6(struct sk_buff *skb, const struc
 {
 	const struct xt_tee_tginfo *info = par->targinfo;
 
-	if (percpu_read(tee_active))
+	if (__this_cpu_read(tee_active))
 		return XT_CONTINUE;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
@@ -186,9 +186,9 @@ tee_tg6(struct sk_buff *skb, const struc
 		--iph->hop_limit;
 	}
 	if (tee_tg_route6(skb, info)) {
-		percpu_write(tee_active, true);
+		__this_cpu_write(tee_active, true);
 		ip6_local_out(skb);
-		percpu_write(tee_active, false);
+		__this_cpu_write(tee_active, false);
 	} else {
 		kfree_skb(skb);
 	}
diff -puN net/socket.c~net-use-this_cpu_xxx-replace-percpu_xxx-funcs net/socket.c
--- a/net/socket.c~net-use-this_cpu_xxx-replace-percpu_xxx-funcs
+++ a/net/socket.c
@@ -479,7 +479,7 @@ static struct socket *sock_alloc(void)
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
 
-	percpu_add(sockets_in_use, 1);
+	this_cpu_add(sockets_in_use, 1);
 	return sock;
 }
 
@@ -522,7 +522,7 @@ void sock_release(struct socket *sock)
 	if (rcu_dereference_protected(sock->wq, 1)->fasync_list)
 		printk(KERN_ERR "sock_release: fasync list not empty!\n");
 
-	percpu_sub(sockets_in_use, 1);
+	this_cpu_sub(sockets_in_use, 1);
 	if (!sock->file) {
 		iput(SOCK_INODE(sock));
 		return;
_

Patches currently in -mm which might be from alex.shi@intel.com are

percpu-remove-percpu_xxx-functions.patch
mm-move-is_vma_temporary_stack-declaration-to-huge_mmh.patch

