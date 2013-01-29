From: akpm@linux-foundation.org
Subject: + swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix.patch added to -mm tree
Date: Mon, 28 Jan 2013 16:49:08 -0800
Message-ID: <20130129004908.BD15531C1F2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:44337 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3A2AtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 19:49:10 -0500
Received: by mail-ia0-f202.google.com with SMTP id p22so634504iad.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 16:49:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shli@kernel.org, fengguang.wu@intel.com, sfr@canb.auug.org.au, shli@fusionio.com


The patch titled
     Subject: swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix
has been added to the -mm tree.  Its filename is
     swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix.patch

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
diff -puN mm/nommu.c~swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix mm/nommu.c
_

Patches currently in -mm which might be from shli@kernel.org are

linux-next.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
swap-make-each-swap-partition-have-one-address_space-fix-fix.patch
swap-add-per-partition-lock-for-swapfile.patch
swap-add-per-partition-lock-for-swapfile-fix-fix.patch
swap-add-per-partition-lock-for-swapfile-fix-for-nommu.patch
swap-add-per-partition-lock-for-swapfile-fix-fix-fix.patch
swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix.patch
smp-make-smp_call_function_many-use-logic-similar-to-smp_call_function_single.patch
kernel-smpc-cleanups.patch

