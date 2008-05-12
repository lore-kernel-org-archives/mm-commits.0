From: akpm@linux-foundation.org
Subject: + memory_hotplug-always-initialize-pageblock-bitmap.patch added to -mm tree
Date: Mon, 12 May 2008 14:51:50 -0700
Message-ID: <200805122151.m4CLpoAI011020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbYELVxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 17:53:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, apw@shadowen.org, gerald.schaefer@de.ibm.com, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com


The patch titled
     memory_hotplug: always initialize pageblock bitmap.
has been added to the -mm tree.  Its filename is
     memory_hotplug-always-initialize-pageblock-bitmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory_hotplug: always initialize pageblock bitmap.
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Trying to online a new memory section that was added via memory hotplug
sometimes results in crashes when the new pages are added via __free_page. 
Reason for that is that the pageblock bitmap isn't initialized and hence
contains random stuff.  That means that get_pageblock_migratetype() returns
also random stuff and therefore

	list_add(&page->lru,
		 &zone->free_area[order].free_list[migratetype]);

in __free_one_page() tries to do a list_add to something that isn't even
necessarily a list.

This is only an issue for memory sections that get added after boot time since
all previously present memory sections allocate their pageblock bitmaps via
the bootmem allocator which in turn initializes just everything it returns.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~memory_hotplug-always-initialize-pageblock-bitmap mm/sparse.c
--- a/mm/sparse.c~memory_hotplug-always-initialize-pageblock-bitmap
+++ a/mm/sparse.c
@@ -244,7 +244,7 @@ unsigned long usemap_size(void)
 #ifdef CONFIG_MEMORY_HOTPLUG
 static unsigned long *__kmalloc_section_usemap(void)
 {
-	return kmalloc(usemap_size(), GFP_KERNEL);
+	return kzalloc(usemap_size(), GFP_KERNEL);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch
memory-hotplug-memmap_init_zone-called-twice.patch
memory_hotplug-always-initialize-pageblock-bitmap.patch

