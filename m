From: akpm@linux-foundation.org
Subject: [patch 92/94] arch/tile/include/asm/topology.h: remove
 unused parent_node() macro
Date: Fri, 17 Nov 2017 15:31:40 -0800
Message-ID: <20171117233140.D8Yu72pNB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56244 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966169AbdKQXbl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:31:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cmetcalf@mellanox.com, douly.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, torvalds@linux-foundation.org

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
