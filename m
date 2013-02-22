From: akpm@linux-foundation.org
Subject: [folded-merged] swap-add-per-partition-lock-for-swapfile-fix-for-nommu.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:49:18 -0800
Message-ID: <20130222234918.DD7AE5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:50917 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab3BVXtT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:49:19 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so121127ggi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:49:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: swap: fix "add per-partition lock for swapfile" for nommu
has been removed from the -mm tree.  Its filename was
     swap-add-per-partition-lock-for-swapfile-fix-for-nommu.patch

This patch was dropped because it was folded into swap-add-per-partition-lock-for-swapfile.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: swap: fix "add per-partition lock for swapfile" for nommu

The patch "swap: add per-partition lock for swapfile" made the
nr_swap_pages variable unaccessible but forgot to change the
mm/nommu.c file that uses it. This does the trivial conversion
to let us build nommu kernels again

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/nommu.c~swap-add-per-partition-lock-for-swapfile-fix-for-nommu mm/nommu.c
--- a/mm/nommu.c~swap-add-per-partition-lock-for-swapfile-fix-for-nommu
+++ a/mm/nommu.c
@@ -1907,7 +1907,7 @@ int __vm_enough_memory(struct mm_struct 
 		 */
 		free -= global_page_state(NR_SHMEM);
 
-		free += nr_swap_pages;
+		free += get_nr_swap_pages();
 
 		/*
 		 * Any slabs which are created with the
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
swap-add-per-partition-lock-for-swapfile.patch

