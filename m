From: akpm@linux-foundation.org
Subject: +
 mm-memory-remove-unnecessary-pte_devmap-case-in-copy_one_pte.patch added to
 -mm tree
Date: Mon, 20 Apr 2020 15:08:59 -0700
Message-ID: <20200420220859.PxsjGUVAk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgDTWJA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 18:09:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenqiwu@xiaomi.com, mhocko@suse.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm/memory: remove unnecessary pte_devmap case in copy_one_pte()
has been added to the -mm tree.  Its filename is
     mm-memory-remove-unnecessary-pte_devmap-case-in-copy_one_pte.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-remove-unnecessary-pte_devmap-case-in-copy_one_pte.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-remove-unnecessary-pte_devmap-case-in-copy_one_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: chenqiwu <chenqiwu@xiaomi.com>
Subject: mm/memory: remove unnecessary pte_devmap case in copy_one_pte()

Since commit 25b2995a35b6 ("mm: remove MEMORY_DEVICE_PUBLIC support"), the
assignment to 'page' for pte_devmap case has been unnecessary.  Let's
remove it.

[willy@infradead.org: changelog]
Link: http://lkml.kernel.org/r/1587349685-31712-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memory.c~mm-memory-remove-unnecessary-pte_devmap-case-in-copy_one_pte
+++ a/mm/memory.c
@@ -802,8 +802,6 @@ copy_one_pte(struct mm_struct *dst_mm, s
 		get_page(page);
 		page_dup_rmap(page, false);
 		rss[mm_counter(page)]++;
-	} else if (pte_devmap(pte)) {
-		page = pte_page(pte);
 	}
 
 out_set_pte:
_

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-swapfile-use-list_prevnext_entry-instead-of-open-coding.patch
mm-memory-remove-unnecessary-pte_devmap-case-in-copy_one_pte.patch
mm-replace-zero-length-array-with-flexible-array-member.patch
