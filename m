From: akpm@linux-foundation.org
Subject: [merged] include-linux-highmemh-needs-hardirqh.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:04 -0800
Message-ID: <201011161933.oAGJXGkF003089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756309Ab0KPTdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     include/linux/highmem.h needs hardirq.h
has been removed from the -mm tree.  Its filename was
     include-linux-highmemh-needs-hardirqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/highmem.h needs hardirq.h
From: Catalin Marinas <catalin.marinas@arm.com>

Commit 3e4d3af ("mm: stack based kmap_atomic()") introduced the
kmap_atomic_idx_push() function which warns on in_irq() with
CONFIG_DEBUG_HIGHMEM enabled.  This patch includes linux/hardirq.h for the
in_irq definition.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/highmem.h~include-linux-highmemh-needs-hardirqh include/linux/highmem.h
--- a/include/linux/highmem.h~include-linux-highmemh-needs-hardirqh
+++ a/include/linux/highmem.h
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
+#include <linux/hardirq.h>
 
 #include <asm/cacheflush.h>
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

linux-next.patch

