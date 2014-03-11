From: akpm@linux-foundation.org
Subject: + mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch
 added to -mm tree
Date: Tue, 11 Mar 2014 14:16:35 -0700
Message-ID: <531f7d33.koYhniTglb8FFqaI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbaCKVQg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 17:16:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: + mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,dave.hansen@linux.intel.com
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 14:16:35 -0700


The patch titled
     Subject: mm: use 'const char *' insted of 'char *' for reason in dump_page()
has been added to the -mm tree.  Its filename is
     mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: use 'const char *' insted of 'char *' for reason in dump_page()

I tried to use 'dump_page(page, __func__)' for debugging, but it triggers
warning:

  warning: passing argument 2 of `dump_page' discards `const' qualifier from pointer target type [enabled by default]

Let's convert 'reason' to 'const char *' in dump_page() and friends: we
shouldn't modify it anyway.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    4 ++--
 mm/page_alloc.c         |   12 +++++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/mmdebug.h~mm-use-const-char-insted-of-char-for-reason-in-dump_page include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-use-const-char-insted-of-char-for-reason-in-dump_page
+++ a/include/linux/mmdebug.h
@@ -3,8 +3,8 @@
 
 struct page;
 
-extern void dump_page(struct page *page, char *reason);
-extern void dump_page_badflags(struct page *page, char *reason,
+extern void dump_page(struct page *page, const char *reason);
+extern void dump_page_badflags(struct page *page, const char *reason,
 			       unsigned long badflags);
 
 #ifdef CONFIG_DEBUG_VM
diff -puN mm/page_alloc.c~mm-use-const-char-insted-of-char-for-reason-in-dump_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-const-char-insted-of-char-for-reason-in-dump_page
+++ a/mm/page_alloc.c
@@ -295,7 +295,8 @@ static inline int bad_range(struct zone
 }
 #endif
 
-static void bad_page(struct page *page, char *reason, unsigned long bad_flags)
+static void bad_page(struct page *page, const char *reason,
+		unsigned long bad_flags)
 {
 	static unsigned long resume;
 	static unsigned long nr_shown;
@@ -623,7 +624,7 @@ out:
 
 static inline int free_pages_check(struct page *page)
 {
-	char *bad_reason = NULL;
+	const char *bad_reason = NULL;
 	unsigned long bad_flags = 0;
 
 	if (unlikely(page_mapcount(page)))
@@ -859,7 +860,7 @@ static inline void expand(struct zone *z
  */
 static inline int check_new_page(struct page *page)
 {
-	char *bad_reason = NULL;
+	const char *bad_reason = NULL;
 	unsigned long bad_flags = 0;
 
 	if (unlikely(page_mapcount(page)))
@@ -6545,7 +6546,8 @@ static void dump_page_flags(unsigned lon
 	printk(")\n");
 }
 
-void dump_page_badflags(struct page *page, char *reason, unsigned long badflags)
+void dump_page_badflags(struct page *page, const char *reason,
+		unsigned long badflags)
 {
 	printk(KERN_ALERT
 	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
@@ -6561,7 +6563,7 @@ void dump_page_badflags(struct page *pag
 	mem_cgroup_print_bad_page(page);
 }
 
-void dump_page(struct page *page, char *reason)
+void dump_page(struct page *page, const char *reason)
 {
 	dump_page_badflags(page, reason, 0);
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch
mm-thp-drop-do_huge_pmd_wp_zero_page_fallback.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-disable-split-page-table-lock-for-mmu.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-introduce-vm_ops-map_pages.patch
mm-introduce-vm_ops-map_pages-fix.patch
mm-implement-map_pages-for-page-cache.patch
mm-implement-map_pages-for-page-cache-fix.patch
mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

