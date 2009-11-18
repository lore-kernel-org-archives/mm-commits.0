From: akpm@linux-foundation.org
Subject: + mm-fix-section-mismatch-in-memory_hotplugc.patch added to -mm tree
Date: Wed, 18 Nov 2009 12:26:32 -0800
Message-ID: <200911182026.nAIKQWhv023988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932273AbZKRU0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Nov 2009 15:26:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, hannes@cmpxchg.org, pbadari@us.ibm.com, y-goto@jp.fujitsu.com


The patch titled
     mm: fix section mismatch in memory_hotplug.c
has been added to the -mm tree.  Its filename is
     mm-fix-section-mismatch-in-memory_hotplugc.patch

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

linux-next.patch
mm-fix-section-mismatch-in-memory_hotplugc.patch
moxa-remove-ifdef-module-completely.patch

