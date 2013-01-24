From: akpm@linux-foundation.org
Subject: + swap-add-per-partition-lock-for-swapfile-fix-fix.patch added to -mm tree
Date: Thu, 24 Jan 2013 15:26:35 -0800
Message-ID: <20130124232635.8CF9031C559@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:48602 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3AXX0g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jan 2013 18:26:36 -0500
Received: by mail-vb0-f73.google.com with SMTP id fs19so407235vbb.2
        for <mm-commits@vger.kernel.org>; Thu, 24 Jan 2013 15:26:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shli@kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: swap-add-per-partition-lock-for-swapfile-fix-fix
has been added to the -mm tree.  Its filename is
     swap-add-per-partition-lock-for-swapfile-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
swap-add-per-partition-lock-for-swapfile.patch
swap-add-per-partition-lock-for-swapfile-fix-fix.patch
smp-make-smp_call_function_many-use-logic-similar-to-smp_call_function_single.patch
kernel-smpc-cleanups.patch

