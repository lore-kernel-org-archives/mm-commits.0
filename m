From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cpumask-guard-cpumask_of_node-macro-argument.patch
 added to -mm tree
Date: Wed, 27 May 2020 14:55:12 -0700
Message-ID: <20200527215512.xXS2bRaX-%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgE0VzN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 17:55:13 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: include/asm-generic/topology.h: guard cpumask_of_node() macro argument
has been added to the -mm tree.  Its filename is
     cpumask-guard-cpumask_of_node-macro-argument.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpumask-guard-cpumask_of_node-macro-argument.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpumask-guard-cpumask_of_node-macro-argument.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: include/asm-generic/topology.h: guard cpumask_of_node() macro argument

drivers/hwmon/amd_energy.c:195:15: error: invalid operands to binary expression ('void' and 'int')
                                        (channel - data->nr_cpus));
                                        ~~~~~~~~~^~~~~~~~~~~~~~~~~
include/asm-generic/topology.h:51:42: note: expanded from macro 'cpumask_of_node'
    #define cpumask_of_node(node)       ((void)node, cpu_online_mask)
                                               ^~~~
include/linux/cpumask.h:618:72: note: expanded from macro 'cpumask_first_and'
 #define cpumask_first_and(src1p, src2p) cpumask_next_and(-1, (src1p), (src2p))
                                                                       ^~~~~

Link: http://lkml.kernel.org/r/20200527134623.930247-1-arnd@arndb.de
Fixes: f0b848ce6fe9 ("cpumask: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask")
Fixes: 8abee9566b7e ("hwmon: Add amd_energy driver to report energy counters")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/topology.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/topology.h~cpumask-guard-cpumask_of_node-macro-argument
+++ a/include/asm-generic/topology.h
@@ -48,7 +48,7 @@
   #ifdef CONFIG_NEED_MULTIPLE_NODES
     #define cpumask_of_node(node)	((node) == 0 ? cpu_online_mask : cpu_none_mask)
   #else
-    #define cpumask_of_node(node)	((void)node, cpu_online_mask)
+    #define cpumask_of_node(node)	((void)(node), cpu_online_mask)
   #endif
 #endif
 #ifndef pcibus_to_node
_

Patches currently in -mm which might be from arnd@arndb.de are

cpumask-guard-cpumask_of_node-macro-argument.patch
drm-remove-drm-specific-kmap_atomic-code-fix.patch
bitops-avoid-clang-shift-count-overflow-warnings.patch
ubsan-fix-gcc-10-warnings.patch
arm64-add-support-for-folded-p4d-page-tables-fix.patch
