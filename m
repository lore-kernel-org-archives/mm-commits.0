From: akpm@osdl.org
Subject: + remove-tcp-header-from-tcp_v4_check.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:54:59 -0800
Message-ID: <200701112155.l0BLsxn5004134@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37713 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbXAKVze (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:55:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, frederik.deweerdt@gmail.com


The patch titled
     net: remove tcp header from tcp_v4_check
has been added to the -mm tree.  Its filename is
     remove-tcp-header-from-tcp_v4_check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net: remove tcp header from tcp_v4_check
From: Frederik Deweerdt <deweerdt@free.fr>

The tcphdr struct passed to tcp_v4_check is not used, the following patch
removes it from the parameter list.

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/net/tcp.h               |    5 ++---
 net/ipv4/netfilter/ipt_REJECT.c |    2 +-
 net/ipv4/tcp_ipv4.c             |   15 +++++++--------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff -puN include/net/tcp.h~remove-tcp-header-from-tcp_v4_check include/net/tcp.h
--- a/include/net/tcp.h~remove-tcp-header-from-tcp_v4_check
+++ a/include/net/tcp.h
@@ -802,9 +802,8 @@ static inline void tcp_update_wl(struct 
 /*
  * Calculate(/check) TCP checksum
  */
-static inline __sum16 tcp_v4_check(struct tcphdr *th, int len,
-			       __be32 saddr, __be32 daddr,
-			       __wsum base)
+static inline __sum16 tcp_v4_check(int len, __be32 saddr,
+				   __be32 daddr, __wsum base)
 {
 	return csum_tcpudp_magic(saddr,daddr,len,IPPROTO_TCP,base);
 }
diff -puN net/ipv4/netfilter/ipt_REJECT.c~remove-tcp-header-from-tcp_v4_check net/ipv4/netfilter/ipt_REJECT.c
--- a/net/ipv4/netfilter/ipt_REJECT.c~remove-tcp-header-from-tcp_v4_check
+++ a/net/ipv4/netfilter/ipt_REJECT.c
@@ -116,7 +116,7 @@ static void send_reset(struct sk_buff *o
 
 	/* Adjust TCP checksum */
 	tcph->check = 0;
-	tcph->check = tcp_v4_check(tcph, sizeof(struct tcphdr),
+	tcph->check = tcp_v4_check(sizeof(struct tcphdr),
 				   nskb->nh.iph->saddr,
 				   nskb->nh.iph->daddr,
 				   csum_partial((char *)tcph,
diff -puN net/ipv4/tcp_ipv4.c~remove-tcp-header-from-tcp_v4_check net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~remove-tcp-header-from-tcp_v4_check
+++ a/net/ipv4/tcp_ipv4.c
@@ -502,14 +502,13 @@ void tcp_v4_send_check(struct sock *sk, 
 	struct tcphdr *th = skb->h.th;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		th->check = ~tcp_v4_check(th, len,
-					  inet->saddr, inet->daddr, 0);
+		th->check = ~tcp_v4_check(len, inet->saddr,
+					  inet->daddr, 0);
 		skb->csum_offset = offsetof(struct tcphdr, check);
 	} else {
-		th->check = tcp_v4_check(th, len, inet->saddr, inet->daddr,
+		th->check = tcp_v4_check(len, inet->saddr, inet->daddr,
 					 csum_partial((char *)th,
-						      th->doff << 2,
-						      skb->csum));
+						th->doff << 2, skb->csum));
 	}
 }
 
@@ -525,7 +524,7 @@ int tcp_v4_gso_send_check(struct sk_buff
 	th = skb->h.th;
 
 	th->check = 0;
-	th->check = ~tcp_v4_check(th, skb->len, iph->saddr, iph->daddr, 0);
+	th->check = ~tcp_v4_check(skb->len, iph->saddr, iph->daddr, 0);
 	skb->csum_offset = offsetof(struct tcphdr, check);
 	skb->ip_summed = CHECKSUM_PARTIAL;
 	return 0;
@@ -747,7 +746,7 @@ static int tcp_v4_send_synack(struct soc
 	if (skb) {
 		struct tcphdr *th = skb->h.th;
 
-		th->check = tcp_v4_check(th, skb->len,
+		th->check = tcp_v4_check(skb->len,
 					 ireq->loc_addr,
 					 ireq->rmt_addr,
 					 csum_partial((char *)th, skb->len,
@@ -1514,7 +1513,7 @@ static struct sock *tcp_v4_hnd_req(struc
 static __sum16 tcp_v4_checksum_init(struct sk_buff *skb)
 {
 	if (skb->ip_summed == CHECKSUM_COMPLETE) {
-		if (!tcp_v4_check(skb->h.th, skb->len, skb->nh.iph->saddr,
+		if (!tcp_v4_check(skb->len, skb->nh.iph->saddr,
 				  skb->nh.iph->daddr, skb->csum)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			return 0;
_

Patches currently in -mm which might be from deweerdt@free.fr are

fix2-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
remove-tcp-header-from-tcp_v4_check.patch
disable-init-initramfsc-updated-fix.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-user-ns-unshare.patch
reiser4-sb_sync_inodes-fix.patch
