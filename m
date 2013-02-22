From: akpm@linux-foundation.org
Subject: [folded-merged] swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:49:24 -0800
Message-ID: <20130222234924.DD46D31C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:40744 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab3BVXt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:49:26 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so121137vbb.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:49:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@kernel.org, fengguang.wu@intel.com, sfr@canb.auug.org.au, shli@fusionio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix.patch

This patch was dropped because it was folded into swap-add-per-partition-lock-for-swapfile.patch

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix

Fix building errors like:
> arch/sparc/mm/init_32.c: In function 'show_mem':
> arch/sparc/mm/init_32.c:60:23: error: invalid operands to binary << (have 'atomic_long_t' and 'int')

Signed-off-by: Shaohua Li <shli@fusionio.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/tile/mm/pgtable.c~swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix arch/tile/mm/pgtable.c
--- a/arch/tile/mm/pgtable.c~swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix
+++ a/arch/tile/mm/pgtable.c
@@ -61,7 +61,7 @@ void show_mem(unsigned int filter)
 	       global_page_state(NR_PAGETABLE),
 	       global_page_state(NR_BOUNCE),
 	       global_page_state(NR_FILE_PAGES),
-	       nr_swap_pages);
+	       get_nr_swap_pages());
 
 	for_each_zone(zone) {
 		unsigned long flags, order, total = 0, largest_order = -1;
_

Patches currently in -mm which might be from shli@kernel.org are

origin.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-add-per-partition-lock-for-swapfile.patch
swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix-fix.patch

