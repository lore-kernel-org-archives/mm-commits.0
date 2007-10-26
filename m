From: akpm@linux-foundation.org
Subject: + sunrpc-xprtrdma-transportc-fix-use-after-free.patch added to -mm tree
Date: Fri, 26 Oct 2007 13:31:12 -0700
Message-ID: <200710262031.l9QKVCf3013075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56111 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbXJZUcJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 16:32:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, bfields@fieldses.org, davem@davemloft.net, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     sunrpc/xprtrdma/transport.c: fix use-after-free
has been added to the -mm tree.  Its filename is
     sunrpc-xprtrdma-transportc-fix-use-after-free.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sunrpc/xprtrdma/transport.c: fix use-after-free
From: Adrian Bunk <bunk@kernel.org>

Fix an obvious use-after-free spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtrdma/transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sunrpc/xprtrdma/transport.c~sunrpc-xprtrdma-transportc-fix-use-after-free net/sunrpc/xprtrdma/transport.c
--- a/net/sunrpc/xprtrdma/transport.c~sunrpc-xprtrdma-transportc-fix-use-after-free
+++ a/net/sunrpc/xprtrdma/transport.c
@@ -320,9 +320,9 @@ xprt_setup_rdma(struct xprt_create *args
 	xprt->slot = kcalloc(xprt->max_reqs,
 				sizeof(struct rpc_rqst), GFP_KERNEL);
 	if (xprt->slot == NULL) {
-		kfree(xprt);
 		dprintk("RPC:       %s: couldn't allocate %d slots\n",
 			__func__, xprt->max_reqs);
+		kfree(xprt);
 		return ERR_PTR(-ENOMEM);
 	}
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
ipmi-fix-comparison-in-demangle_device_id.patch
git-acpi.patch
git-dvb.patch
git-hwmon.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fuse-fuse_file_alloc-fix-null-dereferences.patch
make-jbd-journalc__journal_abort_hard-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
