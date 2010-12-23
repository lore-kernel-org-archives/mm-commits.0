From: akpm@linux-foundation.org
Subject: [merged] mm-migratec-fix-compilation-error.patch removed from -mm tree
Date: Thu, 23 Dec 2010 14:36:40 -0800
Message-ID: <201012232240.oBNMeR0X015454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658Ab0LWWkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 17:40:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.nazarewicz@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     mm/migrate.c: fix compilation error
has been removed from the -mm tree.  Its filename was
     mm-migratec-fix-compilation-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/migrate.c: fix compilation error
From: Michal Nazarewicz <m.nazarewicz@samsung.com>

GCC complained about update_mmu_cache() not being defined in migrate.c. 
Including <asm/tlbflush.h> seems to solve the problem.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/migrate.c~mm-migratec-fix-compilation-error mm/migrate.c
--- a/mm/migrate.c~mm-migratec-fix-compilation-error
+++ a/mm/migrate.c
@@ -35,6 +35,8 @@
 #include <linux/hugetlb.h>
 #include <linux/gfp.h>
 
+#include <asm/tlbflush.h>
+
 #include "internal.h"
 
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
_

Patches currently in -mm which might be from m.nazarewicz@samsung.com are

origin.patch
linux-next.patch

