From: akpm@linux-foundation.org
Subject: +
 mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4.patch
 added to -mm tree
Date: Thu, 05 Nov 2015 02:27:15 -0800
Message-ID: <563b2f03.I4MxYGGLcEfbGsBh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031093AbbKEK1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 05:27:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4
has been added to the -mm tree.  Its filename is
     mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/rmap.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4 mm/rmap.c
--- a/mm/rmap.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4
+++ a/mm/rmap.c
@@ -1168,7 +1168,6 @@ void do_page_add_anon_rmap(struct page *
 			atomic_inc(&page->_mapcount);
 		}
 	} else {
-		VM_BUG_ON_PAGE(compound, page);
 		first = atomic_inc_and_test(&page->_mapcount);
 	}
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

futex-thp-remove-special-case-for-thp-in-get_futex_key-fix.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4.patch
thp-reintroduce-split_huge_page-fix-2.patch

