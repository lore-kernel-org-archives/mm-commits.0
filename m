From: akpm@linux-foundation.org
Subject: [patch 041/162] mm: thp: microoptimize compound_mapcount()
Date: Fri, 20 May 2016 16:58:24 -0700
Message-ID: <573fa4a0.AkgHKP33n0s0UKit%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbcETX6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, alex.williamson@redhat.com, kirill.shutemov@linux.intel.com

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: thp: microoptimize compound_mapcount()

compound_mapcount() is only called after PageCompound() has already been
checked by the caller, so there's no point to check it again.  Gcc may
optimize it away too because it's inline but this will remove the runtime
check for sure and add it'll add an assert instead.

Link: http://lkml.kernel.org/r/1462547040-1737-3-git-send-email-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-thp-microoptimize-compound_mapcount include/linux/mm.h
--- a/include/linux/mm.h~mm-thp-microoptimize-compound_mapcount
+++ a/include/linux/mm.h
@@ -475,8 +475,7 @@ static inline atomic_t *compound_mapcoun
 
 static inline int compound_mapcount(struct page *page)
 {
-	if (!PageCompound(page))
-		return 0;
+	VM_BUG_ON_PAGE(!PageCompound(page), page);
 	page = compound_head(page);
 	return atomic_read(compound_mapcount_ptr(page)) + 1;
 }
_
