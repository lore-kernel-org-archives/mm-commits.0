From: akpm@linux-foundation.org
Subject: [merged] sh-numa-remove-the-unused-parent_node-macro.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:27:06 -0800
Message-ID: <20171120212706.aMe4-jzcf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752896AbdKTV1H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:27:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, douly.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, ysato@users.sourceforge.jp


The patch titled
     Subject: arch/sh/include/asm/topology.h: remove unused parent_node() macro
has been removed from the -mm tree.  Its filename was
     sh-numa-remove-the-unused-parent_node-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dou Liyang <douly.fnst@cn.fujitsu.com>
Subject: arch/sh/include/asm/topology.h: remove unused parent_node() macro

a7be6e5a7f8d ("mm: drop useless local parameters of
__register_one_node()") removes the last user of parent_node().

The parent_node() macro in SUPERH platform is unnecessary.

Remove it for cleanup.

Link: http://lkml.kernel.org/r/1504234599-29533-5-git-send-email-douly.fnst@cn.fujitsu.com
Signed-off-by: Dou Liyang <douly.fnst@cn.fujitsu.com>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/topology.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/sh/include/asm/topology.h~sh-numa-remove-the-unused-parent_node-macro arch/sh/include/asm/topology.h
--- a/arch/sh/include/asm/topology.h~sh-numa-remove-the-unused-parent_node-macro
+++ a/arch/sh/include/asm/topology.h
@@ -5,7 +5,6 @@
 #ifdef CONFIG_NUMA
 
 #define cpu_to_node(cpu)	((void)(cpu),0)
-#define parent_node(node)	((void)(node),0)
 
 #define cpumask_of_node(node)	((void)node, cpu_online_mask)
 
_

Patches currently in -mm which might be from douly.fnst@cn.fujitsu.com are


