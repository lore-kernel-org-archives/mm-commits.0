From: akpm@linux-foundation.org
Subject: [merged]
 asm-generic-numa-remove-the-unused-parent_node-macro.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:27:15 -0800
Message-ID: <20171120212715.0GjAFG81p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41060 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753014AbdKTV1S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:27:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, douly.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au


The patch titled
     Subject: include/asm-generic/topology.h: remove unused parent_node() macro
has been removed from the -mm tree.  Its filename was
     asm-generic-numa-remove-the-unused-parent_node-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


