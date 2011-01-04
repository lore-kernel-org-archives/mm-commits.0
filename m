From: akpm@linux-foundation.org
Subject: + kpagecount-added-slab-page-checking-because-of-_mapcount-in-union.patch added to -mm tree
Date: Tue, 04 Jan 2011 14:01:17 -0800
Message-ID: <201101042201.p04M1HbN026658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab1ADWCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 17:02:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pholasek@redhat.com, fengguang.wu@intel.com, mpm@selenic.com


The patch titled
     kpagecount: add slab page checking because _mapcount is in a union
has been added to the -mm tree.  Its filename is
     kpagecount-added-slab-page-checking-because-of-_mapcount-in-union.patch

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

kpagecount-added-slab-page-checking-because-of-_mapcount-in-union.patch

