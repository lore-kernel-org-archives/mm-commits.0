From: akpm@linux-foundation.org
Subject: + include-define-__phys_to_pfn-as-phys_pfn.patch added to -mm
 tree
Date: Tue, 17 Nov 2015 13:51:34 -0800
Message-ID: <564ba166.6krW4tAwFPVNoXUI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbbKQVvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xili_gchen_5257@hotmail.com, arnd@arndb.de, gang.chen.5i5j@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add PHYS_PFN, use it in __phys_to_pfn()
has been added to the -mm tree.  Its filename is
     include-define-__phys_to_pfn-as-phys_pfn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-define-__phys_to_pfn-as-phys_pfn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-define-__phys_to_pfn-as-phys_pfn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <xili_gchen_5257@hotmail.com>
Subject: mm: add PHYS_PFN, use it in __phys_to_pfn()

__phys_to_pfn and __pfn_to_phys are symmetric, PHYS_PFN and PFN_PHYS are
semmetric:

 - y = (phys_addr_t)x << PAGE_SHIFT

 - y >> PAGE_SHIFT = (phys_add_t)x

 - (unsigned long)(y >> PAGE_SHIFT) = x

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |    2 +-
 include/linux/pfn.h                |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/memory_model.h~include-define-__phys_to_pfn-as-phys_pfn include/asm-generic/memory_model.h
--- a/include/asm-generic/memory_model.h~include-define-__phys_to_pfn-as-phys_pfn
+++ a/include/asm-generic/memory_model.h
@@ -72,7 +72,7 @@
 /*
  * Convert a physical address to a Page Frame Number and back
  */
-#define	__phys_to_pfn(paddr)	((unsigned long)((paddr) >> PAGE_SHIFT))
+#define	__phys_to_pfn(paddr)	PHYS_PFN(paddr)
 #define	__pfn_to_phys(pfn)	PFN_PHYS(pfn)
 
 #define page_to_pfn __page_to_pfn
diff -puN include/linux/pfn.h~include-define-__phys_to_pfn-as-phys_pfn include/linux/pfn.h
--- a/include/linux/pfn.h~include-define-__phys_to_pfn-as-phys_pfn
+++ a/include/linux/pfn.h
@@ -9,5 +9,6 @@
 #define PFN_UP(x)	(((x) + PAGE_SIZE-1) >> PAGE_SHIFT)
 #define PFN_DOWN(x)	((x) >> PAGE_SHIFT)
 #define PFN_PHYS(x)	((phys_addr_t)(x) << PAGE_SHIFT)
+#define PHYS_PFN(y)	((unsigned long)((y) >> PAGE_SHIFT))
 
 #endif
_

Patches currently in -mm which might be from xili_gchen_5257@hotmail.com are

include-define-__phys_to_pfn-as-phys_pfn.patch

