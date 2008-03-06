From: akpm@linux-foundation.org
Subject: - rxrpc-fix-rxrpc_recvmsgs-returning-of-msg_name.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:22:48 -0800
Message-ID: <200803062222.m26MMm4H020837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbYCFWYE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:24:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     RxRPC: fix rxrpc_recvmsg()'s returning of msg_name
has been removed from the -mm tree.  Its filename was
     rxrpc-fix-rxrpc_recvmsgs-returning-of-msg_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: RxRPC: fix rxrpc_recvmsg()'s returning of msg_name
From: David Howells <dhowells@redhat.com>

Fix rxrpc_recvmsg() to return msg_name correctly.  We shouldn't overwrite the
*msg struct, but should rather write into msg->msg_name (there's a '&' unary
operator that shouldn't be there).

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rxrpc/ar-recvmsg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/rxrpc/ar-recvmsg.c~rxrpc-fix-rxrpc_recvmsgs-returning-of-msg_name net/rxrpc/ar-recvmsg.c
--- a/net/rxrpc/ar-recvmsg.c~rxrpc-fix-rxrpc_recvmsgs-returning-of-msg_name
+++ a/net/rxrpc/ar-recvmsg.c
@@ -143,7 +143,8 @@ int rxrpc_recvmsg(struct kiocb *iocb, st
 		/* copy the peer address and timestamp */
 		if (!continue_call) {
 			if (msg->msg_name && msg->msg_namelen > 0)
-				memcpy(&msg->msg_name, &call->conn->trans->peer->srx,
+				memcpy(msg->msg_name,
+				       &call->conn->trans->peer->srx,
 				       sizeof(call->conn->trans->peer->srx));
 			sock_recv_timestamp(msg, &rx->sk, skb);
 		}
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-hrt.patch
git-net.patch
git-unionfs.patch
romfs-prevent-romfs_lookup-from-always-failing.patch
remove-the-macro-get_personality.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
mutex-subsystem-synchro-test-module.patch

