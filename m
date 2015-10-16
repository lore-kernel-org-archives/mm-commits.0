From: akpm@linux-foundation.org
Subject: + mm-use-unsigned-int-for-page-order-fix-2.patch added to -mm
 tree
Date: Fri, 16 Oct 2015 16:01:18 -0700
Message-ID: <562181be.2QNDBGcRaJcmGAYl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbbJPXBS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 19:01:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use unsigned int for page order fix 2
has been added to the -mm tree.  Its filename is
     mm-use-unsigned-int-for-page-order-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-unsigned-int-for-page-order-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-unsigned-int-for-page-order-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: use unsigned int for page order fix 2

Some configs now end up with MAX_ORDER and pageblock_order having
different types: silence compiler warning in __free_one_page().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-use-unsigned-int-for-page-order-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-unsigned-int-for-page-order-fix-2
+++ a/mm/page_alloc.c
@@ -675,7 +675,7 @@ static inline void __free_one_page(struc
 		 * pageblock. Without this, pageblock isolation
 		 * could cause incorrect freepage accounting.
 		 */
-		max_order = min(MAX_ORDER, pageblock_order + 1);
+		max_order = min_t(unsigned int, MAX_ORDER, pageblock_order + 1);
 	} else {
 		__mod_zone_freepage_state(zone, 1 << order, migratetype);
 	}
_

Patches currently in -mm which might be from hughd@google.com are

memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
mm-use-unsigned-int-for-page-order-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch

