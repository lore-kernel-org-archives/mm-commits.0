From: akpm@linux-foundation.org
Subject: [folded-merged] swap-add-per-partition-lock-for-swapfile-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:49:15 -0800
Message-ID: <20130222234916.297915A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:46952 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab3BVXtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:49:17 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so121012ves.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:49:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: swap-add-per-partition-lock-for-swapfile-fix-fix
has been removed from the -mm tree.  Its filename was
     swap-add-per-partition-lock-for-swapfile-fix-fix.patch

This patch was dropped because it was folded into swap-add-per-partition-lock-for-swapfile.patch

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: swap-add-per-partition-lock-for-swapfile-fix-fix

> arch/sparc/mm/init_32.c: In function 'show_mem':
> arch/sparc/mm/init_32.c:60:23: error: invalid operands to binary << (have 'atomic_long_t' and 'int')
>

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sparc/mm/init_32.c~swap-add-per-partition-lock-for-swapfile-fix-fix arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~swap-add-per-partition-lock-for-swapfile-fix-fix
+++ a/arch/sparc/mm/init_32.c
@@ -57,7 +57,7 @@ void show_mem(unsigned int filter)
 	printk("Mem-info:\n");
 	show_free_areas(filter);
 	printk("Free swap:       %6ldkB\n",
-	       nr_swap_pages << (PAGE_SHIFT-10));
+	       get_nr_swap_pages() << (PAGE_SHIFT-10));
 	printk("%ld pages of RAM\n", totalram_pages);
 	printk("%ld free pages\n", nr_free_pages());
 }
_

Patches currently in -mm which might be from shli@kernel.org are

origin.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-add-per-partition-lock-for-swapfile.patch
swap-add-per-partition-lock-for-swapfile-fix-for-nommu.patch
swap-add-per-partition-lock-for-swapfile-fix-fix-fix.patch
swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix.patch
swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix-fix.patch

