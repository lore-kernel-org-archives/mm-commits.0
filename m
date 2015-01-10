From: akpm@linux-foundation.org
Subject: + mm-more-checks-on-free_pages_prepare-for-tail-pages-fix.patch
 added to -mm tree
Date: Fri, 09 Jan 2015 16:24:29 -0800
Message-ID: <54b0713d.xD3xC5Z1EoXINLbt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAJAYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 19:24:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, kirill.shutemov@linux.intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-more-checks-on-free_pages_prepare-for-tail-pages-fix
has been added to the -mm tree.  Its filename is
     mm-more-checks-on-free_pages_prepare-for-tail-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-more-checks-on-free_pages_prepare-for-tail-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-more-checks-on-free_pages_prepare-for-tail-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-more-checks-on-free_pages_prepare-for-tail-pages-fix

Make it conditional on CONFIG_DEBUG_VM, make free_tail_pages_check()
return void.

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-more-checks-on-free_pages_prepare-for-tail-pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-more-checks-on-free_pages_prepare-for-tail-pages-fix
+++ a/mm/page_alloc.c
@@ -764,20 +764,26 @@ static void free_one_page(struct zone *z
 	spin_unlock(&zone->lock);
 }
 
-static int free_tail_pages_check(struct page *head_page, struct page *page)
+#ifdef CONFIG_DEBUG_VM
+static void free_tail_pages_check(struct page *head_page, struct page *page)
 {
 	if (!IS_ENABLED(CONFIG_DEBUG_VM))
-		return 0;
+		return;
 	if (unlikely(!PageTail(page))) {
 		bad_page(page, "PageTail not set", 0);
-		return 1;
+		return;
 	}
 	if (unlikely(page->first_page != head_page)) {
 		bad_page(page, "first_page not consistent", 0);
-		return 1;
+		return;
 	}
-	return 0;
 }
+#else
+static inline void free_tail_pages_check(struct page *head_page,
+					 struct page *page)
+{
+}
+#endif
 
 static bool free_pages_prepare(struct page *page, unsigned int order)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
livepatching-handle-ancient-compilers-with-more-grace-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

