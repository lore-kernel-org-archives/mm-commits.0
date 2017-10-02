From: akpm@linux-foundation.org
Subject: + asm-generic-numa-remove-the-unused-parent_node-macro.patch
 added to -mm tree
Date: Mon, 02 Oct 2017 16:45:16 -0700
Message-ID: <59d2cf8c.fWsV4JfwX9g1wz+x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbdJBXpR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 19:45:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: douly.fnst@cn.fujitsu.com, arnd@arndb.de, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: include/asm-generic/topology.h: remove unused parent_node() macro
has been added to the -mm tree.  Its filename is
     asm-generic-numa-remove-the-unused-parent_node-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-generic-numa-remove-the-unused-parent_node-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-generic-numa-remove-the-unused-parent_node-macro.patch

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
Subject: include/asm-generic/topology.h: remove unused parent_node() macro

a7be6e5a7f8d ("mm: drop useless local parameters of
__register_one_node()") removes the last user of parent_node().

The parent_node() macro in generic situation is unnecessary.

Remove it for cleanup.

Link: http://lkml.kernel.org/r/1504234599-29533-8-git-send-email-douly.fnst@cn.fujitsu.com
Signed-off-by: Dou Liyang <douly.fnst@cn.fujitsu.com>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/topology.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/asm-generic/topology.h~asm-generic-numa-remove-the-unused-parent_node-macro include/asm-generic/topology.h
--- a/include/asm-generic/topology.h~asm-generic-numa-remove-the-unused-parent_node-macro
+++ a/include/asm-generic/topology.h
@@ -44,9 +44,6 @@
 #define cpu_to_mem(cpu)		((void)(cpu),0)
 #endif
 
-#ifndef parent_node
-#define parent_node(node)	((void)(node),0)
-#endif
 #ifndef cpumask_of_node
   #ifdef CONFIG_NEED_MULTIPLE_NODES
     #define cpumask_of_node(node)	((node) == 0 ? cpu_online_mask : cpu_none_mask)
_

Patches currently in -mm which might be from douly.fnst@cn.fujitsu.com are

ia64-topology-remove-the-unused-parent_node-macro.patch
sh-numa-remove-the-unused-parent_node-macro.patch
sparc64-topology-remove-the-unused-parent_node-macro.patch
tile-topology-remove-the-unused-parent_node-macro.patch
asm-generic-numa-remove-the-unused-parent_node-macro.patch

