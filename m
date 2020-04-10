From: akpm@linux-foundation.org
Subject: [folded-merged] mm-cma-numa-node-interface-fix.patch
 removed from -mm tree
Date: Fri, 10 Apr 2020 14:12:30 -0700
Message-ID: <20200410211230.BE9E2SCMS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVMa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreas.schaufler@gmx.de, aslan@fb.com, guro@fb.com, js1304@gmail.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm-cma-numa-node-interface-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-numa-node-interface-fix.patch

This patch was dropped because it was folded into mm-cma-numa-node-interface.patch

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

mm-cma-numa-node-interface.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
