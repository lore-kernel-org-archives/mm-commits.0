From: akpm@linux-foundation.org
Subject: - rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 02:01:26 -0700
Message-ID: <200705090901.l4991QDR018664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669AbXEIJBi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:01:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     rpc-add-wrapper-for-svc_reserve-to-account-for-checksum fix
has been removed from the -mm tree.  Its filename was
     rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix.patch

This patch was dropped because it was folded into rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch

------------------------------------------------------
Subject: rpc-add-wrapper-for-svc_reserve-to-account-for-checksum fix
From: Jeff Layton <jlayton@redhat.com>

> As far as your suggestion to use RPC_MAX_AUTH_SIZE, that sounds like a good
> idea to me. I'm all for avoiding "magic" numbers. How does this look? I also
> cleaned up the comments as well.
>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/svc.h |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff -puN include/linux/sunrpc/svc.h~rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix include/linux/sunrpc/svc.h
--- a/include/linux/sunrpc/svc.h~rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix
+++ a/include/linux/sunrpc/svc.h
@@ -399,10 +399,9 @@ char *		   svc_print_addr(struct svc_rqs
 /*
  * When we want to reduce the size of the reserved space in the response
  * buffer, we need to take into account the size of any checksum data that
- * may be at the end of the packet. For now, just use a hardcoded value
- * for each possible authflavor. This will need to be updated when new
- * encryption types or algorithms are added, or we'll have to come up with
- * a way to reasonably calculate this on the fly (maybe via a new auth_op).
+ * may be at the end of the packet. This is difficult to determine exactly
+ * for all cases without actually generating the checksum, so we just use a
+ * static value.
  */
 static inline void
 svc_reserve_auth(struct svc_rqst *rqstp, int space)
@@ -411,7 +410,7 @@ svc_reserve_auth(struct svc_rqst *rqstp,
 
 	switch(rqstp->rq_authop->flavour) {
 		case RPC_AUTH_GSS:
-			added_space = 56; /* determined empirically */
+			added_space = RPC_MAX_AUTH_SIZE;
 	}
 	return svc_reserve(rqstp, space + added_space);
 }
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix.patch
