From: akpm@linux-foundation.org
Subject: + sunrpc-do-not-pin-sunrpc-module-in-the-memory.patch added to -mm tree
Date: Tue, 05 Aug 2008 14:43:45 -0700
Message-ID: <200808052143.m75LhjrP025009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757922AbYHEVok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 17:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, bfields@fieldses.org, chuck.lever@oracle.com, davem@davemloft.net, trond.myklebust@fys.uio.no


The patch titled
     sunrpc: do not pin sunrpc module in the memory
has been added to the -mm tree.  Its filename is
     sunrpc-do-not-pin-sunrpc-module-in-the-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sunrpc: do not pin sunrpc module in the memory
From: "Denis V. Lunev" <den@openvz.org>

Basically, try_module_get here are pretty useless. Any other module using
this API will pin sunrpc in memory due using exported symbols.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprt.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN net/sunrpc/xprt.c~sunrpc-do-not-pin-sunrpc-module-in-the-memory net/sunrpc/xprt.c
--- a/net/sunrpc/xprt.c~sunrpc-do-not-pin-sunrpc-module-in-the-memory
+++ a/net/sunrpc/xprt.c
@@ -108,13 +108,10 @@ int xprt_register_transport(struct xprt_
 			goto out;
 	}
 
-	result = -EINVAL;
-	if (try_module_get(THIS_MODULE)) {
-		list_add_tail(&transport->list, &xprt_list);
-		printk(KERN_INFO "RPC: Registered %s transport module.\n",
-			transport->name);
-		result = 0;
-	}
+	list_add_tail(&transport->list, &xprt_list);
+	printk(KERN_INFO "RPC: Registered %s transport module.\n",
+	       transport->name);
+	result = 0;
 
 out:
 	spin_unlock(&xprt_list_lock);
@@ -143,7 +140,6 @@ int xprt_unregister_transport(struct xpr
 				"RPC: Unregistered %s transport module.\n",
 				transport->name);
 			list_del_init(&transport->list);
-			module_put(THIS_MODULE);
 			goto out;
 		}
 	}
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
linux-next.patch
nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount.patch
sunrpc-do-not-pin-sunrpc-module-in-the-memory.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

