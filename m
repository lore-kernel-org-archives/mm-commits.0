From: akpm@linux-foundation.org
Subject: [merged] 9p-disallow-rdma-if-rdma-cm-isnt-available.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:18:25 -0800
Message-ID: <200901161918.n0GJIPtS027005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936412AbZAPTTM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:19:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, randy.dunlap@oracle.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     9p: disallow RDMA if RDMA CM isn't available
has been removed from the -mm tree.  Its filename was
     9p-disallow-rdma-if-rdma-cm-isnt-available.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 9p: disallow RDMA if RDMA CM isn't available
From: Roland Dreier <rdreier@cisco.com>

If INET=y and INFINIBAND=y, but IPV6=m then INFINIBAND_ADDR_TRANS is set
to n and the RDMA CM functions rdma_connect() et al are not built. 
However, the current config dependencies allow NET_9P_RDMA to be selected
in this, which leads to a build failure.  Fix this by adding a dependency
on INFINIBAND_ADDR_TRANS to disallow NET_9P_RDMA in this case.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/9p/Kconfig~9p-disallow-rdma-if-rdma-cm-isnt-available net/9p/Kconfig
--- a/net/9p/Kconfig~9p-disallow-rdma-if-rdma-cm-isnt-available
+++ a/net/9p/Kconfig
@@ -23,7 +23,7 @@ config NET_9P_VIRTIO
 	  guest partitions and a host partition.
 
 config NET_9P_RDMA
-	depends on INET && INFINIBAND && EXPERIMENTAL
+	depends on INET && INFINIBAND && INFINIBAND_ADDR_TRANS && EXPERIMENTAL
 	tristate "9P RDMA Transport (Experimental)"
 	help
 	  This builds support for an RDMA transport.
_

Patches currently in -mm which might be from rdreier@cisco.com are

origin.patch

