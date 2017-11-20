From: akpm@linux-foundation.org
Subject: [merged]
 ia64-topology-remove-the-unused-parent_node-macro.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:27:03 -0800
Message-ID: <20171120212703.KFljwEdrn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41020 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752868AbdKTV1E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:27:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: douly.fnst@cn.fujitsu.com, fenghua.yu@intel.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, tony.luck@intel.com


The patch titled
     Subject: arch/ia64/include/asm/topology.h: remove unused parent_node() macro
has been removed from the -mm tree.  Its filename was
     ia64-topology-remove-the-unused-parent_node-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dou Liyang <douly.fnst@cn.fujitsu.com>
Subject: arch/ia64/include/asm/topology.h: remove unused parent_node() macro

a7be6e5a7f8d ("mm: drop useless local parameters of
__register_one_node()") removes the last user of parent_node().

The parent_node() macro in IA64(Itanium) platform is unnecessary.

Remove it for cleanup.

Link: http://lkml.kernel.org/r/1504234599-29533-2-git-send-email-douly.fnst@cn.fujitsu.com
Signed-off-by: Dou Liyang <douly.fnst@cn.fujitsu.com>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/topology.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN arch/ia64/include/asm/topology.h~ia64-topology-remove-the-unused-parent_node-macro arch/ia64/include/asm/topology.h
--- a/arch/ia64/include/asm/topology.h~ia64-topology-remove-the-unused-parent_node-macro
+++ a/arch/ia64/include/asm/topology.h
@@ -34,13 +34,6 @@
 			       &node_to_cpu_mask[node])
 
 /*
- * Returns the number of the node containing Node 'nid'.
- * Not implemented here. Multi-level hierarchies detected with
- * the help of node_distance().
- */
-#define parent_node(nid) (nid)
