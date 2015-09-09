From: akpm@linux-foundation.org
Subject: [merged] mm-rip-put_page_unless_one-as-it-has-no-callers.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:43:47 -0700
Message-ID: <55f08bf3.asU8GFQSQkhaERQ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbbIITnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vineet.Gupta1@synopsys.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove put_page_unless_one()
has been removed from the -mm tree.  Its filename was
     mm-rip-put_page_unless_one-as-it-has-no-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: mm: remove put_page_unless_one()

It has no callers.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN include/linux/mm.h~mm-rip-put_page_unless_one-as-it-has-no-callers include/linux/mm.h
--- a/include/linux/mm.h~mm-rip-put_page_unless_one-as-it-has-no-callers
+++ a/include/linux/mm.h
@@ -361,18 +361,6 @@ static inline int get_page_unless_zero(s
 	return atomic_inc_not_zero(&page->_count);
 }
 
-/*
- * Try to drop a ref unless the page has a refcount of one, return false if
- * that is the case.
- * This is to make sure that the refcount won't become zero after this drop.
- * This can be called when MMU is off so it must not access
- * any of the virtual mappings.
- */
-static inline int put_page_unless_one(struct page *page)
-{
-	return atomic_add_unless(&page->_count, -1, 1);
-}
