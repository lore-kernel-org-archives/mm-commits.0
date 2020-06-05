From: akpm@linux-foundation.org
Subject: [merged] arch-kmap-ensure-kmap_prot-visibility.patch
 removed from -mm tree
Date: Fri, 05 Jun 2020 13:17:29 -0700
Message-ID: <20200605201729.Db7IT7KBW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgFEURa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:17:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: arch/kmap: ensure kmap_prot visibility
has been removed from the -mm tree.  Its filename was
     arch-kmap-ensure-kmap_prot-visibility.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: arch/kmap: ensure kmap_prot visibility

We want to support kmap_atomic_prot() on all architectures and it makes
sense to define kmap_atomic() to use the default kmap_prot.

So we ensure all arch's have a globally available kmap_prot either as a
define or exported symbol.

Link: http://lkml.kernel.org/r/20200507150004.1423069-9-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

 arch/microblaze/include/asm/highmem.h |    2 +-
 arch/microblaze/mm/init.c             |    3 ---
 arch/powerpc/include/asm/highmem.h    |    2 +-
 arch/powerpc/mm/mem.c                 |    3 ---
 arch/sparc/mm/highmem.c               |    1 +
 5 files changed, 3 insertions(+), 8 deletions(-)

--- a/arch/microblaze/include/asm/highmem.h~arch-kmap-ensure-kmap_prot-visi=
bility
+++ a/arch/microblaze/include/asm/highmem.h
@@ -25,8 +25,8 @@
 #include <linux/uaccess.h>
 #include <asm/fixmap.h>
=20
+#define kmap_prot		PAGE_KERNEL
 extern pte_t *kmap_pte;
-extern pgprot_t kmap_prot;
 extern pte_t *pkmap_page_table;
=20
 /*
--- a/arch/microblaze/mm/init.c~arch-kmap-ensure-kmap_prot-visibility
+++ a/arch/microblaze/mm/init.c
@@ -49,8 +49,6 @@ unsigned long lowmem_size;
 #ifdef CONFIG_HIGHMEM
 pte_t *kmap_pte;
 EXPORT_SYMBOL(kmap_pte);
-pgprot_t kmap_prot;
-EXPORT_SYMBOL(kmap_prot);
=20
 static inline pte_t *virt_to_kpte(unsigned long vaddr)
 {
@@ -68,7 +66,6 @@ static void __init highmem_init(void)
 	pkmap_page_table =3D virt_to_kpte(PKMAP_BASE);
=20
 	kmap_pte =3D virt_to_kpte(__fix_to_virt(FIX_KMAP_BEGIN));
-	kmap_prot =3D PAGE_KERNEL;
 }
=20
 static void highmem_setup(void)
--- a/arch/powerpc/include/asm/highmem.h~arch-kmap-ensure-kmap_prot-visibil=
ity
+++ a/arch/powerpc/include/asm/highmem.h
@@ -29,8 +29,8 @@
 #include <asm/page.h>
 #include <asm/fixmap.h>
=20
+#define kmap_prot		PAGE_KERNEL
 extern pte_t *kmap_pte;
-extern pgprot_t kmap_prot;
 extern pte_t *pkmap_page_table;
=20
 /*
--- a/arch/powerpc/mm/mem.c~arch-kmap-ensure-kmap_prot-visibility
+++ a/arch/powerpc/mm/mem.c
@@ -64,8 +64,6 @@ bool init_mem_is_free;
 #ifdef CONFIG_HIGHMEM
 pte_t *kmap_pte;
 EXPORT_SYMBOL(kmap_pte);
-pgprot_t kmap_prot;
-EXPORT_SYMBOL(kmap_prot);
 #endif
=20
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
@@ -245,7 +243,6 @@ void __init paging_init(void)
 	pkmap_page_table =3D virt_to_kpte(PKMAP_BASE);
=20
 	kmap_pte =3D virt_to_kpte(__fix_to_virt(FIX_KMAP_BEGIN));
-	kmap_prot =3D PAGE_KERNEL;
 #endif /* CONFIG_HIGHMEM */
=20
 	printk(KERN_DEBUG "Top of RAM: 0x%llx, Total RAM: 0x%llx\n",
--- a/arch/sparc/mm/highmem.c~arch-kmap-ensure-kmap_prot-visibility
+++ a/arch/sparc/mm/highmem.c
@@ -33,6 +33,7 @@
 #include <asm/vaddrs.h>
=20
 pgprot_t kmap_prot;
+EXPORT_SYMBOL(kmap_prot);
=20
 static pte_t *kmap_pte;
=20
_

Patches currently in -mm which might be from ira.weiny@intel.com are
