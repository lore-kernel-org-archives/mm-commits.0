From: akpm@linux-foundation.org
Subject: + net-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch added to -mm tree
Date: Fri, 13 Jan 2012 15:16:32 -0800
Message-ID: <20120113231633.925695C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62264 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2AMXQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 18:16:35 -0500
Received: by eaad12 with SMTP id d12so29015eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 15:16:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.shi@intel.com, davem@davemloft.net, eric.dumazet@gmail.com, kaber@trash.net


The patch titled
     Subject: net: use this_cpu_xxx replace percpu_xxx funcs
has been added to the -mm tree.  Its filename is
     net-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -167,7 +167,7 @@ tee_tg6(struct sk_buff *skb, const struc
 {
 	const struct xt_tee_tginfo *info = par->targinfo;
 
-	if (percpu_read(tee_active))
+	if (__this_cpu_read(tee_active))
 		return XT_CONTINUE;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
@@ -185,9 +185,9 @@ tee_tg6(struct sk_buff *skb, const struc
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
Subject: Subject: net: use this_cpu_xxx replace percpu_xxx funcs

Patches currently in -mm which might be from alex.shi@intel.com are

origin.patch
net-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch
xen-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable.patch
percpu-remove-percpu_xxx-functions.patch

