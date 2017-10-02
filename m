From: akpm@linux-foundation.org
Subject: + ia64-topology-remove-the-unused-parent_node-macro.patch added
 to -mm tree
Date: Mon, 02 Oct 2017 16:45:07 -0700
Message-ID: <59d2cf83.NlaS5XXv4tNk1+yH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48440 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbdJBXpI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 19:45:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: douly.fnst@cn.fujitsu.com, fenghua.yu@intel.com, mpe@ellerman.id.au, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/ia64/include/asm/topology.h: remove unused parent_node() macro
has been added to the -mm tree.  Its filename is
     ia64-topology-remove-the-unused-parent_node-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ia64-topology-remove-the-unused-parent_node-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ia64-topology-remove-the-unused-parent_node-macro.patch

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
