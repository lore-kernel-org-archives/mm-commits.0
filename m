From: akpm@linux-foundation.org
Subject: + nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits.patch added to -mm tree
Date: Fri, 13 Mar 2009 13:05:43 -0700
Message-ID: <200903132005.n2DK5iJd020860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821AbZCMULi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 16:11:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, Enrik.Berkhan@ge.com, a.p.zijlstra@chello.nl, gerg@snapgear.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     nommu: there is no mlock() for NOMMU, so don't provide the bits
has been added to the -mm tree.  Its filename is
     nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits.patch

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
Subject: nommu: there is no mlock() for NOMMU, so don't provide the bits
From: David Howells <dhowells@redhat.com>

The mlock() facility does not exist for NOMMU since all mappings are
effectively locked anyway, so we don't make the bits available when
they're not useful.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Enrik Berkhan <Enrik.Berkhan@ge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   20 +++++++++++++-------
 mm/Kconfig                 |    8 ++++++++
 mm/internal.h              |    8 +++++---
 3 files changed, 26 insertions(+), 10 deletions(-)

diff -puN include/linux/page-flags.h~nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits include/linux/page-flags.h
--- a/include/linux/page-flags.h~nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits
+++ a/include/linux/page-flags.h
@@ -98,6 +98,8 @@ enum pageflags {
 	PG_swapbacked,		/* Page is backed by RAM/swap */
 #ifdef CONFIG_UNEVICTABLE_LRU
 	PG_unevictable,		/* Page is "unevictable"  */
+#endif
+#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
 	PG_mlocked,		/* Page is vma mlocked */
 #endif
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
@@ -252,20 +254,20 @@ PAGEFLAG_FALSE(SwapCache)
 #ifdef CONFIG_UNEVICTABLE_LRU
 PAGEFLAG(Unevictable, unevictable) __CLEARPAGEFLAG(Unevictable, unevictable)
 	TESTCLEARFLAG(Unevictable, unevictable)
+#else
+PAGEFLAG_FALSE(Unevictable) TESTCLEARFLAG_FALSE(Unevictable)
+	SETPAGEFLAG_NOOP(Unevictable) CLEARPAGEFLAG_NOOP(Unevictable)
+	__CLEARPAGEFLAG_NOOP(Unevictable)
+#endif
 
+#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
 #define MLOCK_PAGES 1
 PAGEFLAG(Mlocked, mlocked) __CLEARPAGEFLAG(Mlocked, mlocked)
 	TESTSCFLAG(Mlocked, mlocked)
-
 #else
-
 #define MLOCK_PAGES 0
 PAGEFLAG_FALSE(Mlocked)
 	SETPAGEFLAG_NOOP(Mlocked) TESTCLEARFLAG_FALSE(Mlocked)
-
-PAGEFLAG_FALSE(Unevictable) TESTCLEARFLAG_FALSE(Unevictable)
-	SETPAGEFLAG_NOOP(Unevictable) CLEARPAGEFLAG_NOOP(Unevictable)
-	__CLEARPAGEFLAG_NOOP(Unevictable)
 #endif
 
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
@@ -385,9 +387,13 @@ static inline void __ClearPageTail(struc
 
 #ifdef CONFIG_UNEVICTABLE_LRU
 #define __PG_UNEVICTABLE	(1 << PG_unevictable)
-#define __PG_MLOCKED		(1 << PG_mlocked)
 #else
 #define __PG_UNEVICTABLE	0
+#endif
+
+#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
+#define __PG_MLOCKED		(1 << PG_mlocked)
+#else
 #define __PG_MLOCKED		0
 #endif
 
diff -puN mm/Kconfig~nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits mm/Kconfig
--- a/mm/Kconfig~nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits
+++ a/mm/Kconfig
@@ -214,5 +214,13 @@ config UNEVICTABLE_LRU
 	  will use one page flag and increase the code size a little,
 	  say Y unless you know what you are doing.
 
+config HAVE_MLOCK
+	bool
+	default y if MMU=y
+
+config HAVE_MLOCKED_PAGE_BIT
+	bool
+	default y if HAVE_MLOCK=y && UNEVICTABLE_LRU=y
+
 config MMU_NOTIFIER
 	bool
diff -puN mm/internal.h~nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits mm/internal.h
--- a/mm/internal.h~nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits
+++ a/mm/internal.h
@@ -63,6 +63,7 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
+#ifdef CONFIG_HAVE_MLOCK
 extern long mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
 extern void munlock_vma_pages_range(struct vm_area_struct *vma,
@@ -71,6 +72,7 @@ static inline void munlock_vma_pages_all
 {
 	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
 }
+#endif
 
 #ifdef CONFIG_UNEVICTABLE_LRU
 /*
@@ -90,7 +92,7 @@ static inline void unevictable_migrate_p
 }
 #endif
 
-#ifdef CONFIG_UNEVICTABLE_LRU
+#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
 /*
  * Called only in fault path via page_evictable() for a new page
  * to determine if it's being mapped into a LOCKED vma.
@@ -165,7 +167,7 @@ static inline void free_page_mlock(struc
 	}
 }
 
-#else /* CONFIG_UNEVICTABLE_LRU */
+#else /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
 static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
 {
 	return 0;
@@ -175,7 +177,7 @@ static inline void mlock_vma_page(struct
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
 static inline void free_page_mlock(struct page *page) { }
 
-#endif /* CONFIG_UNEVICTABLE_LRU */
+#endif /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
 
 /*
  * Return the mem_map entry representing the 'offset' subpage within
_

Patches currently in -mm which might be from dhowells@redhat.com are

nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded.patch
nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails.patch
linux-next.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch
nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits.patch
nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-present-backing-device-capabilities-for-mtd-chardevs.patch
nommu-add-support-for-direct-mapping-through-mtdconcat-if-possible.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly-fix.patch
mtd-fix-a-bad-dependency-in-the-blackfin-code.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch
mutex-subsystem-synchro-test-module.patch

