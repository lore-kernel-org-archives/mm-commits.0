From: akpm@linux-foundation.org
Subject: [patch 078/131] kmemcheck: remove whats left of NOTRACK
 flags
Date: Wed, 15 Nov 2017 17:35:58 -0800
Message-ID: <20171116013558.hM08dQJDj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39724 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933612AbdKPBgA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:36:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexander.levin@verizon.com, devtimhansen@gmail.com, ebiederm@xmission.com, glider@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, rostedt@goodmis.org, torvalds@linux-foundation.org, vegardno@ifi.uio.no

From: "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>
Subject: kmemcheck: remove whats left of NOTRACK flags

Now that kmemcheck is gone, we don't need the NOTRACK flags.

Link: http://lkml.kernel.org/r/20171007030159.22241-5-alexander.levin@verizon.com
Signed-off-by: Sasha Levin <alexander.levin@verizon.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Hansen <devtimhansen@gmail.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h       |    5 -----
 arch/x86/include/asm/pgtable_types.h |   13 -------------
 include/linux/gfp.h                  |    9 ---------
 include/linux/slab.h                 |    6 ------
 include/trace/events/mmflags.h       |    1 -
 mm/slub.c                            |    2 --
 tools/perf/builtin-kmem.c            |    1 -
 7 files changed, 37 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~kmemcheck-remove-whats-left-of-notrack-flags arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~kmemcheck-remove-whats-left-of-notrack-flags
+++ a/arch/x86/include/asm/pgtable.h
@@ -667,11 +667,6 @@ static inline bool pte_accessible(struct
 	return false;
 }
 
-static inline int pte_hidden(pte_t pte)
-{
-	return pte_flags(pte) & _PAGE_HIDDEN;
-}
-
 static inline int pmd_present(pmd_t pmd)
 {
 	/*
diff -puN arch/x86/include/asm/pgtable_types.h~kmemcheck-remove-whats-left-of-notrack-flags arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~kmemcheck-remove-whats-left-of-notrack-flags
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -32,7 +32,6 @@
 
 #define _PAGE_BIT_SPECIAL	_PAGE_BIT_SOFTW1
 #define _PAGE_BIT_CPA_TEST	_PAGE_BIT_SOFTW1
-#define _PAGE_BIT_HIDDEN	_PAGE_BIT_SOFTW3 /* hidden by kmemcheck */
 #define _PAGE_BIT_SOFT_DIRTY	_PAGE_BIT_SOFTW3 /* software dirty tracking */
 #define _PAGE_BIT_DEVMAP	_PAGE_BIT_SOFTW4
 
@@ -79,18 +78,6 @@
 #define _PAGE_KNL_ERRATUM_MASK 0
 #endif
 
-#ifdef CONFIG_KMEMCHECK
-#define _PAGE_HIDDEN	(_AT(pteval_t, 1) << _PAGE_BIT_HIDDEN)
-#else
-#define _PAGE_HIDDEN	(_AT(pteval_t, 0))
-#endif
-
-/*
- * The same hidden bit is used by kmemcheck, but since kmemcheck
- * works on kernel pages while soft-dirty engine on user space,
- * they do not conflict with each other.
- */
-
 #ifdef CONFIG_MEM_SOFT_DIRTY
 #define _PAGE_SOFT_DIRTY	(_AT(pteval_t, 1) << _PAGE_BIT_SOFT_DIRTY)
 #else
diff -puN include/linux/gfp.h~kmemcheck-remove-whats-left-of-notrack-flags include/linux/gfp.h
--- a/include/linux/gfp.h~kmemcheck-remove-whats-left-of-notrack-flags
+++ a/include/linux/gfp.h
@@ -37,7 +37,6 @@ struct vm_area_struct;
 #define ___GFP_THISNODE		0x40000u
 #define ___GFP_ATOMIC		0x80000u
 #define ___GFP_ACCOUNT		0x100000u
-#define ___GFP_NOTRACK		0x200000u
 #define ___GFP_DIRECT_RECLAIM	0x400000u
 #define ___GFP_WRITE		0x800000u
 #define ___GFP_KSWAPD_RECLAIM	0x1000000u
@@ -201,19 +200,11 @@ struct vm_area_struct;
  * __GFP_COMP address compound page metadata.
  *
  * __GFP_ZERO returns a zeroed page on success.
- *
- * __GFP_NOTRACK avoids tracking with kmemcheck.
- *
- * __GFP_NOTRACK_FALSE_POSITIVE is an alias of __GFP_NOTRACK. It's a means of
- *   distinguishing in the source between false positives and allocations that
- *   cannot be supported (e.g. page tables).
  */
 #define __GFP_COLD	((__force gfp_t)___GFP_COLD)
 #define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)
 #define __GFP_COMP	((__force gfp_t)___GFP_COMP)
 #define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)
-#define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)
-#define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
 
 /* Disable lockdep for GFP context tracking */
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
diff -puN include/linux/slab.h~kmemcheck-remove-whats-left-of-notrack-flags include/linux/slab.h
--- a/include/linux/slab.h~kmemcheck-remove-whats-left-of-notrack-flags
+++ a/include/linux/slab.h
@@ -89,12 +89,6 @@
 /* Avoid kmemleak tracing */
 #define SLAB_NOLEAKTRACE	((slab_flags_t __force)0x00800000U)
 
-/* Don't track use of uninitialized memory */
-#ifdef CONFIG_KMEMCHECK
-# define SLAB_NOTRACK		((slab_flags_t __force)0x01000000U)
-#else
-# define SLAB_NOTRACK		0
-#endif
 /* Fault injection mark */
 #ifdef CONFIG_FAILSLAB
 # define SLAB_FAILSLAB		((slab_flags_t __force)0x02000000U)
diff -puN include/trace/events/mmflags.h~kmemcheck-remove-whats-left-of-notrack-flags include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~kmemcheck-remove-whats-left-of-notrack-flags
+++ a/include/trace/events/mmflags.h
@@ -46,7 +46,6 @@
 	{(unsigned long)__GFP_RECLAIMABLE,	"__GFP_RECLAIMABLE"},	\
 	{(unsigned long)__GFP_MOVABLE,		"__GFP_MOVABLE"},	\
 	{(unsigned long)__GFP_ACCOUNT,		"__GFP_ACCOUNT"},	\
-	{(unsigned long)__GFP_NOTRACK,		"__GFP_NOTRACK"},	\
 	{(unsigned long)__GFP_WRITE,		"__GFP_WRITE"},		\
 	{(unsigned long)__GFP_RECLAIM,		"__GFP_RECLAIM"},	\
 	{(unsigned long)__GFP_DIRECT_RECLAIM,	"__GFP_DIRECT_RECLAIM"},\
diff -puN mm/slub.c~kmemcheck-remove-whats-left-of-notrack-flags mm/slub.c
--- a/mm/slub.c~kmemcheck-remove-whats-left-of-notrack-flags
+++ a/mm/slub.c
@@ -5635,8 +5635,6 @@ static char *create_unique_id(struct kme
 		*p++ = 'a';
 	if (s->flags & SLAB_CONSISTENCY_CHECKS)
 		*p++ = 'F';
-	if (!(s->flags & SLAB_NOTRACK))
-		*p++ = 't';
 	if (s->flags & SLAB_ACCOUNT)
 		*p++ = 'A';
 	if (p != name + 1)
diff -puN tools/perf/builtin-kmem.c~kmemcheck-remove-whats-left-of-notrack-flags tools/perf/builtin-kmem.c
--- a/tools/perf/builtin-kmem.c~kmemcheck-remove-whats-left-of-notrack-flags
+++ a/tools/perf/builtin-kmem.c
@@ -655,7 +655,6 @@ static const struct {
 	{ "__GFP_RECLAIMABLE",		"RC" },
 	{ "__GFP_MOVABLE",		"M" },
 	{ "__GFP_ACCOUNT",		"AC" },
-	{ "__GFP_NOTRACK",		"NT" },
 	{ "__GFP_WRITE",		"WR" },
 	{ "__GFP_RECLAIM",		"R" },
 	{ "__GFP_DIRECT_RECLAIM",	"DR" },
_
