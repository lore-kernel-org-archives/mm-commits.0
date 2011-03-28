From: akpm@linux-foundation.org
Subject: + mm-optimize-pfn-calculation-in-online_page.patch added to -mm tree
Date: Mon, 28 Mar 2011 15:21:27 -0700
Message-ID: <201103282221.p2SMLRg9000932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400Ab1C1WWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Mar 2011 18:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkiper@net-space.pl, cl@linux.com, dave@linux.vnet.ibm.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     mm: optimize pfn calculation in online_page()
has been added to the -mm tree.  Its filename is
     mm-optimize-pfn-calculation-in-online_page.patch

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
Subject: mm: optimize pfn calculation in online_page()
From: Daniel Kiper <dkiper@net-space.pl>

If CONFIG_FLATMEM is enabled pfn is calculated in online_page() more than
once.  It is possible to optimize that and use value established at
beginning of that function.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-optimize-pfn-calculation-in-online_page mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-optimize-pfn-calculation-in-online_page
+++ a/mm/memory_hotplug.c
@@ -375,7 +375,7 @@ void online_page(struct page *page)
 #endif
 
 #ifdef CONFIG_FLATMEM
-	max_mapnr = max(page_to_pfn(page), max_mapnr);
+	max_mapnr = max(pfn, max_mapnr);
 #endif
 
 	ClearPageReserved(page);
_

Patches currently in -mm which might be from dkiper@net-space.pl are

origin.patch
mm-optimize-pfn-calculation-in-online_page.patch

