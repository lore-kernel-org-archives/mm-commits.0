From: akpm@linux-foundation.org
Subject: [merged] afs-remote-abort-can-cause-bug-in-rxrpc-code.patch removed from -mm tree
Date: Mon, 19 Mar 2012 13:30:01 -0700
Message-ID: <20120319203001.5D39CA02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45243 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415Ab2CSUaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Mar 2012 16:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, dhowells@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: afs: remote abort can cause BUG in rxrpc code
has been removed from the -mm tree.  Its filename was
     afs-remote-abort-can-cause-bug-in-rxrpc-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Anton Blanchard <anton@samba.org>
Subject: afs: remote abort can cause BUG in rxrpc code

When writing files to afs I sometimes hit a BUG:

kernel BUG at fs/afs/rxrpc.c:179!

With a backtrace of:

	afs_free_call
	afs_make_call
	afs_fs_store_data
	afs_vnode_store_data
	afs_write_back_from_locked_page
	afs_writepages_region
	afs_writepages

The cause is:

	ASSERT(skb_queue_empty(&call->rx_queue));

Looking at a tcpdump of the session the abort happens because we
are exceeding our disk quota:

	rx abort fs reply store-data error diskquota exceeded (32)

So the abort error is valid. We hit the BUG because we haven't
freed all the resources for the call.

By freeing any skbs in call->rx_queue before calling afs_free_call
we avoid hitting leaking memory and avoid hitting the BUG.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/rxrpc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/afs/rxrpc.c~afs-remote-abort-can-cause-bug-in-rxrpc-code fs/afs/rxrpc.c
--- a/fs/afs/rxrpc.c~afs-remote-abort-can-cause-bug-in-rxrpc-code
+++ a/fs/afs/rxrpc.c
@@ -314,6 +314,7 @@ int afs_make_call(struct in_addr *addr, 
 	struct msghdr msg;
 	struct kvec iov[1];
 	int ret;
+	struct sk_buff *skb;
 
 	_enter("%x,{%d},", addr->s_addr, ntohs(call->port));
 
@@ -380,6 +381,8 @@ int afs_make_call(struct in_addr *addr, 
 
 error_do_abort:
 	rxrpc_kernel_abort_call(rxcall, RX_USER_ABORT);
+	while ((skb = skb_dequeue(&call->rx_queue)))
+		afs_free_skb(skb);
 	rxrpc_kernel_end_call(rxcall);
 	call->rxcall = NULL;
 error_kill_call:
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
linux-next.patch

