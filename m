From: akpm@linux-foundation.org
Subject: - sunrpc-fix-crash-in-rpc_malloc.patch removed from -mm tree
Date: Fri, 11 May 2007 22:14:46 -0700
Message-ID: <200705120514.l4C5Ekas001687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756242AbXELFPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, davem@davemloft.net, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     sunrpc: fix crash in rpc_malloc()
has been removed from the -mm tree.  Its filename was
     sunrpc-fix-crash-in-rpc_malloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sunrpc: fix crash in rpc_malloc()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

While the comment says:
 * To prevent rpciod from hanging, this allocator never sleeps,
 * returning NULL if the request cannot be serviced immediately.

The function does not actually check for NULL pointers being returned.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/sched.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN net/sunrpc/sched.c~sunrpc-fix-crash-in-rpc_malloc net/sunrpc/sched.c
--- a/net/sunrpc/sched.c~sunrpc-fix-crash-in-rpc_malloc
+++ a/net/sunrpc/sched.c
@@ -762,6 +762,10 @@ void *rpc_malloc(struct rpc_task *task, 
 		buf = mempool_alloc(rpc_buffer_mempool, gfp);
 	else
 		buf = kmalloc(size, gfp);
+
+	if (!buf)
+		return NULL;
+
 	*buf = size;
 	dprintk("RPC: %5u allocated buffer of size %zu at %p\n",
 			task->tk_pid, size, buf);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
loop_probe-fix-return-value.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
