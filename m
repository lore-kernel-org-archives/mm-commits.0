From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-numa-node-interface-fix.patch added to -mm tree
Date: Wed, 08 Apr 2020 21:39:43 -0700
Message-ID: <20200409043943.vwo4xw79H%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725271AbgDIEjo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Apr 2020 00:39:44 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreas.schaufler@gmx.de, aslan@fb.com, guro@fb.com, js1304@gmail.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm-cma-numa-node-interface-fix
has been added to the -mm tree.  Its filename is
     mm-cma-numa-node-interface-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-numa-node-interface-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-numa-node-interface-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-numa-node-interface-fix

./include/linux/cma.h: In function cma_declare_contiguous:
./include/linux/cma.h:38:41: error: NUMA_NO_NODE undeclared (first use in this function)
    order_per_bit, fixed, name, res_cma, NUMA_NO_NODE);
                                         ^~~~~~~~~~~~

Cc: Aslan Bakirov <aslan@fb.com>
Cc: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@kernel.org>
Cc: Andreas Schaufler <andreas.schaufler@gmx.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/cma.h~mm-cma-numa-node-interface-fix
+++ a/include/linux/cma.h
@@ -4,6 +4,7 @@
 
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/numa.h>
 
 /*
  * There is always at least global CMA area and a few optional
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-clarify-__gfp_memalloc-usage-update-checkpatch-fixes.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mm-cma-numa-node-interface-fix.patch
