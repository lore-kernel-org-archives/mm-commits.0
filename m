From: akpm@linux-foundation.org
Subject: [merged] intel_th-use-set_memoryh-header.patch removed
 from -mm tree
Date: Tue, 09 May 2017 11:03:18 -0700
Message-ID: <20170509180318.aX1xjFFLP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34844 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754195AbdEISDT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:03:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.shishkin@linux.intel.com, labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/hwtracing/intel_th/msu.c: use set_memory.h header
has been removed from the -mm tree.  Its filename was
     intel_th-use-set_memoryh-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: drivers/hwtracing/intel_th/msu.c: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-9-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwtracing/intel_th/msu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/hwtracing/intel_th/msu.c~intel_th-use-set_memoryh-header drivers/hwtracing/intel_th/msu.c
--- a/drivers/hwtracing/intel_th/msu.c~intel_th-use-set_memoryh-header
+++ a/drivers/hwtracing/intel_th/msu.c
@@ -27,7 +27,9 @@
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/cacheflush.h>
+#ifdef CONFIG_X86
+#include <asm/set_memory.h>
+#endif
 
 #include "intel_th.h"
 #include "msu.h"
_

Patches currently in -mm which might be from labbott@redhat.com are


