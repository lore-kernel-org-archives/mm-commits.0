From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch added to
 -mm tree
Date: Wed, 12 Feb 2020 18:57:04 -0800
Message-ID: <20200213025704.5OTwbUgtS%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729496AbgBMC5F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 21:57:05 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjunroy@google.com, davem@davemloft.net, edumazet@google.com, mm-commits@vger.kernel.org, soheil@google.com


The patch titled
     Subject: net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix
has been added to the -mm tree.  Its filename is
     net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix

Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
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

mm.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
linux-next-rejects.patch
linux-next-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
