From: akpm@linux-foundation.org
Subject: [merged] kpagecount-added-slab-page-checking-because-of-_mapcount-in-union.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:39 -0800
Message-ID: <201101132011.p0DKBKjK030165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933673Ab1AMUMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:12:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pholasek@redhat.com, fengguang.wu@intel.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     kpagecount: add slab page checking because _mapcount is in a union
has been removed from the -mm tree.  Its filename was
     kpagecount-added-slab-page-checking-because-of-_mapcount-in-union.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kpagecount: add slab page checking because _mapcount is in a union
From: Petr Holasek <pholasek@redhat.com>

Add a PageSlab() check before adding the _mapcount value to /kpagecount. 
page->_mapcount is in a union with the SLAB structure so for pages
controlled by SLAB, page_mapcount() returns nonsense.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/page.c~kpagecount-added-slab-page-checking-because-of-_mapcount-in-union fs/proc/page.c
--- a/fs/proc/page.c~kpagecount-added-slab-page-checking-because-of-_mapcount-in-union
+++ a/fs/proc/page.c
@@ -40,7 +40,7 @@ static ssize_t kpagecount_read(struct fi
 			ppage = pfn_to_page(pfn);
 		else
 			ppage = NULL;
-		if (!ppage)
+		if (!ppage || PageSlab(ppage))
 			pcount = 0;
 		else
 			pcount = page_mapcount(ppage);
_

Patches currently in -mm which might be from pholasek@redhat.com are

origin.patch

