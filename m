From: akpm@linux-foundation.org
Subject: + xen-paravirt-remove-ctor-for-pgd-cache.patch added to -mm tree
Date: Thu, 15 Feb 2007 23:00:10 -0800
Message-ID: <200702160700.l1G70AJX022616@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55165 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423354AbXBPHBA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 02:01:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     Xen-paravirt: remove ctor for pgd cache
has been added to the -mm tree.  Its filename is
     xen-paravirt-remove-ctor-for-pgd-cache.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Xen-paravirt: remove ctor for pgd cache
From: Jeremy Fitzhardinge <jeremy@goop.org>

Remove the ctor for the pgd cache.  There's no point in having the cache
machinery do this via an indirect call when all pgd are freed in the one place
anyway.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/init.c        |    8 +++-----
 arch/i386/mm/pgtable.c     |   15 +++++++++++----
 include/asm-i386/pgtable.h |    2 --
 3 files changed, 14 insertions(+), 11 deletions(-)

diff -puN arch/i386/mm/init.c~xen-paravirt-remove-ctor-for-pgd-cache arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~xen-paravirt-remove-ctor-for-pgd-cache
+++ a/arch/i386/mm/init.c
@@ -728,11 +728,9 @@ void __init pgtable_cache_init(void)
 			panic("pgtable_cache_init(): cannot create pmd cache");
 	}
 	pgd_cache = kmem_cache_create("pgd",
-				PTRS_PER_PGD*sizeof(pgd_t),
-				PTRS_PER_PGD*sizeof(pgd_t),
-				0,
-				pgd_ctor,
-				PTRS_PER_PMD == 1 ? pgd_dtor : NULL);
+				      PTRS_PER_PGD*sizeof(pgd_t),
+				      PTRS_PER_PGD*sizeof(pgd_t),
+				      0, NULL, NULL);
 	if (!pgd_cache)
 		panic("pgtable_cache_init(): Cannot create pgd cache");
 }
diff -puN arch/i386/mm/pgtable.c~xen-paravirt-remove-ctor-for-pgd-cache arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c~xen-paravirt-remove-ctor-for-pgd-cache
+++ a/arch/i386/mm/pgtable.c
@@ -238,7 +238,7 @@ static inline void pgd_list_del(pgd_t *p
 		set_page_private(next, (unsigned long)pprev);
 }
 
-void pgd_ctor(void *pgd, struct kmem_cache *cache, unsigned long unused)
+static void pgd_ctor(pgd_t *pgd)
 {
 	unsigned long flags;
 
@@ -247,7 +247,7 @@ void pgd_ctor(void *pgd, struct kmem_cac
 		spin_lock_irqsave(&pgd_lock, flags);
 	}
 
-	clone_pgd_range((pgd_t *)pgd + USER_PTRS_PER_PGD,
+	clone_pgd_range(pgd + USER_PTRS_PER_PGD,
 			swapper_pg_dir + USER_PTRS_PER_PGD,
 			KERNEL_PGD_PTRS);
 
@@ -263,11 +263,13 @@ void pgd_ctor(void *pgd, struct kmem_cac
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
-/* never called when PTRS_PER_PMD > 1 */
-void pgd_dtor(void *pgd, struct kmem_cache *cache, unsigned long unused)
+static void pgd_dtor(pgd_t *pgd)
 {
 	unsigned long flags; /* can be called from interrupt context */
 
+	if (PTRS_PER_PMD == 1)
+		return;
+
 	paravirt_release_pd(__pa(pgd) >> PAGE_SHIFT);
 	spin_lock_irqsave(&pgd_lock, flags);
 	pgd_list_del(pgd);
@@ -279,6 +281,9 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	int i;
 	pgd_t *pgd = kmem_cache_alloc(pgd_cache, GFP_KERNEL);
 
+	if (pgd)
+		pgd_ctor(pgd);
+
 	if (PTRS_PER_PMD == 1 || !pgd)
 		return pgd;
 
@@ -298,6 +303,7 @@ out_oom:
 		paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
 		kmem_cache_free(pmd_cache, pmd);
 	}
+	pgd_dtor(pgd);
 	kmem_cache_free(pgd_cache, pgd);
 	return NULL;
 }
@@ -315,5 +321,6 @@ void pgd_free(pgd_t *pgd)
 			kmem_cache_free(pmd_cache, pmd);
 		}
 	/* in the non-PAE case, free_pgtables() clears user pgd entries */
+	pgd_dtor(pgd);
 	kmem_cache_free(pgd_cache, pgd);
 }
diff -puN include/asm-i386/pgtable.h~xen-paravirt-remove-ctor-for-pgd-cache include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~xen-paravirt-remove-ctor-for-pgd-cache
+++ a/include/asm-i386/pgtable.h
@@ -44,8 +44,6 @@ extern spinlock_t pgd_lock;
 extern struct page *pgd_list;
 
 void pmd_ctor(void *, struct kmem_cache *, unsigned long);
-void pgd_ctor(void *, struct kmem_cache *, unsigned long);
-void pgd_dtor(void *, struct kmem_cache *, unsigned long);
 void pgtable_cache_init(void);
 void paging_init(void);
 
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-probe_roms-cleanup.patch
no-need-to-use-traditional-for-processing-asm-in-i386-kernel.patch
xen-paravirt-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt-remove-ctor-for-pgd-cache.patch
xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch
xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt-allocate-and-free-vmalloc-areas.patch
xen-paravirt-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
xen-paravirt-add-xen-interface-header-files.patch
xen-paravirt-core-xen-implementation.patch
xen-paravirt-add-the-xen-virtual-console-driver.patch
xen-paravirt-add-xen-grant-table-support.patch
xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt-add-xen-virtual-block-device-driver.patch
xen-paravirt-add-the-xen-virtual-network-device-driver.patch
uninline-jiffiesh-functions.patch
