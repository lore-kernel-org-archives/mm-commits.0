From: akpm@linux-foundation.org
Subject: [patch 105/114] treewide: convert PF_MEMALLOC
 manipulations to new helpers
Date: Mon, 08 May 2017 15:59:53 -0700
Message-ID: <20170508225953.3YEBO0ZmY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47632 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751087AbdEHW7z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, boris.brezillon@free-electrons.com, cleech@redhat.com, davem@davemloft.net, edumazet@google.com, hannes@cmpxchg.org, jbacik@fb.com, lduncan@suse.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, richard@nod.at, torvalds@linux-foundation.org, vbabka@suse.cz, w@uter.be

From: Vlastimil Babka <vbabka@suse.cz>
Subject: treewide: convert PF_MEMALLOC manipulations to new helpers

We now have memalloc_noreclaim_{save,restore} helpers for robust setting
and clearing of PF_MEMALLOC.  Let's convert the code which was using the
generic tsk_restore_flags().  No functional change.

[vbabka@suse.cz: in net/core/sock.c the hunk is missing]
Link: http://lkml.kernel.org/r/20170405074700.29871-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Wouter Verhelst <w@uter.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c      |    7 ++++---
 drivers/scsi/iscsi_tcp.c |    7 ++++---
 net/core/dev.c           |    7 ++++---
 net/core/sock.c          |    7 ++++---
 4 files changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/block/nbd.c~treewide-convert-pf_memalloc-manipulations-to-new-helpers drivers/block/nbd.c
--- a/drivers/block/nbd.c~treewide-convert-pf_memalloc-manipulations-to-new-helpers
+++ a/drivers/block/nbd.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/fs.h>
 #include <linux/bio.h>
 #include <linux/stat.h>
@@ -347,7 +348,7 @@ static int sock_xmit(struct nbd_device *
 	struct socket *sock = config->socks[index]->sock;
 	int result;
 	struct msghdr msg;
-	unsigned long pflags = current->flags;
+	unsigned int noreclaim_flag;
 
 	if (unlikely(!sock)) {
 		dev_err_ratelimited(disk_to_dev(nbd->disk),
@@ -358,7 +359,7 @@ static int sock_xmit(struct nbd_device *
 
 	msg.msg_iter = *iter;
 
-	current->flags |= PF_MEMALLOC;
+	noreclaim_flag = memalloc_noreclaim_save();
 	do {
 		sock->sk->sk_allocation = GFP_NOIO | __GFP_MEMALLOC;
 		msg.msg_name = NULL;
@@ -381,7 +382,7 @@ static int sock_xmit(struct nbd_device *
 			*sent += result;
 	} while (msg_data_left(&msg));
 
-	current_restore_flags(pflags, PF_MEMALLOC);
+	memalloc_noreclaim_restore(noreclaim_flag);
 
 	return result;
 }
diff -puN drivers/scsi/iscsi_tcp.c~treewide-convert-pf_memalloc-manipulations-to-new-helpers drivers/scsi/iscsi_tcp.c
--- a/drivers/scsi/iscsi_tcp.c~treewide-convert-pf_memalloc-manipulations-to-new-helpers
+++ a/drivers/scsi/iscsi_tcp.c
@@ -30,6 +30,7 @@
 #include <linux/types.h>
 #include <linux/inet.h>
 #include <linux/slab.h>
+#include <linux/sched/mm.h>
 #include <linux/file.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
@@ -371,10 +372,10 @@ static inline int iscsi_sw_tcp_xmit_qlen
 static int iscsi_sw_tcp_pdu_xmit(struct iscsi_task *task)
 {
 	struct iscsi_conn *conn = task->conn;
-	unsigned long pflags = current->flags;
+	unsigned int noreclaim_flag;
 	int rc = 0;
 
-	current->flags |= PF_MEMALLOC;
+	noreclaim_flag = memalloc_noreclaim_save();
 
 	while (iscsi_sw_tcp_xmit_qlen(conn)) {
 		rc = iscsi_sw_tcp_xmit(conn);
@@ -387,7 +388,7 @@ static int iscsi_sw_tcp_pdu_xmit(struct
 		rc = 0;
 	}
 
-	current_restore_flags(pflags, PF_MEMALLOC);
+	memalloc_noreclaim_restore(noreclaim_flag);
 	return rc;
 }
 
diff -puN net/core/dev.c~treewide-convert-pf_memalloc-manipulations-to-new-helpers net/core/dev.c
--- a/net/core/dev.c~treewide-convert-pf_memalloc-manipulations-to-new-helpers
+++ a/net/core/dev.c
@@ -81,6 +81,7 @@
 #include <linux/hash.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/mutex.h>
 #include <linux/string.h>
 #include <linux/mm.h>
@@ -4235,7 +4236,7 @@ static int __netif_receive_skb(struct sk
 	int ret;
 
 	if (sk_memalloc_socks() && skb_pfmemalloc(skb)) {
-		unsigned long pflags = current->flags;
+		unsigned int noreclaim_flag;
 
 		/*
 		 * PFMEMALLOC skbs are special, they should
@@ -4246,9 +4247,9 @@ static int __netif_receive_skb(struct sk
 		 * Use PF_MEMALLOC as this saves us from propagating the allocation
 		 * context down to all allocation sites.
 		 */
-		current->flags |= PF_MEMALLOC;
+		noreclaim_flag = memalloc_noreclaim_save();
 		ret = __netif_receive_skb_core(skb, true);
-		current_restore_flags(pflags, PF_MEMALLOC);
+		memalloc_noreclaim_restore(noreclaim_flag);
 	} else
 		ret = __netif_receive_skb_core(skb, false);
 
diff -puN net/core/sock.c~treewide-convert-pf_memalloc-manipulations-to-new-helpers net/core/sock.c
--- a/net/core/sock.c~treewide-convert-pf_memalloc-manipulations-to-new-helpers
+++ a/net/core/sock.c
@@ -102,6 +102,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
@@ -372,14 +373,14 @@ EXPORT_SYMBOL_GPL(sk_clear_memalloc);
 int __sk_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	int ret;
-	unsigned long pflags = current->flags;
+	unsigned int noreclaim_flag;
 
 	/* these should have been dropped before queueing */
 	BUG_ON(!sock_flag(sk, SOCK_MEMALLOC));
 
-	current->flags |= PF_MEMALLOC;
+	noreclaim_flag = memalloc_noreclaim_save();
 	ret = sk->sk_backlog_rcv(sk, skb);
-	current_restore_flags(pflags, PF_MEMALLOC);
+	memalloc_noreclaim_restore(noreclaim_flag);
 
 	return ret;
 }
_
