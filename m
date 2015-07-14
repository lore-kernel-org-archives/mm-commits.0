From: akpm@linux-foundation.org
Subject: +
 mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void.patch added to -mm tree
Date: Tue, 14 Jul 2015 15:34:04 -0700
Message-ID: <55a58e5c.d0h3sBlC5XXykjJM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbbGNWeF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 18:34:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xerofoify@gmail.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make set_recommended_min_free_kbytes() return void
has been added to the -mm tree.  Its filename is
     mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Krause <xerofoify@gmail.com>
Subject: mm: make set_recommended_min_free_kbytes() return void

This makes set_recommended_min_free_kbytes() have a return type of void as
it cannot fail.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void
+++ a/mm/huge_memory.c
@@ -105,7 +105,7 @@ static struct khugepaged_scan khugepaged
 };
 
 
-static int set_recommended_min_free_kbytes(void)
+static void set_recommended_min_free_kbytes(void)
 {
 	struct zone *zone;
 	int nr_zones = 0;
@@ -140,7 +140,6 @@ static int set_recommended_min_free_kbyt
 		min_free_kbytes = recommended_min;
 	}
 	setup_per_zone_wmarks();
-	return 0;
 }
 
 static int start_stop_khugepaged(void)
_

Patches currently in -mm which might be from xerofoify@gmail.com are

hugetlb-make-the-function-vma_shareable-bool.patch
mm-change-function-return-from-int-to-bool-for-the-function-is_page_busy.patch
memory-make-the-function-tlb_next_batch-bool-now.patch
mm-make-the-function-madvise_behaviour_valid-bool.patch
mm-make-the-function-vma_has_reserves-bool.patch
mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void.patch
linux-next.patch

