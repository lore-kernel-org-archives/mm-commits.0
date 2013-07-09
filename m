From: akpm@linux-foundation.org
Subject: [merged] mm-remove-unused-__put_page.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:59 -0700
Message-ID: <51dc9a9f.S6YJKpliNphke/Rp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3GIXT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-remove-unused-__put_page.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:59 -0700


The patch titled
     Subject: mm: remove unused __put_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-__put_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm: remove unused __put_page()

This function is nowhere used, and it has a confusing name with put_page
in mm/swap.c.  So better to remove it.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/internal.h~mm-remove-unused-__put_page mm/internal.h
--- a/mm/internal.h~mm-remove-unused-__put_page
+++ a/mm/internal.h
@@ -32,11 +32,6 @@ static inline void set_page_refcounted(s
 	set_page_count(page, 1);
 }
 
-static inline void __put_page(struct page *page)
-{
-	atomic_dec(&page->_count);
-}
