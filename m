From: akpm@linux-foundation.org
Subject: [merged] mm-fix-sparsemem-configuration.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:51:59 -0700
Message-ID: <200910302052.n9UKpx51014198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932650AbZJ3Uwr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:52:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+lkml@arm.linux.org.uk, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mm: fix sparsemem configuration
has been removed from the -mm tree.  Its filename was
     mm-fix-sparsemem-configuration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix sparsemem configuration
From: Russell King <rmk+lkml@arm.linux.org.uk>

Currently, sparsemem is only available if EXPERIMENTAL is enabled. 
However, it hasn't ever been marked experimental.

It's been about four years since sparsemem was merged, and we have
platforms which depend on it; allow architectures to decide whether
sparsemem should be the default memory model.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/Kconfig~mm-fix-sparsemem-configuration mm/Kconfig
--- a/mm/Kconfig~mm-fix-sparsemem-configuration
+++ a/mm/Kconfig
@@ -67,7 +67,7 @@ config DISCONTIGMEM
 
 config SPARSEMEM
 	def_bool y
-	depends on SPARSEMEM_MANUAL
+	depends on (!SELECT_MEMORY_MODEL && ARCH_SPARSEMEM_ENABLE) || SPARSEMEM_MANUAL
 
 config FLATMEM
 	def_bool y
_

Patches currently in -mm which might be from rmk+lkml@arm.linux.org.uk are

origin.patch

