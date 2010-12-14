From: akpm@linux-foundation.org
Subject: + mm-migratec-fix-compilation-error.patch added to -mm tree
Date: Mon, 13 Dec 2010 16:07:29 -0800
Message-ID: <201012140007.oBE07TYm020364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab0LNAHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Dec 2010 19:07:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.nazarewicz@samsung.com, kyungmin.park@samsung.com


The patch titled
     mm/migrate.c: fix compilation error
has been added to the -mm tree.  Its filename is
     mm-migratec-fix-compilation-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mm-migratec-fix-compilation-error.patch

