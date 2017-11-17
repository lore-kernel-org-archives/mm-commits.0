From: akpm@linux-foundation.org
Subject: [patch 91/94] arch/sparc/include/asm/topology_64.h: remove
 unused parent_node() macro
Date: Fri, 17 Nov 2017 15:31:36 -0800
Message-ID: <20171117233136.HMtBUdHlt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966169AbdKQXbi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:31:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, douly.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, torvalds@linux-foundation.org

From: Dou Liyang <douly.fnst@cn.fujitsu.com>
Subject: arch/sparc/include/asm/topology_64.h: remove unused parent_node() macro

a7be6e5a7f8d ("mm: drop useless local parameters of
__register_one_node()") removes the last user of parent_node().

The parent_node() macro in SPARC64 platform is unnecessary.

Remove it for cleanup.

Link: http://lkml.kernel.org/r/1504234599-29533-6-git-send-email-douly.fnst@cn.fujitsu.com
Signed-off-by: Dou Liyang <douly.fnst@cn.fujitsu.com>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/topology_64.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/sparc/include/asm/topology_64.h~sparc64-topology-remove-the-unused-parent_node-macro arch/sparc/include/asm/topology_64.h
--- a/arch/sparc/include/asm/topology_64.h~sparc64-topology-remove-the-unused-parent_node-macro
+++ a/arch/sparc/include/asm/topology_64.h
@@ -11,8 +11,6 @@ static inline int cpu_to_node(int cpu)
 	return numa_cpu_lookup_table[cpu];
 }
 
-#define parent_node(node)	(node)
