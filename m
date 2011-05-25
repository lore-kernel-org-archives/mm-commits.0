From: akpm@linux-foundation.org
Subject: [merged] mm-remove-dependency-on-config_flatmem-from-online_page.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:52 -0700
Message-ID: <201105252028.p4PKSFRP014727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404Ab1EYU27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkiper@net-space.pl, dave@linux.vnet.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove dependency on CONFIG_FLATMEM from online_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-dependency-on-config_flatmem-from-online_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove dependency on CONFIG_FLATMEM from online_page()
From: Daniel Kiper <dkiper@net-space.pl>

online_pages() is only compiled for CONFIG_MEMORY_HOTPLUG_SPARSE, so there
is no need to support CONFIG_FLATMEM code within it.

This patch removes code that is never used.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
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
