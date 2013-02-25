From: akpm@linux-foundation.org
Subject: [merged] mm-remove-unused-memclear_highpage_flush.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:52:30 -0800
Message-ID: <20130225205230.A7D225A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:59854 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759745Ab3BYUwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:52:31 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so142070yen.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:52:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unused memclear_highpage_flush()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-memclear_highpage_flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: remove unused memclear_highpage_flush()

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/linux/highmem.h~mm-remove-unused-memclear_highpage_flush include/linux/highmem.h
--- a/include/linux/highmem.h~mm-remove-unused-memclear_highpage_flush
+++ a/include/linux/highmem.h
@@ -219,12 +219,6 @@ static inline void zero_user(struct page
 	zero_user_segments(page, start, start + size, 0, 0);
 }
 
-static inline void __deprecated memclear_highpage_flush(struct page *page,
-			unsigned int offset, unsigned int size)
-{
-	zero_user(page, offset, size);
-}
