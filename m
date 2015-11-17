From: akpm@linux-foundation.org
Subject: + mm-lru-remove-unused-is_unevictable_lru-function.patch added to -mm tree
Date: Tue, 17 Nov 2015 15:58:34 -0800
Message-ID: <564bbf2a.epm/L0FMQuHV0s+5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbbKQX6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 18:58:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, hillf.zj@alibaba-inc.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: remove unused is_unevictable_lru()
has been added to the -mm tree.  Its filename is
     mm-lru-remove-unused-is_unevictable_lru-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-lru-remove-unused-is_unevictable_lru-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-lru-remove-unused-is_unevictable_lru-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
