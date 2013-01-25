From: akpm@linux-foundation.org
Subject: + swap-add-per-partition-lock-for-swapfile-fix-for-nommu.patch added to -mm tree
Date: Fri, 25 Jan 2013 14:35:04 -0800
Message-ID: <20130125223506.0ACC531C00F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:48555 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3AYWfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 17:35:08 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so41626vea.0
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 14:35:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, shli@kernel.org


The patch titled
     Subject: swap: fix "add per-partition lock for swapfile" for nommu
has been added to the -mm tree.  Its filename is
     swap-add-per-partition-lock-for-swapfile-fix-for-nommu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1906,7 +1906,7 @@ int __vm_enough_memory(struct mm_struct 
 		 */
 		free -= global_page_state(NR_SHMEM);
 
-		free += nr_swap_pages;
+		free += get_nr_swap_pages();
 
 		/*
 		 * Any slabs which are created with the
_

Patches currently in -mm which might be from arnd@arndb.de are

linux-next.patch
swap-add-per-partition-lock-for-swapfile-fix-for-nommu.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch

