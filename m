From: akpm@linux-foundation.org
Subject: + x86powerpcmicroblaze-kmap-move-preempt-disable.patch
 added to -mm tree
Date: Thu, 07 May 2020 13:36:27 -0700
Message-ID: <20200507203627.ecl4hqdKx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgEGUg3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 16:36:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: {x86,powerpc,microblaze}/kmap: move preempt disable
has been added to the -mm tree.  Its filename is
     x86powerpcmicroblaze-kmap-move-preempt-disable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86powerpcmicroblaze-kmap-move=
-preempt-disable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86powerpcmicroblaze-kmap-move=
-preempt-disable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: {x86,powerpc,microblaze}/kmap: move preempt disable

During this kmap() conversion series we must maintain bisect-ability.  To
do this, kmap_atomic_prot() in x86, powerpc, and microblaze need to remain
functional.

Create a temporary inline version of kmap_atomic_prot within these
architectures so we can rework their kmap_atomic() calls and then lift
kmap_atomic_prot() to the core.

Link: http://lkml.kernel.org/r/20200507150004.1423069-6-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/highmem.h |   11 ++++++++++-
 arch/microblaze/mm/highmem.c          |   10 ++--------
 arch/powerpc/include/asm/highmem.h    |   11 ++++++++++-
 arch/powerpc/mm/highmem.c             |    9 ++-------
 arch/x86/include/asm/highmem.h        |   11 ++++++++++-
 arch/x86/mm/highmem_32.c              |   10 ++--------
 6 files changed, 36 insertions(+), 26 deletions(-)

--- a/arch/microblaze/include/asm/highmem.h~x86powerpcmicroblaze-kmap-move-=
preempt-disable
+++ a/arch/microblaze/include/asm/highmem.h
@@ -51,7 +51,16 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt - PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
+extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
+static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+{
+	preempt_disable();
+	pagefault_disable();
+	if (!PageHighMem(page))
+		return page_address(page);
+
+	return kmap_atomic_high_prot(page, prot);
+}
 extern void __kunmap_atomic(void *kvaddr);
=20
 static inline void *kmap_atomic(struct page *page)
--- a/arch/microblaze/mm/highmem.c~x86powerpcmicroblaze-kmap-move-preempt-d=
isable
+++ a/arch/microblaze/mm/highmem.c
@@ -32,18 +32,12 @@
  */
 #include <asm/tlbflush.h>
=20
-void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
=20
 	unsigned long vaddr;
 	int idx, type;
=20
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
-
 	type =3D kmap_atomic_idx_push();
 	idx =3D type + KM_TYPE_NR*smp_processor_id();
 	vaddr =3D __fix_to_virt(FIX_KMAP_BEGIN + idx);
@@ -55,7 +49,7 @@ void *kmap_atomic_prot(struct page *page
=20
 	return (void *) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_prot);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
 void __kunmap_atomic(void *kvaddr)
 {
--- a/arch/powerpc/include/asm/highmem.h~x86powerpcmicroblaze-kmap-move-pre=
empt-disable
+++ a/arch/powerpc/include/asm/highmem.h
@@ -59,7 +59,16 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
+extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
+static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+{
+	preempt_disable();
+	pagefault_disable();
+	if (!PageHighMem(page))
+		return page_address(page);
+
+	return kmap_atomic_high_prot(page, prot);
+}
 extern void __kunmap_atomic(void *kvaddr);
=20
 static inline void *kmap_atomic(struct page *page)
--- a/arch/powerpc/mm/highmem.c~x86powerpcmicroblaze-kmap-move-preempt-disa=
ble
+++ a/arch/powerpc/mm/highmem.c
@@ -30,16 +30,11 @@
  * be used in IRQ contexts, so in some (very limited) cases we need
  * it.
  */
-void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
 	int idx, type;
=20
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	type =3D kmap_atomic_idx_push();
 	idx =3D type + KM_TYPE_NR*smp_processor_id();
 	vaddr =3D __fix_to_virt(FIX_KMAP_BEGIN + idx);
@@ -49,7 +44,7 @@ void *kmap_atomic_prot(struct page *page
=20
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_prot);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
 void __kunmap_atomic(void *kvaddr)
 {
--- a/arch/x86/include/asm/highmem.h~x86powerpcmicroblaze-kmap-move-preempt=
-disable
+++ a/arch/x86/include/asm/highmem.h
@@ -58,7 +58,16 @@ extern unsigned long highstart_pfn, high
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-void *kmap_atomic_prot(struct page *page, pgprot_t prot);
+extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
+static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+{
+	preempt_disable();
+	pagefault_disable();
+	if (!PageHighMem(page))
+		return page_address(page);
+
+	return kmap_atomic_high_prot(page, prot);
+}
 void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
 void *kmap_atomic_pfn(unsigned long pfn);
--- a/arch/x86/mm/highmem_32.c~x86powerpcmicroblaze-kmap-move-preempt-disab=
le
+++ a/arch/x86/mm/highmem_32.c
@@ -12,17 +12,11 @@
  * However when holding an atomic kmap it is not legal to sleep, so atomic
  * kmaps are appropriate for short, tight code paths only.
  */
-void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
 	int idx, type;
=20
-	preempt_disable();
-	pagefault_disable();
-
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	type =3D kmap_atomic_idx_push();
 	idx =3D type + KM_TYPE_NR*smp_processor_id();
 	vaddr =3D __fix_to_virt(FIX_KMAP_BEGIN + idx);
@@ -32,7 +26,7 @@ void *kmap_atomic_prot(struct page *page
=20
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_prot);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
 void *kmap_atomic(struct page *page)
 {
_

Patches currently in -mm which might be from ira.weiny@intel.com are

arch-kmap-remove-bug_on.patch
arch-xtensa-move-kmap-build-bug-out-of-the-way.patch
arch-kmap-remove-redundant-arch-specific-kmaps.patch
arch-kunmap-remove-duplicate-kunmap-implementations.patch
x86powerpcmicroblaze-kmap-move-preempt-disable.patch
arch-kmap_atomic-consolidate-duplicate-code.patch
arch-kunmap_atomic-consolidate-duplicate-code.patch
arch-kmap-ensure-kmap_prot-visibility.patch
arch-kmap-dont-hard-code-kmap_prot-values.patch
arch-kmap-define-kmap_atomic_prot-for-all-archs.patch
drm-remove-drm-specific-kmap_atomic-code.patch
kmap-remove-kmap_atomic_to_page.patch
parisc-kmap-remove-duplicate-kmap-code.patch
sparc-remove-unnecessary-includes.patch
kmap-consolidate-kmap_prot-definitions.patch
