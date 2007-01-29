From: akpm@osdl.org
Subject: - readahead-state-based-method-routines-explicitly-embed-class_new-class_old-inside-flags.patch removed from -mm tree
Date: Mon, 29 Jan 2007 15:35:18 -0800
Message-ID: <200701292335.l0TNZIDB002640@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33797 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964857AbXA2XfX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 18:35:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: state based method routines: explicitly embed class_new/class_old inside flags
has been removed from the -mm tree.  Its filename was
     readahead-state-based-method-routines-explicitly-embed-class_new-class_old-inside-flags.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: readahead: state based method routines: explicitly embed class_new/class_old inside flags
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

The new/old ra class were implicitly stored in low bits of
file_ra_state.flags.  Now make the data structure obvious, and remove the
coding tricks.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/fs.h |    9 ++++++++-
 mm/readahead.c     |   18 ++++--------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff -puN include/linux/fs.h~readahead-state-based-method-routines-explicitly-embed-class_new-class_old-inside-flags include/linux/fs.h
--- a/include/linux/fs.h~readahead-state-based-method-routines-explicitly-embed-class_new-class_old-inside-flags
+++ a/include/linux/fs.h
@@ -738,7 +738,14 @@ struct file_ra_state {
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
 
-	unsigned long flags;	/* RA_FLAG_xxx | ra_class_old | ra_class_new */
+	union {
+		unsigned long	flags;	/* RA_FLAG_xxx | class_old | class_new */
+		struct {
+			u8	class_new;
+			u8	class_old;
+		};
+	};
+
 	unsigned long prev_page;	/* Cache last read() position */
 	unsigned long ra_pages;		/* Maximum readahead window */
 };
diff -puN mm/readahead.c~readahead-state-based-method-routines-explicitly-embed-class_new-class_old-inside-flags mm/readahead.c
--- a/mm/readahead.c~readahead-state-based-method-routines-explicitly-embed-class_new-class_old-inside-flags
+++ a/mm/readahead.c
@@ -48,8 +48,6 @@ int readahead_hit_rate = 1;
 /*
  * Detailed classification of read-ahead behaviors.
  */
-#define RA_CLASS_SHIFT 4
-#define RA_CLASS_MASK  ((1 << RA_CLASS_SHIFT) - 1)
 enum ra_class {
 	RA_CLASS_ALL,
 	RA_CLASS_INITIAL,
@@ -791,12 +789,12 @@ out:
 
 static enum ra_class ra_class_new(struct file_ra_state *ra)
 {
-	return ra->flags & RA_CLASS_MASK;
+	return ra->class_new;
 }
 
 static inline enum ra_class ra_class_old(struct file_ra_state *ra)
 {
-	return (ra->flags >> RA_CLASS_SHIFT) & RA_CLASS_MASK;
+	return ra->class_old;
 }
 
 static unsigned long ra_readahead_size(struct file_ra_state *ra)
@@ -828,16 +826,8 @@ static int ra_has_index(struct file_ra_s
  */
 static void ra_set_class(struct file_ra_state *ra, enum ra_class ra_class)
 {
-	unsigned long flags_mask;
-	unsigned long flags;
-	unsigned long old_ra_class;
-
-	flags_mask = ~(RA_CLASS_MASK | (RA_CLASS_MASK << RA_CLASS_SHIFT));
-	flags = ra->flags & flags_mask;
-
-	old_ra_class = ra_class_new(ra) << RA_CLASS_SHIFT;
-
-	ra->flags = flags | old_ra_class | ra_class;
+	ra->class_old = ra->class_new;
+	ra->class_new = ra_class;
 }
 
 /*
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-kconfig-options.patch
readahead-kconfig-options-fix.patch
radixtree-introduce-scan-hole-data-functions.patch
mm-introduce-probe_page.patch
mm-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-sysctl-parameters-fix.patch
readahead-sysctl-parameters-set-readahead_hit_rate=1.patch
readahead-min-max-sizes.patch
readahead-min-max-sizes-remove-get_readahead_bounds.patch
readahead-min-max-sizes-increase-vm_min_readahead-to-32kb.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method-routines-explicitly-embed-class_new-class_old-inside-flags.patch
readahead-state-based-method.patch
readahead-state-based-method-prevent-tiny-size.patch
readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold.patch
readahead-context-based-method.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-context-based-method-update-ra_min.patch
readahead-context-based-method-remove-readahead_ratio.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-fix.patch
readahead-call-scheme.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-call-scheme-remove-get_readahead_bounds.patch
readahead-call-scheme-fix-thrashed-unaligned-read.patch
readahead-laptop-mode.patch
readahead-laptop-mode-fix.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
readahead-nfsd-case-fix-uninitialized-ra_min-ra_max.patch
readahead-nfsd-case-remove-ra_min.patch
readahead-turn-on-by-default.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
