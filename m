From: akpm@linux-foundation.org
Subject: + tile-topology-remove-the-unused-parent_node-macro.patch added
 to -mm tree
Date: Mon, 02 Oct 2017 16:45:13 -0700
Message-ID: <59d2cf89.Mu6fkwj7aUgcoTFI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48468 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdJBXpO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 19:45:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: douly.fnst@cn.fujitsu.com, cmetcalf@mellanox.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/tile/include/asm/topology.h: remove unused parent_node() macro
has been added to the -mm tree.  Its filename is
     tile-topology-remove-the-unused-parent_node-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tile-topology-remove-the-unused-parent_node-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tile-topology-remove-the-unused-parent_node-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dou Liyang <douly.fnst@cn.fujitsu.com>
Subject: arch/tile/include/asm/topology.h: remove unused parent_node() macro

a7be6e5a7f8d ("mm: drop useless local parameters of
__register_one_node()") removes the last user of parent_node().

The parent_node() macro in tile platform is unnecessary.

Remove it for cleanup.

Link: http://lkml.kernel.org/r/1504234599-29533-7-git-send-email-douly.fnst@cn.fujitsu.com
Signed-off-by: Dou Liyang <douly.fnst@cn.fujitsu.com>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Chris Metcalf <cmetcalf@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/topology.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN arch/tile/include/asm/topology.h~tile-topology-remove-the-unused-parent_node-macro arch/tile/include/asm/topology.h
--- a/arch/tile/include/asm/topology.h~tile-topology-remove-the-unused-parent_node-macro
+++ a/arch/tile/include/asm/topology.h
@@ -29,12 +29,6 @@ static inline int cpu_to_node(int cpu)
 	return cpu_2_node[cpu];
 }
 
-/*
- * Returns the number of the node containing Node 'node'.
- * This architecture is flat, so it is a pretty simple function!
- */
-#define parent_node(node) (node)
