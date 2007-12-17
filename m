From: akpm@linux-foundation.org
Subject: - fix-proc-net-packet-crash-due-to-bogus-private-pointer.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:39:20 -0800
Message-ID: <200712172339.lBHNdKUs008118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758646AbXLQXj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:39:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     Fix /proc/net/packet crash due to bogus private pointer
has been removed from the -mm tree.  Its filename was
     fix-proc-net-packet-crash-due-to-bogus-private-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix /proc/net/packet crash due to bogus private pointer
From: Herbert Xu <herbert@gondor.apana.org.au>

The seq_open_net patch changed the meaning of seq->private.  Unfortunately
it missed two spots in AF_PACKET, which still used the old way of
dereferencing seq->private, thus causing weird and wonderful crashes when
reading /proc/net/packet.

This patch fixes them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/packet/af_packet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/packet/af_packet.c~fix-proc-net-packet-crash-due-to-bogus-private-pointer net/packet/af_packet.c
--- a/net/packet/af_packet.c~fix-proc-net-packet-crash-due-to-bogus-private-pointer
+++ a/net/packet/af_packet.c
@@ -1878,7 +1878,7 @@ static void *packet_seq_start(struct seq
 
 static void *packet_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct net *net = seq->private;
+	struct net *net = seq_file_net(seq);
 	++*pos;
 	return  (v == SEQ_START_TOKEN)
 		? sk_head(&net->packet.sklist)
@@ -1887,7 +1887,7 @@ static void *packet_seq_next(struct seq_
 
 static void packet_seq_stop(struct seq_file *seq, void *v)
 {
-	struct net *net = seq->private;
+	struct net *net = seq_file_net(seq);
 	read_unlock(&net->packet.sklist_lock);
 }
 
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
git-net.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
avoid-divide-in-is_align.patch
remove-rcu_assign_pointer-penalty-for-null-pointers.patch
