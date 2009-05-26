From: akpm@linux-foundation.org
Subject: [merged] rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:45 -0700
Message-ID: <200905261935.n4QJZj9X006492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757379AbZEZTgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, davem@davemloft.net, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     RxRPC: fix error handling for rxrpc_alloc_connection()
has been removed from the -mm tree.  Its filename was
     rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: RxRPC: fix error handling for rxrpc_alloc_connection()
From: Dan Carpenter <error27@gmail.com>

rxrpc_alloc_connection() doesn't return an error code on failure, it just
returns NULL.  IS_ERR(NULL) is false.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rxrpc/ar-connection.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN net/rxrpc/ar-connection.c~rxrpc-fix-error-handling-for-rxrpc_alloc_connection net/rxrpc/ar-connection.c
--- a/net/rxrpc/ar-connection.c~rxrpc-fix-error-handling-for-rxrpc_alloc_connection
+++ a/net/rxrpc/ar-connection.c
@@ -343,9 +343,9 @@ static int rxrpc_connect_exclusive(struc
 		/* not yet present - create a candidate for a new connection
 		 * and then redo the check */
 		conn = rxrpc_alloc_connection(gfp);
-		if (IS_ERR(conn)) {
-			_leave(" = %ld", PTR_ERR(conn));
-			return PTR_ERR(conn);
+		if (!conn) {
+			_leave(" = -ENOMEM");
+			return -ENOMEM;
 		}
 
 		conn->trans = trans;
@@ -508,9 +508,9 @@ int rxrpc_connect_call(struct rxrpc_sock
 		/* not yet present - create a candidate for a new connection and then
 		 * redo the check */
 		candidate = rxrpc_alloc_connection(gfp);
-		if (IS_ERR(candidate)) {
-			_leave(" = %ld", PTR_ERR(candidate));
-			return PTR_ERR(candidate);
+		if (!candidate) {
+			_leave(" = -ENOMEM");
+			return -ENOMEM;
 		}
 
 		candidate->trans = trans;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch

