From: akpm@linux-foundation.org
Subject: [merged] rxrpc-fix-v1-keys.patch removed from -mm tree
Date: Fri, 04 Mar 2011 15:16:04 -0800
Message-ID: <201103042316.p24NGFAb009472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab1CDXQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 18:16:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@au1.ibm.com, anton@samba.org, davem@davemloft.net, dhowells@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     RxRPC: Fix v1 keys
has been removed from the -mm tree.  Its filename was
     rxrpc-fix-v1-keys.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: RxRPC: Fix v1 keys
From: Anton Blanchard <anton@au1.ibm.com>

commit 339412841d7 (RxRPC: Allow key payloads to be passed in XDR form)
broke klog for me.  I notice the v1 key struct had a kif_version field
added:

-struct rxkad_key {
-       u16     security_index;         /* RxRPC header security index */
-       u16     ticket_len;             /* length of ticket[] */
-       u32     expiry;                 /* time at which expires */
-       u32     kvno;                   /* key version number */
-       u8      session_key[8];         /* DES session key */
-       u8      ticket[0];              /* the encrypted ticket */
-};

+struct rxrpc_key_data_v1 {
+       u32             kif_version;            /* 1 */
+       u16             security_index;
+       u16             ticket_length;
+       u32             expiry;                 /* time_t */
+       u32             kvno;
+       u8              session_key[8];
+       u8              ticket[0];
+};

However the code in rxrpc_instantiate strips it away:

	data += sizeof(kver);
	datalen -= sizeof(kver);

Removing kif_version fixes my problem.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: <stable@kernel.org>		[2.6.37.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/keys/rxrpc-type.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/keys/rxrpc-type.h~rxrpc-fix-v1-keys include/keys/rxrpc-type.h
--- a/include/keys/rxrpc-type.h~rxrpc-fix-v1-keys
+++ a/include/keys/rxrpc-type.h
@@ -99,7 +99,6 @@ struct rxrpc_key_token {
  * structure of raw payloads passed to add_key() or instantiate key
  */
 struct rxrpc_key_data_v1 {
-	u32		kif_version;		/* 1 */
 	u16		security_index;
 	u16		ticket_length;
 	u32		expiry;			/* time_t */
_

Patches currently in -mm which might be from anton@au1.ibm.com are

origin.patch

