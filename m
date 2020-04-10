From: akpm@linux-foundation.org
Subject: [folded-merged]
 net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch removed
 from -mm tree
Date: Fri, 10 Apr 2020 11:59:53 -0700
Message-ID: <20200410185953.T-chjhkkJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgDJS7y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 14:59:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjunroy.kdev@gmail.com, arjunroy@google.com, davem@davemloft.net, edumazet@google.com, jgg@ziepe.ca, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, soheil@google.com, willy@infradead.org


The patch titled
     Subject: net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix
has been removed from the -mm tree.  Its filename was
     net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch

This patch was dropped because it was folded into net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix

Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arjun Roy <arjunroy.kdev@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp.c~net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix
+++ a/net/ipv4/tcp.c
@@ -1788,6 +1788,8 @@ static int tcp_zerocopy_receive(struct s
 
 	sock_rps_record_flow(sk);
 
+	tp = tcp_sk(sk);
+
 	down_read(&current->mm->mmap_sem);
 
 	ret = -EINVAL;
@@ -1796,7 +1798,6 @@ static int tcp_zerocopy_receive(struct s
 		goto out;
 	zc->length = min_t(unsigned long, zc->length, vma->vm_end - address);
 
-	tp = tcp_sk(sk);
 	seq = tp->copied_seq;
 	inq = tcp_inq(sk);
 	zc->length = min_t(u32, zc->length, inq);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-cma-numa-node-interface-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
