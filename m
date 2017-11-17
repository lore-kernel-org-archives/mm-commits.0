From: akpm@linux-foundation.org
Subject: [patch 90/94] arch/sh/include/asm/topology.h: remove
 unused parent_node() macro
Date: Fri, 17 Nov 2017 15:31:33 -0800
Message-ID: <20171117233133.-TAGjZPrB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966979AbdKQXbe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:31:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dalias@libc.org, douly.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, torvalds@linux-foundation.org, ysato@users.sourceforge.jp

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
