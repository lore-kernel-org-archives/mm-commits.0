From: akpm@linux-foundation.org
Subject: + ksm-identify-pageksm-pages.patch added to -mm tree
Date: Thu, 23 Jul 2009 14:07:38 -0700
Message-ID: <200907232107.n6NL7dnV027567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754320AbZGWVI1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 17:08:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chrisw@redhat.com, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     ksm: identify PageKsm pages
has been added to the -mm tree.  Its filename is
     ksm-identify-pageksm-pages.patch

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
Subject: ksm: identify PageKsm pages
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

KSM will need to identify its kernel merged pages unambiguously, and
/proc/kpageflags will probably like to do so too.

Since KSM will only be substituting anonymous pages, statistics are best
preserved by making a PageKsm page a special PageAnon page: one with no
anon_vma.

But KSM then needs its own page_add_ksm_rmap() - keep it in ksm.h near
PageKsm; and do_wp_page() must COW them, unlike singly mapped PageAnons.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Chris Wright <chrisw@redhat.com>
Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c      |    5 +++++
 include/linux/ksm.h |   29 +++++++++++++++++++++++++++++
 mm/memory.c         |    3 ++-
 3 files changed, 36 insertions(+), 1 deletion(-)

diff -puN fs/proc/page.c~ksm-identify-pageksm-pages fs/proc/page.c
--- a/fs/proc/page.c~ksm-identify-pageksm-pages
+++ a/fs/proc/page.c
@@ -2,6 +2,7 @@
 #include <linux/compiler.h>
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/ksm.h>
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/proc_fs.h>
@@ -95,6 +96,8 @@ static const struct file_operations proc
 #define KPF_UNEVICTABLE		18
 #define KPF_NOPAGE		20
 
+#define KPF_KSM			21
+
 /* kernel hacking assistances
  * WARNING: subject to change, never rely on them!
  */
@@ -137,6 +140,8 @@ static u64 get_uflags(struct page *page)
 		u |= 1 << KPF_MMAP;
 	if (PageAnon(page))
 		u |= 1 << KPF_ANON;
+	if (PageKsm(page))
+		u |= 1 << KPF_KSM;
 
 	/*
 	 * compound pages: export both head/tail info
diff -puN include/linux/ksm.h~ksm-identify-pageksm-pages include/linux/ksm.h
--- a/include/linux/ksm.h~ksm-identify-pageksm-pages
+++ a/include/linux/ksm.h
@@ -10,6 +10,7 @@
 #include <linux/bitops.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/vmstat.h>
 
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
@@ -29,6 +30,27 @@ static inline void ksm_exit(struct mm_st
 	if (test_bit(MMF_VM_MERGEABLE, &mm->flags))
 		__ksm_exit(mm);
 }
+
+/*
+ * A KSM page is one of those write-protected "shared pages" or "merged pages"
+ * which KSM maps into multiple mms, wherever identical anonymous page content
+ * is found in VM_MERGEABLE vmas.  It's a PageAnon page, with NULL anon_vma.
+ */
+static inline int PageKsm(struct page *page)
+{
+	return ((unsigned long)page->mapping == PAGE_MAPPING_ANON);
+}
+
+/*
+ * But we have to avoid the checking which page_add_anon_rmap() performs.
+ */
+static inline void page_add_ksm_rmap(struct page *page)
+{
+	if (atomic_inc_and_test(&page->_mapcount)) {
+		page->mapping = (void *) PAGE_MAPPING_ANON;
+		__inc_zone_page_state(page, NR_ANON_PAGES);
+	}
+}
 #else  /* !CONFIG_KSM */
 
 static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
@@ -45,6 +67,13 @@ static inline int ksm_fork(struct mm_str
 static inline void ksm_exit(struct mm_struct *mm)
 {
 }
+
+static inline int PageKsm(struct page *page)
+{
+	return 0;
+}
+
+/* No stub required for page_add_ksm_rmap(page) */
 #endif /* !CONFIG_KSM */
 
 #endif
diff -puN mm/memory.c~ksm-identify-pageksm-pages mm/memory.c
--- a/mm/memory.c~ksm-identify-pageksm-pages
+++ a/mm/memory.c
@@ -45,6 +45,7 @@
 #include <linux/swap.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/module.h>
 #include <linux/delayacct.h>
@@ -1972,7 +1973,7 @@ static int do_wp_page(struct mm_struct *
 	 * Take out anonymous pages first, anonymous shared vmas are
 	 * not dirty accountable.
 	 */
-	if (PageAnon(old_page)) {
+	if (PageAnon(old_page) && !PageKsm(old_page)) {
 		if (!trylock_page(old_page)) {
 			page_cache_get(old_page);
 			pte_unmap_unlock(page_table, ptl);
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

mm-avoid-endless-looping-for-oom-killed-tasks.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
prio_tree-debugging-patch.patch

