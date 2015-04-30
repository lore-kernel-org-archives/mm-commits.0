From: akpm@linux-foundation.org
Subject: + mm-meminit-inline-some-helper-functions-fix.patch added to -mm
 tree
Date: Thu, 30 Apr 2015 14:54:04 -0700
Message-ID: <5542a47c.afdEGUWPHbiQ8ZZq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbbD3VyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Apr 2015 17:54:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-meminit-inline-some-helper-functions-fix
has been added to the -mm tree.  Its filename is
     mm-meminit-inline-some-helper-functions-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-inline-some-helper-functions-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-inline-some-helper-functions-fix.patch

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
Subject: mm-meminit-inline-some-helper-functions-fix

mm/page_alloc.c: In function 'memmap_init_zone':
mm/page_alloc.c:4287: error: implicit declaration of function 'early_pfn_in_nid'

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/page_alloc.c~mm-meminit-inline-some-helper-functions-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-inline-some-helper-functions-fix
+++ a/mm/page_alloc.c
@@ -950,8 +950,16 @@ static inline bool __meminit early_pfn_i
 {
 	return meminit_pfn_in_nid(pfn, node, &early_pfnnid_cache);
 }
+
+#else
+
+static inline bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
+{
+	return true;
+}
 #endif
 
+
 #ifdef CONFIG_CMA
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
 void __init init_cma_reserved_pageblock(struct page *page)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
maintainers-add-co-maintainer-for-led-subsystem.patch
revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

