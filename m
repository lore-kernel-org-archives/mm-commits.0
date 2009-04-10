From: akpm@linux-foundation.org
Subject: + rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch added to -mm tree
Date: Thu, 09 Apr 2009 21:43:00 -0700
Message-ID: <200904100443.n3A4h0PQ025255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbZDJEpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 00:45:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, davem@davemloft.net, dhowells@redhat.com


The patch titled
     RxRPC: fix error handling for rxrpc_alloc_connection()
has been added to the -mm tree.  Its filename is
     rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch

