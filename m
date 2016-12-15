From: akpm@linux-foundation.org
Subject: [merged] rxrpc-abstract-away-knowledge-of-idr-internals.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:49:18 -0800
Message-ID: <5852e5ae.UyCE3ybFcnoTa963%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50088 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752208AbcLOStU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:49:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, dhowells@redhat.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rxrpc: abstract away knowledge of IDR internals
has been removed from the -mm tree.  Its filename was
     rxrpc-abstract-away-knowledge-of-idr-internals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: rxrpc: abstract away knowledge of IDR internals

Add idr_get_cursor() / idr_set_cursor() APIs, and remove the reference
to IDR_SIZE.

Link: http://lkml.kernel.org/r/1480369871-5271-65-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h     |   26 ++++++++++++++++++++++++++
 net/rxrpc/af_rxrpc.c    |   11 ++++++-----
 net/rxrpc/conn_client.c |    4 ++--
 3 files changed, 34 insertions(+), 7 deletions(-)

diff -puN include/linux/idr.h~rxrpc-abstract-away-knowledge-of-idr-internals include/linux/idr.h
--- a/include/linux/idr.h~rxrpc-abstract-away-knowledge-of-idr-internals
+++ a/include/linux/idr.h
@@ -56,6 +56,32 @@ struct idr {
 #define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
 
 /**
+ * idr_get_cursor - Return the current position of the cyclic allocator
+ * @idr: idr handle
+ *
+ * The value returned is the value that will be next returned from
+ * idr_alloc_cyclic() if it is free (otherwise the search will start from
+ * this position).
+ */
+static inline unsigned int idr_get_cursor(struct idr *idr)
+{
+	return READ_ONCE(idr->cur);
+}
+
+/**
+ * idr_set_cursor - Set the current position of the cyclic allocator
+ * @idr: idr handle
+ * @val: new position
+ *
+ * The next call to idr_alloc_cyclic() will return @val if it is free
+ * (otherwise the search will start from this position).
+ */
+static inline void idr_set_cursor(struct idr *idr, unsigned int val)
+{
+	WRITE_ONCE(idr->cur, val);
+}
+
+/**
  * DOC: idr sync
  * idr synchronization (stolen from radix-tree.h)
  *
diff -puN net/rxrpc/af_rxrpc.c~rxrpc-abstract-away-knowledge-of-idr-internals net/rxrpc/af_rxrpc.c
--- a/net/rxrpc/af_rxrpc.c~rxrpc-abstract-away-knowledge-of-idr-internals
+++ a/net/rxrpc/af_rxrpc.c
@@ -762,16 +762,17 @@ static const struct net_proto_family rxr
 static int __init af_rxrpc_init(void)
 {
 	int ret = -1;
+	unsigned int tmp;
 
 	BUILD_BUG_ON(sizeof(struct rxrpc_skb_priv) > FIELD_SIZEOF(struct sk_buff, cb));
 
 	get_random_bytes(&rxrpc_epoch, sizeof(rxrpc_epoch));
 	rxrpc_epoch |= RXRPC_RANDOM_EPOCH;
-	get_random_bytes(&rxrpc_client_conn_ids.cur,
-			 sizeof(rxrpc_client_conn_ids.cur));
-	rxrpc_client_conn_ids.cur &= 0x3fffffff;
-	if (rxrpc_client_conn_ids.cur == 0)
-		rxrpc_client_conn_ids.cur = 1;
+	get_random_bytes(&tmp, sizeof(tmp));
+	tmp &= 0x3fffffff;
+	if (tmp == 0)
+		tmp = 1;
+	idr_set_cursor(&rxrpc_client_conn_ids, tmp);
 
 	ret = -ENOMEM;
 	rxrpc_call_jar = kmem_cache_create(
diff -puN net/rxrpc/conn_client.c~rxrpc-abstract-away-knowledge-of-idr-internals net/rxrpc/conn_client.c
--- a/net/rxrpc/conn_client.c~rxrpc-abstract-away-knowledge-of-idr-internals
+++ a/net/rxrpc/conn_client.c
@@ -263,12 +263,12 @@ static bool rxrpc_may_reuse_conn(struct
 	 * times the maximum number of client conns away from the current
 	 * allocation point to try and keep the IDs concentrated.
 	 */
-	id_cursor = READ_ONCE(rxrpc_client_conn_ids.cur);
+	id_cursor = idr_get_cursor(&rxrpc_client_conn_ids);
 	id = conn->proto.cid >> RXRPC_CIDSHIFT;
 	distance = id - id_cursor;
 	if (distance < 0)
 		distance = -distance;
-	limit = round_up(rxrpc_max_client_connections, IDR_SIZE) * 4;
+	limit = max(rxrpc_max_client_connections * 4, 1024U);
 	if (distance > limit)
 		goto mark_dont_reuse;
 
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

radix-tree-test-suite-fix-compilation.patch

