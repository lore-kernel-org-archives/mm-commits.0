From: akpm@linux-foundation.org
Subject: [merged] include-define-__phys_to_pfn-as-phys_pfn.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:32:34 -0800
Message-ID: <56997382.GyFx3IDlqU6y5I47%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbcAOWcf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xili_gchen_5257@hotmail.com, arnd@arndb.de, gang.chen.5i5j@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add PHYS_PFN, use it in __phys_to_pfn()
has been removed from the -mm tree.  Its filename was
     include-define-__phys_to_pfn-as-phys_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <xili_gchen_5257@hotmail.com>
Subject: mm: add PHYS_PFN, use it in __phys_to_pfn()

__phys_to_pfn and __pfn_to_phys are symmetric, PHYS_PFN and PFN_PHYS are
semmetric:

 - y = (phys_addr_t)x << PAGE_SHIFT

 - y >> PAGE_SHIFT = (phys_add_t)x

 - (unsigned long)(y >> PAGE_SHIFT) = x

[akpm@linux-foundation.org: use macro arg name `x']
[arnd@arndb.de: include linux/pfn.h for PHYS_PFN definition]
Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |    4 +++-
 include/linux/pfn.h                |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/memory_model.h~include-define-__phys_to_pfn-as-phys_pfn include/asm-generic/memory_model.h
--- a/include/asm-generic/memory_model.h~include-define-__phys_to_pfn-as-phys_pfn
+++ a/include/asm-generic/memory_model.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_MEMORY_MODEL_H
 #define __ASM_MEMORY_MODEL_H
 
+#include <linux/pfn.h>
+
 #ifndef __ASSEMBLY__
 
 #if defined(CONFIG_FLATMEM)
@@ -72,7 +74,7 @@
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
+#define PHYS_PFN(x)	((unsigned long)((x) >> PAGE_SHIFT))
 
 #endif
_

Patches currently in -mm which might be from xili_gchen_5257@hotmail.com are


