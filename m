From: akpm@linux-foundation.org
Subject: + mm-thp-microoptimize-compound_mapcount.patch added to -mm tree
Date: Fri, 06 May 2016 15:25:09 -0700
Message-ID: <572d19c5.hWCagBG9ua/u249m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929AbcEFWZK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 18:25:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alex.williamson@redhat.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: microoptimize compound_mapcount()
has been added to the -mm tree.  Its filename is
     mm-thp-microoptimize-compound_mapcount.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-microoptimize-compound_mapcount.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-microoptimize-compound_mapcount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: thp: microoptimize compound_mapcount()

compound_mapcount() is only called after PageCompound() has already been
checked by the caller, so there's no point to check it again.  Gcc may
optimize it away too because it's inline but this will remove the runtime
check for sure and add it'll add an assert instead.

Link: http://lkml.kernel.org/r/1462547040-1737-3-git-send-email-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-thp-microoptimize-compound_mapcount include/linux/mm.h
--- a/include/linux/mm.h~mm-thp-microoptimize-compound_mapcount
+++ a/include/linux/mm.h
@@ -471,8 +471,7 @@ static inline atomic_t *compound_mapcoun
 
 static inline int compound_mapcount(struct page *page)
 {
-	if (!PageCompound(page))
-		return 0;
+	VM_BUG_ON_PAGE(!PageCompound(page), page);
 	page = compound_head(page);
 	return atomic_read(compound_mapcount_ptr(page)) + 1;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-thp-calculate-the-mapcount-correctly-for-thp-pages-during-wp-faults.patch
mm-thp-microoptimize-compound_mapcount.patch

