From: akpm@linux-foundation.org
Subject: + arch-kmap-remove-bug_on.patch added to -mm tree
Date: Thu, 30 Apr 2020 14:20:33 -0700
Message-ID: <20200430212033.nKxeQTDBS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgD3VUg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Apr 2020 17:20:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, ray.huang@amd.com, tglx@linutronix.de, thellstrom@vmware.com, tsbogend@alpha.franken.de


The patch titled
     Subject: arch/kmap: remove BUG_ON()
has been added to the -mm tree.  Its filename is
     arch-kmap-remove-bug_on.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-kmap-remove-bug_on.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-kmap-remove-bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: arch/kmap: remove BUG_ON()

Patch series "Remove duplicated kmap code", v1.

The kmap infrastructure has been copied almost verbatim to every
architecture.  This series consolidates obvious duplicated code by
defining core functions which call into the architectures only when
needed.

Some of the k[un]map_atomic() implementations have some similarities but
the similarities were not sufficient to warrant further changes.

In addition we remove a duplicate implementation of kmap() in DRM.


This patch (of 10):

Replace the use of BUG_ON(in_interrupt()) in the kmap() and kunmap() in
favor of might_sleep().

Besides the benefits of might_sleep(), this normalizes the implementations
such that they can be made generic in subsequent patches.

Link: http://lkml.kernel.org/r/20200430203845.582900-1-ira.weiny@intel.com
Link: http://lkml.kernel.org/r/20200430203845.582900-2-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>,
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/highmem.h        |    2 +-
 arch/arc/mm/highmem.c                 |    2 +-
 arch/arm/mm/highmem.c                 |    2 +-
 arch/csky/mm/highmem.c                |    2 +-
 arch/microblaze/include/asm/highmem.h |    2 +-
 arch/mips/mm/highmem.c                |    2 +-
 arch/nds32/mm/highmem.c               |    2 +-
 arch/powerpc/include/asm/highmem.h    |    2 +-
 arch/sparc/include/asm/highmem.h      |    4 ++--
 arch/x86/mm/highmem_32.c              |    3 +--
 arch/xtensa/include/asm/highmem.h     |    4 ++--
 11 files changed, 13 insertions(+), 14 deletions(-)

--- a/arch/arc/include/asm/highmem.h~arch-kmap-remove-bug_on
+++ a/arch/arc/include/asm/highmem.h
@@ -45,7 +45,7 @@ static inline void flush_cache_kmaps(voi
 
 static inline void kunmap(struct page *page)
 {
-	BUG_ON(in_interrupt());
+	might_sleep();
 	if (!PageHighMem(page))
 		return;
 	kunmap_high(page);
--- a/arch/arc/mm/highmem.c~arch-kmap-remove-bug_on
+++ a/arch/arc/mm/highmem.c
@@ -51,7 +51,7 @@ static pte_t * fixmap_page_table;
 
 void *kmap(struct page *page)
 {
-	BUG_ON(in_interrupt());
+	might_sleep();
 	if (!PageHighMem(page))
 		return page_address(page);
 
--- a/arch/arm/mm/highmem.c~arch-kmap-remove-bug_on
+++ a/arch/arm/mm/highmem.c
@@ -42,7 +42,7 @@ EXPORT_SYMBOL(kmap);
 
 void kunmap(struct page *page)
 {
-	BUG_ON(in_interrupt());
+	might_sleep();
 	if (!PageHighMem(page))
 		return;
 	kunmap_high(page);
--- a/arch/csky/mm/highmem.c~arch-kmap-remove-bug_on
+++ a/arch/csky/mm/highmem.c
@@ -29,7 +29,7 @@ EXPORT_SYMBOL(kmap);
 
 void kunmap(struct page *page)
 {
-	BUG_ON(in_interrupt());
+	might_sleep();
 	if (!PageHighMem(page))
 		return;
 	kunmap_high(page);
--- a/arch/microblaze/include/asm/highmem.h~arch-kmap-remove-bug_on
+++ a/arch/microblaze/include/asm/highmem.h
@@ -66,7 +66,7 @@ static inline void *kmap(struct page *pa
 
 static inline void kunmap(struct page *page)
 {
-	BUG_ON(in_interrupt());
+	might_sleep();
 	if (!PageHighMem(page))
 		return;
 	kunmap_high(page);
--- a/arch/mips/mm/highmem.c~arch-kmap-remove-bug_on
+++ a/arch/mips/mm/highmem.c
@@ -28,7 +28,7 @@ EXPORT_SYMBOL(kmap);
 
 void kunmap(struct page *page)
 {
-	BUG_ON(in_interrupt());
+	might_sleep();
 	if (!PageHighMem(page))
 		return;
 	kunmap_high(page);
--- a/arch/nds32/mm/highmem.c~arch-kmap-remove-bug_on
+++ a/arch/nds32/mm/highmem.c
@@ -24,7 +24,7 @@ EXPORT_SYMBOL(kmap);
 
 void kunmap(struct page *page)
 {
-	BUG_ON(in_interrupt());
+	might_sleep();
 	if (!PageHighMem(page))
 		return;
 	kunmap_high(page);
--- a/arch/powerpc/include/asm/highmem.h~arch-kmap-remove-bug_on
+++ a/arch/powerpc/include/asm/highmem.h
@@ -74,7 +74,7 @@ static inline void *kmap(struct page *pa
 
 static inline void kunmap(struct page *page)
 {
-	BUG_ON(in_interrupt());
+	might_sleep();
 	if (!PageHighMem(page))
 		return;
 	kunmap_high(page);
--- a/arch/sparc/include/asm/highmem.h~arch-kmap-remove-bug_on
+++ a/arch/sparc/include/asm/highmem.h
@@ -55,7 +55,7 @@ void kunmap_high(struct page *page);
 
 static inline void *kmap(struct page *page)
 {
-	BUG_ON(in_interrupt());
+	might_sleep();
 	if (!PageHighMem(page))
 		return page_address(page);
 	return kmap_high(page);
@@ -63,7 +63,7 @@ static inline void *kmap(struct page *pa
 
 static inline void kunmap(struct page *page)
 {
-	BUG_ON(in_interrupt());
+	might_sleep();
 	if (!PageHighMem(page))
 		return;
 	kunmap_high(page);
--- a/arch/x86/mm/highmem_32.c~arch-kmap-remove-bug_on
+++ a/arch/x86/mm/highmem_32.c
@@ -15,8 +15,7 @@ EXPORT_SYMBOL(kmap);
 
 void kunmap(struct page *page)
 {
-	if (in_interrupt())
-		BUG();
+	might_sleep();
 	if (!PageHighMem(page))
 		return;
 	kunmap_high(page);
--- a/arch/xtensa/include/asm/highmem.h~arch-kmap-remove-bug_on
+++ a/arch/xtensa/include/asm/highmem.h
@@ -73,7 +73,7 @@ static inline void *kmap(struct page *pa
 	 */
 	BUILD_BUG_ON(PKMAP_BASE <
 		     TLBTEMP_BASE_1 + TLBTEMP_SIZE);
-	BUG_ON(in_interrupt());
+	might_sleep();
 	if (!PageHighMem(page))
 		return page_address(page);
 	return kmap_high(page);
@@ -81,7 +81,7 @@ static inline void *kmap(struct page *pa
 
 static inline void kunmap(struct page *page)
 {
-	BUG_ON(in_interrupt());
+	might_sleep();
 	if (!PageHighMem(page))
 		return;
 	kunmap_high(page);
_

Patches currently in -mm which might be from ira.weiny@intel.com are

arch-kmap-remove-bug_on.patch
arch-xtensa-move-kmap-build-bug-out-of-the-way.patch
arch-kmap-remove-redundant-arch-specific-kmaps.patch
arch-kunmap-remove-duplicate-kunmap-implementations.patch
arch-kmap_atomic-consolidate-duplicate-code.patch
arch-kunmap_atomic-consolidate-duplicate-code.patch
arch-kmap-ensure-kmap_prot-visibility.patch
arch-kmap-dont-hard-code-kmap_prot-values.patch
arch-kmap-define-kmap_atomic_prot-for-all-archs.patch
drm-remove-drm-specific-kmap_atomic-code.patch
