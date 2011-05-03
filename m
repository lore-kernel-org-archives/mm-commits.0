From: akpm@linux-foundation.org
Subject: + mm-remove-dependency-on-config_flatmem-from-online_page.patch added to -mm tree
Date: Tue, 03 May 2011 16:35:52 -0700
Message-ID: <201105032335.p43NZqv0017520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088Ab1ECXgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2011 19:36:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkiper@net-space.pl, dave@linux.vnet.ibm.com


The patch titled
     mm: remove dependency on CONFIG_FLATMEM from online_page()
has been added to the -mm tree.  Its filename is
     mm-remove-dependency-on-config_flatmem-from-online_page.patch

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
Subject: mm: remove dependency on CONFIG_FLATMEM from online_page()
From: Daniel Kiper <dkiper@net-space.pl>

Memory hotplug code strictly depends on CONFIG_SPARSEMEM.  It means that
code depending on CONFIG_FLATMEM in online_page() is never compiled. 
Remove it because it is not needed anymore.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-remove-dependency-on-config_flatmem-from-online_page mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-remove-dependency-on-config_flatmem-from-online_page
+++ a/mm/memory_hotplug.c
@@ -374,10 +374,6 @@ void online_page(struct page *page)
 		totalhigh_pages++;
 #endif
 
-#ifdef CONFIG_FLATMEM
-	max_mapnr = max(pfn, max_mapnr);
-#endif
