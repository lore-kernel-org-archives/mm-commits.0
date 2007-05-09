From: akpm@linux-foundation.org
Subject: + sunrpc-fix-crash-in-rpc_malloc.patch added to -mm tree
Date: Wed, 09 May 2007 00:14:05 -0700
Message-ID: <200705090714.l497E5PF016803@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755506AbXEIHOR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 03:14:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, davem@davemloft.net, trond.myklebust@fys.uio.no


The patch titled
     sunrpc: fix crash in rpc_malloc()
has been added to the -mm tree.  Its filename is
     sunrpc-fix-crash-in-rpc_malloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
sunrpc-fix-crash-in-rpc_malloc.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
uml-turn-on-scsi-support.patch
