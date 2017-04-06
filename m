From: akpm@linux-foundation.org
Subject: + treewide-convert-pf_memalloc-manipulations-to-new-helpers.patch added to -mm tree
Date: Thu, 06 Apr 2017 16:22:06 -0700
Message-ID: <58e6cd9e.oAfmBnX8+C/9tMIO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755303AbdDFXWI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2017 19:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aryabinin@virtuozzo.com, boris.brezillon@free-electrons.com, cleech@redhat.com, davem@davemloft.net, edumazet@google.com, hannes@cmpxchg.org, jbacik@fb.com, lduncan@suse.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: convert PF_MEMALLOC manipulations to new helpers
has been added to the -mm tree.  Its filename is
     treewide-convert-pf_memalloc-manipulations-to-new-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/treewide-convert-pf_memalloc-manipulations-to-new-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/treewide-convert-pf_memalloc-manipulations-to-new-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: treewide: convert PF_MEMALLOC manipulations to new helpers

We now have memalloc_noreclaim_{save,restore} helpers for robust setting
and clearing of PF_MEMALLOC.  Let's convert the code which was using the
generic tsk_restore_flags().  No functional change.

Link: http://lkml.kernel.org/r/20170405074700.29871-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Richard Weinberger <richard@nod.at>
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
@@ -210,7 +211,7 @@ static int sock_xmit(struct nbd_device *
 	struct socket *sock = nbd->socks[index]->sock;
 	int result;
 	struct msghdr msg;
-	unsigned long pflags = current->flags;
+	unsigned int noreclaim_flag;
 
 	if (unlikely(!sock)) {
 		dev_err_ratelimited(disk_to_dev(nbd->disk),
@@ -221,7 +222,7 @@ static int sock_xmit(struct nbd_device *
 
 	msg.msg_iter = *iter;
 
-	current->flags |= PF_MEMALLOC;
+	noreclaim_flag = memalloc_noreclaim_save();
 	do {
 		sock->sk->sk_allocation = GFP_NOIO | __GFP_MEMALLOC;
 		msg.msg_name = NULL;
@@ -244,7 +245,7 @@ static int sock_xmit(struct nbd_device *
 			*sent += result;
 	} while (msg_data_left(&msg));
 
-	tsk_restore_flags(current, pflags, PF_MEMALLOC);
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
 
-	tsk_restore_flags(current, pflags, PF_MEMALLOC);
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
@@ -4227,7 +4228,7 @@ static int __netif_receive_skb(struct sk
 	int ret;
 
 	if (sk_memalloc_socks() && skb_pfmemalloc(skb)) {
-		unsigned long pflags = current->flags;
+		unsigned int noreclaim_flag;
 
 		/*
 		 * PFMEMALLOC skbs are special, they should
@@ -4238,9 +4239,9 @@ static int __netif_receive_skb(struct sk
 		 * Use PF_MEMALLOC as this saves us from propagating the allocation
 		 * context down to all allocation sites.
 		 */
-		current->flags |= PF_MEMALLOC;
+		noreclaim_flag = memalloc_noreclaim_save();
 		ret = __netif_receive_skb_core(skb, true);
-		tsk_restore_flags(current, pflags, PF_MEMALLOC);
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
@@ -318,14 +319,14 @@ EXPORT_SYMBOL_GPL(sk_clear_memalloc);
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
-	tsk_restore_flags(current, pflags, PF_MEMALLOC);
+	memalloc_noreclaim_restore(noreclaim_flag);
 
 	return ret;
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-reorder-fields-in-struct-compact_control.patch
mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch
mm-page_alloc-split-smallest-stolen-page-in-fallback.patch
mm-page_alloc-split-smallest-stolen-page-in-fallback-fix.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch
mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch
mm-compaction-add-migratetype-to-compact_control.patch
mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch
mm-compaction-finish-whole-pageblock-to-reduce-fragmentation.patch
mm-prevent-potential-recursive-reclaim-due-to-clearing-pf_memalloc.patch
mm-introduce-memalloc_noreclaim_saverestore.patch
treewide-convert-pf_memalloc-manipulations-to-new-helpers.patch
mtd-nand-nandsim-convert-to-memalloc_noreclaim_.patch

