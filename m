From: akpm@linux-foundation.org
Subject: + fix-proc-net-packet-crash-due-to-bogus-private-pointer.patch added to -mm tree
Date: Sun, 16 Dec 2007 02:14:31 -0800
Message-ID: <200712161014.lBGAEVAO023165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59733 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758875AbXLPKPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Dec 2007 05:15:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     Fix /proc/net/packet crash due to bogus private pointer
has been added to the -mm tree.  Its filename is
     fix-proc-net-packet-crash-due-to-bogus-private-pointer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-proc-net-packet-crash-due-to-bogus-private-pointer.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
avoid-divide-in-is_align.patch
remove-rcu_assign_pointer-penalty-for-null-pointers.patch
