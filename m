From: akpm@linux-foundation.org
Subject: + mm-make-lowmem_page_address-use-pfn_phys-for-improved-portability.patch added to -mm tree
Date: Fri, 21 May 2010 14:30:38 -0700
Message-ID: <201005212130.o4LLUcAp002572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986Ab0EUVaq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 17:30:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmetcalf@tilera.com, 21cnbao@gmail.com


The patch titled
     mm: make lowmem_page_address() use PFN_PHYS() for improved portability
has been added to the -mm tree.  Its filename is
     mm-make-lowmem_page_address-use-pfn_phys-for-improved-portability.patch

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
Subject: mm: make lowmem_page_address() use PFN_PHYS() for improved portability
From: Chris Metcalf <cmetcalf@tilera.com>

This ensures that platforms with lowmem PAs above 32 bits work correctly
by avoiding truncating the PA during a left shift.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Barry Song <21cnbao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-make-lowmem_page_address-use-pfn_phys-for-improved-portability include/linux/mm.h
--- a/include/linux/mm.h~mm-make-lowmem_page_address-use-pfn_phys-for-improved-portability
+++ a/include/linux/mm.h
@@ -13,6 +13,7 @@
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
 #include <linux/range.h>
+#include <linux/pfn.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -595,7 +596,7 @@ static inline void set_page_links(struct
 
 static __always_inline void *lowmem_page_address(struct page *page)
 {
-	return __va(page_to_pfn(page) << PAGE_SHIFT);
+	return __va(PFN_PHYS(page_to_pfn(page)));
 }
 
 #if defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL)
_

Patches currently in -mm which might be from cmetcalf@tilera.com are

mm-make-lowmem_page_address-use-pfn_phys-for-improved-portability.patch

