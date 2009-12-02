From: akpm@linux-foundation.org
Subject: + include-linux-mmh-remove-unneeded-ifdef.patch added to -mm tree
Date: Wed, 02 Dec 2009 12:59:50 -0800
Message-ID: <200912022059.nB2Kxokv031332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753976AbZLBU7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 15:59:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com


The patch titled
     include/linux/mm.h: remove unneeded ifdef
has been added to the -mm tree.  Its filename is
     include-linux-mmh-remove-unneeded-ifdef.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/mm.h: remove unneeded ifdef
From: Huang Shijie <shijie8@gmail.com>

The check code for CONFIG_SWAP is redundant, because there is a
non-CONFIG_SWAP version for PageSwapCache() which just returns 0.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/mm.h~include-linux-mmh-remove-unneeded-ifdef include/linux/mm.h
--- a/include/linux/mm.h~include-linux-mmh-remove-unneeded-ifdef
+++ a/include/linux/mm.h
@@ -643,12 +643,9 @@ static inline struct address_space *page
 	struct address_space *mapping = page->mapping;
 
 	VM_BUG_ON(PageSlab(page));
-#ifdef CONFIG_SWAP
 	if (unlikely(PageSwapCache(page)))
 		mapping = &swapper_space;
-	else
-#endif
-	if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
+	else if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
 		mapping = NULL;
 	return mapping;
 }
_

Patches currently in -mm which might be from shijie8@gmail.com are

rmap-fix-the-comment-for-try_to_unmap_anon.patch
rmap-simplify-try_to_unmap_file.patch
rmap-move-the-out-to-a-more-proper-place.patch
vmscan-simplify-code.patch
include-linux-mmh-remove-unneeded-ifdef.patch

