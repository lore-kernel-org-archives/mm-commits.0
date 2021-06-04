Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063F1C47082
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 03:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA95F61407
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 03:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFDDFR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 23:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhFDDFR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Jun 2021 23:05:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06842613EA;
        Fri,  4 Jun 2021 03:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622775795;
        bh=qjRgYk1ivYrXH0skocP5ydHtKYYc80r93JzoBpYsfPo=;
        h=Date:From:To:Subject:From;
        b=gdY0esbp/2FV1UdWKvVBhdbOGFWVhq5EJtOYrrppeeRNOK7T4/lvciVtH7Z5Fjmid
         VekcO6TOlyhmSGszx+f8n1cpS9T2XG7MFA6EpRx9eCWZUNweQ5ini3/6GTNiabdz/v
         E3oo3JRLFIPIMda/KI96hQDCyKBjUNr6g5knfH+A=
Date:   Thu, 03 Jun 2021 20:03:14 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, catalin.marinas@arm.com, eugenis@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org,
        pcc@google.com, vincenzo.frascino@arm.com
Subject:  +
 =?US-ASCII?Q?mm-arch-remove-indirection-level-in-alloc=5Fzeroed=5Fuse?=
 =?US-ASCII?Q?r=5Fhighpage=5Fmovable.patch?= added to -mm tree
Message-ID: <20210604030314.R-EL0Ui58%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: arch: remove indirection level in alloc_zeroed_user_highpage_movable()
has been added to the -mm tree.  Its filename is
     mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: mm: arch: remove indirection level in alloc_zeroed_user_highpage_movable()

Patch series "arm64: improve efficiency of setting tags for user pages", v6.

Currently we can end up touching PROT_MTE user pages twice on fault and
once on unmap.  On fault, with KASAN disabled we first clear data and then
set tags to 0, and with KASAN enabled we simultaneously clear data and set
tags to the KASAN random tag, and then set tags again to 0.  On unmap, we
poison the page by setting tags, but this is less likely to find a bug
than poisoning kernel pages.

This patch series fixes these inefficiencies by only touching the pages
once on fault using the DC GZVA instruction to clear both data and tags,
and avoiding poisoning user pages on free.


This patch (of 4):

In an upcoming change we would like to add a flag to GFP_HIGHUSER_MOVABLE
so that it would no longer be an OR of GFP_HIGHUSER and __GFP_MOVABLE. 
This poses a problem for alloc_zeroed_user_highpage_movable() which passes
__GFP_MOVABLE into an arch-specific __alloc_zeroed_user_highpage() hook
which ORs in GFP_HIGHUSER.

Since __alloc_zeroed_user_highpage() is only ever called from
alloc_zeroed_user_highpage_movable(), we can remove one level of
indirection here.  Remove __alloc_zeroed_user_highpage(), make
alloc_zeroed_user_highpage_movable() the hook, and use
GFP_HIGHUSER_MOVABLE in the hook implementations so that they will pick up
the new flag that we are going to add.

Link: https://lkml.kernel.org/r/20210602235230.3928842-1-pcc@google.com
Link: https://lkml.kernel.org/r/20210602235230.3928842-2-pcc@google.com
Link: https://linux-review.googlesource.com/id/Ic6361c657b2cdcd896adbe0cf7cb5a7fbb1ed7bf
Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/page.h   |    6 ++---
 arch/arm64/include/asm/page.h   |    6 ++---
 arch/ia64/include/asm/page.h    |    6 ++---
 arch/m68k/include/asm/page_no.h |    6 ++---
 arch/s390/include/asm/page.h    |    6 ++---
 arch/x86/include/asm/page.h     |    6 ++---
 include/linux/highmem.h         |   35 ++++++------------------------
 7 files changed, 26 insertions(+), 45 deletions(-)

--- a/arch/alpha/include/asm/page.h~mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable
+++ a/arch/alpha/include/asm/page.h
@@ -17,9 +17,9 @@
 extern void clear_page(void *page);
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 
-#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vmaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
+#define alloc_zeroed_user_highpage_movable(vma, vaddr) \
+	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vmaddr)
+#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
 
 extern void copy_page(void * _to, void * _from);
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
--- a/arch/arm64/include/asm/page.h~mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable
+++ a/arch/arm64/include/asm/page.h
@@ -28,9 +28,9 @@ void copy_user_highpage(struct page *to,
 void copy_highpage(struct page *to, struct page *from);
 #define __HAVE_ARCH_COPY_HIGHPAGE
 
-#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
+#define alloc_zeroed_user_highpage_movable(vma, vaddr) \
+	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr)
+#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
 
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
--- a/arch/ia64/include/asm/page.h~mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable
+++ a/arch/ia64/include/asm/page.h
@@ -82,16 +82,16 @@ do {						\
 } while (0)
 
 
-#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr)		\
+#define alloc_zeroed_user_highpage_movable(vma, vaddr)			\
 ({									\
 	struct page *page = alloc_page_vma(				\
-		GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr);	\
+		GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr);		\
 	if (page)							\
  		flush_dcache_page(page);				\
 	page;								\
 })
 
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
+#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
 
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 
--- a/arch/m68k/include/asm/page_no.h~mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable
+++ a/arch/m68k/include/asm/page_no.h
@@ -13,9 +13,9 @@ extern unsigned long memory_end;
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
+#define alloc_zeroed_user_highpage_movable(vma, vaddr) \
+	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr)
+#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
 
 #define __pa(vaddr)		((unsigned long)(vaddr))
 #define __va(paddr)		((void *)((unsigned long)(paddr)))
--- a/arch/s390/include/asm/page.h~mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable
+++ a/arch/s390/include/asm/page.h
@@ -68,9 +68,9 @@ static inline void copy_page(void *to, v
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
+#define alloc_zeroed_user_highpage_movable(vma, vaddr) \
+	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr)
+#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
 
 /*
  * These are used to make use of C type-checking..
--- a/arch/x86/include/asm/page.h~mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable
+++ a/arch/x86/include/asm/page.h
@@ -34,9 +34,9 @@ static inline void copy_user_page(void *
 	copy_page(to, from);
 }
 
-#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
-#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
+#define alloc_zeroed_user_highpage_movable(vma, vaddr) \
+	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr)
+#define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
 
 #ifndef __pa
 #define __pa(x)		__phys_addr((unsigned long)(x))
--- a/include/linux/highmem.h~mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable
+++ a/include/linux/highmem.h
@@ -152,28 +152,24 @@ static inline void clear_user_highpage(s
 }
 #endif
 
-#ifndef __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
+#ifndef __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
 /**
- * __alloc_zeroed_user_highpage - Allocate a zeroed HIGHMEM page for a VMA with caller-specified movable GFP flags
- * @movableflags: The GFP flags related to the pages future ability to move like __GFP_MOVABLE
+ * alloc_zeroed_user_highpage_movable - Allocate a zeroed HIGHMEM page for a VMA that the caller knows can move
  * @vma: The VMA the page is to be allocated for
  * @vaddr: The virtual address the page will be inserted into
  *
- * This function will allocate a page for a VMA but the caller is expected
- * to specify via movableflags whether the page will be movable in the
- * future or not
+ * This function will allocate a page for a VMA that the caller knows will
+ * be able to migrate in the future using move_pages() or reclaimed
  *
  * An architecture may override this function by defining
- * __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE and providing their own
+ * __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE and providing their own
  * implementation.
  */
 static inline struct page *
-__alloc_zeroed_user_highpage(gfp_t movableflags,
-			struct vm_area_struct *vma,
-			unsigned long vaddr)
+alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
+				   unsigned long vaddr)
 {
-	struct page *page = alloc_page_vma(GFP_HIGHUSER | movableflags,
-			vma, vaddr);
+	struct page *page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
 
 	if (page)
 		clear_user_highpage(page, vaddr);
@@ -182,21 +178,6 @@ __alloc_zeroed_user_highpage(gfp_t movab
 }
 #endif
 
-/**
- * alloc_zeroed_user_highpage_movable - Allocate a zeroed HIGHMEM page for a VMA that the caller knows can move
- * @vma: The VMA the page is to be allocated for
- * @vaddr: The virtual address the page will be inserted into
- *
- * This function will allocate a page for a VMA that the caller knows will
- * be able to migrate in the future using move_pages() or reclaimed
- */
-static inline struct page *
-alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
-					unsigned long vaddr)
-{
-	return __alloc_zeroed_user_highpage(__GFP_MOVABLE, vma, vaddr);
-}
-
 static inline void clear_highpage(struct page *page)
 {
 	void *kaddr = kmap_local_page(page);
_

Patches currently in -mm which might be from pcc@google.com are

mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-v5.patch
mm-arch-remove-indirection-level-in-alloc_zeroed_user_highpage_movable.patch
kasan-use-separate-unpoison-implementation-for-integrated-init.patch
arm64-mte-handle-tags-zeroing-at-page-allocation-time.patch
kasan-disable-freed-user-page-poisoning-with-hw-tags.patch

