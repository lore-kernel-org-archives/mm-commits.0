From: akpm@linux-foundation.org
Subject: + ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch added to -mm tree
Date: Tue, 20 Jun 2017 15:21:04 -0700
Message-ID: <59499fd0.vsfrN03Y4e13N18A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47946 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752401AbdFTWVF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jun 2017 18:21:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, danielmicay@gmail.com, dledford@redhat.com, monis@mellanox.com, sean.hefty@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/rxe: do not copy extra stack memory to skb
has been added to the -mm tree.  Its filename is
     ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: IB/rxe: do not copy extra stack memory to skb

This fixes a over-read condition detected by FORTIFY_SOURCE for this line:

	memcpy(SKB_TO_PKT(skb), &ack_pkt, sizeof(skb->cb));

The error was:

In file included from ./include/linux/bitmap.h:8:0,
                 from ./include/linux/cpumask.h:11,
                 from ./include/linux/mm_types_task.h:13,
                 from ./include/linux/mm_types.h:4,
                 from ./include/linux/kmemcheck.h:4,
                 from ./include/linux/skbuff.h:18,
                 from drivers/infiniband/sw/rxe/rxe_resp.c:34:
In function 'memcpy',
    inlined from 'send_atomic_ack.constprop' at drivers/infiniband/sw/rxe/rxe_resp.c:998:2,
    inlined from 'acknowledge' at drivers/infiniband/sw/rxe/rxe_resp.c:1026:3,
    inlined from 'rxe_responder' at drivers/infiniband/sw/rxe/rxe_resp.c:1286:10:
./include/linux/string.h:309:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
    __read_overflow2();

Daniel Micay noted that struct rxe_pkt_info is 32 bytes on 32-bit
architectures, but skb->cb is still 64. The memcpy() over-reads 32
bytes. This fixes it by zeroing the unused bytes in skb->cb.

Link: http://lkml.kernel.org/r/1497903987-21002-5-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Moni Shoua <monis@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/sw/rxe/rxe_resp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/infiniband/sw/rxe/rxe_resp.c~ib-rxe-do-not-copy-extra-stack-memory-to-skb drivers/infiniband/sw/rxe/rxe_resp.c
--- a/drivers/infiniband/sw/rxe/rxe_resp.c~ib-rxe-do-not-copy-extra-stack-memory-to-skb
+++ a/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -995,7 +995,9 @@ static int send_atomic_ack(struct rxe_qp
 	free_rd_atomic_resource(qp, res);
 	rxe_advance_resp_resource(qp);
 
-	memcpy(SKB_TO_PKT(skb), &ack_pkt, sizeof(skb->cb));
+	memcpy(SKB_TO_PKT(skb), &ack_pkt, sizeof(ack_pkt));
+	memset((unsigned char *)SKB_TO_PKT(skb) + sizeof(ack_pkt), 0,
+	       sizeof(skb->cb) - sizeof(ack_pkt));
 
 	res->type = RXE_ATOMIC_MASK;
 	res->atomic.skb = skb;
_

Patches currently in -mm which might be from keescook@chromium.org are

ipc-drop-non-rcu-allocation.patch
ipc-sem-do-not-use-ipc_rcu_free.patch
ipc-shm-do-not-use-ipc_rcu_free.patch
ipc-msg-do-not-use-ipc_rcu_free.patch
ipc-util-drop-ipc_rcu_free.patch
ipc-sem-avoid-ipc_rcu_alloc.patch
ipc-shm-avoid-ipc_rcu_alloc.patch
ipc-msg-avoid-ipc_rcu_alloc.patch
ipc-util-drop-ipc_rcu_alloc.patch
ipc-move-atomic_set-to-where-it-is-needed.patch
ipc-shm-remove-special-shm_alloc-free.patch
ipc-msg-remove-special-msg_alloc-free.patch
ipc-sem-drop-__sem_free.patch
efi-avoid-fortify-checks-in-efi-stub.patch
x86-power-64-use-char-arrays-for-asm-function-names.patch
kexec_file-adjust-declaration-of-kexec_purgatory.patch
ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch

