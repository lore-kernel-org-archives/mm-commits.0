From: akpm@linux-foundation.org
Subject: + 9p-disallow-rdma-if-rdma-cm-isnt-available.patch added to -mm tree
Date: Wed, 14 Jan 2009 14:43:44 -0800
Message-ID: <200901142243.n0EMhimo016740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbZANWoV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 17:44:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, randy.dunlap@oracle.com, rolandd@cisco.com


The patch titled
     9p: disallow RDMA if RDMA CM isn't available
has been added to the -mm tree.  Its filename is
     9p-disallow-rdma-if-rdma-cm-isnt-available.patch

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

9p-disallow-rdma-if-rdma-cm-isnt-available.patch

