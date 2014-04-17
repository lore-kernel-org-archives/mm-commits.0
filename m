From: akpm@linux-foundation.org
Subject: + hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
 added to -mm tree
Date: Thu, 17 Apr 2014 16:01:25 -0700
Message-ID: <53505d45.FwBBxtsD/t6ZX9pj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaDQXB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 19:01:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, rientjes@google.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mtosatti@redhat.com, kirill.shutemov@linux.intel.com, isimatu.yasuaki@jp.fujitsu.com, davidlohr@hp.com, aarcange@redhat.com, lcapitulino@redhat.com

Subject: + hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch added to -mm tree
To: lcapitulino@redhat.com,aarcange@redhat.com,davidlohr@hp.com,isimatu.yasuaki@jp.fujitsu.com,kirill.shutemov@linux.intel.com,mtosatti@redhat.com,n-horiguchi@ah.jp.nec.com,riel@redhat.com,rientjes@google.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 16:01:25 -0700


The patch titled
     Subject: hugetlb: update_and_free_page(): don't clear PG_reserved bit
has been added to the -mm tree.  Its filename is
     hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: hugetlb: update_and_free_page(): don't clear PG_reserved bit

Hugepages pages never get the PG_reserved bit set, so don't clear it.

However, note that if the bit gets mistakenly set free_pages_check() will
catch it.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-update_and_free_page-dont-clear-pg_reserved-bit mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-update_and_free_page-dont-clear-pg_reserved-bit
+++ a/mm/hugetlb.c
@@ -619,8 +619,8 @@ static void update_and_free_page(struct
 	for (i = 0; i < pages_per_huge_page(h); i++) {
 		page[i].flags &= ~(1 << PG_locked | 1 << PG_error |
 				1 << PG_referenced | 1 << PG_dirty |
-				1 << PG_active | 1 << PG_reserved |
-				1 << PG_private | 1 << PG_writeback);
+				1 << PG_active | 1 << PG_private |
+				1 << PG_writeback);
 	}
 	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
 	set_compound_page_dtor(page, NULL);
_

Patches currently in -mm which might be from lcapitulino@redhat.com are

hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch

