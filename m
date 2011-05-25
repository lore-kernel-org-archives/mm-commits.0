From: akpm@linux-foundation.org
Subject: [merged] mm-delete-non-atomic-mm-counter-implementation.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:03 -0700
Message-ID: <201105252028.p4PKSQif014742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756488Ab1EYUtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@linux.intel.com, cl@linux-foundation.org, dave@linux.vnet.ibm.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: delete non-atomic mm counter implementation
has been removed from the -mm tree.  Its filename was
     mm-delete-non-atomic-mm-counter-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: delete non-atomic mm counter implementation
From: Matt Fleming <matt.fleming@linux.intel.com>

The problem with having two different types of counters is that developers
adding new code need to keep in mind whether it's safe to use both the
atomic and non-atomic implementations.  For example, when adding new
callers of the *_mm_counter() functions a developer needs to ensure that
those paths are always executed with page_table_lock held, in case we're
using the non-atomic implementation of mm counters.

Hugh Dickins introduced the atomic mm counters in commit f412ac08c986
("[PATCH] mm: fix rss and mmlist locking").  When asked why he left the
non-atomic counters around he said,

  | The only reason was to avoid adding costly atomic operations into a
  | configuration that had no need for them there: the page_table_lock
  | sufficed.
  |
  | Certainly it would be simpler just to delete the non-atomic variant.
  |
  | And I think it's fair to say that any configuration on which we're
  | measuring performance to that degree (rather than "does it boot fast?"
  | type measurements), would already be going the split ptlocks route.

Removing the non-atomic counters eases the maintenance burden because
developers no longer have to mindful of the two implementations when using
*_mm_counter().

Note that all architectures provide a means of atomically updating
atomic_long_t variables, even if they have to revert to the generic
spinlock implementation because they don't support 64-bit atomic
instructions (see lib/atomic64.c).

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   44 +++++--------------------------------
 include/linux/mm_types.h |    9 ++-----
 2 files changed, 10 insertions(+), 43 deletions(-)

diff -puN include/linux/mm.h~mm-delete-non-atomic-mm-counter-implementation include/linux/mm.h
--- a/include/linux/mm.h~mm-delete-non-atomic-mm-counter-implementation
+++ a/include/linux/mm.h
@@ -1053,65 +1053,35 @@ int __get_user_pages_fast(unsigned long 
 /*
  * per-process(per-mm_struct) statistics.
  */
-#if defined(SPLIT_RSS_COUNTING)
-/*
- * The mm counters are not protected by its page_table_lock,
- * so must be incremented atomically.
- */
 static inline void set_mm_counter(struct mm_struct *mm, int member, long value)
 {
 	atomic_long_set(&mm->rss_stat.count[member], value);
 }
 
+#if defined(SPLIT_RSS_COUNTING)
 unsigned long get_mm_counter(struct mm_struct *mm, int member);
-
-static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
-{
-	atomic_long_add(value, &mm->rss_stat.count[member]);
-}
-
-static inline void inc_mm_counter(struct mm_struct *mm, int member)
-{
-	atomic_long_inc(&mm->rss_stat.count[member]);
-}
-
-static inline void dec_mm_counter(struct mm_struct *mm, int member)
-{
-	atomic_long_dec(&mm->rss_stat.count[member]);
-}
-
-#else  /* !USE_SPLIT_PTLOCKS */
-/*
- * The mm counters are protected by its page_table_lock,
- * so can be incremented directly.
- */
-static inline void set_mm_counter(struct mm_struct *mm, int member, long value)
-{
-	mm->rss_stat.count[member] = value;
-}
-
+#else
 static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 {
-	return mm->rss_stat.count[member];
+	return atomic_long_read(&mm->rss_stat.count[member]);
 }
+#endif
 
 static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
 {
-	mm->rss_stat.count[member] += value;
+	atomic_long_add(value, &mm->rss_stat.count[member]);
 }
 
 static inline void inc_mm_counter(struct mm_struct *mm, int member)
 {
-	mm->rss_stat.count[member]++;
+	atomic_long_inc(&mm->rss_stat.count[member]);
 }
 
 static inline void dec_mm_counter(struct mm_struct *mm, int member)
 {
-	mm->rss_stat.count[member]--;
+	atomic_long_dec(&mm->rss_stat.count[member]);
 }
 
-#endif /* !USE_SPLIT_PTLOCKS */
-
 static inline unsigned long get_mm_rss(struct mm_struct *mm)
 {
 	return get_mm_counter(mm, MM_FILEPAGES) +
diff -puN include/linux/mm_types.h~mm-delete-non-atomic-mm-counter-implementation include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-delete-non-atomic-mm-counter-implementation
+++ a/include/linux/mm_types.h
@@ -204,19 +204,16 @@ enum {
 
 #if USE_SPLIT_PTLOCKS && defined(CONFIG_MMU)
 #define SPLIT_RSS_COUNTING
-struct mm_rss_stat {
-	atomic_long_t count[NR_MM_COUNTERS];
-};
 /* per-thread cached information, */
 struct task_rss_stat {
 	int events;	/* for synchronization threshold */
 	int count[NR_MM_COUNTERS];
 };
-#else  /* !USE_SPLIT_PTLOCKS */
+#endif /* USE_SPLIT_PTLOCKS */
+
 struct mm_rss_stat {
-	unsigned long count[NR_MM_COUNTERS];
+	atomic_long_t count[NR_MM_COUNTERS];
 };
-#endif /* !USE_SPLIT_PTLOCKS */
 
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
_

Patches currently in -mm which might be from matt.fleming@linux.intel.com are

origin.patch

