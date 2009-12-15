From: akpm@linux-foundation.org
Subject: [merged] mm-fix-section-mismatch-in-memory_hotplugc.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:07 -0800
Message-ID: <200912152154.nBFLs7dn015334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761240AbZLOVy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:54:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, hannes@cmpxchg.org, pbadari@us.ibm.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix section mismatch in memory_hotplug.c
has been removed from the -mm tree.  Its filename was
     mm-fix-section-mismatch-in-memory_hotplugc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix section mismatch in memory_hotplug.c
From: Rakib Mullick <rakib.mullick@gmail.com>

__free_pages_bootmem() is a __meminit function - which has been called
from put_pages_bootmem thus causes a section mismatch warning.

 We were warned by the following warning:

  LD      mm/built-in.o
WARNING: mm/built-in.o(.text+0x26b22): Section mismatch in reference
from the function put_page_bootmem() to the function
.meminit.text:__free_pages_bootmem()
The function put_page_bootmem() references
the function __meminit __free_pages_bootmem().
This is often because put_page_bootmem lacks a __meminit
annotation or the annotation of __free_pages_bootmem is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-fix-section-mismatch-in-memory_hotplugc mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-fix-section-mismatch-in-memory_hotplugc
+++ a/mm/memory_hotplug.c
@@ -72,7 +72,9 @@ static void get_page_bootmem(unsigned lo
 	atomic_inc(&page->_count);
 }
 
-void put_page_bootmem(struct page *page)
+/* reference to __meminit __free_pages_bootmem is valid
+ * so use __ref to tell modpost not to generate a warning */
+void __ref put_page_bootmem(struct page *page)
 {
 	int type;
 
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch
linux-next.patch
moxa-remove-ifdef-module-completely.patch
ip2-remove-ifdef-module-from-ip2mainc.patch

