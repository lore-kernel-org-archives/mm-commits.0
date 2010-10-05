From: akpm@linux-foundation.org
Subject: + mm-fix-sparse-warnings-on-gfp_zone_table-bad.patch added to -mm tree
Date: Tue, 05 Oct 2010 15:14:46 -0700
Message-ID: <201010052214.o95MEkGl023242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821Ab0JEWOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 18:14:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     mm: fix sparse warnings on GFP_ZONE_TABLE/BAD
has been added to the -mm tree.  Its filename is
     mm-fix-sparse-warnings-on-gfp_zone_table-bad.patch

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
Subject: mm: fix sparse warnings on GFP_ZONE_TABLE/BAD
From: Namhyung Kim <namhyung@gmail.com>

Introduce ___GFP_* masks in order for gfp_t to not be mixed with plain
integers which causes a lot of warnings like the following:

 warning: restricted gfp_t degrades to integer

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |  105 +++++++++++++++++++++++++-----------------
 1 file changed, 63 insertions(+), 42 deletions(-)

diff -puN include/linux/gfp.h~mm-fix-sparse-warnings-on-gfp_zone_table-bad include/linux/gfp.h
--- a/include/linux/gfp.h~mm-fix-sparse-warnings-on-gfp_zone_table-bad
+++ a/include/linux/gfp.h
@@ -9,6 +9,32 @@
 
 struct vm_area_struct;
 
+/* Plain integer GFP bitmasks. Do not use this directly. */
+#define ___GFP_DMA		0x01u
+#define ___GFP_HIGHMEM		0x02u
+#define ___GFP_DMA32		0x04u
+#define ___GFP_MOVABLE		0x08u
+#define ___GFP_WAIT		0x10u
+#define ___GFP_HIGH		0x20u
+#define ___GFP_IO		0x40u
+#define ___GFP_FS		0x80u
+#define ___GFP_COLD		0x100u
+#define ___GFP_NOWARN		0x200u
+#define ___GFP_REPEAT		0x400u
+#define ___GFP_NOFAIL		0x800u
+#define ___GFP_NORETRY		0x1000u
+#define ___GFP_COMP		0x4000u
+#define ___GFP_ZERO		0x8000u
+#define ___GFP_NOMEMALLOC	0x10000u
+#define ___GFP_HARDWALL		0x20000u
+#define ___GFP_THISNODE		0x40000u
+#define ___GFP_RECLAIMABLE	0x80000u
+#ifdef CONFIG_KMEMCHECK
+#define ___GFP_NOTRACK		0x200000u
+#else
+#define ___GFP_NOTRACK		0
+#endif
+
 /*
  * GFP bitmasks..
  *
@@ -18,10 +44,10 @@ struct vm_area_struct;
  * without the underscores and use them consistently. The definitions here may
  * be used in bit comparisons.
  */
-#define __GFP_DMA	((__force gfp_t)0x01u)
-#define __GFP_HIGHMEM	((__force gfp_t)0x02u)
-#define __GFP_DMA32	((__force gfp_t)0x04u)
-#define __GFP_MOVABLE	((__force gfp_t)0x08u)  /* Page is movable */
+#define __GFP_DMA	((__force gfp_t)___GFP_DMA)
+#define __GFP_HIGHMEM	((__force gfp_t)___GFP_HIGHMEM)
+#define __GFP_DMA32	((__force gfp_t)___GFP_DMA32)
+#define __GFP_MOVABLE	((__force gfp_t)___GFP_MOVABLE)  /* Page is movable */
 #define GFP_ZONEMASK	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE)
 /*
  * Action modifiers - doesn't change the zoning
@@ -38,27 +64,22 @@ struct vm_area_struct;
  * __GFP_MOVABLE: Flag that this page will be movable by the page migration
  * mechanism or reclaimed
  */
-#define __GFP_WAIT	((__force gfp_t)0x10u)	/* Can wait and reschedule? */
-#define __GFP_HIGH	((__force gfp_t)0x20u)	/* Should access emergency pools? */
-#define __GFP_IO	((__force gfp_t)0x40u)	/* Can start physical IO? */
-#define __GFP_FS	((__force gfp_t)0x80u)	/* Can call down to low-level FS? */
-#define __GFP_COLD	((__force gfp_t)0x100u)	/* Cache-cold page required */
-#define __GFP_NOWARN	((__force gfp_t)0x200u)	/* Suppress page allocation failure warning */
-#define __GFP_REPEAT	((__force gfp_t)0x400u)	/* See above */
-#define __GFP_NOFAIL	((__force gfp_t)0x800u)	/* See above */
-#define __GFP_NORETRY	((__force gfp_t)0x1000u)/* See above */
-#define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
-#define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
-#define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
-#define __GFP_HARDWALL   ((__force gfp_t)0x20000u) /* Enforce hardwall cpuset memory allocs */
-#define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
-#define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
-
-#ifdef CONFIG_KMEMCHECK
-#define __GFP_NOTRACK	((__force gfp_t)0x200000u)  /* Don't track with kmemcheck */
-#else
-#define __GFP_NOTRACK	((__force gfp_t)0)
-#endif
+#define __GFP_WAIT	((__force gfp_t)___GFP_WAIT)	/* Can wait and reschedule? */
+#define __GFP_HIGH	((__force gfp_t)___GFP_HIGH)	/* Should access emergency pools? */
+#define __GFP_IO	((__force gfp_t)___GFP_IO)	/* Can start physical IO? */
+#define __GFP_FS	((__force gfp_t)___GFP_FS)	/* Can call down to low-level FS? */
+#define __GFP_COLD	((__force gfp_t)___GFP_COLD)	/* Cache-cold page required */
+#define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)	/* Suppress page allocation failure warning */
+#define __GFP_REPEAT	((__force gfp_t)___GFP_REPEAT)	/* See above */
+#define __GFP_NOFAIL	((__force gfp_t)___GFP_NOFAIL)	/* See above */
+#define __GFP_NORETRY	((__force gfp_t)___GFP_NORETRY) /* See above */
+#define __GFP_COMP	((__force gfp_t)___GFP_COMP)	/* Add compound page metadata */
+#define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)	/* Return zeroed page on success */
+#define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC) /* Don't use emergency reserves */
+#define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL) /* Enforce hardwall cpuset memory allocs */
+#define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)/* No fallback, no policies */
+#define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
+#define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
 
 /*
  * This may seem redundant, but it's a way of annotating false positives vs.
@@ -186,14 +207,14 @@ static inline int allocflags_to_migratet
 #endif
 
 #define GFP_ZONE_TABLE ( \
-	(ZONE_NORMAL << 0 * ZONES_SHIFT)				\
-	| (OPT_ZONE_DMA << __GFP_DMA * ZONES_SHIFT)			\
-	| (OPT_ZONE_HIGHMEM << __GFP_HIGHMEM * ZONES_SHIFT)		\
-	| (OPT_ZONE_DMA32 << __GFP_DMA32 * ZONES_SHIFT)			\
-	| (ZONE_NORMAL << __GFP_MOVABLE * ZONES_SHIFT)			\
-	| (OPT_ZONE_DMA << (__GFP_MOVABLE | __GFP_DMA) * ZONES_SHIFT)	\
-	| (ZONE_MOVABLE << (__GFP_MOVABLE | __GFP_HIGHMEM) * ZONES_SHIFT)\
-	| (OPT_ZONE_DMA32 << (__GFP_MOVABLE | __GFP_DMA32) * ZONES_SHIFT)\
+	(ZONE_NORMAL << 0 * ZONES_SHIFT)				      \
+	| (OPT_ZONE_DMA << ___GFP_DMA * ZONES_SHIFT)			      \
+	| (OPT_ZONE_HIGHMEM << ___GFP_HIGHMEM * ZONES_SHIFT)		      \
+	| (OPT_ZONE_DMA32 << ___GFP_DMA32 * ZONES_SHIFT)		      \
+	| (ZONE_NORMAL << ___GFP_MOVABLE * ZONES_SHIFT)			      \
+	| (OPT_ZONE_DMA << (___GFP_MOVABLE | ___GFP_DMA) * ZONES_SHIFT)	      \
+	| (ZONE_MOVABLE << (___GFP_MOVABLE | ___GFP_HIGHMEM) * ZONES_SHIFT)   \
+	| (OPT_ZONE_DMA32 << (___GFP_MOVABLE | ___GFP_DMA32) * ZONES_SHIFT)   \
 )
 
 /*
@@ -203,20 +224,20 @@ static inline int allocflags_to_migratet
  * allowed.
  */
 #define GFP_ZONE_BAD ( \
-	1 << (__GFP_DMA | __GFP_HIGHMEM)				\
-	| 1 << (__GFP_DMA | __GFP_DMA32)				\
-	| 1 << (__GFP_DMA32 | __GFP_HIGHMEM)				\
-	| 1 << (__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM)		\
-	| 1 << (__GFP_MOVABLE | __GFP_HIGHMEM | __GFP_DMA)		\
-	| 1 << (__GFP_MOVABLE | __GFP_DMA32 | __GFP_DMA)		\
-	| 1 << (__GFP_MOVABLE | __GFP_DMA32 | __GFP_HIGHMEM)		\
-	| 1 << (__GFP_MOVABLE | __GFP_DMA32 | __GFP_DMA | __GFP_HIGHMEM)\
+	1 << (___GFP_DMA | ___GFP_HIGHMEM)				      \
+	| 1 << (___GFP_DMA | ___GFP_DMA32)				      \
+	| 1 << (___GFP_DMA32 | ___GFP_HIGHMEM)				      \
+	| 1 << (___GFP_DMA | ___GFP_DMA32 | ___GFP_HIGHMEM)		      \
+	| 1 << (___GFP_MOVABLE | ___GFP_HIGHMEM | ___GFP_DMA)		      \
+	| 1 << (___GFP_MOVABLE | ___GFP_DMA32 | ___GFP_DMA)		      \
+	| 1 << (___GFP_MOVABLE | ___GFP_DMA32 | ___GFP_HIGHMEM)		      \
+	| 1 << (___GFP_MOVABLE | ___GFP_DMA32 | ___GFP_DMA | ___GFP_HIGHMEM)  \
 )
 
 static inline enum zone_type gfp_zone(gfp_t flags)
 {
 	enum zone_type z;
-	int bit = flags & GFP_ZONEMASK;
+	int bit = (__force int) (flags & GFP_ZONEMASK);
 
 	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
 					 ((1 << ZONES_SHIFT) - 1);
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
mm-remove-temporary-variable-on-generic_file_direct_write.patch
mm-add-casts-to-from-gfp_t-in-gfp_to_alloc_flags.patch
mm-wrap-get_locked_pte-using-__cond_lock.patch
mm-add-lock-release-annotation-on-do_wp_page.patch
mm-wrap-follow_pte-using-__cond_lock.patch
rmap-annotate-lock-context-change-on-page_lock_anon_vma.patch
rmap-wrap-page_check_address-using-__cond_lock.patch
rmap-make-anon_vma_free-static.patch
vmalloc-rename-temporary-variable-in-__insert_vmap_area.patch
vmalloc-annotate-lock-context-change-on-s_start-stop.patch
mm-declare-some-external-symbols.patch
vmstat-include-compactionh-when-config_compaction.patch
vmstat-include-compactionh-when-config_compaction-fix.patch
mm-fix-sparse-warnings-on-gfp_zone_table-bad.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
ptrace-change-signature-of-sys_ptrace-and-friends.patch
ptrace-cleanup-ptrace_request.patch
ptrace-change-signature-of-arch_ptrace.patch
ptrace-cleanup-arch_ptrace-on-x86.patch
ptrace-cleanup-arch_ptrace-on-arm.patch
ptrace-cleanup-arch_ptrace-on-avr32.patch
ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch
ptrace-cleanup-arch_ptrace-on-cris.patch
ptrace-cleanup-arch_ptrace-on-frv.patch
ptrace-cleanup-arch_ptrace-on-h8300.patch
ptrace-cleanup-arch_ptrace-on-m32r.patch
ptrace-cleanup-arch_ptrace-on-m68k.patch
ptrace-cleanup-arch_ptrace-on-m68knommu.patch
ptrace-cleanup-arch_ptrace-on-microblaze.patch
ptrace-cleanup-arch_ptrace-on-mips.patch
ptrace-cleanup-arch_ptrace-on-mn10300.patch
ptrace-cleanup-arch_ptrace-on-parisc.patch
ptrace-cleanup-arch_ptrace-on-powerpc.patch
ptrace-cleanup-arch_ptrace-on-score.patch
ptrace-cleanup-arch_ptrace-on-sh.patch
ptrace-cleanup-arch_ptrace-on-sparc.patch
ptrace-cleanup-arch_ptrace-on-tile.patch
ptrace-cleanup-arch_ptrace-on-um.patch
ptrace-cleanup-arch_ptrace-on-xtensa.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

