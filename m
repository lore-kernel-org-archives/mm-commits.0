From: akpm@linux-foundation.org
Subject: + metag-numa-remove-the-unused-parent_node-macro.patch added to
 -mm tree
Date: Wed, 26 Jul 2017 14:42:01 -0700
Message-ID: <59790ca9.sZ960ZUjUp5dXuHB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37472 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbdGZVmB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 17:42:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: douly.fnst@cn.fujitsu.com, james.hogan@imgtec.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: metag/numa: remove the unused parent_node() macro
has been added to the -mm tree.  Its filename is
     metag-numa-remove-the-unused-parent_node-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/metag-numa-remove-the-unused-parent_node-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/metag-numa-remove-the-unused-parent_node-macro.patch

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

Patches currently in -mm which might be from douly.fnst@cn.fujitsu.com are

metag-numa-remove-the-unused-parent_node-macro.patch

