From: akpm@linux-foundation.org
Subject: [merged]
 mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded.patch removed from
 -mm tree
Date: Wed, 15 Apr 2015 12:10:24 -0700
Message-ID: <552eb7a0.PQjyno1Ub9Khri0p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbbDOTKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:10:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, benh@kernel.crashing.org, catalin.marinas@arm.com, cmetcalf@ezchip.com, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, fenghua.yu@intel.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, hpa@zytor.com, ink@jurassic.park.msu.ru, jdike@addtoit.com, jejb@parisc-linux.org, linux@arm.linux.org.uk, linux@roeck-us.net, mattst88@gmail.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, ralf@linux-mips.org, richard@nod.at, rth@twiddle.net, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, will.deacon@arm.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not add nr_pmds into mm_struct if PMD is folded
has been removed from the -mm tree.  Its filename was
     mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: do not add nr_pmds into mm_struct if PMD is folded

CONFIG_PGTABLE_LEVELS is now available on every architecture and we can
use it to check if we need to add nr_pmds into mm_struct.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/mm_types.h~mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded
+++ a/include/linux/mm_types.h
@@ -364,7 +364,9 @@ struct mm_struct {
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
 	atomic_long_t nr_ptes;			/* PTE page table pages */
+#if CONFIG_PGTABLE_LEVELS > 2
 	atomic_long_t nr_pmds;			/* PMD page table pages */
+#endif
 	int map_count;				/* number of VMAs */
 
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
mm-migrate-check-before-clear-pageswapcache.patch
mm-page-writeback-check-before-clear-pagereclaim.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-sanitize-page-mapping-for-tail-pages-v2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
thp-cleanup-khugepaged-startup.patch
mmv41-new-pfn_mkwrite-same-as-page_mkwrite-for-vm_pfnmap.patch
dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection.patch
dax-unify-ext2-4_dax_file_operations.patch
linux-next.patch

