From: akpm@linux-foundation.org
Subject: [patch 001/119] metag/numa: remove the unused
 parent_node() macro
Date: Wed, 06 Sep 2017 16:18:32 -0700
Message-ID: <20170906231832.KWUJ1SG85%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48880 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbdIFXSd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:18:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, douly.fnst@cn.fujitsu.com, james.hogan@imgtec.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, torvalds@linux-foundation.org

From: Dou Liyang <douly.fnst@cn.fujitsu.com>
Subject: metag/numa: remove the unused parent_node() macro

Commit a7be6e5a7f8d ("mm: drop useless local parameters of
__register_one_node()") removes the last user of parent_node().

The parent_node() macro in METAG architecture is unnecessary.

Remove it for cleanup.

Link: http://lkml.kernel.org/r/1501076076-1974-4-git-send-email-douly.fnst@cn.fujitsu.com
Signed-off-by: Dou Liyang <douly.fnst@cn.fujitsu.com>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/include/asm/topology.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/metag/include/asm/topology.h~metag-numa-remove-the-unused-parent_node-macro arch/metag/include/asm/topology.h
--- a/arch/metag/include/asm/topology.h~metag-numa-remove-the-unused-parent_node-macro
+++ a/arch/metag/include/asm/topology.h
@@ -4,7 +4,6 @@
 #ifdef CONFIG_NUMA
 
 #define cpu_to_node(cpu)	((void)(cpu), 0)
-#define parent_node(node)	((void)(node), 0)
 
 #define cpumask_of_node(node)	((void)node, cpu_online_mask)
 
_
