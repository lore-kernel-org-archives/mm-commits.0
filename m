From: akpm@linux-foundation.org
Subject: [merged] mm-lru-remove-unused-is_unevictable_lru-function.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:32:54 -0800
Message-ID: <56997396.usrenoQZi+ZvAwtd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbcAOWcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, hillf.zj@alibaba-inc.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: remove unused is_unevictable_lru()
has been removed from the -mm tree.  Its filename was
     mm-lru-remove-unused-is_unevictable_lru-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: include/linux/mmzone.h: remove unused is_unevictable_lru()

Since commit a0b8cab3 ("mm: remove lru parameter from __pagevec_lru_add
and remove parts of pagevec API") there's no user of this function anymore,
so remove it.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/mmzone.h~mm-lru-remove-unused-is_unevictable_lru-function include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-lru-remove-unused-is_unevictable_lru-function
+++ a/include/linux/mmzone.h
@@ -195,11 +195,6 @@ static inline int is_active_lru(enum lru
 	return (lru == LRU_ACTIVE_ANON || lru == LRU_ACTIVE_FILE);
 }
 
-static inline int is_unevictable_lru(enum lru_list lru)
-{
-	return (lru == LRU_UNEVICTABLE);
-}
